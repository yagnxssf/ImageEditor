//
//  CLClipCircleView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/18.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CLClipCircleView.h"

@implementation CLClipCircleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 线条宽
    CGContextSetLineWidth(context, 5.0);
    // 线条颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    // 起点坐标
    //    CGContextMoveToPoint(context, 0, CGRectGetMidY(rect));
    CGContextMoveToPoint(context, self.startPoint.x ,self.startPoint.y);
    
    // 终点坐标
    //    CGContextAddLineToPoint(context, rect.size.width - width*cos(M_PI/6), endPoint.y);
    CGContextAddLineToPoint(context, self.centerPoint.x, self.centerPoint.y);
    
    CGContextMoveToPoint(context, self.centerPoint.x,self.centerPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    // 绘制路径
    CGContextStrokePath(context);

}


@end
