//
//  TextToolCell.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/30.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "TextToolCell.h"

@interface TextToolCell()

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;


@end

@implementation TextToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellBtn.userInteractionEnabled = NO;

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.cellBtn.selected = selected;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self.cellBtn setImage:dic[@"image"] forState:UIControlStateNormal];
    [self.cellBtn setImage:dic[@"select_Image"] forState:UIControlStateSelected];
}

@end
