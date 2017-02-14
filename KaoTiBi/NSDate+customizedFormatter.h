//
//  NSDate+customizedFormatter.h
//  KaoTiBi
//
//  Created by linkapp on 15/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (customizedFormatter)
+ (NSString *)currentDateWithApplicationDefaultFormmater;
+ (NSDictionary *)getDateElementFromApplicationDefaultFormmaterString:(NSString *)date;
@end
