//
//  CLTextView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const CLTextViewActiveViewDidChangeNotification = @"CLTextViewActiveViewDidChangeNotificationString";
static NSString* const CLTextViewActiveViewDidTapNotification = @"CLTextViewActiveViewDidTapNotificationString";

@class CLTextView,CLTextTool;
NS_ASSUME_NONNULL_BEGIN

@interface CLTextView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

+ (void)setActiveTextView:(CLTextView*)view;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;

@end

NS_ASSUME_NONNULL_END
