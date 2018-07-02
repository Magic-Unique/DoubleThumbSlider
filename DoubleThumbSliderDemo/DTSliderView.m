//
//  DTSliderView.m
//  DoubleThumbSliderDemo
//
//  Created by 吴双 on 2018/7/2.
//  Copyright © 2018年 unique. All rights reserved.
//

#import "DTSliderView.h"

@interface DTSliderView ()

@property (nonatomic, strong, readonly) UILabel *minValueLabel;

@property (nonatomic, strong, readonly) UILabel *maxValueLabel;

@end

@implementation DTSliderView

+ (UILabel *)createLabel {
    UILabel *label = [UILabel new];
    label.text = @"0.0000000";
    label.font = [UIFont fontWithName:@"Courier" size:20];
    return label;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _slider = [DTSlider new];
        [_slider addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        
        _minValueLabel = [DTSliderView createLabel];
        [self addSubview:_minValueLabel];
        
        _maxValueLabel = [DTSliderView createLabel];
        [self addSubview:_maxValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.minValueLabel sizeToFit];
    [self.maxValueLabel sizeToFit];
    CGRect frame = self.maxValueLabel.frame;
    frame.origin.x = self.bounds.size.width - frame.size.width;
    self.maxValueLabel.frame = frame;
    
    frame = self.slider.frame;
    frame.origin.y = CGRectGetMaxY(self.maxValueLabel.frame);
    frame.size.width = self.bounds.size.width;
    frame.size.height = self.bounds.size.height - self.maxValueLabel.frame.size.height;
    self.slider.frame = frame;
}

- (void)onValueChange:(DTSlider *)sender {
    self.minValueLabel.text = [NSString stringWithFormat:@"%.7f", sender.minValue];
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.7f", sender.maxValue];
    [self setNeedsLayout];
}

@end
