//
//  NSString+StringSize.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/18.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (StringSize)
/**
 *  给定宽度，字体，返回高度
 *
 *  @param width PreferWidth
 *  @param font  字体
 */
- (CGSize)sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font;

/**
 *  给定高度，字体，返回宽度
 *
 *  @param height 固定高度
 *  @param font  字体
 */
- (CGSize)sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font;
@end
