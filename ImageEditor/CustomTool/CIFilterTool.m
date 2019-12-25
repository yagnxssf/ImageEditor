//
//  CIFilterTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CIFilterTool.h"

@interface CIFilterTool()

@property (nonatomic, strong) GPUImageFilterGroup *myFilterGroup;//滤镜组

@end

@implementation CIFilterTool

SASingletonM(CIFilterTool);

#pragma mark 滤镜处理事件
- (UIImage *)fliterEvent:(NSString *)filterName originImage:(UIImage *)originImage
{
    if ([filterName isEqualToString:@"OriginImage"]) {
        return originImage;
        
    }else{
        //将UIImage转换成CIImage
        CIImage *ciImage = [[CIImage alloc] initWithImage:originImage];
        
        //创建滤镜
        CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        
        //已有的值不改变，其他的设为默认值
        [filter setDefaults];
        
        //获取绘制上下文
        CIContext *context = [CIContext contextWithOptions:nil];
        
        //渲染并输出CIImage
        CIImage *outputImage = [filter outputImage];
        
        //创建CGImage句柄
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        
        //获取图片
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        //释放CGImage句柄
        CGImageRelease(cgImage);
        
        return image;
    }
    
}

- (UIImage *)adjustmentWithValueDic:(NSDictionary *)valueDic originImage:(UIImage *)originImage{
    //初始化GPUImagePicture
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:originImage smoothlyScaleOutput:YES];
    //亮度
    GPUImageBrightnessFilter *brightness =  [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = [valueDic[@"brightness"] floatValue];
    //曝光度
    GPUImageExposureFilter *exposure =  [[GPUImageExposureFilter alloc] init];
    exposure.exposure = [valueDic[@"exposure"] floatValue];
    //对比度
    GPUImageContrastFilter *contrast =  [[GPUImageContrastFilter alloc]init];
    contrast.contrast = [valueDic[@"contrast"] floatValue];
    //饱和度
    GPUImageSaturationFilter *saturation =  [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = [valueDic[@"saturation"] floatValue];
    //阴影
    GPUImageHighlightShadowFilter *shadow = [[GPUImageHighlightShadowFilter alloc] init];
    shadow.shadows = [valueDic[@"shadow"] floatValue];//0 - 1, increase to lighten shadows.
    shadow.highlights = 1;
    //色调
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = [valueDic[@"hue"] floatValue];
    
    //滤镜组
    self.myFilterGroup = [[GPUImageFilterGroup alloc] init];
    //将滤镜组加在GPUImagePicture上
    [picture addTarget:self.myFilterGroup];
    //将滤镜加在FilterGroup中
    [self addGPUImageFilter:brightness];
    [self addGPUImageFilter:exposure];
    [self addGPUImageFilter:contrast];
    [self addGPUImageFilter:saturation];
    [self addGPUImageFilter:shadow];
    [self addGPUImageFilter:hue];
    
    //处理图片
    [picture processImage];
    [self.myFilterGroup useNextFrameForImageCapture];
    
    UIImage *finalImage = [self.myFilterGroup imageFromCurrentFramebuffer];
    
    return finalImage;
}

- (UIImage *)balanceWithValueBalanceDic:(NSDictionary *)balanceDic originImage:(UIImage *)originImage{
    //使用滤镜
    GPUImageWhiteBalanceFilter *disFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    disFilter.temperature = [balanceDic[@"temperature"] floatValue];//色温
    disFilter.tint = [balanceDic[@"tint"] floatValue];//着色
    //设置渲染的区域
    [disFilter forceProcessingAtSize:originImage.size];
    [disFilter useNextFrameForImageCapture];
    
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:originImage];
    
    //添加滤镜
    [stillImageSource addTarget:disFilter];
    
    //开始渲染
    [stillImageSource processImage];
    
    //获取渲染后的图片
    UIImage *finalImage = [disFilter imageFromCurrentFramebuffer];
    
    return finalImage;
}

#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter{
    
    [self.myFilterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = self.myFilterGroup.filterCount;
    
    if (count == 1)
    {
        //设置初始滤镜
        self.myFilterGroup.initialFilters = @[newTerminalFilter];
        //设置末尾滤镜
        self.myFilterGroup.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = self.myFilterGroup.terminalFilter;
        NSArray *initialFilters                          = self.myFilterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        //设置初始滤镜
        self.myFilterGroup.initialFilters = @[initialFilters[0]];
        //设置末尾滤镜
        self.myFilterGroup.terminalFilter = newTerminalFilter;
    }
}


@end
