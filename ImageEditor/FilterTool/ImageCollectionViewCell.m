//
//  ImageCollectionViewCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIImageView *lockImg;

@end

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.imageV = imageV;
    
    UIImageView *lockImg = [UIImageView new];
    lockImg.hidden = YES;
    lockImg.image = [UIImage imageNamed:@"locked"];
    [self addSubview:lockImg];
    [lockImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-11);
        make.top.equalTo(self).offset(28);
    }];
    self.lockImg = lockImg;
    
}

- (void)setCurrentImage:(UIImage *)currentImage{
    _currentImage = currentImage;
    self.imageV.image = currentImage;
}

- (void)setIsShowLock:(BOOL)isShowLock{
    _isShowLock = isShowLock;
    self.lockImg.hidden = !isShowLock;
}

@end
