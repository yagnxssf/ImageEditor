//
//  SettingViewController.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "SettingViewController.h"
#import "ImageValueSaveViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = @[@[NSLocalizedString(@"保存默认值", nil),
                       NSLocalizedString(@"自动分享", nil)],
                     @[NSLocalizedString(@"关于应用", nil),
                       NSLocalizedString(@"分享应用", nil),
                       NSLocalizedString(@"评价应用", nil)]
                    ];
    
    [self setupTableView];
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return-setting"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableView{
    UILabel *titleLab = [UILabel new];
    titleLab.text = NSLocalizedString(@"设置", nil);
    titleLab.font = [UIFont boldSystemFontOfSize:34];
    titleLab.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view);
    }];
    
    self.view.backgroundColor = RGB(20, 20, 20);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    cell.backgroundColor = RGB(31, 31, 31);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
        UISwitch *switchBtn = [[UISwitch alloc] init];
        [switchBtn addTarget:self action:@selector(setOpenShare:) forControlEvents:UIControlEventValueChanged];
        BOOL isOpenShare = [[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenShare"];
        [switchBtn setOn:isOpenShare];
        cell.accessoryView = switchBtn;
    } else {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow-setting"]];
        cell.accessoryView = imageV;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {//c保存默认值
        ImageValueSaveViewController *saveVC = [[ImageValueSaveViewController alloc] init];
        [self.navigationController pushViewController:saveVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {//关于应用
        AboutUsViewController *aboutVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {//分享应用
        NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"itms-apps://itunes.apple.com/app/id",APPID]];
        UIImage *shareImage = [UIImage imageNamed:@"green-unselected"];
        NSString *shareText = NSLocalizedString(@"应用分享", nil);
        NSArray *items = @[shareText,shareImage,shareUrl];
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        
        [self presentViewController:activity animated:YES completion:nil];
    } else if (indexPath.section == 1 && indexPath.row == 2) {//评价应用
        //评分
        NSString *openAppStore = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",APPID];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openAppStore]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 38;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)setOpenShare:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"isOpenShare"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
