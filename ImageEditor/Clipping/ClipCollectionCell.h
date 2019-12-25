//
//  ClipCollectionCell.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/18.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClipCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, copy) NSDictionary *dic;

@property (nonatomic, strong) UIColor *btnBackgroundColor;

@end

NS_ASSUME_NONNULL_END
