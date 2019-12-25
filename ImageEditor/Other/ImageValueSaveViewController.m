//
//  ImageValueSaveViewController.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "ImageValueSaveViewController.h"
#import "UIView+LSCore.h"


@interface ImageValueSaveViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *compressLab;

@property (weak, nonatomic) IBOutlet UIButton *jpgBtn;
@property (weak, nonatomic) IBOutlet UIButton *pngBtn;
@property (weak, nonatomic) IBOutlet UIButton *percentBtn;
@property (weak, nonatomic) IBOutlet UIButton *specifyValueBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *formatLab;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ImageValueSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"图片保存选项", nil);
    
    self.formatLab.text = NSLocalizedString(@"格式", nil);
    self.compressLab.text = NSLocalizedString(@"压缩系数", nil);
//    NSLog(@"%@",NSStringFromCGRect(self.jpgBtn.frame));
    [self.jpgBtn addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft  withRadii:CGSizeMake(4.0, 4.0) viewRect:self.jpgBtn.bounds];

    [self.pngBtn addRoundedCorners:UIRectCornerBottomRight|UIRectCornerTopRight  withRadii:CGSizeMake(4.0, 4.0) viewRect:self.pngBtn.bounds];
    
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    
    self.dataArr = @[@"JPG100%",
                     @"JPG95%",
                     @"JPG90%",
                     @"JPG85%",
                     @"JPG80%"];
    
    NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:@"CompressSelectRow"];
    [self.pickView selectRow:row inComponent:0 animated:YES];
    
    NSString *imgFormat = [[NSUserDefaults standardUserDefaults] valueForKey:@"ImageFormatString"];
//    NSLog(@"%@",imgFormat);
    if (imgFormat == NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:@"JPG" forKey:@"ImageFormatString"];
    } else {
        if ([imgFormat isEqualToString:@"JPG"]) {
            [self.jpgBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            self.jpgBtn.backgroundColor = [UIColor whiteColor];
            
            [self.pngBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.pngBtn.backgroundColor = RGBA(51, 51, 51, 1);
            
            self.dataArr = @[@"JPG100%",
                             @"JPG95%",
                             @"JPG90%",
                             @"JPG85%",
                             @"JPG80%"];
        } else {
            [self.pngBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
            self.pngBtn.backgroundColor = [UIColor whiteColor];
            
            [self.jpgBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
            self.jpgBtn.backgroundColor = RGBA(51, 51, 51, 1);
            
            self.dataArr = @[@"PNG"];
        }
    }

    
}
- (IBAction)jpgAction:(id)sender {
    [self.jpgBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    self.jpgBtn.backgroundColor = [UIColor whiteColor];
    
    [self.pngBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pngBtn.backgroundColor = RGBA(51, 51, 51, 1);
    
    self.dataArr = @[@"JPG100%",
                     @"JPG95%",
                     @"JPG90%",
                     @"JPG85%",
                     @"JPG80%"];
    [self.pickView reloadAllComponents];
    
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"CompressSelectRow"];

    [[NSUserDefaults standardUserDefaults] setObject:@"JPG" forKey:@"ImageFormatString"];
}

- (IBAction)pngAction:(id)sender {
    [self.pngBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    self.pngBtn.backgroundColor = [UIColor whiteColor];
    
    [self.jpgBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    self.jpgBtn.backgroundColor = RGBA(51, 51, 51, 1);
    
    self.dataArr = @[@"PNG"];
    [self.pickView reloadAllComponents];
    
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"CompressSelectRow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"PNG" forKey:@"ImageFormatString"];
}

//- (IBAction)percentAction:(id)sender {
//    [self.percentBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//    self.percentBtn.backgroundColor = [UIColor whiteColor];
//
//    [self.specifyValueBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//    self.specifyValueBtn.backgroundColor = RGBA(51, 51, 51, 1);
//    self.unitLab.text = @"%";
//    self.subLab.text = NSLocalizedString(@"比值", nil);
//}
//
//- (IBAction)specifyValueAction:(id)sender {
//    [self.specifyValueBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//    self.specifyValueBtn.backgroundColor = [UIColor whiteColor];
//
//    [self.percentBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//    self.percentBtn.backgroundColor = RGBA(51, 51, 51, 1);
//    self.unitLab.text = @"KB";
//    self.subLab.text = NSLocalizedString(@"大小", nil);
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- UIPickerView --
//返回有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回指定列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [self.dataArr objectAtIndex:row];
    return str;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"被选择的行%@",[self.dataArr  objectAtIndex:row]);
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"CompressSelectRow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [self.dataArr objectAtIndex:row];
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

@end
