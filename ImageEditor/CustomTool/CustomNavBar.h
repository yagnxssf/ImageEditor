//
//  CustomNavBar.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomNavBarDelegate <NSObject>

- (void)leftItemAction;

- (void)rightItemAction;

- (void)forwardItemAction;

- (void)backItemAction;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CustomNavBar : UIView

@property (nonatomic, assign) id <CustomNavBarDelegate> delegate;

@property (nonatomic, strong) NSString *rightTitle;

- (void)setBackBtnAlpha:(CGFloat)alpha;

- (void)setForwardBtnAplha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
