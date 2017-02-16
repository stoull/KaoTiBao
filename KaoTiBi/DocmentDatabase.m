//
//  DocmentDatabase.m
//  KaoTiBi
//
//  Created by linkapp on 15/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocmentDatabase.h"
#import "DocumentManagerObject+CoreDataClass.h"
#import "KTBUserManager.h"

#define DocumentsTable @"Document"

@implementation DocmentDatabase
singleton_implementation(DocmentDatabase)
//@synthesize managedObjectContext = self.managedObjectContext;
//@synthesize managedObjectModel = self.managedObjectModel;
//@synthesize persistentStoreCoordinator = self.persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
 //   if (_managedObjectContext != nil) {
 //       return _managedObjectContext;
//    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KTDocumentModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
//    if (_persistentStoreCoordinator != nil) {
//       if ([KTBUserManager isNeedUpdateUser]) {
            
//        }else{
//            return _persistentStoreCoordinator;
//        }
//    }
    
    NSURL *storeURL;
    NSString *uniqueIdentifier = [NSString stringWithFormat:@"%@/KTDocumentModel.sqlite",[KTBUserManager userUniqueIdentifer]];
    storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:uniqueIdentifier];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = false;
    BOOL isExist = [fileManager fileExistsAtPath:storeURL.path isDirectory:&isDirectory];
    if (!isDirectory) {
        [fileManager createDirectoryAtPath:[[self applicationDocumentsDirectory] URLByAppendingPathComponent:[KTBUserManager userUniqueIdentifer]].path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (void)insertCoreData:(NSArray *)dataArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    for (Document *docu in dataArray) {
        DocumentManagerObject *newsDocu = [NSEntityDescription insertNewObjectForEntityForName:DocumentsTable inManagedObjectContext:context];
        newsDocu.date = docu.date;
        newsDocu.dateName = docu.dateName;
        newsDocu.folderName = docu.folderName;
        newsDocu.identifierYear = docu.identifierYear;
        newsDocu.identifierDay = docu.identifierDay;
        newsDocu.identifierMonth = docu.identifierMonth;
        newsDocu.year = docu.year;
        newsDocu.month = docu.month;
        newsDocu.day = docu.day;
        newsDocu.name = docu.name;
        newsDocu.describleString = docu.describleString;
        newsDocu.classfiy = docu.classfiy;
        newsDocu.fileSize = docu.fileSize;
        newsDocu.path = docu.path;
        newsDocu.assetURLString = docu.assetURLString;
        newsDocu.isDelete = docu.isDelete;
        newsDocu.isSync = docu.isSync;
        newsDocu.viewcount = docu.viewcount;

        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}


- (NSFetchedResultsController *)selectGroupWithMonth{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSSortDescriptor *monthDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifierMonth" ascending:NO];
    [fetchRequest setSortDescriptors:@[monthDescriptor, sortDescriptorDate]];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",self.isRoomrun?@"(type = 0 || type = 1)":@"type = 2"]];
    
    _docFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:context
                                                                                                 sectionNameKeyPath:@"identifierMonth"
                                                                                                          cacheName:@"docInforCacheMonth"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
    }
    
    NSError *error;
    [_docFetchResultController  performFetch:&error];
    if (error == nil) {
        return _docFetchResultController ;
    }else{
        return nil;
    }
}


- (NSFetchedResultsController *)selectGroupWithDay{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSSortDescriptor *monthDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifierDay" ascending:NO];
    [fetchRequest setSortDescriptors:@[monthDescriptor, sortDescriptorDate]];
    //    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",self.isRoomrun?@"(type = 0 || type = 1)":@"type = 2"]];
    
    _docFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:@"identifierDay"
                                                                               cacheName:@"docInforCacheDay"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
    }
    
    NSError *error;
    [_docFetchResultController  performFetch:&error];
    if (error == nil) {
        return _docFetchResultController ;
    }else{
        return nil;
    }
}

- (NSFetchedResultsController *)selectGroupWithYear{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSSortDescriptor *monthDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifierYear" ascending:NO];
    [fetchRequest setSortDescriptors:@[monthDescriptor, sortDescriptorDate]];
    //    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",self.isRoomrun?@"(type = 0 || type = 1)":@"type = 2"]];
    
    _docFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:@"identifierYear"
                                                                               cacheName:@"docInforCacheYear"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
    }
    
    NSError *error;
    [_docFetchResultController  performFetch:&error];
    if (error == nil) {
        return _docFetchResultController ;
    }else{
        return nil;
    }
}

- (NSFetchedResultsController *)selectGroupWithFolderName{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSSortDescriptor *monthDescriptor = [[NSSortDescriptor alloc] initWithKey:@"folderName" ascending:NO];
    [fetchRequest setSortDescriptors:@[monthDescriptor, sortDescriptorDate]];
    //    fetchRequest.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",self.isRoomrun?@"(type = 0 || type = 1)":@"type = 2"]];
    
    _docFetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:@"folderName"
                                                                               cacheName:@"docInforCachefoldername"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
    }
    
    NSError *error;
    [_docFetchResultController  performFetch:&error];
    if (error == nil) {
        return _docFetchResultController ;
    }else{
        return nil;
    }
}
- (NSMutableArray *)selectDocumentsWithName:(NSString *)dayStr{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptorDate, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"name CONTAINS[cd] %@",dayStr];
    fetchRequest.predicate = predicate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
        return resultArray;
    }
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    int i = 0;
    for (Document *docu in fetchedObjects) {
        Document *notObDocument = [Document copyWithManagedObject:docu];
        [resultArray addObject:notObDocument];
    }
    return resultArray;
}

- (NSMutableArray *)selectDocumentsWithDay:(NSString *)dayStr{
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc]
                                            initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptorDate, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"identifierDay like[cd] %@",dayStr];
    fetchRequest.predicate = predicate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    if (entity == nil) {
        NSString *hintStr = [NSString stringWithFormat:@"没有 %@ 这个实体类",DocumentsTable];
        LBLog(@"%@",hintStr);
        return resultArray;
    }
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    int i = 0;
    for (Document *docu in fetchedObjects) {
        Document *notObDocument = [Document copyWithManagedObject:docu];
        [resultArray addObject:notObDocument];
    }
    return resultArray;
}

//删除
- (void)deleteDataWithDocument:(Document *)docment
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(date like[cd] %@) AND (path like[cd] %@)",
                              docment.date, docment.path];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        int i = 0;
        for (NSManagedObject *obj in datas)
        {
            i++;
            [context deleteObject:obj];
            LBLog(@" Delete Document form DB i : %d",i);
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

// 按文档属性删除
- (void)deleteDataWithDocumentProperty:(NSString *)property withValue:(NSString *)value{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"%@ like[cd] %@",
                              property,value];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        int i = 0;
        for (NSManagedObject *obj in datas)
        {
            i++;
            [context deleteObject:obj];
            LBLog(@" Delete Document form DB i : %d",i);
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

//更新
- (void)updateDocumentProperty:(NSString *)property oldValue:(NSString *)oldValue newValue:(NSString *)newValue
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"%@ like[cd] %@",property, oldValue];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:DocumentsTable inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Document *doc in result) {
        [doc setValue:newValue forKey:property];
    }
    
#pragma mark - 今天就到这里......
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

@end
