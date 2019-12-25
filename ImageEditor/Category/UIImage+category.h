//
//  UIImage+category.h
//  SalaryCalculator
//
//  Created by cwsdteam03 on 2019/1/10.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (category)

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)convertViewToImage:(UIView*)v;

@end

NS_ASSUME_NONNULL_END
