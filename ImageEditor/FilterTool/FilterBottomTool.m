//
//  FilterBottomTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/16.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "FilterBottomTool.h"

@implementation FilterBottomTool
{
    UILabel *_titleLab;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = MainColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLab.text = titleStr;
}

- (void)setupSubviews{
    UILabel *titleLab = [UILabel new];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    _titleLab = titleLab;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:closeBtn];
    
    UIButton *okBtn = [UIButton new];
    [okBtn setImage:[UIImage imageNamed:@"confirm"]  forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self addSubview:okBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(80);
    }];
}

- (void)okAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterBottomToolOK)]) {
        [self.delegate filterBottomToolOK];
    }
}

- (void)closeAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterBottomToolClose)]) {
        [self.delegate filterBottomToolClose];
    }
}

@end
