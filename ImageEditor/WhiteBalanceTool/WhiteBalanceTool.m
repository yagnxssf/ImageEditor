//
//  WhiteBalanceTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/4.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "WhiteBalanceTool.h"
#import "SingleImageEditorViewController.h"
#import "FilterEditorToolView.h"
#import "ImageScrollView.h"

@implementation WhiteBalanceTool
{
    UISlider *_temperatureSlider;
    UISlider *_tintSlider;
}

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController *)imageEditor{
    if ([super init]) {
        _editor = imageEditor;
        
        [self setup];
    }
    return self;
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 240, 35)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.scrollView addSubview:container];
    
    return slider;
}

- (void)setup{
    
    _temperatureSlider = [self sliderWithValue:5000 minimumValue:1000 maximumValue:10000 action:@selector(sliderDidChange)];
    _temperatureSlider.superview.center = CGPointMake(20, self.editor.scrollView.imageView.center.y);
    _temperatureSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    _tintSlider = [self sliderWithValue:0 minimumValue:-1000 maximumValue:1000 action:@selector(sliderDidChange)];
    _tintSlider.superview.center = CGPointMake(self.editor.view.width-20, _temperatureSlider.superview.center.y);
    _tintSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    
    
}

- (UIImage *)addWhiteBalanceWithTemperature:(CGFloat)temperature tint:(CGFloat)tint{
    //使用滤镜
    GPUImageWhiteBalanceFilter *disFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    disFilter.temperature = temperature;//色温
    disFilter.tint = tint;//着色
    //设置渲染的区域
    [disFilter forceProcessingAtSize:self.editor.scrollView.currentImage.size];
    [disFilter useNextFrameForImageCapture];
    
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.editor.scrollView.currentImage];
    
    //添加滤镜
    [stillImageSource addTarget:disFilter];
    
    //开始渲染
    [stillImageSource processImage];
    
    //获取渲染后的图片
    UIImage *finalImage = [disFilter imageFromCurrentFramebuffer];
    
    return finalImage;
}

- (void)sliderDidChange{
    CGFloat temperatureValue = _temperatureSlider.value;
    CGFloat tintValue = _tintSlider.value;
    self.editor.scrollView.imageView.image = [self addWhiteBalanceWithTemperature:temperatureValue tint:tintValue];
}

- (UIImage *)whiteBalanceResultImage{
    CGFloat temperatureValue = _temperatureSlider.value;
    CGFloat tintValue = _tintSlider.value;
    return [self addWhiteBalanceWithTemperature:temperatureValue tint:tintValue];
}

- (void)clearupSubviews{
    [_tintSlider.superview removeFromSuperview];
    [_temperatureSlider.superview removeFromSuperview];
    _tintSlider = nil;
    _temperatureSlider = nil;
    self.editor.scrollView.imageView.image = self.editor.scrollView.currentImage;
}



@end
