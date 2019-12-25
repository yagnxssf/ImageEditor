//
//  FilterEditorToolView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/28.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "FilterEditorToolView.h"
#import "FilterEditorToolCell.h"
#import "AdjustmentCell.h"
#import "FilterBottomTool.h"
#import "TextToolCell.h"
#import "ClipCollectionCell.h"
#import "SliderView.h"

@interface FilterEditorToolView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *value_arr;

@end

@implementation FilterEditorToolView

- (NSMutableArray *)value_arr{
    if (!_value_arr) {
        _value_arr = [NSMutableArray array];
    }
    return _value_arr;
}

- (instancetype)init{
    if ([super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    FilterBottomTool *bottomView = [FilterBottomTool new];
    bottomView.backgroundColor = MainColor;
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.mas_equalTo(44);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    CGFloat width = (ScreenW - 7*6)/6;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width*73/55);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 6;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = MainColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FilterEditorToolCell class]) bundle:nil] forCellWithReuseIdentifier:@"FilterEditorToolCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AdjustmentCell class]) bundle:nil] forCellWithReuseIdentifier:@"AdjustmentCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TextToolCell class]) bundle:nil] forCellWithReuseIdentifier:@"TextToolCell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ClipCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"ClipCollectionCell"];
    [self addSubview:collectionView];
    
    SliderView *sliderV = [[SliderView alloc] init];
    sliderV.hidden = YES;
    sliderV.backgroundColor = [RGB(20, 20, 20) colorWithAlphaComponent:0.7];
    [self addSubview:sliderV];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(sliderV.mas_bottom);
        make.right.equalTo(self);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    self.collectionView = collectionView;
   
    [sliderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    self.sliderV = sliderV;
    
}

- (void)reloadItemValueWith:(NSString *)Value type:(SliderType)type{
    if (self.toolType == EditorToolTypeAdjustment || self.toolType == EditorToolTypeWhiteBalance) {
        NSIndexPath *indexPath;
        if (type == SliderTypeBrightness) { //亮度
             indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        } else if (type == SliderTypeContrast) { //对比
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        } else if (type == SliderTypeSaturation) { //氛围
            indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        } else if (type == SliderTypeVisibility) { //高光
            indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        } else if (type == SliderTypeShadow) { //阴影
            indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        } else if (type == SliderTypeHue) { //色调
            indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        } else if (type == SliderTypeTemperature) { //色温
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        } else if (type == SliderTypeTint) { //着色
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        [self.value_arr replaceObjectAtIndex:indexPath.row withObject:Value];
        
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.toolType == EditorToolTypeAdjustment || self.toolType == EditorToolTypeWhiteBalance) {
        AdjustmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdjustmentCell" forIndexPath:indexPath];
        cell.highlighted = NO;
//        if (self.toolType == EditorToolTypeWhiteBalance) {
//            cell.cellBtn.imageView.backgroundColor = [RGB(167, 167, 167) colorWithAlphaComponent:0.4];
//        } else {
            cell.cellBtn.imageView.backgroundColor = [UIColor clearColor];
//        }
        cell.dic = self.dataArr[indexPath.row];
        if (self.dataArr.count == self.value_arr.count) {
            cell.countValue = self.value_arr[indexPath.row];
        }
        return cell;
    } else if (self.toolType == EditorToolTypeText) {
        TextToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextToolCell" forIndexPath:indexPath];
        cell.dic = self.dataArr[indexPath.row];
        return cell;
    } else if (self.toolType == EditorToolTypeCrop) {
        ClipCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClipCollectionCell" forIndexPath:indexPath];
//        if (indexPath.row == 0) {
//            cell.btnBackgroundColor = [RGB(167, 167, 167) colorWithAlphaComponent:0.4];
//        } else {
            cell.btnBackgroundColor = [UIColor clearColor];
//        }
        cell.dic = self.dataArr[indexPath.row];
        return cell;
    } else {
        FilterEditorToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterEditorToolCell" forIndexPath:indexPath];
        cell.dic = self.dataArr[indexPath.row];
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.toolType == EditorToolTypeAdjustment) {
        [self adjustmentWith:indexPath];
        return;
    } else if (self.toolType == EditorToolTypeWhiteBalance){
        [self whiteBalanceWith:indexPath];
        return;
    } else if (self.toolType == EditorToolTypeText) {
        self.sliderV.title = NSLocalizedString(@"不透明度", nil);
        self.sliderV.type = SliderTypeAlpha;
        [self.sliderV setSliderMaxValue:1 minValue:0];
    } else if (self.toolType == EditorToolTypeDraw) {
        self.sliderV.title = NSLocalizedString(@"粗细", nil);
        self.sliderV.type = SliderTypeLineWidth;
        [self.sliderV setSliderMaxValue:20 minValue:1];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterEditorToolDidSelectWith:indexPath:)]) {
        [self.delegate filterEditorToolDidSelectWith:self indexPath:indexPath];
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;

    [self.collectionView reloadData];
    if (self.toolType == EditorToolTypeCrop) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
       ClipCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ClipCollectionCell" forIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.selected = YES;
        return;
    }
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)setToolType:(EditorToolType)toolType{
    _toolType = toolType;
    if (toolType != EditorToolTypeCrop && self.lineView) {
        [self.lineView removeFromSuperview];
        self.lineView = nil;
    }
    switch (toolType) {
        case EditorToolTypeFilter:
        {
            self.bottomView.titleStr = NSLocalizedString(@"滤镜", nil);
            [self.sliderV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            self.sliderV.hidden = YES;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            CGFloat width = (ScreenW - 7*6)/6;
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.itemSize = CGSizeMake(width, width*73/55);
            if (IS_IPAD) {
                layout.itemSize = CGSizeMake(102*55/73, 102);
            }
            layout.minimumInteritemSpacing = 6;
            layout.minimumLineSpacing = 6;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self.collectionView setCollectionViewLayout:layout animated:NO];

            break;
        }
        case EditorToolTypeAdjustment:
        {
            self.value_arr = @[@"0",@"0",@"0",@"0",@"0",@"0"].mutableCopy;
            self.bottomView.titleStr = NSLocalizedString(@"调整", nil);
            [self.sliderV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(47);
            }];
            self.sliderV.hidden = NO;
            CGFloat width = (ScreenW - 15*5 - 20)/6;
            if (ScreenW <= 375) {
                width = (375 - 15*5 - 20)/6;
            }
            [self.collectionView layoutIfNeeded];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 15;
            layout.minimumLineSpacing = 15;
            layout.itemSize = CGSizeMake(width, 102);
            layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self.collectionView setCollectionViewLayout:layout animated:NO];

            break;
        }
        case EditorToolTypeWhiteBalance:
        {
            self.value_arr = @[@"0",@"0"].mutableCopy;
            self.bottomView.titleStr = NSLocalizedString(@"白平衡", nil);
            [self.sliderV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(47);
            }];
            self.sliderV.hidden = NO;
            CGFloat width = ScreenW/2;
            [self.collectionView layoutIfNeeded];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 6;
            layout.minimumLineSpacing = 6;
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.itemSize = CGSizeMake(width, 102);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self.collectionView setCollectionViewLayout:layout animated:NO];

            break;
        }
        case EditorToolTypeText:
        {
            self.bottomView.titleStr = NSLocalizedString(@"文字", nil);
            [self.sliderV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(47);
            }];
            self.sliderV.hidden = NO;
            break;
        }
        case EditorToolTypeCrop:
        {
            self.bottomView.titleStr = NSLocalizedString(@"裁剪", nil);
            CGFloat width = 60;
            [self.collectionView layoutIfNeeded];
            if (self.lineView == nil) {
                self.lineView = [UIView new];
                self.lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
                self.lineView.size = CGSizeMake(1, 15);
                self.lineView.center = CGPointMake((width+3) * 3, (self.collectionView.height-10)/2);
                [self.collectionView addSubview:self.lineView];
            } else {
                self.lineView.center = CGPointMake((width+3) * 3, (self.collectionView.height-10)/2);
            }
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumInteritemSpacing = 3;
            layout.minimumLineSpacing = 3;
            layout.itemSize = CGSizeMake(width, 102);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self.collectionView setCollectionViewLayout:layout animated:NO];

            break;
        }
        case EditorToolTypeMosaic :
        {
            self.bottomView.titleStr = NSLocalizedString(@"马赛克", nil);
            break;
        }
        case EditorToolTypeDraw:
        {
            self.bottomView.titleStr = NSLocalizedString(@"标记", nil);
            [self.sliderV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(47);
            }];
            self.sliderV.hidden = NO;
            
            CGFloat width = (ScreenW - 7*6)/6;
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(width, width*73/55);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.minimumInteritemSpacing = 6;
            layout.minimumLineSpacing = 6;
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            [self.collectionView setCollectionViewLayout:layout animated:NO];
            break;
        }
        default:
            break;
    }

}

- (void)sliderViewIsHiden:(BOOL)isHiden{
    self.sliderV.hidden = isHiden;
}

- (void)whiteBalanceWith:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    self.sliderV.title = dic[@"name"];
    switch (indexPath.row) {
        case 0://色温
        {
            self.sliderV.type = SliderTypeTemperature;
            [self.sliderV setSliderMaxValue:10000 minValue:1000];
            break;
        }
        case 1://着色
        {
            self.sliderV.type = SliderTypeTint;
            [self.sliderV setSliderMaxValue:200 minValue:-200];
            break;
        }
        default:
            break;
    }
}

- (void)adjustmentWith:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    self.sliderV.title = dic[@"name"];
    switch (indexPath.row) {
        case 0://亮度
        {
            self.sliderV.type = SliderTypeBrightness;
            [self.sliderV setSliderMaxValue:0.8 minValue:-0.8];
            break;
        }
        case 1://对比
        {
            self.sliderV.type = SliderTypeContrast;
            [self.sliderV setSliderMaxValue:4 minValue:0.1];
            break;
        }
        case 2://饱和
        {
            self.sliderV.type = SliderTypeSaturation;
            [self.sliderV setSliderMaxValue:2 minValue:0];
            break;
        }
        case 3://曝光
        {
            self.sliderV.type = SliderTypeVisibility;
            [self.sliderV setSliderMaxValue:5 minValue:-5];
            break;
        }
        case 4://阴影
        {
            self.sliderV.type = SliderTypeShadow;
            [self.sliderV setSliderMaxValue:1 minValue:0];
            break;
        }
        case 5://色调
        {
            self.sliderV.type = SliderTypeHue;
            [self.sliderV setSliderMaxValue:200 minValue:1];
            break;
        }
        default:
            break;
    }
}

@end
