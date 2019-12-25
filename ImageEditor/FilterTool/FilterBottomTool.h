//
//  FilterBottomTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/16.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterBottomToolDelegate <NSObject>

- (void)filterBottomToolClose;

- (void)filterBottomToolOK;

@end


NS_ASSUME_NONNULL_BEGIN

@interface FilterBottomTool : UIView

@property (nonatomic, assign) id <FilterBottomToolDelegate> delegate;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
