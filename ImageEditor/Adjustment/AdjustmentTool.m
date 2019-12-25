//
//  AdjustmentTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/5.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "AdjustmentTool.h"
#import "SingleImageEditorViewController.h"
#import "FilterEditorToolView.h"
#import "ImageScrollView.h"

@implementation AdjustmentTool
{
    UIScrollView *_scrollView;
    NSArray *_dataArr;
    UISlider *_slider;
    NSString *_currentStr;//记录选中滤镜对应的字符串
}
- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController *)imageEditor{
    if ([super init]) {
        _editor = imageEditor;
        _dataArr = @[@"亮度",@"对比度",@"饱和度",@"曝光度",@"阴影",@"色调"];
        [self setup];
    }
    return self;
}

- (void)setup{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.editor.filterTool addSubview:_scrollView];
 
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editor.filterTool);
        make.left.equalTo(self.editor.filterTool);
        make.right.equalTo(self.editor.filterTool);
        make.height.mas_equalTo(self.editor.filterTool.height - 44);
    }];
    
    CGFloat btnWidth = ScreenW/4;
    CGFloat btnHeight = self.editor.filterTool.height - 44;
    _scrollView.contentSize = CGSizeMake(btnWidth*_dataArr.count, TAB_BAR_HEIGHT);
    for (int i = 0; i < _dataArr.count; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = 500+i;
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
        [btn setTitle:_dataArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    
    _slider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1 action:@selector(sliderDidChange)];
    _slider.superview.center = CGPointMake(20, self.editor.scrollView.imageView.center.y);
    _slider.superview.hidden = YES;
    _slider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
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

- (void)sliderDidChange{
    if (_currentStr) {
        [self filterImageWithFilterName:_currentStr SliderValue:_slider.value];
    }
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag <= 505) {
        _slider.superview.hidden = NO;
    }
    switch (sender.tag) {
        case 500://亮度
        {
            _currentStr = @"GPUImageBrightnessFilter";
            _slider.minimumValue = -1;
            _slider.maximumValue = 1;
            _slider.value = 0;
            break;
        }
        case 501://对比度
        {
            _currentStr = @"GPUImageContrastFilter";
            _slider.minimumValue = 0;
            _slider.maximumValue = 4;
            _slider.value = 1;
            break;
        }
        case 502://饱和度
        {
            _currentStr = @"GPUImageSaturationFilter";
            _slider.minimumValue = 0;
            _slider.maximumValue = 2;
            _slider.value = 1;
            break;
        }
        case 503://曝光度
        {
            _currentStr = @"GPUImageExposureFilter";
            _slider.minimumValue = -10;
            _slider.maximumValue = 10;
            _slider.value = 0;
            break;
        }
        case 504://阴影
        {
            _currentStr = @"GPUImageHighlightShadowFilter";
            _slider.minimumValue = 0;
            _slider.maximumValue = 1;
            _slider.value = 0;
            break;
        }
        case 505://色调
        {
            _currentStr = @"GPUImageHueFilter";
            _slider.minimumValue = 1;
            _slider.maximumValue = 200;
            _slider.value = 1;
            break;
        }
        default:
            break;
    }
}

- (void)filterImageWithFilterName:(NSString *)filterName SliderValue:(CGFloat)value{
    
    GPUImageFilter *passthroughFilter;
    if ([filterName isEqualToString:@"GPUImageBrightnessFilter"]) {//亮度
        GPUImageBrightnessFilter *brightness =  [[GPUImageBrightnessFilter alloc] init];
        brightness.brightness = value;// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
        passthroughFilter = brightness;
    } else if ([filterName isEqualToString:@"GPUImageExposureFilter"]){//曝光
        GPUImageExposureFilter *exposure =  [[GPUImageExposureFilter alloc] init];
        exposure.exposure = value;// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
        passthroughFilter = exposure;
    } else if ([filterName isEqualToString:@"GPUImageContrastFilter"]){//对比度
        GPUImageContrastFilter *contrast =  [[GPUImageContrastFilter alloc]init];
        contrast.contrast = value;//Contrast ranges from 0.0 to 4.0 (max contrast), with 1.0 as the normal level
        passthroughFilter = contrast;
    } else if ([filterName isEqualToString:@"GPUImageSaturationFilter"]){//饱和度
        GPUImageSaturationFilter *saturation =  [[GPUImageSaturationFilter alloc] init];
        saturation.saturation = value;//Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 1.0 as the normal level
        passthroughFilter = saturation;
    } else if ([filterName isEqualToString:@"GPUImageHighlightShadowFilter"]) {
        GPUImageHighlightShadowFilter *shadow = [[GPUImageHighlightShadowFilter alloc] init];
        shadow.shadows = value;//0 - 1, increase to lighten shadows.
        shadow.highlights = 1;
        passthroughFilter = shadow;
    } else if ([filterName isEqualToString:@"GPUImageHueFilter"]){//色调
        GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
        hue.hue = value;
        passthroughFilter = hue;
    }
    [passthroughFilter forceProcessingAtSize:self.editor.scrollView.currentImage.size];
    [passthroughFilter useNextFrameForImageCapture];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self.editor.scrollView.currentImage];
    [stillImageSource addTarget:passthroughFilter];
    [stillImageSource processImage];
    
    UIImage *finallImage = [passthroughFilter imageFromCurrentFramebuffer];
    
    self.editor.scrollView.imageView.image = finallImage;
}

- (UIImage *)adjustmentResultImage{
    return self.editor.scrollView.imageView.image;
}

- (void)clearupSubviews{
    [_scrollView removeFromSuperview];
    [_slider.superview removeFromSuperview];
    _dataArr = nil;
    _currentStr = nil;
}

@end
