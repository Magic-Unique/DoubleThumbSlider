//
//  DTSlider+Private.h
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSlider.h"

#define CFSTR__minTrackView     DTStringFrom(@"`njoUsbdlWjfx")
#define CFSTR__maxTrackView     DTStringFrom(@"`nbyUsbdlWjfx")
#define CFSTR__thumbView        DTStringFrom(@"`uivncWjfx")
#define CFSTR__thumbViewNeue    DTStringFrom(@"`uivncWjfxOfvf")

UIKIT_EXTERN UIImageView *DTCopyUIImageView(UIImageView *imageView);
FOUNDATION_EXTERN NSString *DTStringFrom(NSString *input);

@interface DTSlider (Private)

@property (nonatomic, strong) UIImageView *_currentThumbView;

@property (nonatomic, assign, readonly) BOOL _containsThumbImage;

- (BOOL)_touch:(UITouch *)touch inThumb:(UIImageView *)thumb;

- (CGRect)_thumbRectForValue:(float)value;

@end

#define DTSlider_maxTrackClipView(slider) (UISlider_maxTrackView(self).superview)

#define UISlider_minTrackView(slider) (((UIImageView *(*)(UISlider *, SEL))objc_msgSend)(slider, NSSelectorFromString(CFSTR__minTrackView)))
#define UISlider_maxTrackView(slider) (((UIImageView *(*)(UISlider *, SEL))objc_msgSend)(slider, NSSelectorFromString(CFSTR__maxTrackView)))

//@interface UISlider (Private)
//
//@property (nonatomic, strong, readonly) UIImageView *_minTrackView;
//
//@property (nonatomic, strong, readonly) UIImageView *_maxTrackView;
//
//- (void)_layoutSubviewsForBoundsChange:(BOOL)boundsChange;
//
//@end
