//
//  CustomNavBar.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CustomNavBar.h"

@interface CustomNavBar()

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *forwardBtn;

@end

@implementation CustomNavBar

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = MainColor;
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews{
    UIButton *leftBtn = [UIButton new];
    [leftBtn setImage:[UIImage imageNamed:@"return-album"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(leftBtn.mas_height).multipliedBy(2);
    }];
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn setTitle:NSLocalizedString(@"导出", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:rightBtn];
    self.rightBtn = rightBtn;
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(leftBtn.mas_height).multipliedBy(2);
    }];
    
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"revoke-selectable"] forState:UIControlStateNormal];
    backBtn.alpha = 0.22;
//    backBtn.backgroundColor = RGB(167, 167, 167);
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *forwardBtn = [UIButton new];
    [forwardBtn setImage:[UIImage imageNamed:@"redo-selectable"] forState:UIControlStateNormal];
    forwardBtn.alpha = 0.22;
//    forwardBtn.backgroundColor = RGB(167, 167, 167);
    [forwardBtn addTarget:self action:@selector(forwardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forwardBtn];
    self.forwardBtn = forwardBtn;
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.mas_centerX).offset(-15);
    }];
    
    [forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.mas_centerX).offset(15);
    }];
}

- (void)leftBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftItemAction)]) {
        [self.delegate leftItemAction];
    }
}

- (void)rightBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightItemAction)]) {
        [self.delegate rightItemAction];
        
    }
}

- (void)backBtnAction:(UIButton *)sender{
    if (sender.alpha == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(backItemAction)]) {
            [self.delegate backItemAction];
        }
    }
    
}

- (void)forwardBtnAction:(UIButton *)sender{
    if (sender.alpha == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(forwardItemAction)]) {
            [self.delegate forwardItemAction];
        }
    }
}

- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    [self.rightBtn setTitle:NSLocalizedString(rightTitle, nil) forState:UIControlStateNormal];
}

- (void)setBackBtnAlpha:(CGFloat)alpha{
    self.backBtn.alpha = alpha;
}

- (void)setForwardBtnAplha:(CGFloat)alpha{
    self.forwardBtn.alpha = alpha;  
}

@end
