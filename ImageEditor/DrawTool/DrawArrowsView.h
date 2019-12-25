//
//  DrawArrowsView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/14.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawArrowsView : UIView

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;

- (void)pointViewSetHidden:(BOOL)hidden;

@property (nonatomic, strong) UIColor *lineColor;

@end

NS_ASSUME_NONNULL_END
