//
//  NSString+StringSize.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/18.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)
- (CGSize)sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font{
    if (!font) {
        return CGSizeZero;
    }
    NSDictionary *dict=@{NSFontAttributeName : font};
    return [self sizeWithpreferHeight:height attribute:dict];
}

- (CGSize)sizeWithpreferHeight:(CGFloat)height attribute:(NSDictionary *)attr{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

- (CGSize)sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font{
    if (!font) {
        return CGSizeZero;
    }
    NSDictionary *dict=@{NSFontAttributeName : font};
    return [self sizeWithPreferWidth:width attribute:dict];
}

- (CGSize)sizeWithPreferWidth:(CGFloat)width attribute:(NSDictionary *)attr{
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

@end
