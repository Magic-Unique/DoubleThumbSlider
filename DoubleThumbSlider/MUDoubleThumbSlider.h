//
//  MUDoubleThumbSlider.h
//  DoubleThumbSlider
//
//  Created by Magic-Unique on 16/1/1.
//  Copyright © 2016年 unique. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  双滑块类，暂时不支持样式定制。
 */

@interface MUDoubleThumbSlider : UISlider

/** 滑块小值 */
@property (nonatomic, assign) CGFloat maxValue;

/** 滑块大值 */
@property (nonatomic, assign) CGFloat minValue;

@end

