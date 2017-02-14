//
//  DocRecord.h
//  KaoTiBi
//
//  Created by linkapp on 03/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocRecord : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) NSMutableArray *childRecord;

@property (nonatomic, strong) NSMutableArray *documents; // Documents
@end                                        
