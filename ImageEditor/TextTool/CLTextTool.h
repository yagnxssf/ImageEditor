//
//  CLTextTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/2.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SingleImageEditorViewController;
//
//@protocol CLTextToolDelegate <NSObject>
//
//- (void)textToolDidChangeText:(NSString*)text;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface CLTextTool : NSObject

- (instancetype)initWithImageEditorVC:(SingleImageEditorViewController*)imageEditor;

@property (nonatomic,weak) SingleImageEditorViewController *editor;

//@property (nonatomic,assign) id <CLTextToolDelegate> delegate;

- (UIImage*)buildImage:(UIImage*)image;

- (void)textViewToolDidSelectIndexPath:(NSIndexPath *)indexPath;

- (void)clearupSubviews;

- (void)setTextFontAlphaWith:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
