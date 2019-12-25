//
//  SliderView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "SliderView.h"

@interface SliderView()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation SliderView
{
    UILabel *_titleLab;
    UILabel *_valueLab;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:9];
    titleLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self addSubview:titleLab];
    _titleLab = titleLab;
    
    UILabel *valueLab = [UILabel new];
    valueLab.textColor = titleLab.textColor;
    valueLab.font = titleLab.font;
    [self addSubview:valueLab];
    _valueLab = valueLab;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.continuous = YES;
    [slider setThumbImage:[UIImage imageNamed:@"knob-slider"] forState:UIControlStateNormal];
    [slider setMinimumTrackTintColor:RGB(81, 154, 255)];
    [slider setMaximumTrackTintColor:RGBA(255, 255, 255,0.2)];
    slider.value = 0;
    slider.minimumValue = -1;
    slider.maximumValue = 1;
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(22);
        make.right.equalTo(self).offset(-22);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self);
    }];
    self.slider = slider;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider);
        make.bottom.equalTo(slider.mas_top);
    }];
    
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(9);
        make.centerY.equalTo(titleLab);
    }];
    
    self.cur_brightness = 0;
    self.cur_contrast = 1;
    self.cur_saturation = 1;
    self.cur_visibility = 0;
    self.cur_shadow = 0;
    self.cur_hue = 1;
    self.cur_temperature = 5000;
    self.cur_tint = 0;
    self.cur_alpha = 1;
    self.cur_lineWidth = 5;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;

}

- (void)setType:(SliderType)type{
    _type = type;
    switch (self.type) {
        case SliderTypeBrightness:
        {
            if (self.cur_brightness >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",self.cur_brightness*100];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_brightness*100];
            }
            break;
        }
        case SliderTypeContrast:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_contrast*10];
            break;
        }
        case SliderTypeSaturation:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_saturation*50];
            break;
        }
        case SliderTypeVisibility:
        {
            CGFloat tempValue = self.cur_visibility * 10;
            if (tempValue >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",tempValue];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",tempValue];
            }
            break;
        }
        case SliderTypeShadow:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_shadow*100];
            break;
        }
        case SliderTypeHue:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_hue];
            break;
        }
        case SliderTypeTemperature:
        {
            CGFloat tempValue = self.cur_temperature - 5000;
            if (tempValue >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",tempValue/50];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",tempValue/50];
            }
            break;
        }
        case SliderTypeTint:
        {
            if (self.cur_tint >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",self.cur_tint/2];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_tint/2];
            }
            break;
        }
        case SliderTypeAlpha:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_alpha*100];
            break;
        }
        case SliderTypeLineWidth:
        {
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_lineWidth];
            break;
        }
        default:
            break;
    }
}

- (void)setSliderMaxValue:(float)maxValue minValue:(float)minValue{
    self.slider.maximumValue = maxValue;
    self.slider.minimumValue = minValue;
    
    switch (self.type) {
        case SliderTypeBrightness:
        {
            self.slider.value = self.cur_brightness;
            break;
        }
        case SliderTypeContrast:
        {
            self.slider.value = self.cur_contrast;
            break;
        }
        case SliderTypeSaturation:
        {
            self.slider.value = self.cur_saturation;
            break;
        }
        case SliderTypeVisibility:
        {
            self.slider.value = self.cur_visibility;
            break;
        }
        case SliderTypeShadow:
        {
            self.slider.value = self.cur_shadow;
            break;
        }
        case SliderTypeHue:
        {
            self.slider.value = self.cur_hue;
            break;
        }
        case SliderTypeTemperature://色温
        {
            self.slider.value = self.cur_temperature;
            break;
        }
        case SliderTypeTint://着色
        {
            self.slider.value = self.cur_tint;
            break;
        }
        case SliderTypeAlpha://透明度
        {
            self.slider.value = self.cur_alpha;
            break;
        }
        case SliderTypeLineWidth://粗细
        {
            self.slider.value = self.cur_lineWidth;
            break;
        }
        default:
            break;
    }
}

- (void)sliderValueChange:(UISlider *)sender{
    switch (self.type) {
        case SliderTypeBrightness:
        {
            self.cur_brightness = sender.value;
            if (self.cur_brightness >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",self.cur_brightness*100];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_brightness*100];
            }
            break;
        }
        case SliderTypeContrast:
        {
            self.cur_contrast = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_contrast*10];
            break;
        }
        case SliderTypeSaturation:
        {
            self.cur_saturation = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_saturation*50];
            break;
        }
        case SliderTypeVisibility:
        {
            self.cur_visibility = sender.value;
            CGFloat tempValue = self.cur_visibility * 10;
            if (tempValue >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",tempValue];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",tempValue];
            }
            break;
        }
        case SliderTypeShadow:
        {
            self.cur_shadow = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_shadow*100];
            break;
        }
        case SliderTypeHue:
        {
            self.cur_hue = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_hue];
            break;
        }
        case SliderTypeTemperature:
        {
            self.cur_temperature = sender.value;
            CGFloat tempValue = self.cur_temperature - 5000;
            if (tempValue >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",tempValue/50];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",tempValue/50];
            }
            break;
        }
        case SliderTypeTint:
        {
            self.cur_tint = sender.value;
            if (self.cur_tint >= 0) {
                _valueLab.text = [NSString stringWithFormat:@"+%.0f",self.cur_tint/2];
            } else {
                _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_tint/2];
            }
            break;
        }
        case SliderTypeAlpha:
        {
            self.cur_alpha = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_alpha*100];
            break;
        }
        case SliderTypeLineWidth:
        {
            self.cur_lineWidth = sender.value;
            _valueLab.text = [NSString stringWithFormat:@"%.0f",self.cur_lineWidth];
            break;
        }
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChangeWithValue:type:valueText:)]) {
        [self.delegate sliderValueChangeWithValue:sender.value type:self.type valueText:_valueLab.text];
    }
}

- (void)clearAllValue{
    _valueLab.text = @"";
    self.cur_brightness = 0;
    self.cur_contrast = 1;
    self.cur_saturation = 1;
    self.cur_visibility = 0;
    self.cur_shadow = 0;
    self.cur_hue = 1;
    self.cur_temperature = 5000;
    self.cur_tint = 0;
    self.cur_alpha = 1;
    self.cur_lineWidth = 5;
}



@end
