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
	__strong UIImageView *_newThumbView;// 自己创建的ThumbView
	__weak UIImageView *_minThumbView;// 左边的ThumbView，重合时候可能会和_maxThumbView互换
	__weak UIImageView *_maxThumbView;// 右边的ThumbView，重合时候可能会和_minThumbView互换
	
	/* 
	 * 以下为重合标记，如果最大值==最小值，touchesBegan 会设置bool为yes，并获取对应的值
	 * 重合标记会被 touchesMove 激活一次，并关掉重合标记防止下一次 touchesMove 重复激活。
	 */

	BOOL coincide;
	float coincideValue;
}

@end




@interface UISlider (Subviews)

@end


@implementation MUDoubleThumbSlider

@end




@implementation UISlider (Subviews)


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
