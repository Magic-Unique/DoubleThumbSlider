//
//  DTSlider+Private.m
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSlider+Private.h"

UIImageView *DTCopyUIImageView(UIImageView *imageView) {
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:imageView.image];
    newImageView.frame = imageView.frame;
    for (UIImageView *subView in imageView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *newSubView = DTCopyUIImageView(subView);
            [newImageView addSubview:newSubView];
        }
    }
    return newImageView;
}

@implementation DTSlider (Private)

- (BOOL)_containsThumbImage {
    return [self valueForKey:@"_thumbView"];
}

#pragma mark - Private method

- (BOOL)_touch:(UITouch *)touch inThumb:(UIImageView *)thumb {
    if ([self _containsThumbImage]) {
        CGPoint location = [touch locationInView:self];
        return CGRectContainsPoint(thumb.frame, location);
    } else {
        CGPoint location = [touch locationInView:thumb.subviews.firstObject];
        return CGRectContainsPoint(thumb.subviews.firstObject.frame, location);
    }
}

- (CGRect)_thumbRectForValue:(float)value {
    return [self thumbRectForBounds:self.bounds trackRect:self._maxTrackClipView.frame value:value];
}

#pragma mark - Property setter

- (void)set_currentThumbView:(UIImageView *)_currentThumbView {
    if (_currentThumbView) {
        if ([self _containsThumbImage]) {
            [self setValue:_currentThumbView forKey:@"_thumbView"];
        } else {
            [self setValue:_currentThumbView forKey:@"_thumbViewNeue"];
        }
        [self bringSubviewToFront:_currentThumbView];
    }
}

#pragma mark - Property getter

- (UIImageView *)_currentThumbView {
    if ([self _containsThumbImage]) {
        return [super valueForKey:@"_thumbView"];
    } else {
        return [super valueForKey:@"_thumbViewNeue"];
    }
}

- (UIView *)_maxTrackClipView {
    return self._maxTrackView.superview;
}
@end
