//
//  DocumentMgr.h
//  KaoTiBi
//
//  Created by linkapp on 11/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>
#import "Document.h"
#import "CCSingleton.h"

@interface DocumentMgr : NSObject
singleton_interface(DocumentMgr)

// 判断进入首页是否要刷新
@property (nonatomic, assign) BOOL isNeedUpdate;

// 按月分组查询数据库
+ (NSFetchedResultsController *)selectGroupWithYear;
+ (NSFetchedResultsController *)selectGroupWithMonth;
+ (NSFetchedResultsController *)selectGroupWithDay;
+ (NSFetchedResultsController *)selectGroupWithFolderName;

// 按文件名搜索
+ (NSMutableArray *)selectDocumentsWithName:(NSString *)name;
// 查询某天的记录
+ (NSMutableArray *)selectDocumentsWithDayStr:(NSString *)dayStr;


+ (void)deleteDocument:(Document *)docment;

// 按文档属性删除
+ (void)deleteDocumentByDocumentProperty:(NSString *)property withValue:(NSString *)value;

// 更新NSString 类型 属性的 值
+ (void)updateDocumentDateNameIdentifer:(NSString *)identifer property:(NSString *)property newValue:(NSString *)newValue;
// 更新NSString 类型 属性的 值
+ (void)updateDocumentDateNameIdentifers:(NSArray *)docus property:(NSString *)property newValue:(NSString *)newValue;

+ (NSString *)documentAbsoluteStorageRootPath;  // 完整的记录存储路径
+ (NSString *)docuemntRelativeStorageRootPath;  // 相对于Documnt的相对存储路径

+ (NSString *)getDocumentPathWithDocment:(Document *)doc;

// 文件目录信息
+ (NSArray *)directoryInfor;
+ (void)saveDirectoryInfor:(NSArray *)directors;

@end
