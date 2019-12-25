//
//  UsingGuideView.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/3/5.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "UsingGuideView.h"

@interface UsingGuideView()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;
@property (weak, nonatomic) IBOutlet UILabel *fourthLab;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation UsingGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    self.firstLab.text = NSLocalizedString(@"双击图片", nil);
    self.secondLab.text = NSLocalizedString(@"进入单张编辑页面", nil);
    self.thirdLab.text = NSLocalizedString(@"左右滑动", nil);
    self.fourthLab.text = NSLocalizedString(@"随意切换多张图片", nil);
    [self.button setTitle:NSLocalizedString(@"继续", nil) forState:UIControlStateNormal];
}

- (IBAction)continueAction:(id)sender {
    [self dismissExportView];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsShowedGuideView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
