//
//  SliderView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SliderType) {
    SliderTypeBrightness = 0,//亮度
    SliderTypeContrast,//对比度
    SliderTypeSaturation,//氛围
    SliderTypeVisibility,//高光
    SliderTypeShadow,//调整的阴影
    SliderTypeHue,//调整的色调
    SliderTypeTemperature,//白平衡的色温
    SliderTypeTint,//白平衡的着色
    SliderTypeAlpha,//文字的不透明度
    SliderTypeLineWidth,//标记粗细
};

@protocol SliderViewDelegate <NSObject>

- (void)sliderValueChangeWithValue:(float)value type:(SliderType)type valueText:(NSString *)valueText;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SliderView : UIView

@property (nonatomic, assign) float cur_brightness;

@property (nonatomic, assign) float cur_contrast;

@property (nonatomic, assign) float cur_saturation;

@property (nonatomic, assign) float cur_visibility;

@property (nonatomic, assign) float cur_shadow;

@property (nonatomic, assign) float cur_hue;

@property (nonatomic, assign) float cur_temperature;

@property (nonatomic, assign) float cur_tint;

@property (nonatomic, assign) float cur_alpha;

@property (nonatomic, assign) float cur_lineWidth;

@property (nonatomic, copy) NSString *title;

- (void)setSliderMaxValue:(float)maxValue minValue:(float)minValue;

@property (nonatomic, assign) SliderType type;

@property (nonatomic, assign) id <SliderViewDelegate> delegate;


- (void)clearAllValue;

@end

NS_ASSUME_NONNULL_END
