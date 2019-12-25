//
//  FilterEditorToolCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/28.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import "FilterEditorToolCell.h"
@interface FilterEditorToolCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@end

@implementation FilterEditorToolCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
//    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.imageV.image = dic[@"image"];
    self.nameLab.text = dic[@"name"];
    self.imageV.backgroundColor = [UIColor clearColor];
    if (dic[@"color"] != nil) {
        self.imageV.backgroundColor = dic[@"color"];
        self.imageV.layer.cornerRadius = 15;
        self.imageV.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.selectView.hidden = NO;
    } else {
        self.selectView.hidden = YES;
    }
}

@end
