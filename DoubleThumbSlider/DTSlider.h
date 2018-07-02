//
//  DTSlider.h
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSlider : UISlider

/** Current max value */
@property (nonatomic, assign) float maxValue;

/** Current min value */
@property (nonatomic, assign) float minValue;

- (void)setMaxValue:(float)maxValue animated:(BOOL)animated;
- (void)setMinValue:(float)minValue animated:(BOOL)animated;
- (void)setMinValue:(float)minValue maxValue:(float)maxValue animated:(BOOL)animated;

@end
