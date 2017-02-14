//
//  DocumentMgr.m
//  KaoTiBi
//
//  Created by linkapp on 11/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocumentMgr.h"
#import "KTDefine.h"
#import "LBMD5.h"
#import "NSDate+customizedFormatter.h"
#import "DocmentDatabase.h"
#import "KTBUserManager.h"

#define kRelativeRootPath @"DocRecords"

@implementation DocumentMgr

+ (NSString *)documentAbsoluteStorageRootPath{
    NSString *rootPath = [kPathDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",[KTBUserManager userUniqueIdentifer],kRelativeRootPath]];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [fileMgr fileExistsAtPath:rootPath isDirectory:&isDirectory];
    
    if (!isExist || (isExist && !isDirectory)) {
        [fileMgr createDirectoryAtPath:rootPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    return rootPath;
}

// 相对于Documnt的相对存储路径
+ (NSString *)docuemntRelativeStorageRootPath{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[KTBUserManager userUniqueIdentifer],kRelativeRootPath];
    return path;
}

+ (NSString *)getDocumentPathWithDocment:(Document *)doc{
    NSString *path = [kPathDocument stringByAppendingPathComponent:doc.path];
    path = [path stringByAppendingPathComponent:doc.dateName];
    return path;
}

// 查询某天的记录
+ (NSMutableArray *)selectDocumentsWithDayStr:(NSString *)dayStr{
    return [[DocmentDatabase shareDocmentDatabase] selectDocumentsWithDay:dayStr];
}

// 按月分组查询数据库
+ (NSFetchedResultsController *)selectGroupWithMonth{
    // 分组查询
    return [[DocmentDatabase shareDocmentDatabase] selectGroupWithMonth];
}

+ (NSFetchedResultsController *)selectGroupWithDay{
    // 分组查询
    return [[DocmentDatabase shareDocmentDatabase] selectGroupWithDay];
}

// 更新NSString 类型 属性的 值 
+ (void)updateDocumentProperty:(NSString *)property oldValue:(NSString *)oldValue newValue:(NSString *)newValue{
    [[DocmentDatabase shareDocmentDatabase] updateDocumentProperty:property oldValue:oldValue newValue:newValue];
}
@end
