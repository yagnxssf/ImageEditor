//
//  SingleImageEditorViewController.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageScrollView,FilterEditorToolView;

typedef void(^finishBlock)(UIImage *image);

NS_ASSUME_NONNULL_BEGIN

@interface SingleImageEditorViewController : UIViewController

@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) ImageScrollView *scrollView;

@property (nonatomic, strong) FilterEditorToolView *filterTool;//滤镜工具条

@property (nonatomic,copy) finishBlock block;

@end

NS_ASSUME_NONNULL_END
