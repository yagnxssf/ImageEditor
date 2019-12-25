//
//  CLTextTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CLTextTool.h"
#import "CLTextView.h"
#import "CLTextLabel.h"
#import "SingleImageEditorViewController.h"
#import "ImageScrollView.h"
#import "CLFontPickerView.h"
#import "FilterEditorToolView.h"
#import "CLColorPickerView.h"
#import "CLCircleView.h"
#import "UIView+Frame.h"

@interface CLTextTool ()

@property (nonatomic, strong) CLTextView *selectedTextView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation CLTextTool
{
    UIView *_workingView;
    
    UITextView *_textView;

}

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController *)imageEditor{
    if ([super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:CLTextViewActiveViewDidTapNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        _editor = imageEditor;
        [self setup];
    }
    return self;
}

- (void)activeTextViewDidTap:(NSNotification*)notification{
    [_textView becomeFirstResponder];
}

- (void)newTextView{
    CLTextView *view = [[CLTextView alloc] init];
    view.fillColor = [UIColor whiteColor];
    view.borderColor = [UIColor clearColor];
    view.borderWidth = 0;
    view.font = [UIFont systemFontOfSize:16];
    
    CGFloat ratio = MIN( (0.8 * self.editor.scrollView.imageView.width) / view.width, (0.2 * self.editor.scrollView.imageView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.editor.scrollView.imageView.width/2, _workingView.height/2);
    [_workingView addSubview:view];
    [CLTextView setActiveTextView:view];
    
    self.selectedTextView = view;
}

- (void)setup{
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.scrollView.imageView.frame fromView:self.editor.scrollView.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    [self newTextView];
    
    UIView *contentView = [UIView new];
    contentView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
    [self.editor.view addSubview:contentView];
    self.contentView = contentView;

    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    [contentView addSubview:blurEffectView];
    [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];

    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:22];
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:_textView];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"close-popup"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeBtn];
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(25);
        make.right.equalTo(contentView).offset(-25);
        make.top.equalTo(closeBtn.mas_bottom).offset(40);
        make.bottom.equalTo(contentView);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(10);
        make.left.equalTo(contentView).offset(15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

//- (void)pathSliderDidChange:(UISlider *)sender{
//    self.selectedTextView.borderWidth = sender.value;
//}

- (void)confirmBtnClick:(UIButton *)sender{
    NSRange selection = _textView.selectedRange;
    if(selection.location+selection.length == _textView.text.length && [_textView.text characterAtIndex:_textView.text.length-1] == '\n') {
        [_textView layoutSubviews];
        [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height - 1, 1, 1) animated:YES];
    }
    else {
        [_textView scrollRangeToVisible:_textView.selectedRange];
    }
    
    self.selectedTextView.text = _textView.text;
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
    
    [_textView resignFirstResponder];

}

- (void)closeBtnClick:(UIButton *)sender{
    
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0 options:UIViewAnimationOptionBeginFromCurrentState
         animations:^{
             self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
         } completion:^(BOOL finished) {
             
         }
     ];
    
}

- (void)textViewToolDidSelectIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self setTextViewColor:[UIColor whiteColor]];
            break;
        case 1:
            [self setTextViewColor:RGB(33, 33, 33)];//黑
            break;
        case 2:
            [self setTextViewColor:RGB(19, 125, 250)];//蓝色
            break;
        case 3:
            [self setTextViewColor:RGB(73, 209, 94)];//绿色
            break;
        case 4:
            [self setTextViewColor:RGB(254, 208, 43)];//黄色
            break;
        case 5:
            [self setTextViewColor:RGB(252, 42, 71)];//红色
            break;
        default:
            break;
    }
}

- (UIImage*)buildImage:(UIImage*)image
{
    __block CALayer *layer = nil;
    __block CGFloat scale = 1;
    
    UIView *deleteBtn = [self.selectedTextView viewWithTag:999];
    UIView *circleView = [self.selectedTextView viewWithTag:998];
    CLTextLabel *textLab = [self.selectedTextView viewWithTag:1000];
    textLab.layer.borderColor = [[UIColor clearColor] CGColor];
    deleteBtn.hidden = YES;
    circleView.hidden = YES;
    
    safe_dispatch_sync_main(^{
        scale = image.size.width / self->_workingView.width;
        layer = self->_workingView.layer;
    });
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.selectedTextView removeFromSuperview];
    [_workingView removeFromSuperview];
    
    return tmp;
}

#pragma mark - keyboard events

- (void)keyBoardWillShow:(NSNotification *)notificatioin
{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    }];
    [_textView scrollRangeToVisible:_textView.selectedRange];
}

- (void)keyBoardWillHide:(NSNotification *)notificatioin
{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
    }];
}

//文字颜色
- (void)setTextViewColor:(UIColor *)color{
    self.selectedTextView.fillColor = color;
}

//字体
- (void)setTextViewFont:(UIFont *)font{
    self.selectedTextView.font = font;
    [self.selectedTextView sizeToFitWithMaxWidth:0.8*_workingView.width lineHeight:0.2*_workingView.height];
}

//字体透明度
- (void)setTextFontAlphaWith:(CGFloat)alpha{
    self.selectedTextView.fillColor = [self.selectedTextView.fillColor colorWithAlphaComponent:alpha];
}

- (void)clearupSubviews{
    [_workingView removeFromSuperview];
    self.selectedTextView = nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
