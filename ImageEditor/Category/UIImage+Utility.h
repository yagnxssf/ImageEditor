//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

//根据Data生成图片
+ (UIImage*)fastImageWithData:(NSData*)data;
//根据路径生成图片
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

//深拷贝
- (UIImage*)deepCopy;

//灰色图片
- (UIImage*)grayScaleImage;

- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;

- (UIImage*)crop:(CGRect)rect;

- (UIImage*)maskedImage:(UIImage*)maskImage;

- (UIImage*)gaussBlur:(CGFloat)blurLevel;       //  {blurLevel | 0 ≤ t ≤ 1}

//保存图片到自定义相册
- (void)saveImageToCollectionWithIsPNG:(BOOL)isPNG compress:(CGFloat)compress;

//图片压缩到指定大小
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;


- (NSData *)compressImageWithAimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy;

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

@end


void safe_dispatch_sync_main(DISPATCH_NOESCAPE dispatch_block_t block);
