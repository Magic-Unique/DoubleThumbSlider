//
//  DTSlider+Private.h
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSlider.h"

UIKIT_EXTERN UIImageView *DTCopyUIImageView(UIImageView *imageView);

@interface DTSlider (Private)

@property (nonatomic, strong) UIImageView *_currentThumbView;

@property (nonatomic, assign, readonly) BOOL _containsThumbImage;

@property (nonatomic, strong, readonly) UIView *_maxTrackClipView;

- (BOOL)_touch:(UITouch *)touch inThumb:(UIImageView *)thumb;

- (CGRect)_thumbRectForValue:(float)value;

@end

@interface UISlider (Private)

@property (nonatomic, strong, readonly) UIImageView *_minTrackView;

@property (nonatomic, strong, readonly) UIImageView *_maxTrackView;

- (void)_layoutSubviewsForBoundsChange:(BOOL)boundsChange;

@end
