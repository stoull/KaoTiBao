//
//  DocmentDatabase.h
//  KaoTiBi
//
//  Created by linkapp on 15/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Document.h"

#import "CCSingleton.h"

@interface DocmentDatabase : NSObject
singleton_interface(DocmentDatabase)

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *docFetchResultController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//插入数据
- (void)insertCoreData:(NSArray *)dataArray;

// 分组查询
- (NSFetchedResultsController *)selectGroupWithMonth;

- (NSFetchedResultsController *)selectGroupWithDay;

- (NSFetchedResultsController *)selectGroupWithYear;

- (NSFetchedResultsController *)selectGroupWithFolderName;

// 查询某天的记录
- (NSMutableArray *)selectDocumentsWithDay:(NSString *)dayStr;
- (NSMutableArray *)selectDocumentsWithName:(NSString *)dayStr;

//删除
- (void)deleteDataWithDocument:(Document *)docment;
- (void)deleteDataWithDocumentProperty:(NSString *)property withValue:(NSString *)value;

//更新
- (void)updateDocumentDateNameIdentifer:(NSString *)identifer property:(NSString *)property newValue:(NSString *)newValue;
- (void)updateDocumentDateNameIdentifers:(NSArray *)docments property:(NSString *)property newValue:(NSString *)newValue;
@end
