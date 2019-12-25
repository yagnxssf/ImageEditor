//
//  CLMosaicView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CLMosaicView.h"

@interface CLMosaicView ()

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef pathRef;


@end

@implementation CLMosaicView

- (void)dealloc{
    if (self.pathRef) {
        CGPathRelease(self.pathRef);
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        //添加imageview（surfaceImageView）到self上
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        
        //添加layer（imageLayer）到self上
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        //线端的形状
        self.shapeLayer.lineCap = kCALineCapSquare;//kCALineCapSquare
        //连接端的形状
        self.shapeLayer.lineJoin = kCALineJoinRound;
        //手指移动时 画笔的宽度
        self.shapeLayer.lineWidth = 10;
        self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
        self.shapeLayer.fillColor = nil;
        
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        self.pathRef = CGPathCreateMutableCopy(pathRef);
        CGPathRelease(pathRef);
        
    }
    return self;
}

- (void)setMosaicLineWidth:(CGFloat)width{
    self.shapeLayer.lineWidth = width;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.pathRef, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.pathRef);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(self.pathRef, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.pathRef);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
  
    CGContextAddPath(currentContext, path);
    [[UIColor redColor] setStroke];
    CGContextDrawPath(currentContext, kCGPathStroke);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];    
}

- (void)setImage:(UIImage *)image
{
    //底图
    _image = image;
    self.imageLayer.contents = (id)image.CGImage;
}


- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    //顶图
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}


@end
