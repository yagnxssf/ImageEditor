//
//  UIButton+Category.h
//  PasswordAlbum
//
//  Created by cwsdteam03 on 2018/11/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)

/**
 上部分是图片，下部分是文字
 
 @param space 间距
 */
- (void)setUpImageAndDownLableWithSpace:(CGFloat)space;

/**
 左边是文字，右边是图片（和原来的样式翻过来）
 
 @param space 间距
 */
- (void)setLeftTitleAndRightImageWithSpace:(CGFloat)space;

/**
 设置角标的个数（右上角）

 */
- (void)setBadgeValue:(NSInteger)badgeValue;

/**
 倒计时
 
 @param timeLine 倒计时时间
 @param title 正常时显示文字
 @param subTitle 倒计时时显示的文字（不包含秒）
 @param countDoneBlock 倒计时结束时的Block
 @param isInteraction 是否希望倒计时时可交互
 */

- (void)countDownWithTime:(NSInteger)timeLine withTitle:(NSString *)title andCountDownTitle:(NSString *)subTitle countDoneBlock:(void(^)(id))countDoneBlock isInteraction:(BOOL)isInteraction;

@end

NS_ASSUME_NONNULL_END
