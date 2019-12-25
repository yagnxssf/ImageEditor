//
//  DrawFrameView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/12.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawFrameView : UIView

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;

@property (nonatomic, assign) CGRect frameRect;

@property (nonatomic, strong) UIColor *lineColor;

- (void)allSubviewsSetHidden:(BOOL)isHidden;

- (void)hiddenFourPointView;


@end

NS_ASSUME_NONNULL_END
