//
//  NSObject+FileTool.h
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/3/4.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FileTool)

+ (NSInteger)getFileCountWithPath:(NSString *)filePath;


+ (NSString *)creatFolderInCacheWithFolerName:(NSString *)folderName;

@end

NS_ASSUME_NONNULL_END
