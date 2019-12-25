//
//  ImageScrollView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/29.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLClippingPanel;
NS_ASSUME_NONNULL_BEGIN

@interface ImageScrollView : UIScrollView

- (instancetype)initImageScrollViewWithImage:(UIImage *)image frame:(CGRect)frame;


- (void)resetImageViewFrame:(CGRect)frame;

- (void)layoutImageView;

@property (strong, nonatomic) UIImage *currentImage;

@property (nonatomic, strong) UIImageView *imageView;

//框
@property (nonatomic, strong, nullable) CLClippingPanel *gridView;


//关闭缩放
//@property (nonatomic, assign) BOOL closeZoom;

@end

NS_ASSUME_NONNULL_END
