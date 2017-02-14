//
//  DocumentManagerObject+CoreDataProperties.m
//  
//
//  Created by Stoull Hut on 15/01/2017.
//
//  This file was automatically generated and should not be edited.
//

#import "DocumentManagerObject+CoreDataProperties.h"

@implementation DocumentManagerObject (CoreDataProperties)

+ (NSFetchRequest<DocumentManagerObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Document"];
}

@dynamic classfiy;
@dynamic date;
@dynamic day;
@dynamic describleString;
@dynamic fileSize;
@dynamic isDelete;
@dynamic isSync;
@dynamic month;
@dynamic name;
@dynamic path;
@dynamic viewcount;
@dynamic year;
@dynamic dateName;

@end
