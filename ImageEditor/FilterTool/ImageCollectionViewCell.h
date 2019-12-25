//
//  ImageCollectionViewCell.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, assign) BOOL isShowLock;

@end

NS_ASSUME_NONNULL_END
