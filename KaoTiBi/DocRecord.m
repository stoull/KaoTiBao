//
//  DocRecord.m
//  KaoTiBi
//
//  Created by linkapp on 03/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocRecord.h"


@implementation DocRecord
-(NSMutableArray *)documents{
    if (!_documents) {
        _documents = [NSMutableArray array];
    }
    return _documents;
}
@end
