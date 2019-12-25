//
//  DrawFrameLayer.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/13.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawFrameLayer : CALayer

@property (nonatomic, assign) CGRect clippingRect;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *gridColor;

@end

NS_ASSUME_NONNULL_END
