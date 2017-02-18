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
#define kDirectoryFileName @"directoryFileInfor"

@implementation DocumentMgr
singleton_implementation(DocumentMgr)

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

+ (NSMutableArray *)selectDocumentsWithName:(NSString *)name{
    // 分组查询
    return [[DocmentDatabase shareDocmentDatabase] selectDocumentsWithName:name];
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

+ (NSFetchedResultsController *)selectGroupWithYear{
    // 分组查询
    return [[DocmentDatabase shareDocmentDatabase] selectGroupWithYear];
}

+ (NSFetchedResultsController *)selectGroupWithFolderName{
    return [[DocmentDatabase shareDocmentDatabase] selectGroupWithFolderName];
}

+ (void)deleteDocument:(Document *)docment{
    if (docment == nil) {
        return;
    }
    [[DocmentDatabase shareDocmentDatabase] deleteDataWithDocument:docment];
}

+ (void)deleteDocumentByDocumentProperty:(NSString *)property withValue:(NSString *)value{
    if (property == nil || value == nil) {
        return;
    }
    [[DocmentDatabase shareDocmentDatabase] deleteDataWithDocumentProperty:property withValue:value];
}

// 更新NSString 类型 属性的 值 
+ (void)updateDocumentDateNameIdentifer:(NSString *)identifer property:(NSString *)property newValue:(NSString *)newValue{
    [[DocmentDatabase shareDocmentDatabase] updateDocumentDateNameIdentifer:identifer property:property newValue:newValue];
}

// 更新NSString 类型 属性的 值
+ (void)updateDocumentDateNameIdentifers:(NSArray *)docus property:(NSString *)property newValue:(NSString *)newValue{
    [[DocmentDatabase shareDocmentDatabase] updateDocumentDateNameIdentifers:docus property:property newValue:newValue];
}

+ (NSArray *)directoryInfor{
    NSString *rootPath = [kPathDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",[KTBUserManager userUniqueIdentifer],kRelativeRootPath]];
    NSString *directFilePath = [rootPath stringByAppendingPathComponent:kDirectoryFileName];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:directFilePath]) {
        [DocumentMgr saveDirectoryInfor:@[@"我的文档"]];
    }
    NSArray *directoryArray = [NSArray arrayWithContentsOfFile:directFilePath];
    if (directoryArray == nil || directoryArray.count == 0) {
        directoryArray = @[@"我的文档"];
        [DocumentMgr saveDirectoryInfor:directoryArray];
    }
    return directoryArray;
}

+ (void)saveDirectoryInfor:(NSArray *)directors{
    NSString *rootPath = [kPathDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",[KTBUserManager userUniqueIdentifer],kRelativeRootPath]];
    NSString *directFilePath = [rootPath stringByAppendingPathComponent:kDirectoryFileName];
    BOOL isSuccessfu = [directors writeToFile:directFilePath atomically:YES];
    if (isSuccessfu) {
        LBLog(@"目录信息写入成功");
    }else{
        LBLog(@"目录信息写入失败");
    }
}
@end
