//
//  ExportView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/20.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExportSuccessBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExportView : UIView

@property (nonatomic, copy) ExportSuccessBlock successBlock;

@property (nonatomic, copy) NSArray *images;

@end

NS_ASSUME_NONNULL_END
