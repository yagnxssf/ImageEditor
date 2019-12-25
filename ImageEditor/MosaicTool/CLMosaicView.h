//
//  CLMosaicView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMosaicView : UIView
//马赛克图片
@property (nonatomic, strong) UIImage *image;

//涂层图片.
@property (nonatomic, strong) UIImage *surfaceImage;

- (void)setMosaicLineWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
