//
//  DrawFrameView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/12.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "DrawFrameView.h"
#import "CLClippingCircle.h"
#import "FrameView.h"

@interface DrawFrameView ()

@property (nonatomic, assign) CGRect initialRect;

@end

@implementation DrawFrameView
{
    FrameView *_frameView;
    CLClippingCircle *_ltView;
    CLClippingCircle *_lbView;
    CLClippingCircle *_rtView;
    CLClippingCircle *_rbView;
    
    CGPoint _initialPoint;
}

- (CLClippingCircle*)clippingCircleWithTag:(NSInteger)tag
{
    CLClippingCircle *view = [[CLClippingCircle alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    view.backgroundColor = [UIColor whiteColor];
    view.bgColor = [UIColor whiteColor];
    view.layer.cornerRadius = view.width/2;
    view.layer.masksToBounds = YES;
    view.tag = tag;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCircleView:)];
    [view addGestureRecognizer:panGesture];
    
    [self.superview addSubview:view];
    
    return view;
}

- (void)allSubviewsSetHidden:(BOOL)isHidden{
    for (UIView *view in self.superview.subviews) {
        if ([view isKindOfClass:[CLClippingCircle class]] || [view isKindOfClass:[DrawFrameView class]] || [view isKindOfClass:[FrameView class]]) {
            view.hidden = isHidden;
        }
    }
}

- (void)hiddenFourPointView{
    for (UIView *view in self.superview.subviews) {
        if ([view isKindOfClass:[CLClippingCircle class]] || [view isKindOfClass:[DrawFrameView class]]) {
            view.hidden = YES;
        }
    }
}

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [superview addSubview:self];
        _frameView = [[FrameView alloc] init];
        _frameView.lineColor = [UIColor blackColor];
        _frameView.backgroundColor = [UIColor clearColor];
        _frameView.frame = frame;
        [self.superview addSubview:_frameView];
        
        _ltView = [self clippingCircleWithTag:0];
        _lbView = [self clippingCircleWithTag:1];
        _rtView = [self clippingCircleWithTag:2];
        _rbView = [self clippingCircleWithTag:3];
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGridView:)];
        [_frameView addGestureRecognizer:panGesture];
        
        self.userInteractionEnabled = YES;
        
        self.frameRect = self.bounds;
        
    }
    return self;
}

- (void)setFrameRect:(CGRect)frameRect{
    _frameRect = frameRect;
    
    _ltView.center = [self.superview convertPoint:CGPointMake(frameRect.origin.x, frameRect.origin.y) fromView:self];
    _lbView.center = [self.superview convertPoint:CGPointMake(frameRect.origin.x, frameRect.origin.y+frameRect.size.height) fromView:self];
    _rtView.center = [self.superview convertPoint:CGPointMake(frameRect.origin.x+frameRect.size.width, frameRect.origin.y) fromView:self];
    _rbView.center = [self.superview convertPoint:CGPointMake(frameRect.origin.x+frameRect.size.width, frameRect.origin.y+frameRect.size.height) fromView:self];
    
    _frameView.size = frameRect.size;
    self.size = _frameView.size;

    [self setNeedsDisplay];
    
    
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [_frameView setNeedsDisplay];
}

- (void)panCircleView:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self];
    CGRect rct = self.frameRect;    
    const CGFloat W = self.superview.frame.size.width;
    const CGFloat H = self.superview.frame.size.height;
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = W;
    CGFloat maxY = H;
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialRect = self.frame;
    }
    
    switch (sender.view.tag) {
        case 0: // upper left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);

            point.x = MIN(point.x, maxX);
            point.y = MIN(point.y, maxY);
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.x = point.x;
            rct.origin.y = point.y;
            _frameView.x = self.x + point.x;
            _frameView.y = self.y + point.y;

            break;
        }
        case 1: // lower left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            
            point.x = MIN(point.x, maxX);
            point.y = MAX(minY, MIN(point.y, maxY));
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = point.y - rct.origin.y;
            rct.origin.x = point.x;
            _frameView.x = self.x + point.x;
            _frameView.y = self.y + point.y - rct.size.height;
            break;
        }
        case 2: // upper right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
            
            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MIN(point.y, maxY);
        
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.y = point.y;
            _frameView.y = self.y + point.y;
            _frameView.x = self.x + point.x - rct.size.width;

            break;
        }
        case 3: // lower right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MAX(minY, MIN(point.y, maxY));

            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = point.y - rct.origin.y;
            _frameView.x = self.x + point.x - rct.size.width;
            _frameView.y = self.y + point.y - rct.size.height;

            
            break;
        }
        default:
            break;
    }
    
    self.frameRect = rct;
}


- (void)panGridView:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = sender.view.center;
    }
    _frameView.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
    self.frame = _frameView.frame;
    self.frameRect = CGRectMake(0, 0, _frameView.width, _frameView.height);
    
    _ltView.center = CGPointMake(self.centerX-self.width/2, self.centerY-self.height/2);
    _lbView.center = CGPointMake(self.centerX-self.width/2, self.centerY+self.height/2);
    _rtView.center = CGPointMake(self.centerX+self.width/2, self.centerY-self.height/2);
    _rbView.center = CGPointMake(self.centerX+self.width/2, self.centerY+self.height/2);
    
    [self setNeedsDisplay];
    
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _frameView.lineColor = lineColor;
}

@end
