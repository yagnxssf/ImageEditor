//
//  AdjustmentCell.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustmentCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;

@property (nonatomic, strong) NSString *countValue;

@end

