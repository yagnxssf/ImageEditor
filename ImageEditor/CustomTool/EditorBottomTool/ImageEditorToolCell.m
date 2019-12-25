//
//  ImageEditorToolCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "ImageEditorToolCell.h"

@interface ImageEditorToolCell()

@property (nonatomic, strong) UILabel *functionLab;

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation ImageEditorToolCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    UIImageView *iconImage = [UIImageView new];
//    iconImage.backgroundColor = RGB(167, 167, 167);
    [self addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *functionLab = [UILabel new];
    functionLab.font = [UIFont systemFontOfSize:8];
    functionLab.textColor = RGBA(117, 117, 177, 1);
    functionLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:functionLab];
    self.functionLab = functionLab;
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-10);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [functionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(7);
        make.centerX.equalTo(iconImage);
    }];
}

- (void)setCellDic:(NSDictionary *)cellDic{
    _cellDic = cellDic;
    self.functionLab.text = cellDic[@"title"];
    self.iconImage.image = [UIImage imageNamed:cellDic[@"image"]];
}


@end
