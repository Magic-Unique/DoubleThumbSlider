//
//  ViewController.m
//  DoubleThumbSliderDemo
//
//  Created by Magic-Unique on 2018/7/1.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "ViewController.h"
#import <DoubleThumbSlider/DTSlider.h>

@interface ViewController ()

@property (nonatomic, strong, readonly) DTSlider *normalSlider;
@property (nonatomic, strong, readonly) DTSlider *customSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _normalSlider = [DTSlider new];
    _normalSlider.continuous = NO;
    [_normalSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_normalSlider];
    
    _customSlider = [DTSlider new];
    _customSlider.continuous = NO;
    [_customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_customSlider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [_customSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_enable"] forState:UIControlStateNormal];
    [_customSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_disable"] forState:UIControlStateNormal];
    [_customSlider setMaximumValueImage:[UIImage imageNamed:@"slider_max"]];
    [_customSlider setMinimumValueImage:[UIImage imageNamed:@"slider_min"]];
    [self.view addSubview:_customSlider];
    
    CGRect frame = self.view.bounds;
    frame.size.height *= 0.5;
    
    self.normalSlider.frame = frame;
    
    frame.origin.y += frame.size.height;
    self.customSlider.frame = frame;
}

- (void)sliderAction:(DTSlider *)sender {
    static BOOL skip = YES;
    if (skip) {
        skip = NO;
        return;
    }
    skip = YES;
    NSLog(@"sss");
    DTSlider *targetSlider = (sender == self.customSlider) ? self.normalSlider : self.customSlider;
//    targetSlider.minValue = sender.minValue;
//    [targetSlider setMinValue:sender.minValue animated:YES];
//    targetSlider.maxValue = sender.maxValue;
//    [targetSlider setMaxValue:sender.maxValue animated:YES];
    [targetSlider setMinValue:sender.minValue maxValue:sender.maxValue animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


@end
