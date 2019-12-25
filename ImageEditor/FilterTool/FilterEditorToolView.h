//
//  FilterEditorToolView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/28.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"

typedef NS_ENUM(NSInteger,EditorToolType) {
    EditorToolTypeFilter = 0,
    EditorToolTypeAdjustment,
    EditorToolTypeWhiteBalance,
    EditorToolTypeMosaic,
    EditorToolTypeDraw,
    EditorToolTypeText,
    EditorToolTypeCrop,
};

@class FilterEditorToolView,FilterBottomTool,SliderView;

@protocol FilterEditorToolViewDelegate <NSObject>

- (void)filterEditorToolDidSelectWith:(FilterEditorToolView *)toolView indexPath:(NSIndexPath *)indexPath ;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FilterEditorToolView : UIView

@property (nonatomic, assign) id <FilterEditorToolViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) EditorToolType toolType;

@property (nonatomic, strong) FilterBottomTool *bottomView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SliderView *sliderV;

- (void)sliderViewIsHiden:(BOOL)isHiden;

- (void)reloadItemValueWith:(NSString *)Value type:(SliderType)type;

@end

NS_ASSUME_NONNULL_END
