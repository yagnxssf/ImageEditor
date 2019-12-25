//
//  UIButton+Category.m
//  PasswordAlbum
//
//  Created by cwsdteam03 on 2018/11/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)


- (void)setUpImageAndDownLableWithSpace:(CGFloat)space{
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // 测试的时候发现titleLabel的宽度不正确，这里进行判断处理
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    if (titleSize.width < labelWidth) {
        titleSize.width = labelWidth;
    }
    
    CGFloat totalHeigt = (imageSize.height + titleSize.height + space);
    
    // 文字距上边框的距离增加imageView的高度+间距，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height+space, -imageSize.width, -space, 0.0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeigt - titleSize.height), 0.0)];
    
    // 图片距右边框的距离减少图片的宽度，距离上面的间隔，其它不变
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-space, 0.0,0.0,-titleSize.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeigt - imageSize.height), 0.0, 0.0, -titleSize.width)];
}

/**
 左边是文字，右边是图片（和原来的样式翻过来）
 
 @param space 间距
 */
- (void)setLeftTitleAndRightImageWithSpace:(CGFloat)space{
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // 测试的时候发现titleLabel的宽度不正确，这里进行判断处理
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    if (titleSize.width < labelWidth) {
        titleSize.width = labelWidth;
    }
    
    // 文字距左边框的距离减少imageView的宽度-间距，右侧增加距离imageView的宽度
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -imageSize.width - space, 0.0, imageSize.width)];
    
    // 图片距左边框的距离增加titleLable的宽度,距右边框的距离减少titleLable的宽度
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, titleSize.width,0.0,-titleSize.width)];
}


/**
 设置角标的个数（右上角）
 
 @param badgeValue 角标值
 */
- (void)setBadgeValue:(NSInteger)badgeValue{
    
    CGFloat badgeW   = 20;
    CGSize imageSize = self.imageView.frame.size;
    CGFloat imageX   = self.imageView.frame.origin.x;
    CGFloat imageY   = self.imageView.frame.origin.y;
    
    UILabel *badgeLable = [[UILabel alloc]init];
    badgeLable.text = [NSString stringWithFormat:@"%ld",badgeValue];
    badgeLable.textAlignment = NSTextAlignmentCenter;
    badgeLable.textColor = [UIColor whiteColor];
    badgeLable.font = [UIFont systemFontOfSize:12];
    badgeLable.layer.cornerRadius = badgeW*0.5;
    badgeLable.clipsToBounds = YES;
    badgeLable.backgroundColor = [UIColor redColor];
    
    CGFloat badgeX = imageX + imageSize.width - badgeW*0.5;
    CGFloat badgeY = imageY - badgeW*0.25;
    badgeLable.frame = CGRectMake(badgeX, badgeY, badgeW, badgeW);
    [self addSubview:badgeLable];
}

/**
 倒计时
 
 @param timeLine 倒计时时间
 @param title 正常时显示文字
 @param subTitle 倒计时时显示的文字（不包含秒）
 @param countDoneBlock 倒计时结束时的Block
 @param isInteraction 是否希望倒计时时可交互
 */

- (void)countDownWithTime:(NSInteger)timeLine withTitle:(NSString *)title andCountDownTitle:(NSString *)subTitle countDoneBlock:(void(^)(id))countDoneBlock isInteraction:(BOOL)isInteraction{
    __block NSInteger timeout = timeLine; // 倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (countDoneBlock) {
                    countDoneBlock(self);
                }
                //设置界面的按钮显示 根据自己需求设置
                self.userInteractionEnabled = YES;
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:MainColor forState:UIControlStateNormal];
                self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                //                NSLog(@"____%@",strTime);
                
                [self setTitle:[NSString stringWithFormat:@"%@s%@",strTime,subTitle] forState:UIControlStateNormal];
                [self setTitleColor:MainColor forState:UIControlStateNormal];
                self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                
                self.userInteractionEnabled = isInteraction;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}

@end
