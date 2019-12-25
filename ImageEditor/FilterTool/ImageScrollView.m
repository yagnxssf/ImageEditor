//
//  ImageScrollView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/29.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "ImageScrollView.h"
#import "CLClippingPanel.h"

#define MaxSCale 3.0  //最大缩放比例
#define MinScale 1.0  //最小缩放比例

@interface ImageScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@end

@implementation ImageScrollView

- (void)setCurrentImage:(UIImage *)currentImage{
    _currentImage = currentImage;
    self.imageView.image = currentImage;
}

- (void)resetImageViewFrame:(CGRect)frame{
    self.imageView.frame = frame;
}

- (instancetype)initImageScrollViewWithImage:(UIImage *)image frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = MinScale;
        self.maximumZoomScale = MaxSCale;
        self.userInteractionEnabled = YES;
        
        _currentImage = image;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        [self layoutImageView];
        
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return _imageView;
//}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//
//    CGFloat offsetX = (self.bounds.size.width>self.contentSize.width)?(self.bounds.size.width-self.contentSize.width)*0.5:0.0;
//    CGFloat offsetY = (self.bounds.size.height>self.contentSize.height)?(self.bounds.size.height-self.contentSize.height)*0.5:0.0;
//    _imageView.center = CGPointMake(scrollView.contentSize.width*0.5+offsetX, scrollView.contentSize.height*0.5+offsetY);
//}

//自适应图片的宽高比
- (void)layoutImageView {
    CGRect imageFrame;
    if (_currentImage.size.width/_currentImage.size.height == ScreenW/ScreenH) {
//        imageFrame.size = CGSizeMake(ScreenW * 2/3, ScreenH*2/3);
//        imageFrame.origin.x = ScreenW/3/2;
//        imageFrame.origin.y = (self.size.height-imageFrame.size.height)/2;

        CGFloat height = self.bounds.size.height- 20;
        CGFloat width = height * (_currentImage.size.width/_currentImage.size.height);
        imageFrame.size = CGSizeMake(width, height);
        imageFrame.origin.y = 10;
        imageFrame.origin.x = (self.bounds.size.width - width)/2;
    } else if (_currentImage.size.width > self.bounds.size.width || _currentImage.size.height > self.bounds.size.height) {
        CGFloat imageRatio = _currentImage.size.width/_currentImage.size.height;
        CGFloat photoRatio = self.bounds.size.width/self.bounds.size.height;
        
        if (imageRatio > photoRatio) {
            imageFrame.size = CGSizeMake(self.bounds.size.width, self.bounds.size.width/_currentImage.size.width*_currentImage.size.height);
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (self.bounds.size.height-imageFrame.size.height)/2.0;
        }
        else {
            imageFrame.size = CGSizeMake(self.bounds.size.height/_currentImage.size.height*_currentImage.size.width, self.bounds.size.height);
            imageFrame.origin.x = (self.bounds.size.width-imageFrame.size.width)/2.0;
            imageFrame.origin.y = 0;
        }
    }
    else {
        imageFrame.size = _currentImage.size;
        imageFrame.origin.x = (self.bounds.size.width-_currentImage.size.width)/2.0;
        imageFrame.origin.y = (self.bounds.size.height-_currentImage.size.height)/2.0;
    }
    _imageView.frame = imageFrame;
    _imageView.image = _currentImage;
    
//    NSLog(@"%@ == %@",NSStringFromCGRect(_imageView.frame),NSStringFromCGRect(_imageView.bounds));
    _gridView = [[CLClippingPanel alloc] initWithSuperview:_imageView frame:_imageView.bounds];
    _gridView.hidden = YES;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.bgColor   = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _gridView.gridColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    _gridView.clipsToBounds = NO;
}

- (void)rotateAfterImageFrameUpdate{
    
}

@end
