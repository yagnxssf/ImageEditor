//
//  PADefine.h
//  PasswordAlbum
//
//  Created by cwsdteam03 on 2018/11/12.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#ifndef PADefine_h
#define PADefine_h


/******Start******/
/****** appInfo ******/
#define APPID   @"1456109275"

/******颜色******/
#define UIColorFormRGB(rgb)    [UIColor colorWithRed:((rgb&0xff0000) >> 16)/255.0 green:((rgb&0xff00) >> 8)/255.0 blue:(rgb&0xff)/255.0 alpha:1.0]

#define RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGB(r,g,b)     RGBA(r,g,b,1.0)

#define RandColor RGB(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))

/******字体******/
// 偏细字体
#define LIGHT_FONT(Size) [UIFont fontWithName:@"STHeitiSC-Light" size:Size]
// 偏粗字体
#define MEDIUM_FONT(Size) [UIFont fontWithName:@"PingFangSC-Regular" size:Size]
// 系统默认字体
#define DEFAULT_FONT(Size) [UIFont systemFontOfSize:Size]
// 粗体字体
#define BOLD_FONT(Size) [UIFont fontWithName:@"Helvetica-Bold" size:Size]

/******通用******/

//通用颜色
#define MainColor   RGBA(20,20,20,1)
#define DefaultBGColor [UIColor whiteColor]

#define RandColor RGB(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))

//通用尺寸
//屏幕宽度和高度
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define MainBounds [UIScreen mainScreen].bounds

#define SACornerRadius 2.5

//字体尺寸
#define DefaultFont  [UIFont systemFontOfSize:15]
#define BigFont      [UIFont systemFontOfSize:17]
#define SmartFont    [UIFont systemFontOfSize:13]
#define PingFangFont(a) [UIFont fontWithName:@"PingFang SC" size:a]

//适配尺寸
//UI按照iphone6设计
#define UIRate(a) ScreenW/750*a
#define HeightRate (ScreenH/667)
#define WidthRage  (ScreenW/375)


//适配相关 判断iPhone4s 的3.5英寸屏幕, iPhone5 的4英寸屏幕, 判断iPhone6 的4.7英寸屏幕, Phone6 Plus 的5.5英寸屏幕
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iPhoneX ([UIScreen mainScreen].bounds.size.height == 896 || [UIScreen mainScreen].bounds.size.height == 812)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)//判断iPad
#define DEVICES_IS_PRO_12_9 ([UIScreen mainScreen].bounds.size.height == 1366) //判断ipadpro

/******常用******/
#define NibName(className) [UINib nibWithNibName:NSStringFromClass([className class]) bundle:nil]
#define CellID(className)  [NSString stringWithFormat:@"%@",NSStringFromClass([className class])]
//bundleid
#define GetBundleID  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
//cache沙盒路径
#define Cache_Path  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define PAKeyWindow [UIApplication sharedApplication].keyWindow

#define PAWeakSelf __typeof(self) __weak weakSelf = self;
#define PAStrongSelf typeof(weakSelf) strongSelf = weakSelf;
#define AngleToRad(angle) ((angle) / 180.0 * M_PI)

//导航栏高度
#define NAV_BAR_HEIGHT  (IS_iPhoneX ? 88 : 64)

//tabBar高度
#define TAB_BAR_HEIGHT  (IS_iPhoneX ? 49+34 : 49)

#define State_Bar_Height (IS_iPhoneX ? 44 : 20)

#define Safe_Area_Height (IS_iPhoneX ? 34 : 0)

/******END******/
#endif /* PADefine_h */
