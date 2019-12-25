//
//  CLDrawTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SingleImageEditorViewController;

NS_ASSUME_NONNULL_BEGIN

@interface CLDrawTool : NSObject

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController*)imageEditor;

@property (nonatomic,weak) SingleImageEditorViewController *editor;

@property (nonatomic,assign) CGFloat silderValue;//粗细


- (UIImage*)buildImageWithBackgroundImage:(UIImage*)backgroundImage;

- (void)clearupSubviews;

- (void)removeEraserView;

@end

NS_ASSUME_NONNULL_END
