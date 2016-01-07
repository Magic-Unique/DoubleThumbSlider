# DoubleThumbSlider

双滑块Slider控件

## 效果图

![gif](Slider.gif)

## 使用方式

```objc
@interface MUDoubleThumbSlider : UISlider

/** 滑块小值 */
@property (nonatomic, assign) CGFloat maxValue;

/** 滑块大值 */
@property (nonatomic, assign) CGFloat minValue;

@end
```

使用系统自带的控件通过KVC改造而成，只有两个属性，可以设置两个滑块条的左右位置以及滑块条的值的获取。
其他的使用方法和系统自带的 UISlider 一样。使用 target-action 列表监控两个值的变化，取父类的value可以获取到变化的值（用户滑动左边，value就是小值，用户滑动右边，value就是大值）