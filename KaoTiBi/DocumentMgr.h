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

@interface DocumentMgr : NSObject

// 按月分组查询数据库
+ (NSFetchedResultsController *)selectGroupWithMonth;
+ (NSFetchedResultsController *)selectGroupWithDay;
// 查询某天的记录
+ (NSMutableArray *)selectDocumentsWithDayStr:(NSString *)dayStr;

// 更新NSString 类型 属性的 值
+ (void)updateDocumentProperty:(NSString *)property oldValue:(NSString *)oldValue newValue:(NSString *)newValue;

+ (NSString *)documentAbsoluteStorageRootPath;  // 完整的记录存储路径
+ (NSString *)docuemntRelativeStorageRootPath;  // 相对于Documnt的相对存储路径

+ (NSString *)getDocumentPathWithDocment:(Document *)doc;
@end
