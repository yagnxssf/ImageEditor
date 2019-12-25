//
//  AboutUsViewController.m
//  SalaryCalculator
//
//  Created by cwsdteam03 on 2019/1/10.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"关于应用", nil);
    
    self.view.backgroundColor = RGB(20, 20, 20);
    
    [self setupSubviews];
}

- (void)setupSubviews{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [NSString
                            stringWithFormat:@"%@ %@",@"Version",[infoPlist objectForKey:@"CFBundleShortVersionString"]];
    UILabel *versionLab = [UILabel new];
    versionLab.text = appVersion;
    versionLab.textColor = [UIColor whiteColor];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:versionLab];
    
    UILabel *nameLab = [UILabel new];
    nameLab.text = NSLocalizedString(appName, nil);
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nameLab];
    
    UIImageView *appIconImg = [[UIImageView alloc] init];
    appIconImg.image = [UIImage imageNamed:@"icon-1024"];
    appIconImg.layer.cornerRadius = 15;
    appIconImg.layer.masksToBounds = YES;
    [self.view addSubview:appIconImg];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(versionLab.mas_top);
    }];
    
    [appIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(125);
        make.bottom.equalTo(nameLab.mas_top).offset(-20);
    }];
    
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
}


@end
