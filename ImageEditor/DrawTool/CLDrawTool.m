//
//  CLDrawTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "CLDrawTool.h"
#import "SingleImageEditorViewController.h"
#import "ImageScrollView.h"
#import "FilterEditorToolView.h"
#import "SliderView.h"
#import "DrawFrameView.h"
#import "DrawArrowsView.h"
#import "SDDrawView/SDDrawView.h"

typedef NS_ENUM(NSInteger,DrawToolType) {
    DrawToolTypeFrame = 0,//框框
    DrawToolTypeArrows,//箭头
    DrawToolTypeBrush,//画笔
};

@interface CLDrawTool()

@property (nonatomic,assign) DrawToolType drawType;

@property (nonatomic, strong) UIScrollView *menuView;

@property (nonatomic, strong) NSMutableArray *itemsArr;

@property (nonatomic, strong) UIColor *strokeColor;//颜色

//@property (nonatomic, strong) UISlider *widthSilder;//粗细

@property (nonatomic, assign) BOOL isEraser;//橡皮擦
//@property (nonatomic ,strong) DrawFrameView *frameView;
//@property (nonatomic, strong) DrawArrowsView *arrowsView;

@property (nonatomic, strong) UIButton *eraserBtn;//橡皮擦按钮

@property (nonatomic, strong) SDDrawView *drawView;

@end

@implementation CLDrawTool
{
    UIImageView *_drawingView;
    CGSize _originalImageSize;
    CGPoint _prevDraggingPosition;
}

- (NSMutableArray *)itemsArr{
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
    }
    return _itemsArr;
}

- (SDDrawView *)drawView{
    
    if(_drawView == nil){
        
        _drawView = [[SDDrawView alloc] init];
        _drawView.drawViewColor = [UIColor clearColor];
        _drawView.lineWidth = self.silderValue;
        _drawView.drawStyle = DrawStyleArrow;
        _drawView.lineColor = self.strokeColor;
        _drawView.layer.borderWidth = 1.0f;
        _drawView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _drawView;
    
}

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController *)imageEditor{
    if ([super init]) {
        self.drawType = DrawToolTypeBrush;
        _editor = imageEditor;
        self.strokeColor = RGB(252, 42, 71);
        [self setup];
        
    }
    return self;
}

- (void)setup{
    _originalImageSize = self.editor.scrollView.imageView.image.size;
    _drawingView = [[UIImageView alloc] initWithFrame:self.editor.scrollView.imageView.bounds];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    panGesture.maximumNumberOfTouches = 1;
    
    _drawingView.userInteractionEnabled = YES;
    [_drawingView addGestureRecognizer:panGesture];
    
    [self.editor.scrollView.imageView addSubview:_drawingView];
    self.editor.scrollView.imageView.userInteractionEnabled = YES;

    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    self.menuView = [[UIScrollView alloc] init];
    self.menuView.frame = CGRectMake(0, 47, self.editor.filterTool.width, self.editor.filterTool.collectionView.height);
    self.menuView.backgroundColor = RGB(20, 20, 20);
    [self.editor.filterTool addSubview:self.menuView];
    
    [self setMenuView];
    
//    self.frameView = [[DrawFrameView alloc] initWithSuperview:_drawingView frame:CGRectMake(_drawingView.centerX-60, _drawingView.centerY-60, 120, 120)];
//    self.frameView.lineColor = self.strokeColor;
//    self.frameView.center = _drawingView.center;
//    self.frameView.backgroundColor = [UIColor clearColor];
//    self.frameView.clipsToBounds = NO;
//    [self.frameView allSubviewsSetHidden:YES];
    
//    DrawArrowsView *arrowsView = [[DrawArrowsView alloc] initWithSuperview:_drawingView frame:_drawingView.bounds];
//    arrowsView.hidden = YES;
//    arrowsView.lineColor = self.strokeColor;
//    arrowsView.backgroundColor = [UIColor clearColor];
//    self.arrowsView = arrowsView;
    
    //画方框和箭头
    [self.editor.scrollView.imageView addSubview:self.drawView];
    self.drawView.hidden = YES;
    self.drawView.frame = self.editor.scrollView.imageView.bounds;
    
    UIButton *eraserBtn = [UIButton new];
    [eraserBtn setImage:[UIImage imageNamed:@"eraser-selectable"] forState:UIControlStateNormal];
    [eraserBtn setImage:[UIImage imageNamed:@"eraser-selected"] forState:UIControlStateSelected];
    [eraserBtn addTarget:self action:@selector(eraserAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editor.scrollView.imageView addSubview:eraserBtn];
    
    [eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editor.scrollView.imageView).offset(-10);
        make.centerY.equalTo(self.editor.scrollView.imageView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    self.eraserBtn = eraserBtn;

}

- (void)eraserAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isEraser = sender.selected;
}

- (void)setMenuView{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self.menuView addSubview:lineView];
    
    CGFloat itemWidth = 30;
    CGFloat contentWidth = itemWidth * (9 + 8) + 21 * 2;
    self.menuView.contentSize = CGSizeMake(contentWidth, self.menuView.height);
    
    NSArray *imageArr = @[@"square-unselected",
                          @"arrow-unselected",
                          @"marker-unselected",
                          @"red-unselected",
                          @"yellow-unselected",
                          @"blue-unselected",
                          @"green-unselected",
                          @"black-unselected",
                          @"white-unselected"];
    NSArray *selectImage = @[@"square-selected",
                             @"arrow-selected",
                             @"marker-selected",
                             @"red-selected",
                             @"yellow-selected",
                             @"blue-selected",
                             @"green-selected",
                             @"black-selected",
                             @"white-selected"];
    for (int i = 0; i < 9; i++) {
        UIButton *itemBtn = [UIButton new];
        itemBtn.tag = 100+i;
        itemBtn.backgroundColor = [RGB(167, 167, 167) colorWithAlphaComponent:0.4];
        [self.menuView addSubview:itemBtn];
        itemBtn.y = self.menuView.height/2-(itemWidth/2);
        itemBtn.size = CGSizeMake(itemWidth,itemWidth);
        itemBtn.x = 21 + (itemWidth+itemWidth)*i;
        if (i == 2) {
            itemBtn.selected = YES;
        }
        [itemBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:selectImage[i]] forState:UIControlStateSelected];
        [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 2) {
            lineView.height = itemWidth/2;
            lineView.y = CGRectGetMinY(itemBtn.frame)+lineView.height/2;
            lineView.width = 1;
            lineView.x = CGRectGetMaxX(itemBtn.frame) + itemWidth/2;
        }
        if (i == 3) {
            itemBtn.selected = YES;
        }
        
        [self.itemsArr addObject:itemBtn];
    }
}

- (void)itemBtnClick:(UIButton *)sender{
    sender.selected = YES;
    if (sender.tag > 102) {//画笔颜色
        for (int i = 103; i <= 108; i++) {
            UIButton *btn = self.itemsArr[i-100];
            if (![btn isEqual:sender]) {
                btn.selected = NO;
            }
        }
        switch (sender.tag) {
            case 103:
                self.strokeColor = RGB(252, 42, 71);
                break;
            case 104:
                self.strokeColor = RGB(254, 208, 43);
                break;
            case 105:
                self.strokeColor = RGB(19, 125, 250);
                break;
            case 106:
                self.strokeColor = RGB(73, 209, 94);
                break;
            case 107:
                self.strokeColor = RGB(33, 33, 33);
                break;
            case 108:
                self.strokeColor = [UIColor whiteColor];
                break;
            default:
                break;
        }
//        self.frameView.lineColor = self.strokeColor;
//        self.arrowsView.lineColor = self.strokeColor;
        self.drawView.lineColor = self.strokeColor;
    } else if (sender.tag == 100) {
        self.drawType = DrawToolTypeFrame;
        self.drawView.drawStyle = DrawStyleSquare;
        UIButton *btn_1 = self.itemsArr[1];
        btn_1.selected = NO;
        UIButton *btn_2 = self.itemsArr[2];
        btn_2.selected = NO;
//        self.frameView.lineColor = self.strokeColor;
//        [self.frameView allSubviewsSetHidden:NO];
//        self.arrowsView.hidden = YES;
        self.drawView.hidden = NO;
    } else if (sender.tag == 101) {
        self.drawType = DrawToolTypeArrows;
        self.drawView.drawStyle = DrawStyleArrow;
        UIButton *btn = self.itemsArr[0];
        btn.selected = NO;
        UIButton *btn_2 = self.itemsArr[2];
        btn_2.selected = NO;
//        [self.frameView allSubviewsSetHidden:YES];
        
        self.drawView.lineColor = self.strokeColor;
        self.drawView.hidden = NO;
//        self.arrowsView.lineColor = self.strokeColor;
//        self.arrowsView.hidden = NO;
    } else if (sender.tag == 102) {
        self.drawType = DrawToolTypeBrush;
        UIButton *btn = self.itemsArr[0];
        btn.selected = NO;
        UIButton *btn_1 = self.itemsArr[1];
        btn_1.selected = NO;
//        [self.frameView allSubviewsSetHidden:YES];
//        self.arrowsView.hidden = YES;
        if (self.drawView.pathsArray.count) {
            UIImage *tempImage = [self drawView:self.drawView WithBackgroundImage:_drawingView.image];
            _drawingView.image = [self drawView:_drawingView WithBackgroundImage:tempImage];
        }
        
        [self.drawView removeFromSuperview];//切换画笔时，移除并只为空drawView
        self.drawView = nil;
        [self.editor.scrollView.imageView addSubview:self.drawView];
        self.drawView.hidden = YES;
        self.drawView.frame = self.editor.scrollView.imageView.bounds;
    }
//    [self.arrowsView pointViewSetHidden:self.arrowsView.hidden];

    if (self.drawType == DrawToolTypeBrush) {
        self.eraserBtn.enabled = YES;
    } else {
        self.eraserBtn.enabled = NO;
    }
}

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        if (self.drawType == DrawToolTypeBrush) {
            [self drawLine:_prevDraggingPosition to:currentDraggingPosition];
        }
    }
    _prevDraggingPosition = currentDraggingPosition;
}

-(void)drawLine:(CGPoint)from to:(CGPoint)to
{
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_drawingView.image drawAtPoint:CGPointZero];
   
    CGFloat strokeWidth = MAX(1, self.silderValue);
    if (self.silderValue == 0) {
        self.silderValue = 5;
    }
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    //kCGLineCapSquare
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(self.isEraser){//橡皮擦
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);

    _drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (UIImage*)buildImageWithBackgroundImage:(UIImage*)backgroundImage{
    
    UIGraphicsBeginImageContextWithOptions(_originalImageSize, NO, backgroundImage.scale);
    if (self.drawView.pathsArray.count) {
        UIImage *tempImage = [self drawView:self.drawView WithBackgroundImage:backgroundImage];
        _drawingView.image = [self drawView:_drawingView WithBackgroundImage:tempImage];
    } else {
        _drawingView.image = [self drawView:_drawingView WithBackgroundImage:backgroundImage];
    }
    UIImage *foregroundImage = _drawingView.image;
    [backgroundImage drawAtPoint:CGPointZero];
    [foregroundImage drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [_drawingView removeFromSuperview];
    [self.drawView removeFromSuperview];
    [self.menuView removeFromSuperview];
    
    return tmp;
}

- (UIImage *)drawView:(UIView *)drawView WithBackgroundImage:(UIImage *)image{
    __block CALayer *layer = nil;
    __block CGFloat scale = 1;
    
//    [self.frameView hiddenFourPointView];
//    [self.arrowsView pointViewSetHidden:YES];
    
    safe_dispatch_sync_main(^{
        scale = image.size.width / drawView.width;
        layer = drawView.layer;
    });
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (void)setSilderValue:(CGFloat)silderValue{
    _silderValue = silderValue;
    self.drawView.lineWidth = silderValue;
}

- (void)clearupSubviews{
    [_drawingView removeFromSuperview];
    [self.drawView removeFromSuperview];
    [self.menuView removeFromSuperview];
}

- (void)removeEraserView{
    [self.eraserBtn removeFromSuperview];
//    self.isEraser = nil;
}

@end
