//
//  ImagesEditorViewController.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "ImagesEditorViewController.h"
#import "ImageCollectionViewCell.h"
#import "SingleImageEditorViewController.h"
#import "ImageEditorTool.h"
#import "CustomNavBar.h"
#import "FilterEditorToolView.h"
#import "FilterBottomTool.h"
#import "SliderView.h"
#import "CIFilterTool.h"
#import "ExportView.h"
#import "ExportSuccessView.h"
#import "UsingGuideView.h"
#import <Photos/Photos.h>


#define ToolHeight 82
#define BottomToolHeight 146

@interface ImagesEditorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ImageEditorToolDelegate,CustomNavBarDelegate,FilterEditorToolViewDelegate,FilterBottomToolDelegate,SliderViewDelegate>

@property (nonatomic, strong) CustomNavBar *navBar;//导航

@property (nonatomic, strong) UIPageControl *pageC;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ImageEditorTool *editorTool;//滤镜，调整，白平衡工具栏

@property (nonatomic, strong) FilterEditorToolView *filterTool;//工具栏

@property (nonatomic, strong) NSMutableArray *imagesArr;

//上锁字典 key : index value:图片
@property (nonatomic, strong) NSMutableDictionary *lockImageDic;


@property (nonatomic, strong) NSMutableArray *stackArr;//存放编辑后的图片数组的大数组

@property (nonatomic, assign) NSInteger cur_showIndex;//记录数组栈中当前显示图片的下标

@property (nonatomic, strong) UIButton *eraserBtn;

@property (nonatomic, strong) UIImage *contrastImage;//和原图进行对比的图

@property (nonatomic, copy) NSString *selFilterName;//选中的滤镜名
@property (nonatomic, strong) NSDictionary *whiteBalanceDic;//白平衡效果
@property (nonatomic, strong) NSDictionary *adjustmentDic;//调整效果


@end

@implementation ImagesEditorViewController

- (NSMutableArray *)stackArr{
    if (!_stackArr) {
        _stackArr = [NSMutableArray array];
    }
    return _stackArr;
}

- (NSMutableDictionary *)lockImageDic{
    if (!_lockImageDic) {
        _lockImageDic = [NSMutableDictionary dictionary];
    }
    return _lockImageDic;
}

- (NSMutableArray *)imagesArr{
    if (!_imagesArr) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}

- (void)setOriginArr:(NSArray *)originArr{
    _originArr = originArr;
    self.imagesArr = originArr.mutableCopy;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航栏
    [self setNav];
    
    self.view.backgroundColor = MainColor;
    
    [self setupSubViews];
    
    //功能view
    [self funcView];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    //stackArr
    [self.stackArr addObject:[NSMutableArray arrayWithArray:self.originArr]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsShowedGuideView"] == NO) {
        UsingGuideView *guideView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UsingGuideView class]) owner:nil options:nil] lastObject];
        guideView.frame = self.view.bounds;
        guideView.backgroundColor = [RGBA(20, 20, 20, 1) colorWithAlphaComponent:0.8];
        [self.view addSubview:guideView];
    }
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.collectionView addGestureRecognizer:doubleTapGestureRecognizer];

}

//双击
- (void)doubleTap:(UIPanGestureRecognizer *)doubleTap{
    SingleImageEditorViewController *singleVC = [[SingleImageEditorViewController alloc] init];
    singleVC.originalImage = self.imagesArr[self.pageC.currentPage];
    PAWeakSelf
    singleVC.block = ^(UIImage *image) {
        [weakSelf.imagesArr replaceObjectAtIndex:self.pageC.currentPage withObject:image];
        [weakSelf.lockImageDic setObject:image forKey:@(self.pageC.currentPage)];
        
        weakSelf.originArr = [weakSelf.imagesArr copy];
        [weakSelf.collectionView reloadData];
    };
    [self presentViewController:singleVC animated:YES completion:^{
        
    }];
}

- (void)funcView{
    FilterEditorToolView *filterTool = [[FilterEditorToolView alloc] init];
    filterTool.delegate = self;
    filterTool.bottomView.delegate = self;
    filterTool.sliderV.delegate = self;
    [self.view addSubview:filterTool];
    [filterTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(BottomToolHeight);
        make.height.mas_equalTo(BottomToolHeight);
    }];
    self.filterTool = filterTool;
}

- (void)setNav{
    CustomNavBar *navBar = [[CustomNavBar alloc] initWithFrame:CGRectNull];
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

#pragma mark -- 加滤镜 --
- (void)addFiltersWithFilterName:(NSString *)filterName{
    if (self.originArr.count) {
        PAWeakSelf
        NSMutableArray *editArr = [NSMutableArray array];
        NSArray *keys = self.lockImageDic.allKeys;
        // 创建串行队列
//        dispatch_queue_t queue = dispatch_queue_create("AddFilters", DISPATCH_QUEUE_SERIAL);
        [self.originArr enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
//            dispatch_async(queue, ^{
            
                UIImage *editImage = [[CIFilterTool sharedCIFilterTool] fliterEvent:filterName originImage:image];
                BOOL isContinue = YES;
                for (NSNumber *index_num in keys) {
                    if ([index_num integerValue] == idx) {
                        isContinue = NO;
                    }
                }
                if (isContinue) {
                    [editArr addObject:editImage];
                } else {
                    [editArr addObject:image];
                }
//            });
        }];
        
//        dispatch_barrier_async(queue, ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imagesArr = editArr.mutableCopy;
                [editArr removeAllObjects];
                [weakSelf.collectionView reloadData];
//            });
//        });
        
    }
}

#pragma mark -- 调整 --
- (void)addAdjustmentWithVlaueDic:(NSDictionary *)valueDic{
    if (self.originArr.count) {
        NSArray *keys = self.lockImageDic.allKeys;
        PAWeakSelf
        [self.originArr enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isContinue = YES;
            for (NSNumber *index_num in keys) {
                if ([index_num integerValue] == idx) {
                    isContinue = NO;
                }
            }
            if (isContinue) {
                UIImage *editImage = [[CIFilterTool sharedCIFilterTool] adjustmentWithValueDic:valueDic originImage:image];
                if (editImage != nil) {
                    [weakSelf.imagesArr replaceObjectAtIndex:idx withObject:editImage];
                }
            }
        
        }];
        [self.collectionView reloadData];
    
    }
}

#pragma mark -- 白平衡 --
- (void)addWhiteBalanceWithValueDic:(NSDictionary *)valueDic{
    if (self.originArr.count) {
        PAWeakSelf
        NSArray *keys = self.lockImageDic.allKeys;
        [self.originArr enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isContinue = YES;
            for (NSNumber *index_num in keys) {
                if ([index_num integerValue] == idx) {
                    isContinue = NO;
                }
            }
            if (isContinue) {
                UIImage *editImage = [[CIFilterTool sharedCIFilterTool] balanceWithValueBalanceDic:valueDic originImage:image];
                if (editImage != nil) {
                    [weakSelf.imagesArr replaceObjectAtIndex:idx withObject:editImage];
                }
            }
        }];
        [self.collectionView reloadData];
    }
}

//设置子视图
- (void)setupSubViews{
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    [self.view addSubview:collectionView];
    
    UIPageControl *pageC = [[UIPageControl alloc] init];
    pageC.hidesForSinglePage = YES;
    pageC.pageIndicatorTintColor = RGBA(255, 255, 255, 0.1);
    pageC.currentPageIndicatorTintColor = RGBA(255, 255, 255, 0.6);
    pageC.numberOfPages = self.originArr.count;

    [self.view addSubview:pageC];
    self.pageC = pageC;
    
    NSArray *toolArr = @[@{@"title":NSLocalizedString(@"滤镜", nil),@"image":@"filter"},
                         @{@"title":NSLocalizedString(@"调整", nil),@"image":@"adjust"},
                         @{@"title":NSLocalizedString(@"白平衡", nil),@"image":@"white-balance"}];
    ImageEditorTool *editorTool = [[ImageEditorTool alloc] initWithFrame:CGRectNull dataArr:toolArr];
    editorTool.delegate = self;
    editorTool.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:editorTool];
    self.editorTool = editorTool;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.mas_equalTo(editorTool.mas_top);
    }];
    
    [pageC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collectionView);
        make.width.equalTo(collectionView.mas_width);
        make.top.equalTo(collectionView);
        make.height.mas_equalTo(40);
    }];

    [editorTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-Safe_Area_Height);
        make.height.mas_equalTo(ToolHeight);
    }];

    [collectionView layoutIfNeeded];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(collectionView.width, collectionView.height);
    [collectionView setCollectionViewLayout:layout animated:YES];
    self.collectionView = collectionView;
    
    UIButton *eraserBtn = [UIButton new];
    eraserBtn.hidden = YES;
    [eraserBtn setImage:[UIImage imageNamed:@"contrast"] forState:UIControlStateNormal];
    [eraserBtn addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    [self.view addSubview:eraserBtn];
    self.eraserBtn = eraserBtn;
    
    [eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(self.collectionView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"highlighted"]) {
        BOOL highlighted = [change[@"new"] boolValue];
        if (highlighted) {//显示原图
            NSLog(@"old%@",change[@"old"]);
            if ([change[@"old"] boolValue] == NO) {
                self.imagesArr[self.pageC.currentPage] = self.originArr[self.pageC.currentPage];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pageC.currentPage inSection:0];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
            
        } else {//显示编辑后的图
            if (self.contrastImage) {
                self.imagesArr[self.pageC.currentPage] = self.contrastImage;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pageC.currentPage inSection:0];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
        
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
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.filterTool.mas_top);
    }];
    
    //禁止collectionView选中
    self.collectionView.allowsSelection = NO;
    //禁止滚动
    self.collectionView.scrollEnabled = NO;
    
    switch (indexPath.row) {
        case 0://滤镜
        {
            //滤镜
            UIImage *thumbImage = self.imagesArr[self.pageC.currentPage];
            UIGraphicsBeginImageContext(CGSizeMake(100, 100));
            [thumbImage drawInRect:CGRectMake(0, 0, 100, 100)];
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CIFilterTool *ciFilter = [CIFilterTool sharedCIFilterTool];
            NSArray *filterArr = @[@{@"name" : NSLocalizedString(@"原始", nil),@"image" : [ciFilter fliterEvent:@"OriginImage" originImage:thumbImage],@"FilterName":@"OriginImage"},
                                   @{@"name" : @"Mono",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectMono" originImage:thumbImage],@"FilterName":@"CIPhotoEffectMono"},
                                   @{@"name" : @"Chrome",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectChrome" originImage:thumbImage],@"FilterName":@"CIPhotoEffectChrome"},
                                   @{@"name" : @"Fade",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectFade" originImage:thumbImage],@"FilterName":@"CIPhotoEffectFade"},
                                   @{@"name" : @"Instant",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectInstant" originImage:thumbImage],@"FilterName":@"CIPhotoEffectInstant"},
                                   @{@"name" : @"Noir",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectNoir" originImage:thumbImage],@"FilterName":@"CIPhotoEffectNoir"},
                                   @{@"name" : @"Mono",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectMono" originImage:thumbImage],@"FilterName":@"CIPhotoEffectMono"},
                                   @{@"name" : @"Process",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectProcess" originImage:thumbImage],@"FilterName":@"CIPhotoEffectProcess"},
                                   @{@"name" : @"Transfer",@"image" : [ciFilter fliterEvent:@"CIPhotoEffectTransfer" originImage:thumbImage],@"FilterName":@"CIPhotoEffectTransfer"},
                                   @{@"name" : @"Curve",@"image" : [ciFilter fliterEvent:@"CISRGBToneCurveToLinear" originImage:thumbImage],@"FilterName":@"CISRGBToneCurveToLinear"},
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
                                   @{@"name":NSLocalizedString(@"对比", nil   ),@"image":[UIImage imageNamed:@"contrast-unselected"],@"select_Image":[UIImage imageNamed:@"contrast-selected"]},
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
                             @{@"name":NSLocalizedString(@"着色", nil),@"image":[UIImage imageNamed:@"coloring-unselected"],@"select_Image":[UIImage imageNamed:@"coloring-selected"]},];
            self.filterTool.toolType = EditorToolTypeWhiteBalance;
            self.filterTool.dataArr = arr.mutableCopy;
            [self.filterTool mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomToolHeight + 47);
            }];
            self.eraserBtn.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    //约束动画
    [self updateConstraintsAnimation];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.currentImage = self.imagesArr[indexPath.item];
    NSArray *keys = self.lockImageDic.allKeys;
    for (NSNumber *index_num in keys) {
        cell.isShowLock = NO;
        if ([index_num integerValue] == indexPath.row) {
            cell.isShowLock = YES;
        }
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    CGFloat offset_x = scrollView.contentOffset.x;
    NSInteger curPage = offset_x/ScreenW;
    self.pageC.currentPage = curPage;
}

#pragma mark -- FilterEditorToolViewDelegate --
- (void)filterEditorToolDidSelectWith:(FilterEditorToolView *)toolView indexPath:(NSIndexPath *)indexPath{
    if (toolView.toolType == EditorToolTypeFilter) {
        NSDictionary *dic = toolView.dataArr[indexPath.row];
        NSString *filterName = dic[@"FilterName"];
        self.selFilterName = filterName;//选中的滤镜
        
        UIImage *image = self.originArr[self.pageC.currentPage];
        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] fliterEvent:filterName originImage:image];
        [self.imagesArr replaceObjectAtIndex:self.pageC.currentPage withObject:editImage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.pageC.currentPage inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark -- FilterBottomToolDelegate --
- (void)filterBottomToolClose{
    self.imagesArr = self.originArr.mutableCopy;
    [self.collectionView reloadData];
    
    [self subviewsOrignalState];
    
    [self updateConstraintsAnimation];
    
    [self.filterTool sliderViewIsHiden:YES];
    
    self.collectionView.allowsSelection = YES;
    
    self.eraserBtn.hidden = YES;
    
    //清空滤镜，白平衡，调整效果
    self.selFilterName = nil;
    self.whiteBalanceDic = nil;
    self.adjustmentDic = nil;
}

- (void)filterBottomToolOK{

    if (self.selFilterName) {
        //所有图片加上滤镜
        [self addFiltersWithFilterName:self.selFilterName];
        self.selFilterName = nil;
    } else if (self.whiteBalanceDic){//白平衡效果
        [self addWhiteBalanceWithValueDic:self.whiteBalanceDic];
        self.whiteBalanceDic = nil;
    } else if (self.adjustmentDic){//调整效果
        [self addAdjustmentWithVlaueDic:self.adjustmentDic];
        self.adjustmentDic = nil;
    }
    
    self.originArr = [self.imagesArr copy];
    
    [self subviewsOrignalState];
    
    [self updateConstraintsAnimation];
    
    [self.filterTool sliderViewIsHiden:YES];
    
    self.collectionView.allowsSelection = YES;
    
    self.eraserBtn.hidden = YES;
    
    if (self.cur_showIndex == self.stackArr.count - 1) {//最后
        [self.stackArr addObject:self.imagesArr];
    } else { //中间或者第一
        if (self.stackArr.count > 1) {
            NSInteger count = self.stackArr.count;
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int i = 0; i < count; i++) {
                if (i > self.cur_showIndex) {
                    [tempArr addObject:self.stackArr[i]];
                }
            }
            [self.stackArr removeObjectsInArray:tempArr];
            [self.stackArr addObject:self.imagesArr];
        }
    }
    self.cur_showIndex = self.stackArr.count - 1;

    [self.navBar setBackBtnAlpha:1];
    if (self.cur_showIndex == [self.stackArr count] - 1) {
        [self.navBar setForwardBtnAplha:0.22];
    }
    
 
}

#pragma mark -- SliderViewDelegate --
- (void)sliderValueChangeWithValue:(float)value type:(SliderType)type valueText:(NSString *)valueText{
    [self.filterTool reloadItemValueWith:valueText type:type];
    if (type == SliderTypeTemperature || type == SliderTypeTint) {
        NSDictionary *valueDic = @{@"temperature":@(self.filterTool.sliderV.cur_temperature),
              @"tint":@(self.filterTool.sliderV.cur_tint)
                                   };
        self.whiteBalanceDic = valueDic;//白平衡效果
        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] balanceWithValueBalanceDic:valueDic originImage:self.originArr[self.pageC.currentPage]];
        if (editImage != nil) {
            [self.imagesArr replaceObjectAtIndex:self.pageC.currentPage withObject:editImage];
        }
    
    } else {
        NSDictionary *valueDic = @{@"brightness" : @(self.filterTool.sliderV.cur_brightness),
                                   @"exposure" : @(self.filterTool.sliderV.cur_visibility),
                                   @"contrast" : @(self.filterTool.sliderV.cur_contrast),
                                   @"saturation" : @(self.filterTool.sliderV.cur_saturation),
                                   @"shadow" : @(self.filterTool.sliderV.cur_shadow),
                                   @"hue" : @(self.filterTool.sliderV.cur_hue),
                                   };
        
        self.adjustmentDic = valueDic;//调整效果

        UIImage *editImage = [[CIFilterTool sharedCIFilterTool] adjustmentWithValueDic:valueDic originImage:self.originArr[self.pageC.currentPage]];
        if (editImage != nil) {
            [self.imagesArr replaceObjectAtIndex:self.pageC.currentPage withObject:editImage];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.pageC.currentPage inSection:0];
    
    self.contrastImage = self.imagesArr[self.pageC.currentPage];
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

#pragma mark -- CustomNavBarDelegate --
//返回
- (void)leftItemAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//导出
- (void)rightItemAction{
   
    ExportView *exportView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ExportView class]) owner:nil options:nil] lastObject];
    PAWeakSelf
    exportView.successBlock = ^{
        BOOL isOpenShare = [[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenShare"];
        if (isOpenShare == NO) {
            ExportSuccessView *successView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ExportSuccessView class]) owner:nil options:nil] lastObject];
            successView.frame = weakSelf.view.bounds;
            successView.backgroundColor = [RGBA(20, 20, 20, 1) colorWithAlphaComponent:0.8];
            [weakSelf.view addSubview:successView];
            
            successView.shareBlock = ^{//分享
                UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:weakSelf.imagesArr applicationActivities:nil];
                
                [weakSelf presentViewController:activity animated:YES completion:nil];
            };
            successView.backBlock = ^{//返回首页
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
            CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.fromValue=[NSNumber numberWithFloat:0.0];
            animation.toValue=[NSNumber numberWithFloat:1.0];
            animation.duration=0.25;
            animation.repeatCount=1;
            animation.removedOnCompletion=NO;
            animation.fillMode=kCAFillModeForwards;
            [successView.layer addAnimation:animation forKey:@"zoom"];
        } else {
            UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:weakSelf.imagesArr applicationActivities:nil];
            
            [weakSelf presentViewController:activity animated:YES completion:nil];
        }

    };
    exportView.images = self.imagesArr;
    exportView.frame = self.view.bounds;
    exportView.backgroundColor = [RGBA(20, 20, 20, 1) colorWithAlphaComponent:0.8];
    [self.view addSubview:exportView];

    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:1.0];
    animation.duration=0.25;
    animation.repeatCount=1;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [exportView.layer addAnimation:animation forKey:@"zoom"];

}

//撤销
- (void)backItemAction{
    if (self.cur_showIndex > 0) {
        self.cur_showIndex--;
        self.imagesArr = self.stackArr[self.cur_showIndex];
        if (self.cur_showIndex == 0) {
            [self.navBar setBackBtnAlpha:0.22];
        }
        [self.navBar setForwardBtnAplha:1];
        self.originArr = [NSArray arrayWithArray:self.imagesArr];
    } else {
        self.imagesArr = [self.originArr mutableCopy];
        [self.navBar setBackBtnAlpha:0.22];
    }
    
    
    [self.collectionView reloadData];

}

//前进
- (void)forwardItemAction{
    if (self.cur_showIndex < [self.stackArr count]-1) {
        self.cur_showIndex++;
        self.imagesArr = self.stackArr[self.cur_showIndex];
        if (self.cur_showIndex == [self.stackArr count]-1) {
            [self.navBar setForwardBtnAplha:0.22];
        }
        [self.navBar setBackBtnAlpha:1];
    }
    self.originArr = [NSArray arrayWithArray:self.imagesArr];
    [self.collectionView reloadData];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

//子试图恢复初始状态
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
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.editorTool.mas_top);
    }];
    
    //恢复滑动
    self.collectionView.scrollEnabled = YES;
    self.contrastImage = nil;
}

//更新约束动画
- (void)updateConstraintsAnimation{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self.collectionView layoutIfNeeded];
        layout.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
        [self.collectionView setCollectionViewLayout:layout animated:YES];
    }];
}

- (void)dealloc{
    [self.eraserBtn removeObserver:self forKeyPath:@"highlighted" context:nil];
}

@end
