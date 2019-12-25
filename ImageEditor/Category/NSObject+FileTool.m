//
//  NSObject+FileTool.m
//  ImageEditor
//
//  Created by cwsdteam03 on 2019/3/4.
//  Copyright © 2019 cwsdteam03. All rights reserved.
//

#import "NSObject+FileTool.h"

@implementation NSObject (FileTool)

+ (NSInteger)getFileCountWithPath:(NSString *)filePath{
    //文件总个数
    NSInteger fileCount = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //文件是否存在
    BOOL isExist;
    //是否是文件夹
    BOOL isFolder;
    isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isFolder];
    if (!isExist) {
        return 0;
    }
    if (isFolder) {
        //是文件夹
        NSEnumerator *childFileEnemerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
        NSString *fileName;
        while ((fileName = [childFileEnemerator nextObject]) != nil) {
            fileCount += 1;
        }
    } else {
        fileCount = 1;
    }
    return fileCount;
}

+ (NSString *)creatFolderInCacheWithFolerName:(NSString *)folderName{
    //    获取路径
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *folderPath = [paths stringByAppendingPathComponent:folderName];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:folderPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return folderPath;
}

@end
