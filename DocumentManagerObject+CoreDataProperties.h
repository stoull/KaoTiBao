//
//  DocumentManagerObject+CoreDataProperties.h
//  
//
//  Created by Stoull Hut on 15/01/2017.
//
//  This file was automatically generated and should not be edited.
//

#import "DocumentManagerObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DocumentManagerObject (CoreDataProperties)

+ (NSFetchRequest<DocumentManagerObject *> *)fetchRequest;

@property (nonatomic) int16_t classfiy;
@property (nullable, nonatomic, copy) NSString *date;
@property (nonatomic) int16_t day;
@property (nullable, nonatomic, copy) NSString *describleString;
@property (nonatomic) int64_t fileSize;
@property (nonatomic) BOOL isDelete;
@property (nonatomic) BOOL isSync;
@property (nonatomic) int16_t month;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *path;
@property (nonatomic) int32_t viewcount;
@property (nonatomic) int16_t year;
@property (nullable, nonatomic, copy) NSString *dateName;

@end

NS_ASSUME_NONNULL_END
