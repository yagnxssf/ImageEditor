//
//  ImageEditorTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/27.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageEditorToolDelegate <NSObject>

//选中工具条
- (void)imageEditorToolDidSelect:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ImageEditorTool : UIView

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;

@property (nonatomic, assign) id <ImageEditorToolDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
