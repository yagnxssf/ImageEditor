//
//  CLClippingPanel.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/29.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLRatio;
NS_ASSUME_NONNULL_BEGIN

@interface CLClippingPanel : UIView

@property (nonatomic, assign) CGRect clippingRect;

@property (nonatomic, strong , nullable) CLRatio *clippingRatio;
- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;
- (void)setBgColor:(UIColor*)bgColor;
- (void)setGridColor:(UIColor*)gridColor;
- (void)clippingRatioDidChange;

@end

NS_ASSUME_NONNULL_END
