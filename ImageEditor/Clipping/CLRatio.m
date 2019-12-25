//
//  CLRatio.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/29.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "CLRatio.h"

@implementation CLRatio
{
    CGFloat _longSide;
    CGFloat _shortSide;
}

- (id)initWithValue1:(CGFloat)value1 value2:(CGFloat)value2
{
    self = [super init];
    if(self){
        _longSide  = MAX(fabs(value1), fabs(value2));
        _shortSide = MIN(fabs(value1), fabs(value2));
    }
    return self;
}

- (NSString*)description
{
    NSString *format = (self.titleFormat) ? self.titleFormat : @"%g : %g";
    
    if(self.isLandscape){
        return [NSString stringWithFormat:format, _longSide, _shortSide];
    }
    return [NSString stringWithFormat:format, _shortSide, _longSide];
}

- (CGFloat)ratio
{
    if(_longSide==0 || _shortSide==0){
        return 0;
    }
    
    if(self.isLandscape){
        return _shortSide / (CGFloat)_longSide;
    }
    return _longSide / (CGFloat)_shortSide;
}

@end
