//
//  AdjustmentTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/5.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SingleImageEditorViewController;

NS_ASSUME_NONNULL_BEGIN

@interface AdjustmentTool : NSObject

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController*)imageEditor;

@property (nonatomic,weak) SingleImageEditorViewController *editor;

- (UIImage *)adjustmentResultImage;

- (void)clearupSubviews;

@end

NS_ASSUME_NONNULL_END
