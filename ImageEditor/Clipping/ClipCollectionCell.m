//
//  ClipCollectionCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/18.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "ClipCollectionCell.h"

@interface ClipCollectionCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ClipCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.titleLab.text = dic[@"name"];
    self.imageV.image = dic[@"image"];
    if (self.selected) {
        self.imageV.image = self.dic[@"select_Image"];
        self.titleLab.textColor = RGB(81, 154, 255);
    } else {
        self.imageV.image = self.dic[@"image"];
        self.titleLab.textColor = RGB(117, 117, 117);
    }
}

- (void)setBtnBackgroundColor:(UIColor *)btnBackgroundColor{
    _btnBackgroundColor = btnBackgroundColor;
    self.imageV.backgroundColor = btnBackgroundColor;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.imageV.image = self.dic[@"select_Image"];
        self.titleLab.textColor = RGB(81, 154, 255);
    } else {
        self.imageV.image = self.dic[@"image"];
        self.titleLab.textColor = RGB(117, 117, 117);
    }
}

@end
