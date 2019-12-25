//
//  AdjustmentCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "AdjustmentCell.h"

@interface AdjustmentCell()

@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end

@implementation AdjustmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.cellBtn setUpImageAndDownLableWithSpace:8];
    self.cellBtn.userInteractionEnabled = NO;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self.cellBtn setImage:dic[@"image"] forState:UIControlStateNormal];
    [self.cellBtn setImage:dic[@"select_Image"] forState:UIControlStateSelected];
    [self.cellBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
    
    [self.cellBtn setUpImageAndDownLableWithSpace:8];

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.cellBtn.selected = selected;
    self.countLab.textColor = self.cellBtn.currentTitleColor;
    
}

- (void)setCountValue:(NSString *)countValue{
    _countValue = countValue;
    self.countLab.text = countValue;
}

@end
