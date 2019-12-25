//
//  UIView+Frame.m
//  XueYouQuan
//
//  Created by huylens on 17/1/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "UIView+SAExtension.h"

@implementation UIView (SAExtension)
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
    
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center =  center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


- (CGSize)size{
    return self.frame.size;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)origin
{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGFloat)top{
    return self.y;
}
- (CGFloat)left{
    return self.x;
}
- (CGFloat)bottom{
    return self.top + self.height;
}
- (CGFloat)right{
    return self.left + self.width;
}


#pragma mark - 功能
- (BOOL)isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}
+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

#pragma mark - 自定义样式

-(void)setLayerWithRadius:(CGFloat)r BorderWidth:(CGFloat)bw BorderColor:(UIColor *)color {
    
    if (r > 0 ) {
        self.layer.cornerRadius = r;
    }
    
    if (bw > 0) {
        
        self.layer.borderWidth = bw;
    }
    
    if (color) {
        
        self.layer.borderColor = color.CGColor;
    }
}
//设置了圆角边框已经边框颜色
-(void)setUpStyleOne
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self setLayerWithRadius:SACornerRadius BorderWidth:1 BorderColor:[UIColor blueColor]];
}
//只设置圆角
-(void)setUpStyleTwo
{
    self.backgroundColor = [UIColor blueColor];
    
    [self setLayerWithRadius:SACornerRadius BorderWidth:0 BorderColor:nil];
}

@end
