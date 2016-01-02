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

使用系统自带的空间通过KVC改造而成，只有两个属性，可以设置两个滑块条的左右位置以及滑块条的值的获取。