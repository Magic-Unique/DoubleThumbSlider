//
//  DTSlider.h
//  DoubleThumbSliderDemo
//
//  Created by 吴双 on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSlider : UISlider

/** Current max value */
@property (nonatomic, assign) float maxValue;

/** Current min value */
@property (nonatomic, assign) float minValue;

@end
