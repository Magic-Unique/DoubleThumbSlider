//
//  MUDoubleThumbSlider.m
//  DoubleThumbSlider
//
//  Created by Magic-Unique on 16/1/1.
//  Copyright © 2016年 unique. All rights reserved.
//

#import "MUDoubleThumbSlider.h"

#define ThumbKey @"_thumbViewNeue"

@interface MUDoubleThumbSlider ()
{
	__weak UIImageView *_oldThumbView;// 系统创建的ThumbView
	__weak UIImageView *_newThumbView;// 自己创建的ThumbView
	__weak UIImageView *_minThumbView;// 左边的ThumbView，重合时候可能会和_maxThumbView互换
	__weak UIImageView *_maxThumbView;// 右边的ThumbView，重合时候可能会和_minThumbView互换
	
	/* 
	 * 以下为重合标记，如果最大值==最小值，touchesBegan 会设置bool为yes，并获取对应的值
	 * 重合标记会被 touchesMove 激活一次，并关掉重合标记防止下一次 touchesMove 重复激活。
	 */

	BOOL coincide;
	CGFloat coincideValue;
}

@end




@interface UISlider (Subviews)

/** 有效的ThumbView */
@property (nonatomic, strong) UIImageView *thumbViewNeue;

/** 有效的横线视图 */
@property (nonatomic, strong, readonly) UIImageView *minTrackView;

/** 无效的横线视图 */
@property (nonatomic, strong, readonly) UIImageView *maxTrackView;

/** 无效的横线视图背景 */
@property (nonatomic, strong, readonly) UIView *maxTrackClipView;

/**
 *  判断一个touch是否在一个ThumbView上
 *
 *  @param touch UITouch
 *  @param thumb UIImageView
 *
 *  @return BOOL
 */
- (BOOL)touch:(UITouch *)touch inThumb:(UIImageView *)thumb;

@end


@implementation MUDoubleThumbSlider

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

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect frame = CGRectZero;
	
	if (!_oldThumbView) {
		// 通过KVC获取系统创建的ThumbView保存到_oldThumbView，并复制一份保存到_newThumbView。
		// 这一部分的代码只会执行一次。
		_oldThumbView = self.thumbViewNeue;
		UIImageView *newImageView = [_oldThumbView copy];
		[self addSubview:newImageView];
		_newThumbView = newImageView;
		_minThumbView = _oldThumbView;
		_maxThumbView = _newThumbView;
	}
	
	frame = _minThumbView.frame;
	frame.origin.x = (self.bounds.size.width - 31) * (self.minValue / (self.maximumValue-self.minimumValue));
	_minThumbView.frame = frame;
	
	frame = _maxThumbView.frame;
	frame.origin.x = (self.bounds.size.width - 31) * (self.maxValue / (self.maximumValue-self.minimumValue));
	_maxThumbView.frame = frame;
	
	// 设置两个ThumbView之间的有效值横线
	UIView *minTrackView = self.minTrackView;
	frame = minTrackView.frame;
	frame.size.width = _maxThumbView.center.x - _minThumbView.center.x;
	frame.origin.x = _minThumbView.center.x;
	minTrackView.frame = frame;
	
	// 设置两个ThumbView之外的无效值横线
	frame = self.maxTrackClipView.frame;
	frame.origin.x = 2;
	frame.size.width = self.bounds.size.width - 4;
	self.maxTrackClipView.frame = frame;
	self.maxTrackView.frame = self.maxTrackClipView.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	// 由于有两个ThumbView，通过touch位置获取用户触摸的ThumbView，并设置为thumbViewNeue。
	UIImageView *touchImageView = [self imageViewForTouch:touches.anyObject];
	if (touchImageView) {
		self.thumbViewNeue = touchImageView;
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
//	NSLog(@"%f", self.value);
	if (coincide) {
		/*
		 重合标记打开后，第一次移动范围必须要大于一定的值。
		 这个设定是为了提高用户体验
		 因为在重合时候，如果上面的ThumbView是右边的ThumbView，此时用户想往左滑动，滑块会细微地往右边滑动。这一细微的移动也会激活重合标记，导致滑块因逻辑不能向左边移动。另一个方向情况同理。
		 通过dd值的设定，可以防止这个细微的滑动激活这个标记，保证滑动是用户的操作。
		 */
		CGFloat dd = self.value - coincideValue;
		dd = dd > 0 ? dd : (-dd);
		if (dd > 0.025) {
			
			// 不正常移动，因为touchesBegan打开了重合标记
			if (self.value < coincideValue) {
				// 用户往左滑动，下同
				_minValue = self.value;
				// 保证用户滑动的是左边的滑块，如果不是，则交换，下同
				if (self.thumbViewNeue != _minThumbView) {
					[self exchangeMaxAndMinThumb];
				}
			} else if (self.value > coincideValue) {
				_maxValue = self.value;
				if (self.thumbViewNeue != _maxThumbView) {
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
		if (self.thumbViewNeue == _minThumbView) {
			_minValue = self.value;
			// 最小值不能大于最大值，下同
			if (_minValue > _maxValue) {
				_minValue = _maxValue;
				self.value = _minValue;
			}
		} else if (self.thumbViewNeue == _maxThumbView) {
			_maxValue = self.value;
			if (_maxValue < _minValue) {
				_maxValue = _minValue;
				self.value = _maxValue;
			}
		}
	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
}

#pragma mark - Property setter

- (void)setMaxValue:(CGFloat)maxValue {
	if (_maxValue != maxValue) {
		_maxValue = maxValue;
		[self setNeedsLayout];
	}
}

- (void)setMinValue:(CGFloat)minValue {
	if (_minValue != minValue) {
		_minValue = minValue;
		[self setNeedsLayout];
	}
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
		if ([self touch:touch inThumb:_newThumbView]) {
			return _newThumbView;
		}
		if ([self touch:touch inThumb:_oldThumbView]) {
			return _oldThumbView;
		}
	} else {
		if ([self touch:touch inThumb:_oldThumbView]) {
			return _oldThumbView;
		}
		if ([self touch:touch inThumb:_newThumbView]) {
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




@implementation UISlider (Subviews)

#pragma mark - Private method

- (BOOL)touch:(UITouch *)touch inThumb:(UIImageView *)thumb {
	CGPoint location = [touch locationInView:thumb.subviews.firstObject];
	return CGRectContainsPoint(thumb.subviews.firstObject.frame, location);
}

#pragma mark - Property setter

- (void)setThumbViewNeue:(UIImageView *)thumbViewNeue {
	if (thumbViewNeue) {
		[self setValue:thumbViewNeue forKey:ThumbKey];
		[self bringSubviewToFront:thumbViewNeue];
	}
}

#pragma mark - Property getter

- (UIImageView *)thumbViewNeue {
	return [self valueForKey:ThumbKey];
}

- (UIImageView *)minTrackView {
	return [self valueForKey:@"_minTrackView"];
}

- (UIImageView *)maxTrackView {
	return [self valueForKey:@"_maxTrackView"];
}

- (UIView *)maxTrackClipView {
	return [self valueForKey:@"_maxTrackClipView"];
}

@end




@implementation UIImageView (Copy)

- (instancetype)copy {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
	imageView.frame = self.frame;
	for (UIImageView *subView in self.subviews) {
		if ([subView isKindOfClass:[UIImageView class]]) {
			UIImageView *newSubView = [subView copy];
			[imageView addSubview:newSubView];
		}
	}
	return imageView;
}

@end
