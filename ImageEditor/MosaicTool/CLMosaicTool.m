//
//  CLMosaicTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CLMosaicTool.h"
#import "CLMosaicView.h"
#import "SingleImageEditorViewController.h"
#import "ImageScrollView.h"
#import "FilterEditorToolView.h"


@interface CLMosaicTool()

@property (nonatomic, strong)  CIFilter *filter;
@property (nonatomic, strong)  UISlider *slider;

@end

@implementation CLMosaicTool
{
    CLMosaicView *mosaicView; //显示马赛克
    UIView *_menuView; //底部菜单
    UIButton *_normalButton;//普通风格
    UIButton *_imgMosaicBtn;//图片马赛克风格
    UILabel *_valueLab;
    
}

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController *)imageEditor{
    if ([super init]) {
        _editor = imageEditor;
        [self setup];
        
    }
    return self;
}

- (void)setup{
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.editor.scrollView.imageView.image];
    //生成马赛克
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:ciImage  forKey:kCIInputImageKey];
    //马赛克像素大小
    [filter setValue:@(25) forKey:kCIInputScaleKey];
    
    self.filter = filter;
    
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
    UIImage *showImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    
    mosaicView = [[CLMosaicView alloc] initWithFrame:self.editor.scrollView.imageView.bounds];
    mosaicView.image = showImage;
    mosaicView.surfaceImage = self.editor.scrollView.imageView.image;
    [self.editor.scrollView.imageView addSubview:mosaicView];
    
    self.editor.scrollView.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    _menuView = [[UIView alloc] init];
    _menuView.frame = CGRectMake(0, 0, self.editor.filterTool.width, self.editor.filterTool.height-44);
    _menuView.backgroundColor = self.editor.filterTool.backgroundColor;
    [self.editor.filterTool addSubview:_menuView];
    
    [self setMenu];
    
    [self setSliderView];
    
}

- (void)normalMosaicImg:(UIButton *)sender{
    sender.selected = YES;
    _imgMosaicBtn.selected = NO;
    sender.layer.borderColor = RGB(81, 154, 255).CGColor;
    _imgMosaicBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIImage *img = [self buildMosicImage];

    CIImage *ciImage = [[CIImage alloc] initWithImage:self.editor.scrollView.imageView.image];
    [self.filter setValue:ciImage forKey:kCIInputImageKey];
    [self.filter setValue:@(25) forKey:kCIInputScaleKey];

    CIImage *outImage = [self.filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
    UIImage *showImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    
    mosaicView = [[CLMosaicView alloc] initWithFrame:self.editor.scrollView.imageView.bounds];
    mosaicView.image = showImage;
    mosaicView.surfaceImage = img;
    [self.editor.scrollView.imageView addSubview:mosaicView];
    [mosaicView setMosaicLineWidth:self.slider.value];

    mosaicView.image = showImage;
    
//    [self.editor.scrollView.imageView bringSubviewToFront:self.eraserBtn];
}

- (void)createImgMosaicImg:(UIButton *)sender{
    sender.selected = YES;
    _normalButton.selected = NO;
    sender.layer.borderColor = RGB(81, 154, 255).CGColor;
    _normalButton.layer.borderColor = [UIColor clearColor].CGColor;
   
    UIImage *img = [self buildMosicImage];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"color-2174065_1280.png"]];
    [self.filter setValue:ciImage forKey:kCIInputImageKey];
    [self.filter setValue:@(1) forKey:kCIInputScaleKey];

    CIImage *outImage = [self.filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
    UIImage *showImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    
    mosaicView = [[CLMosaicView alloc] initWithFrame:self.editor.scrollView.imageView.bounds];
    mosaicView.image = showImage;
    mosaicView.surfaceImage = img;
    [self.editor.scrollView.imageView addSubview:mosaicView];
    [mosaicView setMosaicLineWidth:self.slider.value];

    mosaicView.image = showImage;
    
//    [self.editor.scrollView.imageView bringSubviewToFront:self.eraserBtn];

}

- (void)setSliderView{
    UILabel *titleLab = [UILabel new];
    titleLab.text = NSLocalizedString(@"大小", nil);
    titleLab.font = [UIFont systemFontOfSize:9];
    titleLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [_menuView addSubview:titleLab];
    
    UILabel *valueLab = [UILabel new];
    valueLab.textColor = titleLab.textColor;
    valueLab.font = titleLab.font;
    [_menuView addSubview:valueLab];
    _valueLab = valueLab;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.continuous = YES;
    [slider setThumbImage:[UIImage imageNamed:@"knob-slider"] forState:UIControlStateNormal];
    [slider setMinimumTrackTintColor:RGB(81, 154, 255)];
    [slider setMaximumTrackTintColor:RGBA(255, 255, 255,0.2)];
    slider.value = 10;
    slider.minimumValue = 10;
    slider.maximumValue = 30;
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [_menuView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_imgMosaicBtn.mas_right).offset(30*WidthRage);
        make.right.equalTo(self->_menuView).offset(-30*WidthRage);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(self->_menuView);
    }];
    self.slider = slider;
    
    _valueLab.text = [NSString stringWithFormat:@"%.0f",slider.value];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider);
        make.bottom.equalTo(slider.mas_top);
    }];
    
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(9);
        make.centerY.equalTo(titleLab);
    }];
    
}

- (void)sliderValueChange:(UISlider *)sender{
    _valueLab.text = [NSString stringWithFormat:@"%.0f",sender.value];
    [mosaicView setMosaicLineWidth:sender.value];
}

- (void)setMenu{
    UIButton *normalButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 25, 60*WidthRage, 60*WidthRage)];
    normalButton.centerY = _menuView.centerY;
    normalButton.backgroundColor = [UIColor redColor];
    [normalButton setImage:self.editor.scrollView.imageView.image forState:UIControlStateNormal];
    [normalButton setAdjustsImageWhenHighlighted:NO];
    normalButton.layer.borderColor = RGB(81, 154, 255).CGColor;
    normalButton.layer.borderWidth = 2;
    normalButton.selected = YES;
    [_menuView addSubview:normalButton];
    [normalButton addTarget:self action:@selector(normalMosaicImg:) forControlEvents:UIControlEventTouchUpInside];
    _normalButton = normalButton;
    
    UIButton *imgMosaicBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(normalButton.frame) + 10, 25, 60*WidthRage, 60*WidthRage)];
    imgMosaicBtn.centerY = _menuView.centerY;
    imgMosaicBtn.backgroundColor = [UIColor orangeColor];
    [imgMosaicBtn setImage:[UIImage imageNamed:@"color-2174065_1280.png"] forState:UIControlStateNormal];
    [imgMosaicBtn setAdjustsImageWhenHighlighted:NO];
    imgMosaicBtn.layer.borderColor = [UIColor clearColor].CGColor;
    imgMosaicBtn.layer.borderWidth = 2;
    [_menuView addSubview:imgMosaicBtn];
    [imgMosaicBtn addTarget:self action:@selector(createImgMosaicImg:) forControlEvents:UIControlEventTouchUpInside];
    _imgMosaicBtn = imgMosaicBtn;
}

- (UIImage*)buildMosicImage
{
    [mosaicView removeFromSuperview];
    UIGraphicsBeginImageContextWithOptions(mosaicView.bounds.size, NO, 0);
    [mosaicView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)buildImage
{
    [mosaicView removeFromSuperview];
    [_menuView removeFromSuperview];
    UIGraphicsBeginImageContextWithOptions(mosaicView.bounds.size, NO, 0);
    [mosaicView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearupSubviews{
    [mosaicView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)removeEraserView{

}

@end
