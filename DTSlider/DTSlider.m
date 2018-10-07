//
//  DTSlider.m
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSlider.h"
#import "DTSlider+Private.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface DTSlider ()
{
    __weak UIImageView *_oldThumbView;// 系统创建的ThumbView
    __strong UIImageView *_newThumbView;// 自己创建的ThumbView
    __weak UIImageView *_minThumbView;// 左边的ThumbView，重合时候可能会和_maxThumbView互换
    __weak UIImageView *_maxThumbView;// 右边的ThumbView，重合时候可能会和_minThumbView互换
    
    /*
     * 以下为重合标记，如果最大值==最小值，touchesBegan 会设置bool为yes，并获取对应的值
     * 重合标记会被 touchesMove 激活一次，并关掉重合标记防止下一次 touchesMove 重复激活。
     */
    
    BOOL coincide;
    float coincideValue;
    
    BOOL _animating;
}

@end

@implementation DTSlider

- (instancetype)init {
    self = [super init];
    if (self) {
        _minValue = 0;
        _maxValue = 1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 1;
    }
    return self;
}

#pragma mark - View

- (void)_layoutSubviewsForBoundsChange:(BOOL)boundsChange {
    ((void (*)(struct objc_super *, SEL, BOOL))objc_msgSendSuper)(&(struct objc_super){self, [UISlider class]}, _cmd, boundsChange);
    CGRect frame = CGRectZero;
    
    if (!_oldThumbView) {
        [_newThumbView removeFromSuperview];
        // 通过KVC获取系统创建的ThumbView保存到_oldThumbView，并复制一份保存到_newThumbView。
        // 这一部分的代码只会执行一次。
        _oldThumbView = self._currentThumbView;
        UIImageView *newImageView = DTCopyUIImageView(_oldThumbView);
        [self addSubview:newImageView];
        _newThumbView = newImageView;
        _minThumbView = _oldThumbView;
        _maxThumbView = _newThumbView;
    }
    
    CGRect progress = ({
        CGRect frame = CGRectZero;
        CGRect min = UISlider_minTrackView(self).frame;
        CGRect max = DTSlider_maxTrackClipView(self).frame;
        frame.origin.x = min.origin.x;
        frame.origin.y = MIN(min.origin.y, max.origin.y);
        frame.size.width = CGRectGetMaxX(max) - frame.origin.x;
        frame.size.height = MAX(CGRectGetMaxY(min), CGRectGetMaxY(max)) - frame.origin.y;
        frame;
    });
    
    // 设置两个ThumbView之外的无效值横线
    frame = DTSlider_maxTrackClipView(self).frame;
    frame.origin.x = progress.origin.x;
    frame.size.width = progress.size.width - 4;
    DTSlider_maxTrackClipView(self).frame = frame;
    UISlider_maxTrackView(self).frame = DTSlider_maxTrackClipView(self).bounds;
    
    //    frame = _minThumbView.frame;
    //    frame.origin.x = (progress.size.width - frame.size.width) * (self.minValue / (self.maximumValue-self.minimumValue));
    //    frame.origin.x += progress.origin.x;
    frame = [self _thumbRectForValue:_minValue];
//    NSLog(@"Min %f => %@", _minValue, NSStringFromCGRect(frame));
    _minThumbView.frame = frame;
    
    //    frame = _maxThumbView.frame;
    //    frame.origin.x = (progress.size.width - frame.size.width) * (self.maxValue / (self.maximumValue-self.minimumValue));
    //    frame.origin.x += progress.origin.x;
    frame = [self _thumbRectForValue:_maxValue];
    _maxThumbView.frame = frame;
    
    // 设置两个ThumbView之间的有效值横线
    UIView *minTrackView = UISlider_minTrackView(self);
    frame = minTrackView.frame;
    frame.size.width = _maxThumbView.center.x - _minThumbView.center.x;
    frame.origin.x = _minThumbView.center.x;
    minTrackView.frame = frame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 由于有两个ThumbView，通过touch位置获取用户触摸的ThumbView，并设置为thumbViewNeue。
    UIImageView *touchImageView = [self imageViewForTouch:touches.anyObject];
    if (touchImageView) {
        self._currentThumbView = touchImageView;
        if (_maxValue == _minValue) {
            // 如果此时两个ThumbView重合，打开重合标记，告诉下一次touchesMove方法（无方向限制，可能调换两个ThumbView的位置）
            coincide = YES;
            coincideValue = _maxValue;// or _minValue;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    //    NSLog(@"%f", self.value);
    if (coincide) {
        /*
         重合标记打开后，第一次移动范围必须要大于一定的值。
         这个设定是为了提高用户体验
         因为在重合时候，如果上面的ThumbView是右边的ThumbView，此时用户想往左滑动，滑块会细微地往右边滑动。这一细微的移动也会激活重合标记，导致滑块因逻辑不能向左边移动。另一个方向情况同理。
         通过dd值的设定，可以防止这个细微的滑动激活这个标记，保证滑动是用户的操作。
         */
        float dd = self.value - coincideValue;
        dd = dd > 0 ? dd : (-dd);
        if (dd > 0.025) {
            
            // 不正常移动，因为touchesBegan打开了重合标记
            if (self.value < coincideValue) {
                // 用户往左滑动，下同
                _minValue = self.value;
                // 保证用户滑动的是左边的滑块，如果不是，则交换，下同
                if (self._currentThumbView != _minThumbView) {
                    [self exchangeMaxAndMinThumb];
                }
            } else if (self.value > coincideValue) {
                _maxValue = self.value;
                if (self._currentThumbView != _maxThumbView) {
                    [self exchangeMaxAndMinThumb];
                }
            }
            coincide = NO;//立马关闭重合标记，防止下一次touchesMove进入
        }
        /*
         else {
         是轻微移动，什么都不做
         }
         */
        
    } else {
        // 正常移动，判断用户移动的是右边ThumbView还是左边ThumbView
        if (self._currentThumbView == _minThumbView) {
            _minValue = self.value;
            // 最小值不能大于最大值，下同
            if (_minValue > _maxValue) {
                _minValue = _maxValue;
//                self.value = _minValue;
            }
        } else if (self._currentThumbView == _maxThumbView) {
            _maxValue = self.value;
            if (_maxValue < _minValue) {
                _maxValue = _minValue;
//                self.value = _maxValue;
            }
        }
    }
}

#pragma mark - Property setter

- (void)setMaxValue:(float)maxValue animated:(BOOL)animated {
    if (_maxValue == maxValue) {
        return;
    }
    _maxValue = maxValue;
    self._currentThumbView = _maxThumbView;
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setValue:maxValue animated:YES];
                         } completion:nil];
    } else {
        [self setValue:maxValue];
    }
}

- (void)setMinValue:(float)minValue animated:(BOOL)animated {
    if (_minValue == minValue) {
        return;
    }
    _minValue = minValue;
    self._currentThumbView = _minThumbView;
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setValue:minValue animated:YES];
                         } completion:nil];
    } else {
        [self setValue:minValue];
    }
}

- (void)setMinValue:(float)minValue maxValue:(float)maxValue animated:(BOOL)animated {
    if (_minValue == minValue && _maxValue == maxValue) {
        return;
    }
    _minValue = minValue;
    _maxValue = maxValue;
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setValue:minValue animated:YES];
                             [self setValue:maxValue animated:YES];
                         } completion:nil];
    } else {
        [self setValue:minValue];
        [self setValue:maxValue];
    }
}

- (void)setMaxValue:(float)maxValue {
    [self setMaxValue:maxValue animated:NO];
}

- (void)setMinValue:(float)minValue {
    [self setMinValue:minValue animated:NO];
}

#pragma mark - Private method

/**
 *  通过touch获取对应的ThumbView
 *
 *  @param touch UITouch
 *
 *  @return UIImageView
 */
- (UIImageView *)imageViewForTouch:(UITouch *)touch {
    NSUInteger indexOfNewThumbView = [self.subviews indexOfObject:_newThumbView];
    NSUInteger indexOfOldThumbView = [self.subviews indexOfObject:_oldThumbView];
    if (indexOfNewThumbView > indexOfOldThumbView) {
        if ([self _touch:touch inThumb:_newThumbView]) {
            return _newThumbView;
        }
        if ([self _touch:touch inThumb:_oldThumbView]) {
            return _oldThumbView;
        }
    } else {
        if ([self _touch:touch inThumb:_oldThumbView]) {
            return _oldThumbView;
        }
        if ([self _touch:touch inThumb:_newThumbView]) {
            return _newThumbView;
        }
    }
    return nil;
}

/**
 *  交换左右滑块
 */
- (void)exchangeMaxAndMinThumb {
    id temp = _minThumbView;
    _minThumbView = _maxThumbView;
    _maxThumbView = temp;
}

@end
