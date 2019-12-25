//
//  ExportView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/20.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "ExportView.h"
#import "UIView+LSCore.h"
#import "UIImage+Utility.h"
#import "YQImageCompressTool.h"
#import "NSObject+FileTool.h"

@interface ExportView()<CAAnimationDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *formatLab;

@property (weak, nonatomic) IBOutlet UILabel *subLab;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *estimateSizeLab;//估计大小

@property (weak, nonatomic) IBOutlet UIButton *jpgBtn;

@property (weak, nonatomic) IBOutlet UIButton *pngBtn;

@property (weak, nonatomic) IBOutlet UIButton *percentBtn;

@property (weak, nonatomic) IBOutlet UIButton *specifyValueBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) CGFloat compress;


@end

@implementation ExportView

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self removeFromSuperview];
    }
}
//关闭
- (IBAction)closeAction:(id)sender {
    [self dismissExportView];
}
//返回编辑
- (IBAction)backToEdit:(id)sender {
    [self dismissExportView];
}

- (void)dismissExportView{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.0];
    animation.duration=0.25;
    animation.repeatCount=1;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"zoom"];
}

//确定
- (IBAction)okAction:(id)sender {
    PAWeakSelf
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [indicator startAnimating];
    BOOL isPNG = self.pngBtn.selected;
    // 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Compress", DISPATCH_QUEUE_SERIAL);
    for (UIImage *image in self.images) {
        dispatch_async(queue, ^{
            [image saveImageToCollectionWithIsPNG:isPNG compress:self.compress];
        });
    }
    
    dispatch_barrier_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [weakSelf dismissExportView];

            if (weakSelf.successBlock) {
                weakSelf.successBlock();
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{                
                NSString *path_document = [NSString creatFolderInCacheWithFolerName:@"ImgMulEdit"];
                NSFileManager *manager = [NSFileManager defaultManager];
                [manager removeItemAtPath:path_document error:nil];
            });
        });
    });
   
    
    
}

//jpg
- (IBAction)JPGAction:(UIButton *)sender {
    sender.selected = YES;
    self.pngBtn.selected = NO;
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
}

//png
- (IBAction)PNGAction:(UIButton *)sender {
    sender.selected = YES;
    self.jpgBtn.selected = NO;
    [self.pngBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    self.pngBtn.backgroundColor = [UIColor whiteColor];
    
    [self.jpgBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    self.jpgBtn.backgroundColor = RGBA(51, 51, 51, 1);
    
    self.dataArr = @[@"PNG"];
    [self.pickView reloadAllComponents];
    
    [self.pickView selectRow:0 inComponent:0 animated:YES];
}
////百分比
//- (IBAction)percentAction:(UIButton *)sender {
//    [self.percentBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//    self.percentBtn.backgroundColor = [UIColor whiteColor];
//
//    [self.specifyValueBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//    self.specifyValueBtn.backgroundColor = RGBA(51, 51, 51, 1);
//    self.unitLab.text = @"%";
//    self.subLab.text = NSLocalizedString(@"比值", nil);
//
//}
////指定值
//- (IBAction)specifyValue:(UIButton *)sender {
//    [self.specifyValueBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
//    self.specifyValueBtn.backgroundColor = [UIColor whiteColor];
//
//    [self.percentBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
//    self.percentBtn.backgroundColor = RGBA(51, 51, 51, 1);
//    self.unitLab.text = @"KB";
//    self.subLab.text = NSLocalizedString(@"大小", nil);
//
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.formatLab.text = NSLocalizedString(@"格式", nil);
    self.subLab.text = NSLocalizedString(@"压缩系数", nil);

    
    CGRect rect = self.jpgBtn.bounds;
    [self.jpgBtn addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft  withRadii:CGSizeMake(4.0, 4.0) viewRect:rect];

    [self.pngBtn addRoundedCorners:UIRectCornerBottomRight|UIRectCornerTopRight  withRadii:CGSizeMake(4.0, 4.0) viewRect:rect];
//    [self.percentBtn addRoundedCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft  withRadii:CGSizeMake(4.0, 4.0) viewRect:rect];
//
//    [self.specifyValueBtn addRoundedCorners:UIRectCornerBottomRight|UIRectCornerTopRight  withRadii:CGSizeMake(4.0, 4.0) viewRect:rect];
    
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    
    
    self.dataArr = @[@"JPG100%",
                     @"JPG95%",
                     @"JPG90%",
                     @"JPG85%",
                     @"JPG80%"];
    self.compress = 1.0;
    
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
    if (row == 0) {//100%
        self.compress = 1.0;
    } else if (row == 1) { //95%
        self.compress = 0.95;
    } else if (row == 2) { //90%
        self.compress = 0.9;
    } else if (row == 3) { //85%
        self.compress = 0.85;
    } else if (row == 4) { //80%
        self.compress = 0.8;
    }
}

//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [self.dataArr objectAtIndex:row];
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

@end
