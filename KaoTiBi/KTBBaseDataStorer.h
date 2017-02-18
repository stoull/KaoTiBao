//
//  KTBBaseDataStorer.h
//  KaoTiBi
//
//  Created by Stoull Hut on 26/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTBUser.h"
@interface KTBBaseDataStorer : NSObject
+ (NSDictionary *)colorPenInfor;
+ (void)saveColorPenInfo:(NSDictionary *)colorDic;
@end
