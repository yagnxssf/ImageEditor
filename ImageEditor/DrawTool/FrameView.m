//
//  FrameView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/13.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "FrameView.h"

@implementation FrameView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.lineColor set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    path.lineWidth = 5;
    path.lineCapStyle = kCGLineCapButt;
    path.lineJoinStyle = kCGLineJoinMiter;
    
    [path stroke];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}


@end
