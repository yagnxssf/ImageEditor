//
//  SABaseNaviController.m
//  SalesAssistant
//
//  Created by huylens on 2017/5/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "SABaseNaviController.h"

@interface SABaseNaviController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation SABaseNaviController
+ (void)initialize {
    //设置Bar
    UINavigationBar *bar = [UINavigationBar appearance];
//    UIImage *image = [[UIImage imageNamed:@"navigationbar_background_tall"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)  resizingMode:UIImageResizingModeStretch];
//
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;

    bar.barStyle = UIBarStyleBlackOpaque;
    
    [bar setBarTintColor:MainColor];
    //    去除黑线
    [bar setShadowImage:[UIImage new]];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName :BOLD_FONT(16),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [bar setTintColor:[UIColor whiteColor]];
    
    // 设置item
    //    UIBarButtonItem *item = [UIBarButtonItem appearance];
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];

    // UIControlStateNormal
    NSDictionary * NormalItemAttrs = @{
                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSFontAttributeName:PingFangFont(17)

                                       };
    [item setTitleTextAttributes:NormalItemAttrs forState:UIControlStateNormal];

//    // UIControlStateDisabled
//    NSDictionary * DisabledItemAttrs = @{
//                                         NSForegroundColorAttributeName:[UIColor lightGrayColor],
//                                         NSFontAttributeName:[UIFont systemFontOfSize:16]
//
//                                         };
//     [item setTitleTextAttributes:DisabledItemAttrs forState:UIControlStateDisabled];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
//    UIImage *image = [UIImage imageNamed:@"background"];
//    self.view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
//    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0)
    {
//
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn setTitle:NSLocalizedString(@" 返回", nil) forState:UIControlStateNormal];
//        [backBtn setTitleColor:RGB(66, 165, 245) forState:UIControlStateNormal];
//        backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [backBtn setImage:[UIImage imageNamed:@"return-setting"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];

}

- (void)backButtonClick {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)beginSlideAction {
    [self.topViewController.view endEditing:YES];
}


// 开始接收到手势的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 判断是否是侧滑相关的手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 如果当前展示的控制器是根控制器就不让其响应
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

// 接收到多个手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 判断是否是侧滑相关手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self.view];
        // 如果是侧滑相关的手势，并且手势的方向是侧滑的方向就让多个手势共存
        if (point.x > 0) {
            return YES;
        }
    }
    return NO;
}

@end
