//
//  CIFilterTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/1/24.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIFilterTool : NSObject


SASingletonH(CIFilterTool);

- (UIImage *)fliterEvent:(NSString *)filterName originImage:(UIImage *)originImage;

- (UIImage *)adjustmentWithValueDic:(NSDictionary *)valueDic originImage:(UIImage *)originImage;

- (UIImage *)balanceWithValueBalanceDic:(NSDictionary *)balanceDic originImage:(UIImage *)originImage;


@end

NS_ASSUME_NONNULL_END
