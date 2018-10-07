//
//  DTSlider+Private.m
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSlider+Private.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSMutableDictionary *DTStringCaches() {
    static NSMutableDictionary *caches = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        caches = [NSMutableDictionary dictionary];
    });
    return caches;
}

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

NSString *DTStringFrom(NSString *input) {
    NSMutableDictionary *caches = DTStringCaches();
    if (caches[input]) {
        return caches[input];
    }
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    char *bytes = (char *)data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        bytes[i]--;
    }
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    caches[input] = output;
    return output;
}

@implementation DTSlider (Private)

- (BOOL)_containsThumbImage {
    return [self valueForKey:CFSTR__thumbView] != nil;
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
    return [self thumbRectForBounds:self.bounds trackRect:DTSlider_maxTrackClipView(self).frame value:value];
}

#pragma mark - Property setter

- (void)set_currentThumbView:(UIImageView *)_currentThumbView {
    if (_currentThumbView) {
        if ([self _containsThumbImage]) {
            [self setValue:_currentThumbView forKey:CFSTR__thumbView];
        } else {
            [self setValue:_currentThumbView forKey:CFSTR__thumbViewNeue];
        }
        [self bringSubviewToFront:_currentThumbView];
    }
}

#pragma mark - Property getter

- (UIImageView *)_currentThumbView {
    if ([self _containsThumbImage]) {
        return [super valueForKey:CFSTR__thumbView];
    } else {
        return [super valueForKey:CFSTR__thumbViewNeue];
    }
}

@end
