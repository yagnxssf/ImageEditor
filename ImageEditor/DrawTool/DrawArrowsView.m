//
//  DrawArrowsView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/14.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "DrawArrowsView.h"
#import "CLClippingCircle.h"
#import "TriangleView.h"


@interface DrawArrowsView()

@property (nonatomic, strong)TriangleView *triangleV;

@property (nonatomic, assign) BOOL rotated;//旋转过

@property (nonatomic, assign) CGFloat rotateAngle;//旋转角度


@end

@implementation DrawArrowsView
{
    CGPoint _initialPoint;
    CGPoint _startPoint;
    CGPoint _endPoint;
//    CGRect _initialRect;
    UIView *_headV;
    UIView *_foot;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//
//    CGFloat width = 20;
////    CGPoint endPoint = CGPointMake(rect.size.width, CGRectGetMidY(rect));
    CGPoint endPoint = _foot.center;
    CGPoint startPoint = _headV.center;
//    CGPoint point_one = CGPointMake(endPoint.x - width*cos(M_PI/6), endPoint.y - width*sin(M_PI/6));
//    CGPoint point_two = CGPointMake(endPoint.x - width*cos(M_PI/6), endPoint.y + width*sin(M_PI/6));
//    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGPoint points[3] = {point_one, point_two,endPoint};
//    CGContextAddLines(context, points, 3);
//    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
//    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
//    // 绘制路径及填充模式
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    // 线条宽
    CGContextSetLineWidth(context, 5.0);
    // 线条颜色
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    // 起点坐标
//    CGContextMoveToPoint(context, 0, CGRectGetMidY(rect));
    CGContextMoveToPoint(context, startPoint.x ,startPoint.y);

    // 终点坐标
//    CGContextAddLineToPoint(context, rect.size.width - width*cos(M_PI/6), endPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    // 绘制路径
    CGContextStrokePath(context);


}

- (UIView*)clippingCircleWithTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] init];
    view.size = CGSizeMake(12, 12);
    view.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = view.width/2;
    view.layer.masksToBounds = YES;
    view.tag = tag;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCircleView:)];
    [view addGestureRecognizer:panGesture];
    
    [self.superview addSubview:view];
    
    return view;
}

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [superview addSubview:self];

        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGridView:)];
        [self addGestureRecognizer:pan];
        
        _headV = [self clippingCircleWithTag:0];
        _foot  = [self clippingCircleWithTag:1];
        
        _headV.center = CGPointMake(frame.origin.x + (frame.size.width-120)/2, frame.origin.y + frame.size.height/2);
        _foot.center = CGPointMake(_headV.x + 120, frame.origin.y + frame.size.height/2);
        
        TriangleView *triangleV = [TriangleView new];
        triangleV.backgroundColor = [UIColor clearColor];
        triangleV.size = CGSizeMake(20, 20);
        [self addSubview:triangleV];
        triangleV.center = CGPointMake(_foot.center.x - triangleV.width/2, _foot.center.y);
        self.triangleV = triangleV;
        
//        _initialRect = frame;
    }
    return self;
}

- (void)panGridView:(UIPanGestureRecognizer *)sender{

    CGPoint p = [sender translationInView:self.superview];

    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = sender.view.center;
        _startPoint = _headV.center;
        _endPoint = _foot.center;
    }
    _headV.center = CGPointMake(_startPoint.x + p.x, _startPoint.y + p.y);
    _foot.center = CGPointMake(_endPoint.x + p.x, _endPoint.y + p.y);
    self.triangleV.center = CGPointMake(_foot.center.x, _foot.center.y);
    
//    static BOOL dragging = NO;
//    if(sender.state==UIGestureRecognizerStateBegan){
//        CGPoint point = [sender locationInView:self];
//        CGRect rect = CGRectZero;
//        dragging = CGRectContainsPoint(rect, point);
//    }
//    else if(dragging){
//
//    }
    [self setNeedsDisplay];
}

- (void)panCircleView:(UIPanGestureRecognizer *)sender{
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = sender.view.center;
        _startPoint = _headV.center;
        _endPoint = _foot.center;
    }
    
    if (sender.view.tag == 1) {//_footV
        
        _foot.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
        
        CGPoint A = _startPoint;
        CGPoint B = _endPoint;
        CGPoint C = _foot.center;
        CGFloat cosA = 0;
        CGFloat ABWidth = sqrt(pow((B.x - A.x),2) + pow((B.y - A.y), 2));
        CGFloat ACWidth = sqrt(pow((C.x - A.x),2) + pow((C.y - A.y), 2));
        cosA = ((B.x-A.x)*(C.x-A.x)+(B.y-A.y)*(C.y-A.y))/(ABWidth*ACWidth);
        CGFloat Angle = acosf(cosA);
        
        self.triangleV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.triangleV.layer.position = _foot.center;

        if (self.rotated) {
            Angle = self.rotateAngle + Angle;
            
        } else {
            if (C.y>A.y) {
                Angle = -Angle;
            }
        }
        
        self.triangleV.transform = CGAffineTransformMakeRotation(-Angle);
        
        if (sender.state == UIGestureRecognizerStateEnded){
            self.rotated = YES;
            CGFloat rotate = [self getRadianDegreeFromTransform:self.triangleV.transform];
            self.rotateAngle = rotate;
        }

    } else if (sender.view.tag == 0) {//_headV
        _headV.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
        
        CGPoint A = _endPoint;
        CGPoint B = _startPoint;
        CGPoint C = _headV.center;
        CGFloat cosA = 0;
        CGFloat ABWidth = sqrt(pow((B.x - A.x),2) + pow((B.y - A.y), 2));
        CGFloat ACWidth = sqrt(pow((C.x - A.x),2) + pow((C.y - A.y), 2));
        cosA = ((B.x-A.x)*(C.x-A.x)+(B.y-A.y)*(C.y-A.y))/(ABWidth*ACWidth);
        CGFloat Angle = acosf(cosA);

        self.triangleV.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.triangleV.layer.position = _foot.center;
        if (self.rotated) {
            
            NSLog(@"rotateAngle = %f",self.rotateAngle);
//            if (C.y > B.y) {//向下
//                Angle = -Angle;
//            }
//            if (self.rotateAngle >= 0 && self.rotateAngle < M_PI /2) {
//                Angle = self.rotateAngle + Angle;
//            } else if (self.rotateAngle >= M_PI/2 && self.rotateAngle < M_PI) {
//                Angle = self.rotateAngle - Angle;
//            } else if (self.rotateAngle >= M_PI && self.rotateAngle < M_PI * 1.5) {
//                Angle = self.rotateAngle + Angle;
//            } else if (self.rotateAngle >= M_PI * 1.5){
//                Angle = self.rotateAngle + Angle;
//            }
            if (C.y > B.y) {//向下
                Angle = self.rotateAngle - Angle;
//                NSLog(@"向下");
            } else {
                Angle = self.rotateAngle + Angle;
            }
            
        } else {
            if (C.y>A.y) {
                Angle = 2*M_PI-Angle;
            }
        }
        
//        NSLog(@"angle = %f",Angle);
        self.triangleV.transform = CGAffineTransformMakeRotation(Angle);
        
      
        
        if (sender.state == UIGestureRecognizerStateEnded){
            CGFloat rotate = [self getRadianDegreeFromTransform:self.triangleV.transform];
            NSLog(@"%f",rotate);
            self.rotateAngle = rotate;
            
            self.rotated = YES;
        }
    }

    [self setNeedsDisplay];
}

- (CGFloat)getRadianDegreeFromTransform:(CGAffineTransform)transform{
    CGFloat rotate = acosf(transform.a);
    // 旋转180度后，需要处理弧度的变化
    if (transform.b < 0) {
        rotate = M_PI*2 - rotate;
        
    }
    return rotate;
    
}
   

- (void)pointViewSetHidden:(BOOL)hidden{
    _headV.hidden = hidden;
    _foot.hidden = hidden;
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.triangleV.bgColor = lineColor;
    
    [self.triangleV setNeedsDisplay];
    [self setNeedsDisplay];

}

@end
