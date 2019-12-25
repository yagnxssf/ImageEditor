//
//  ExportSuccessView.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/2/25.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShareBlock)(void);

typedef void (^BackToHomeBlock)(void);

@interface ExportSuccessView : UIView

@property (nonatomic, copy) ShareBlock shareBlock;

@property (nonatomic, copy) BackToHomeBlock backBlock;

@end

NS_ASSUME_NONNULL_END
