//
//  ExportSuccessView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "ExportSuccessView.h"


@interface ExportSuccessView ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation ExportSuccessView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLab.text = NSLocalizedString(@"导出", nil);
    self.contentLab.text = NSLocalizedString(@"保存成功！分享给朋友吧", nil);
    
    [self.backBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
    [self.shareBtn setTitle:NSLocalizedString(@"分享", nil) forState:UIControlStateNormal];

}

- (IBAction)backAction:(id)sender {
    if (self.backBlock) {
        self.backBlock();
        [self dismissExportView];
    }
}

- (IBAction)shareAction:(id)sender {
    if (self.shareBlock) {
        self.shareBlock();
        [self dismissExportView];
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissExportView];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self removeFromSuperview];
    }
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

@end
