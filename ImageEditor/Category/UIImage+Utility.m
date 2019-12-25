//
//  UIImage+Utility.m
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "UIImage+Utility.h"

#import <Accelerate/Accelerate.h>
#import <Photos/Photos.h>
#import "NSObject+FileTool.h"

@implementation UIImage (Utility)

//保存图片到自定义相册
- (void)saveImageToCollectionWithIsPNG:(BOOL)isPNG compress:(CGFloat)compress{
    __block NSString *assetId = nil;
    NSData *imageData;
    if (isPNG) {
        imageData = UIImagePNGRepresentation(self);
    } else {
        imageData = UIImageJPEGRepresentation(self, compress);
    }
    
    NSString *path_document = [NSString creatFolderInCacheWithFolerName:@"ImgMulEdit"];
    
    NSInteger fileCount = [NSString getFileCountWithPath:path_document];
    
    NSString *imagePath = [path_document stringByAppendingPathComponent:[NSString stringWithFormat:@"ImgMulEdit_%@.%@",@(fileCount),isPNG?@"png":@"jpg"]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [imageData writeToFile:imagePath atomically:YES];
    
    //1.存储图片到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //新建一个PHAssetCreationRequest对象
        //返回PHAsset(图片)的字符串标示
        NSURL *imageUrl = [NSURL fileURLWithPath:imagePath];
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:imageUrl].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //2.获取相册对象
        PHAssetCollection *collection = [self getCollection];
        //3.将图片添加到自定义的相册中
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            //根据唯一标示h获得图片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            
//            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//            options.resizeMode = PHImageRequestOptionsResizeModeFast;
//            options.networkAccessAllowed = YES;
//            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//                NSLog(@"imageData length = %lu",(unsigned long)imageData.length);
//            }];
            
            //添加到相册
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"保存成功");
        }];
    }];
}

//获取自定义的相册
- (PHAssetCollection *)getCollection{
    //先获得之前创建过的相册
    PHFetchResult <PHAssetCollection*> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:@"ImgMulEdit"]) {
            return collection;
        }
    }
    
    //如果相册没有，则创建新的相册文件夹
    __block NSString *collectionId = nil;//__block修改block外部的变量的值
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"ImgMulEdit"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

+ (UIImage*)decode:(UIImage*)image
{
    if(image==nil){  return nil; }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    {
        [image drawAtPoint:CGPointMake(0, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)fastImageWithData:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    return [self decode:image];
}

+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [self decode:image];
}

#pragma mark- Copy

- (UIImage*)deepCopy
{
    return [UIImage decode:self];
}

#pragma mark- GrayScale

- (UIImage*)grayScaleImage
{
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(context, imageRect, [self CGImage]);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

#pragma mark- Resizing

- (UIImage*)resize:(CGSize)size
{
    int W = size.width;
    int H = size.height;
    
    CGImageRef   imageRef   = self.CGImage;  // If the image is CIImage backed, then imageRef would be nil
    if (!imageRef) {
        imageRef = [[CIContext context] createCGImage:self.CIImage fromRect:[self.CIImage extent]];
    }
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

- (UIImage*)aspectFit:(CGSize)size
{
    CGFloat ratio = MIN(size.width/self.size.width, size.height/self.size.height);
    return [self resize:CGSizeMake(self.size.width*ratio, self.size.height*ratio)];
}

- (UIImage*)aspectFill:(CGSize)size
{
    return [self aspectFill:size offset:0];
}

- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset
{
    int W  = size.width;
    int H  = size.height;
    int W0 = self.size.width;
    int H0 = self.size.height;
    
    CGImageRef   imageRef = self.CGImage;  // If the image is CIImage backed, then imageRef would be nil
    if (!imageRef) {
        imageRef = [[CIContext context] createCGImage:self.CIImage fromRect:[self.CIImage extent]];
    }
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W  = size.height;
        H  = size.width;
        W0 = self.size.height;
        H0 = self.size.width;
    }
    
    double ratio = MAX(W/(double)W0, H/(double)H0);
    W0 = ratio * W0;
    H0 = ratio * H0;
    
    int dW = abs((W0-W)/2);
    int dH = abs((H0-H)/2);
    
    if(dW==0){ dH += offset; }
    if(dH==0){ dW += offset; }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(-dW, -dH, W0, H0), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

#pragma mark- Clipping
//裁剪
- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark- Masking
//戴面具的图片
- (UIImage*)maskedImage:(UIImage*)maskImage
{
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage.CGImage),
                                        CGImageGetHeight(maskImage.CGImage),
                                        CGImageGetBitsPerComponent(maskImage.CGImage),
                                        CGImageGetBitsPerPixel(maskImage.CGImage),
                                        CGImageGetBytesPerRow(maskImage.CGImage),
                                        CGImageGetDataProvider(maskImage.CGImage), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask(self.CGImage, mask);
    
    UIImage *result = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(mask);
    CGImageRelease(masked);
    
    return result;
}

#pragma mark- Blur
//模糊图片
- (UIImage*)gaussBlur:(CGFloat)blurLevel
{
    blurLevel = MIN(1.0, MAX(0.0, blurLevel));
    
    int boxSize = (int)(blurLevel * 0.1 * MIN(self.size.width, self.size.height));
    boxSize = boxSize - (boxSize % 2) + 1;
    
    NSData *imageData = UIImageJPEGRepresentation([UIImage decode:self], 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    
    // convolution
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend)?:
    vImageConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    outBuffer = inBuffer;
    
    free(kernel);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    NSLog(@"%luKB",(unsigned long)data.length);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    NSLog(@"%luKB",(unsigned long)data.length);
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        NSLog(@"%luKB",(unsigned long)data.length);
    }
    
    return resultImage;
}


/**
 *  压缩图片质量，返回值为可直接转化成UIImage对象的NSData对象
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)，本方法虽然给出了误差范围，但实际上很难确定一张图片是否能压缩到误差范围内，无法实现精确压缩。
 */
- (NSData *)compressImageWithAimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy{
    UIImage *image = self;
    UIImage * newImage = [self imageWithImage:image scaledToSize:CGSizeMake(width, width * image.size.height / image.size.width)];
//    UIImage *newImage = self;
    NSData  * data = UIImageJPEGRepresentation(newImage, 1);
    NSInteger imageDataLen = [data length];
    
    if (imageDataLen <= length + accuracy) {
        return data;
    }else{
        NSData * imageData = UIImageJPEGRepresentation( newImage, 0.99);
        if (imageData.length < length + accuracy) {
            return imageData;
        }
        
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            if (flag == 6) {
                return UIImageJPEGRepresentation(newImage, minQuality);
            }
            flag ++;
            
            NSData * imageData = UIImageJPEGRepresentation(newImage, midQuality);
            NSInteger len = imageData.length;
            
            if (len > length+accuracy) {
                maxQuality = midQuality;
                continue;
            }else if (len < length-accuracy){
                minQuality = midQuality;
                continue;
            }else{
                return imageData;
                break;
            }
        }
    }
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

@end


void safe_dispatch_sync_main(DISPATCH_NOESCAPE dispatch_block_t block)
{
    if([NSThread isMainThread]){
        block();
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
