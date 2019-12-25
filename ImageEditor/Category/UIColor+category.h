//
//  UIColor+category.h
//  SalaryCalculator
//
//  Created by cwsdteam03 on 2019/1/9.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (category)
//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view colors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

//获取16进制颜色的方法
+ (UIColor *)colorWithHex:(NSString *)hexColor;
@end

NS_ASSUME_NONNULL_END
