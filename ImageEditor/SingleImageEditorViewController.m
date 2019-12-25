//
//  SingleImageEditorViewController.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "SingleImageEditorViewController.h"
#import "ImageEditorTool.h"
#import "FilterEditorToolView.h"
#import "ImageScrollView.h"
#import "CLClippingPanel.h"
#import "CLRatio.h"
#import "TextTool/CLTextTool.h"
#import "DrawTool/CLDrawTool.h"
#import "MosaicTool/CLMosaicTool.h"
#import "FilterBottomTool.h"
#import "CustomNavBar.h"
#import "CIFilterTool.h"
#import "SliderView.h"



#define ToolHeight 82
#define BottomToolHeight 146
#define Scroll_Y (44 + (IS_iPhoneX?44:0))

@interface SingleImageEditorViewController ()<ImageEditorToolDelegate,FilterEditorToolViewDelegate,FilterBottomToolDelegate,CustomNavBarDelegate,SliderViewDelegate>

@property (nonatomic, strong) CustomNavBar *navBar;

@property (nonatomic, strong) ImageEditorTool *editorTool;//工具条

@property (nonatomic, strong) UIImage *thumbImage;//缩略图

@property (nonatomic, strong) CLTextTool *textTool;

@property (nonatomic, strong) CLDrawTool *drawTool;

@property (nonatomic, strong) CLMosaicTool *mosaicTool;

@property (nonatomic, strong) NSMutableArray *imageStackArr;//图片栈数组

@property (nonatomic, assign) NSInteger cur_showIndex;//当前图片数组显示的下标

@property (nonatomic,assign) BOOL resetEnable;//重置按钮可否点击

@property (nonatomic, strong) UIButton *eraserBtn;

@property (nonatomic, strong) UIImage *contrastImage;//和原图进行对比的图

@end

@implementation SingleImageEditorViewController

- (NSMutableArray *)imageStackArr{
    if (_imageStackArr == nil) {
        _imageStackArr = [NSMutableArray array];
    }
    return _imageStackArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor;
    
    UIGraphicsBeginImageContext(CGSizeMake(180, 180));
    [self.originalImage drawInRect:CGRectMake(0, 0, 180, 180)];
    self.thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNav];
    
    [self setupSubviews];
        
    [self.imageStackArr addObject:self.originalImage];
    self.cur_showIndex = 0;
}

#pragma mark -- CustomNavBarDelegate --
//返回
- (void)leftItemAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//完成
- (void)rightItemAction{
    [self dismissViewControllerAnimated:YES completion:^{
        self.block(self.scrollView.currentImage);
    }];
}

//撤销
- (void)backItemAction{
    if (self.cur_showIndex > 0) {
        self.cur_showIndex--;
        self.scrollView.currentImage = self.imageStackArr[self.cur_showIndex];
        if (self.cur_showIndex == 0) {
            [self.navBar setBackBtnAlpha:0.22];
        }
        [self.navBar setForwardBtnAplha:1];
    } else {
        self.scrollView.currentImage = self.originalImage;
        [self.navBar setBackBtnAlpha:0.22];
    }

}

//前进
- (void)forwardItemAction{
    if (self.cur_showIndex < self.imageStackArr.count-1) {
        self.cur_showIndex++;
        self.scrollView.currentImage = self.imageStackArr[self.cur_showIndex];
        if (self.cur_showIndex == self.imageStackArr.count-1) {
            [self.navBar setForwardBtnAplha:0.22];
        }
        [self.navBar setBackBtnAlpha:1];
    }
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)setNav{
    CustomNavBar *navBar = [[CustomNavBar alloc] initWithFrame:CGRectNull];
    navBar.rightTitle = NSLocalizedString(@"完成", nil);
    navBar.delegate = self;
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        if (IS_iPhoneX) {
            make.top.equalTo(self.view).offset(State_Bar_Height);
        } else {
            make.top.equalTo(self.view);
        }
        make.height.mas_equalTo(44);
    }];
}

- (void)rotate{
    self.scrollView.currentImage = [UIImage imageWithCGImage:self.scrollView.currentImage.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
}

- (void)startClipping{
    UIImage *img = self.scrollView.imageView.image;//
    CGFloat zoomScale = self.scrollView.imageView.width / img.size.width;
    CGRect rct = self.scrollView.gridView.clippingRect;
    rct.size.width  /= zoomScale;
    rct.size.height /= zoomScale;
    rct.origin.x    /= zoomScale;
    rct.origin.y    /= zoomScale;
    UIImage *result = [img crop:rct];
    self.scrollView.currentImage = result;
    
    [self.scrollView.gridView removeFromSuperview];
    self.scrollView.gridView = nil;
    [self.scrollView layoutImageView];
}

- (void)setupSubviews{
    ImageScrollView *scrollView = [[ImageScrollView alloc] initImageScrollViewWithImage:self.originalImage frame:CGRectMake(0, Scroll_Y, self.view.width, ScreenH - ToolHeight-Scroll_Y-Safe_Area_Height)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSArray *toolArr = @[@{@"title":NSLocalizedString(@"滤镜", nil),@"image":@"filter"},
                         @{@"title":NSLocalizedString(@"调整", nil),@"image":@"adjust"},
                         @{@"title":NSLocalizedString(@"白平衡", nil),@"image":@"white-balance"},
                         @{@"title":NSLocalizedString(@"裁剪",nil),@"image":@"crop"},
                         @{@"title":NSLocalizedString(@"马赛克", nil),@"image":@"mosaic"},
                         @{@"title":NSLocalizedString(@"标记", nil),@"image":@"mark"},
                         @{@"title":NSLocalizedString(@"添加文字", nil),@"image":@"text"}];
    ImageEditorTool *editorTool = [[ImageEditorTool alloc] initWithFrame:CGRectNull dataArr:toolArr];
    editorTool.delegate = self;
    editorTool.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:editorTool];
    self.editorTool = editorTool;
 
    FilterEditorToolView *filterTool = [[FilterEditorToolView alloc] init];
    filterTool.delegate = self;
    filterTool.bottomView.delegate = self;
    filterTool.sliderV.delegate = self;
    [self.view addSubview:filterTool];
    self.filterTool = filterTool;
    
    [filterTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomToolHeight);
        make.height.mas_equalTo(BottomToolHeight);
    }];
    
    [editorTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-Safe_Area_Height);
        make.height.mas_equalTo(ToolHeight);
    }];
    
    UIButton *eraserBtn = [UIButton new];
    eraserBtn.hidden = YES;
    [eraserBtn setImage:[UIImage imageNamed:@"contrast"] forState:UIControlStateNormal];
//    [eraserBtn setImage:[UIImage imageNamed:@"eraser-selected"] forState:UIControlStateHighlighted];
    [eraserBtn addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.view addSubview:eraserBtn];
    self.eraserBtn = eraserBtn;
    
    [eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.scrollView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"highlighted"]) {
        BOOL highlighted = [change[@"new"] boolValue];
        if (highlighted) {//显示原图
            if ([change[@"old"] boolValue] == NO) {
                self.scrollView.imageView.image = self.scrollView.currentImage;
            }
        } else {//显示编辑后的图
            if (self.contrastImage) {
                self.scrollView.imageView.image = self.contrastImage;
            }
        }
        
    }
}

#pragma mark -- SliderViewDelegate --
- (void)sliderValueChangeWithValue:(float)value type:(SliderType)type valueText:(NSString *)valueText{
    [self.filterTool reloadItemValueWith:valueText type:type];
    if (type == SliderTypeTemperature || type == SliderTypeTint) {//白平衡
        NSDictionary *valueDic = @{@"temperature":@(self.filterTool.sliderV.cur_temperature),
                                   @"tint":@(self.filterTool.sliderV.cur_tint)
                                   };
        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] balanceWithValueBalanceDic:valueDic originImage:self.scrollView.currentImage];

        self.contrastImage = editImage;
        self.scrollView.imageView.image = editImage;
    } else if (type == SliderTypeAlpha) {//文字的透明度
        [self.textTool setTextFontAlphaWith:value];
    } else if (type == SliderTypeLineWidth) {
        self.drawTool.silderValue = value;
    }
    else {
        NSDictionary *valueDic = @{@"brightness" : @(self.filterTool.sliderV.cur_brightness),
                                   @"exposure" : @(self.filterTool.sliderV.cur_visibility),
                                   @"contrast" : @(self.filterTool.sliderV.cur_contrast),
                                   @"saturation" : @(self.filterTool.sliderV.cur_saturation),
                                   @"shadow" : @(self.filterTool.sliderV.cur_shadow),
                                   @"hue" : @(self.filterTool.sliderV.cur_hue),
                                   };
        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] adjustmentWithValueDic:valueDic originImage:self.scrollView.currentImage];
        self.contrastImage = editImage;
        self.scrollView.imageView.image = editImage;
    }
    
}

#pragma mark --  FilterBottomToolDelegate  --
- (void)filterBottomToolClose{
    //重置UI状态
    [self.textTool clearupSubviews];//添加文字
    [self.drawTool clearupSubviews];//标记
    [self.mosaicTool clearupSubviews];//马赛克
    
    [self.drawTool removeEraserView];
    [self.mosaicTool removeEraserView];
    
    self.eraserBtn.hidden = YES;
    self.contrastImage = nil;
    
    //移除裁剪框
    [self.scrollView.gridView removeFromSuperview];//裁剪
    self.scrollView.gridView = nil;
    [self.scrollView layoutImageView];
    
    //重置图片
    self.scrollView.imageView.image = self.imageStackArr[self.cur_showIndex];
    self.scrollView.currentImage = self.scrollView.imageView.image;
//    if (self.filterTool.toolType == EditorToolTypeFilter) {
//        self.scrollView.currentImage = self.scrollView.currentImage;
//    }
    
    [self subviewsOrignalState];
    
    [self updateConstraintsAnimation];
    
    [self.filterTool sliderViewIsHiden:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.y = Scroll_Y;
        self.scrollView.height = ScreenH - ToolHeight - Scroll_Y - Safe_Area_Height;
    }];
    
}

- (void)filterBottomToolOK{
    //重置UI状态
    [self subviewsOrignalState];
    
    [self.drawTool removeEraserView];
    [self.mosaicTool removeEraserView];
    
    [self updateConstraintsAnimation];
    
    [self.filterTool sliderViewIsHiden:YES];
    
    self.eraserBtn.hidden = YES;
    self.contrastImage = nil;

    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.y = Scroll_Y;
        self.scrollView.height = ScreenH - ToolHeight - Scroll_Y - Safe_Area_Height;
    }];
    self.scrollView.scrollEnabled = YES;
    
    switch (self.filterTool.toolType) {
        case EditorToolTypeFilter://滤镜
        case EditorToolTypeAdjustment://调整
        case EditorToolTypeWhiteBalance://白平衡
            self.scrollView.currentImage = self.scrollView.imageView.image;
            break;
        case EditorToolTypeMosaic:
        {
            UIImage *result = [self.mosaicTool buildImage];
            self.scrollView.currentImage = result;
            break;
        }
        case EditorToolTypeDraw:
        {
            UIImage *result = [self.drawTool buildImageWithBackgroundImage:self.scrollView.imageView.image];
            self.scrollView.currentImage = result;
            break;
        }
        case EditorToolTypeText:
        {
            UIImage *result = [self.textTool buildImage:self.scrollView.imageView.image];
            self.scrollView.currentImage = result;
            break;
        }
        case EditorToolTypeCrop:
        {
            if (self.scrollView.gridView.hidden == NO) {
                [self startClipping];
            } else {
                self.scrollView.currentImage = self.scrollView.imageView.image;
            }
        }
            break;
        default:
            break;
    }
    UIImage *currentImage = self.scrollView.currentImage;
    
    if (self.cur_showIndex == self.imageStackArr.count-1) {//当前为最后一张，直接添加在数组末
        [self.imageStackArr addObject:currentImage];
        self.cur_showIndex = self.imageStackArr.count-1;
    } else { //不是最后一张则替换掉从当前下标之后的所有图片
        if (self.imageStackArr.count > 1) {
            NSInteger count = self.imageStackArr.count;
            NSMutableArray *tempArr = [NSMutableArray array];
            
            for (int i = 0; i < count; i++) {
                if (i > self.cur_showIndex) {
                    [tempArr addObject:self.imageStackArr[i]];
                }
            }
            [self.imageStackArr removeObjectsInArray:tempArr];
            [self.imageStackArr addObject:currentImage];
            self.cur_showIndex = self.imageStackArr.count-1;
        }
    }
    if (self.imageStackArr.count > 1) {
        [self.navBar setBackBtnAlpha:1];
    }
    if (self.cur_showIndex == self.imageStackArr.count - 1) {
        [self.navBar setForwardBtnAplha:0.22];
    }
}

#pragma mark -- FilterEditorToolViewDelegate --
- (void)filterEditorToolDidSelectWith:(FilterEditorToolView *)toolView indexPath:(NSIndexPath *)indexPath{
    if (toolView.toolType == EditorToolTypeFilter) {//滤镜
        NSDictionary *dic = toolView.dataArr[indexPath.row];
        NSString *filterName = dic[@"FilterName"];
        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] fliterEvent:filterName originImage:self.scrollView.currentImage];
        self.scrollView.imageView.image = editImage;
        
    } else if (toolView.toolType == EditorToolTypeCrop) {//裁剪
        NSString *ratioStr = self.filterTool.dataArr[indexPath.row][@"name"];
        if (indexPath.row == 0) {//重置
            if (self.resetEnable == YES) {
                self.scrollView.imageView.image = self.imageStackArr[self.cur_showIndex];
                //图片尺寸变化，裁剪框大小重新设置
                self.scrollView.currentImage = self.scrollView.imageView.image;
                [self.scrollView.gridView removeFromSuperview];
                self.scrollView.gridView = nil;
                [self.scrollView layoutImageView];
                self.scrollView.gridView.hidden = NO;

            }
            
            self.resetEnable = NO;//不能点击
        } else if (indexPath.row == 1) {//旋转
            self.resetEnable = YES;
            self.scrollView.imageView.image = [HImageUtility image:self.scrollView.imageView.image rotation:UIImageOrientationLeft];
            //图片尺寸变化，裁剪框大小重新设置
            self.scrollView.currentImage = self.scrollView.imageView.image;
            NSLog(@"%@",NSStringFromCGSize(self.scrollView.imageView.image.size));
            [self.scrollView.gridView removeFromSuperview];
            self.scrollView.gridView = nil;
            [self.scrollView layoutImageView];

        } else if (indexPath.row == 2) {//翻转
            self.resetEnable = YES;
            self.scrollView.gridView.hidden = YES;

            //Quartz重绘图片
            CGRect rect =  CGRectMake(0, 0, self.scrollView.imageView.image.size.width , self.scrollView.imageView.image.size.height);//创建矩形框
            //根据size大小创建一个基于位图的图形上下文
            UIGraphicsBeginImageContext(rect.size);
            //        UIGraphicsBeginImageContextWithOptions(rect.size, false, 2)
            CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
            CGContextClipToRect(currentContext, rect);//设置当前绘图环境到矩形框
            CGContextRotateCTM(currentContext, M_PI); //旋转180度
            //平移， 这里是平移坐标系，跟平移图形是一个道理
            CGContextTranslateCTM(currentContext, -rect.size.width, -rect.size.height);
            CGContextDrawImage(currentContext, rect, self.scrollView.imageView.image.CGImage);//绘图
            
            //翻转图片
            UIImage *drawImage =  UIGraphicsGetImageFromCurrentImageContext();//获得图片
            self.scrollView.imageView.image = drawImage;

        } else {
            self.resetEnable = YES;
            self.scrollView.gridView.hidden = NO;
            if (![ratioStr containsString:@":"]) {
                ratioStr = @"0:0";
            }
            CGFloat val2 = [[ratioStr componentsSeparatedByString:@":"].firstObject floatValue];
            CGFloat val1 = [[ratioStr componentsSeparatedByString:@":"].lastObject floatValue];
            CLRatio *ratio = [[CLRatio alloc] initWithValue1:val1 value2:val2];
            ratio.titleFormat = @"%g : %g";
            if ([ratioStr isEqualToString:@"0:0"]) {
                self.scrollView.gridView.clippingRatio = nil;
            } else {
                self.scrollView.gridView.clippingRatio = ratio;
            }
        }
       
    } else if (toolView.toolType == EditorToolTypeText) {//添加文字
        [self.textTool textViewToolDidSelectIndexPath:indexPath];
    }
    
}

#pragma mark -- ImageEditorToolDelegate --
- (void)imageEditorToolDidSelect:(NSIndexPath *)indexPath{
    [self.editorTool mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(ToolHeight);
    }];
    [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-44);
    }];
    [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-Safe_Area_Height);
    }];
    //imageScrollView
    self.scrollView.scrollEnabled = NO;
    if (ScreenW/ScreenH == self.scrollView.currentImage.size.width/self.scrollView.currentImage.size.height) {
        CGRect imageFrame;
        CGFloat height = self.scrollView.size.height- 20;
        CGFloat width = height * (self.scrollView.currentImage.size.width/self.scrollView.currentImage.size.height);
        imageFrame.size = CGSizeMake(width, height);
        imageFrame.origin.y = 10;
        imageFrame.origin.x = (self.scrollView.size.width - width)/2;
        [self.scrollView resetImageViewFrame:imageFrame];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.y = 0;
        self.scrollView.height = ScreenH - BottomToolHeight - Safe_Area_Height;
    }];
    
    switch (indexPath.row) {
        case 0://滤镜
        {
            CIFilterTool *ciFilter = [CIFilterTool sharedCIFilterTool];
            NSArray *filterArr = @[@{@"name" : NSLocalizedString(@"原始", nil),@"image" : [ciFilter fliterEvent:@"OriginImage" originImage:self.thumbImage],@"FilterName":@"OriginImage"},
                                   @{@"name" : @"Mono",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectMono" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectMono"},
                                   @{@"name" : @"Chrome",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectChrome" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectChrome"},
                                   @{@"name" : @"Fade",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectFade" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectFade"},
                                   @{@"name" : @"Instant",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectInstant" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectInstant"},
                                   @{@"name" : @"Noir",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectNoir" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectNoir"},
                                   @{@"name" : @"Mono",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectMono" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectMono"},
                                   @{@"name" : @"Process",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectProcess" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectProcess"},
                                   @{@"name" : @"Transfer",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectTransfer" originImage:self.thumbImage],@"FilterName":@"CIPhotoEffectTransfer"},
                                   @{@"name" : @"Curve",@"image" : [ciFilter fliterEvent:@"CISRGBToneCurveToLinear" originImage:self.thumbImage],@"FilterName":@"CISRGBToneCurveToLinear"},
                                   ];
            self.filterTool.toolType = EditorToolTypeFilter;
            self.filterTool.dataArr = filterArr.mutableCopy;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight);
            }];
            break;
        }
            
        case 1://调整
        {
            [self.filterTool.sliderV clearAllValue];
            NSArray *adjustArr = @[@{@"name":NSLocalizedString(@"亮度", nil),@"image":[UIImage imageNamed:@"exposure-unselected"],@"select_Image":[UIImage imageNamed:@"exposure-selected"]},
                                   @{@"name":NSLocalizedString(@"对比", nil),@"image":[UIImage imageNamed:@"contrast-unselected"],@"select_Image":[UIImage imageNamed:@"contrast-selected"]},
                                   @{@"name":NSLocalizedString(@"氛围", nil),@"image":[UIImage imageNamed:@"atmosphere-unselected"],@"select_Image":[UIImage imageNamed:@"atmosphere-selected"]},
                                   @{@"name":NSLocalizedString(@"高光", nil),@"image":[UIImage imageNamed:@"highlights-unselected"],@"select_Image":[UIImage imageNamed:@"highlights-selected"]},
                                   @{@"name":NSLocalizedString(@"阴影", nil),@"image":[UIImage imageNamed:@"shadows-unselected"],@"select_Image":[UIImage imageNamed:@"shadows-selected"]},
                                   @{@"name":NSLocalizedString(@"色调", nil),@"image":[UIImage imageNamed:@"hue-unselected"],@"select_Image":[UIImage imageNamed:@"hue-selected"]}];
            self.filterTool.toolType = EditorToolTypeAdjustment;
            self.filterTool.dataArr = adjustArr.mutableCopy;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight + 47);
            }];
            self.eraserBtn.hidden = NO;

            break;
        }
        case 2://白平衡
        {
            [self.filterTool.sliderV clearAllValue];
            NSArray *arr = @[@{@"name":NSLocalizedString(@"色温", nil),@"image":[UIImage imageNamed:@"color-temperature-unselected"],@"select_Image":[UIImage imageNamed:@"color-temperature-selected"]},
                             @{@"name":NSLocalizedString(@"着色", nil),@"image":[UIImage imageNamed:@"coloring-unselected"],@"select_Image":[UIImage imageNamed:@"coloring-selected"]}
                             ];
            self.filterTool.toolType = EditorToolTypeWhiteBalance;
            self.filterTool.dataArr = arr.mutableCopy;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight + 47);
            }];
            self.eraserBtn.hidden = NO;

            break;
        }
        case 4://马赛克
        {
            self.filterTool.toolType = EditorToolTypeMosaic;
            self.filterTool.dataArr = @[].mutableCopy;
            CLMosaicTool *mosaicTool = [[CLMosaicTool alloc] initWithImageEditorVC:self];
            self.mosaicTool = mosaicTool;
            break;
        }
        case 5://绘画
        {
            [self.filterTool.sliderV clearAllValue];
            self.filterTool.toolType = EditorToolTypeDraw;
            self.filterTool.dataArr = @[].mutableCopy;
            CLDrawTool *drawTool = [[CLDrawTool alloc] initWithImageEditorVC:self];
            self.drawTool = drawTool;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight+ 47);
            }];
            break;
        }
        case 6://添加文字
        {
            [self.filterTool.sliderV clearAllValue];
            NSArray *arr = @[@{@"image":[UIImage imageNamed:@"white-unselected"],@"select_Image":[UIImage imageNamed:@"white-selected"]},
                             @{@"image":[UIImage imageNamed:@"black-unselected"],@"select_Image":[UIImage imageNamed:@"black-selected"]},
                             @{@"image":[UIImage imageNamed:@"blue-unselected"],@"select_Image":[UIImage imageNamed:@"blue-selected"]},
                             @{@"image":[UIImage imageNamed:@"green-unselected"],@"select_Image":[UIImage imageNamed:@"green-selected"]},
                             @{@"image":[UIImage imageNamed:@"yellow-unselected"],@"select_Image":[UIImage imageNamed:@"yellow-selected"]},
                             @{@"image":[UIImage imageNamed:@"red-unselected"],@"select_Image":[UIImage imageNamed:@"red-selected"]}
                             ];
            self.filterTool.toolType = EditorToolTypeText;
            self.filterTool.dataArr = arr.mutableCopy;
            CLTextTool *textTool = [[CLTextTool alloc] initWithImageEditorVC:self];
            self.textTool = textTool;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight+ 47);
            }];
            break;
        }
        case 3://裁剪
        {
            NSArray *arr = @[
                             @{@"name" : NSLocalizedString(@"重置", nil),@"image" : [UIImage imageNamed:@"reset-unselected"],@"select_Image" : [UIImage imageNamed:@"reset-selected"]},
                          @{@"name" : NSLocalizedString(@"旋转", nil),@"image" : [UIImage  imageNamed:@"rotate-unselected"],@"select_Image" : [UIImage imageNamed:@"rotate-selected"]},
                          @{@"name" : NSLocalizedString(@"翻转", nil),@"image" : [UIImage imageNamed:@"flip-unselected"],@"select_Image" : [UIImage imageNamed:@"flip-selected"]},
                          @{@"name" : NSLocalizedString(@"自由", nil),@"image" : [UIImage imageNamed:@"free-unselected"],@"select_Image" : [UIImage imageNamed:@"free-selected"]},
                          @{@"name" : @"1:1",@"image" : [UIImage imageNamed:@"11-unselected"],@"select_Image" : [UIImage imageNamed:@"11-selected"]},
                          @{@"name" : @"3:2",@"image" : [UIImage imageNamed:@"32-unselected"],@"select_Image" : [UIImage imageNamed:@"32-selected"]},
                          @{@"name" : @"4:3",@"image" : [UIImage imageNamed:@"43-unselected"],@"select_Image" : [UIImage imageNamed:@"43-selected"]},
                          @{@"name" : @"5:4",@"image" : [UIImage imageNamed:@"54-unselected"],@"select_Image" : [UIImage imageNamed:@"54-selected"]},
                          @{@"name" : @"7:5",@"image" : [UIImage imageNamed:@"75-unselected"],@"select_Image" : [UIImage imageNamed:@"75-selected"]},
                          @{@"name" : @"16:9",@"image" : [UIImage imageNamed:@"169-unselected"],@"select_Image" : [UIImage imageNamed:@"169-selected"]},
                          ];
            self.filterTool.toolType = EditorToolTypeCrop;
            self.filterTool.dataArr = arr.mutableCopy;
            //重新设置裁剪框的尺寸
            [self.scrollView.gridView removeFromSuperview];
            self.scrollView.gridView = nil;
            self.scrollView.currentImage = self.scrollView.imageView.image;
            [self.scrollView layoutImageView];
            self.scrollView.gridView.hidden = NO;

            break;
        }
        default:
            break;
    }
    [self updateConstraintsAnimation];
}

- (void)subviewsOrignalState{
    [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(BottomToolHeight+47);
    }];
    [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
        if (IS_iPhoneX) {
            make.top.equalTo(self.view).offset(State_Bar_Height);
        } else {
            make.top.equalTo(self.view);
        }
    }];
    [self.editorTool mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-Safe_Area_Height);
    }];
}

//更新约束动画
- (void)updateConstraintsAnimation{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc{
    [self.eraserBtn removeObserver:self forKeyPath:@"highlighted" context:nil];
}

@end
