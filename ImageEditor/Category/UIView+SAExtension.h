//
//  UIView+Frame.h
//  XueYouQuan
//
//  Created by huylens on 17/1/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SAExtension)
/** x */
@property (nonatomic, assign) CGFloat x;
/** y */
@property (nonatomic, assign) CGFloat y;
/** width */
@property (nonatomic, assign) CGFloat width;
/** height */
@property (nonatomic, assign) CGFloat height;
/** centerX */
@property (nonatomic, assign) CGFloat centerX;
/** centerY */
@property (nonatomic, assign) CGFloat centerY;
/** size */
@property (nonatomic, assign) CGSize size;
/** origin */
@property (nonatomic, readonly)CGPoint origin;

@property (nonatomic, readonly)CGFloat top;
@property (nonatomic, readonly)CGFloat left;
@property (nonatomic, readonly)CGFloat bottom;
@property (nonatomic, readonly)CGFloat right;


#pragma mark - 功能
/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

+ (instancetype)viewFromXib;



#pragma mark - 自定义样式
-(void)setLayerWithRadius:(CGFloat)r
              BorderWidth:(CGFloat)bw
              BorderColor:(UIColor *)color;

-(void)setUpStyleOne;

-(void)setUpStyleTwo;

@end
