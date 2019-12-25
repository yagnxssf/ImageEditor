//
//  CLRatio.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2018/12/29.
//  Copyright © 2018 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLRatio : NSObject

@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, readonly) CGFloat ratio;
@property (nonatomic, strong) NSString *titleFormat;

- (id)initWithValue1:(CGFloat)value1 value2:(CGFloat)value2;

@end

NS_ASSUME_NONNULL_END
