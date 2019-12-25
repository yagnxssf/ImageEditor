//
//  TriangleView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/16.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    CGFloat width = rect.size.width;
        CGPoint endPoint = CGPointMake(rect.size.width, CGRectGetMidY(rect));
//    CGPoint point_one = CGPointMake(endPoint.x - width*cos(M_PI/6), endPoint.y - width*sin(M_PI/6));
    CGPoint point_one = CGPointMake(rect.origin.x, rect.origin.y);
//    CGPoint point_two = CGPointMake(endPoint.x - width*cos(M_PI/6), endPoint.y + width*sin(M_PI/6));
    CGPoint point_two = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint points[3] = {point_one, point_two,endPoint};
    CGContextAddLines(context, points, 3);
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextSetStrokeColorWithColor(context,self.bgColor.CGColor);
    // 绘制路径及填充模式
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
