//
//  ViewController.m
//  DoubleThumbSlider
//
//  Created by Magic-Unique on 16/1/1.
//  Copyright © 2016年 unique. All rights reserved.
//

#import "ViewController.h"

#import "MUDoubleThumbSlider.h"

@interface ViewController ()

@property (nonatomic, strong) MUDoubleThumbSlider *doubleThumbSlider;

@property (nonatomic, strong) UIImageView *newImageView;

@property (nonatomic, strong) UILabel *minLabel;

@property (nonatomic, strong) UILabel *maxLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.doubleThumbSlider];
	[self.view addSubview:self.minLabel];
	[self.view addSubview:self.maxLabel];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGRect frame  = self.view.bounds;
	frame.size.height *= 0.5;
	self.doubleThumbSlider.frame = frame;
	
	[self.minLabel sizeToFit];
	frame = self.minLabel.frame;
	frame.origin.y = 20;
	self.minLabel.frame = frame;
	
	[self.maxLabel sizeToFit];
	frame = self.maxLabel.frame;
	frame.origin.x = self.view.bounds.size.width - frame.size.width;
	frame.origin.y = 20;
	self.maxLabel.frame = frame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	self.doubleThumbSlider.maxValue = 1;
//	UIImageView *newImageView = self.newImageView;
//	[self.doubleThumbSlider addSubview:newImageView];
//	[self.doubleThumbSlider setValue:newImageView forKey:@"_thumbViewNeue"];
	
}

- (void)valueDidChange:(MUDoubleThumbSlider *)slider {
	self.minLabel.text = [NSString stringWithFormat:@"%f", slider.minValue];
	self.maxLabel.text = [NSString stringWithFormat:@"%f", slider.maxValue];
	[self.view setNeedsLayout];
}

- (MUDoubleThumbSlider *)doubleThumbSlider {
	if (!_doubleThumbSlider) {
		_doubleThumbSlider = [MUDoubleThumbSlider new];
		_doubleThumbSlider.maxValue = 0.7;
		_doubleThumbSlider.minValue = 0.3;
		[_doubleThumbSlider addTarget:self action:@selector(valueDidChange:) forControlEvents:UIControlEventValueChanged];
	}
	return _doubleThumbSlider;
}

- (UIImageView *)newImageView {
	UIImageView *oldImageView = [self.doubleThumbSlider valueForKey:@"_thumbViewNeue"];
	UIImageView *newImageView = [oldImageView copy];
	newImageView.backgroundColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:0.486];
	return newImageView;
}

- (UILabel *)minLabel {
	if (!_minLabel) {
		_minLabel = [UILabel new];
	}
	return _minLabel;
}

- (UILabel *)maxLabel {
	if (!_maxLabel) {
		_maxLabel = [UILabel new];
	}
	return _maxLabel;
}

@end
