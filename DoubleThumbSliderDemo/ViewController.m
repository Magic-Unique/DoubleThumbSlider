//
//  ViewController.m
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "ViewController.h"
#import "DTSliderView.h"

@interface ViewController ()

@property (nonatomic, strong, readonly) UIView *bgView;

@property (nonatomic, strong, readonly) DTSliderView *normalSliderView;
@property (nonatomic, strong, readonly) DTSliderView *customSliderView;

@property (nonatomic, strong, readonly) UIButton *applyBtn;
@property (nonatomic, strong, readonly) UISwitch *animationg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bgView = [UIView new];
    [self.view addSubview:_bgView];
    
    _normalSliderView = [DTSliderView new];
    [self.bgView addSubview:_normalSliderView];

    
    _customSliderView = [DTSliderView new];
//    _customSlider.continuous = NO;
    [_customSliderView.slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [_customSliderView.slider setMinimumTrackImage:[UIImage imageNamed:@"slider_enable"] forState:UIControlStateNormal];
    [_customSliderView.slider setMaximumTrackImage:[UIImage imageNamed:@"slider_disable"] forState:UIControlStateNormal];
    [_customSliderView.slider setMaximumValueImage:[UIImage imageNamed:@"slider_max"]];
    [_customSliderView.slider setMinimumValueImage:[UIImage imageNamed:@"slider_min"]];
    [self.bgView addSubview:_customSliderView];
    
    _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_applyBtn setTitle:@"Apply value animation: " forState:UIControlStateNormal];
    [_applyBtn setTitleColor:UIColor.greenColor forState:UIControlStateNormal];
    [_applyBtn sizeToFit];
    [_applyBtn addTarget:self action:@selector(onApply) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_applyBtn];
    
    _animationg = [UISwitch new];
    [self.bgView addSubview:_animationg];
}

- (UILabel *)createLabel {
    UILabel *label = [UILabel new];
    label.text = @"0.0000000";
    label.font = [UIFont fontWithName:@"Courier" size:20];
    return label;
}

- (void)onApply {
    [self.customSliderView.slider setMinValue:self.normalSliderView.slider.minValue
                                     maxValue:self.normalSliderView.slider.maxValue
                                     animated:self.animationg.isOn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.view.bounds;
    frame.origin.y += 20;
    frame.size.height -= 20;
    self.bgView.frame = frame;
    
    CGRect midFrame = CGRectZero;
    midFrame.size.width = self.view.bounds.size.width;
    midFrame.size.height = MAX(self.applyBtn.frame.size.height, self.animationg.frame.size.height) + 40;
    
    [_applyBtn sizeToFit];
    
    CGRect bounds = frame;
    
    frame = self.normalSliderView.frame;
    frame.origin.x = 0;
    frame.origin.y = 20;
    frame.size.width = bounds.size.width;
    frame.size.height = (bounds.size.height - midFrame.size.height) * 0.5;
    self.normalSliderView.frame = frame;
    
    frame = self.applyBtn.frame;
    frame.size.height = midFrame.size.height;
    frame.origin.y = (bounds.size.height - frame.size.height) * 0.5;
    self.applyBtn.frame = frame;
    
    frame = self.animationg.frame;
    frame.origin.x = bounds.size.width - frame.size.width;
    frame.origin.y = (bounds.size.height - frame.size.height) * 0.5;
    self.animationg.frame = frame;
    
    frame = self.customSliderView.frame;
    frame.origin.x = 0;
    frame.origin.y = bounds.size.height - self.normalSliderView.frame.size.height;
    frame.size.width = bounds.size.width;
    frame.size.height = self.normalSliderView.frame.size.height;
    self.customSliderView.frame = frame;
}


@end
