//
//  DrawFrameLayer.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/13.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "DrawFrameLayer.h"

@implementation DrawFrameLayer
+ (BOOL)needsDisplayForKey:(NSString*)key
{
    if ([key isEqualToString:@"DrawFrameRect"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if(self && [layer isKindOfClass:[DrawFrameLayer class]]){
        self.bgColor   = ((DrawFrameLayer*)layer).bgColor;
        self.gridColor = ((DrawFrameLayer*)layer).gridColor;
        self.clippingRect = ((DrawFrameLayer*)layer).clippingRect;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rct = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rct);
    
    CGContextClearRect(context, _clippingRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 4);
    
    rct = self.clippingRect;
    
    CGContextBeginPath(context);
    CGFloat dW = 0;
    for(int i=0;i<2;++i){
        CGContextMoveToPoint(context, rct.origin.x+dW, rct.origin.y);
        CGContextAddLineToPoint(context, rct.origin.x+dW, rct.origin.y+rct.size.height);
        dW += rct.size.width/1;
    }
    
    dW = 0;
    for(int i=0;i<2;++i){
        CGContextMoveToPoint(context, rct.origin.x, rct.origin.y+dW);
        CGContextAddLineToPoint(context, rct.origin.x+rct.size.width, rct.origin.y+dW);
        dW += rct.size.height/1;
    }
    CGContextStrokePath(context);
}
@end
