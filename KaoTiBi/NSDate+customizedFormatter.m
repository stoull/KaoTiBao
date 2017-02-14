//
//  NSDate+customizedFormatter.m
//  KaoTiBi
//
//  Created by linkapp on 15/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "NSDate+customizedFormatter.h"

@implementation NSDate (customizedFormatter)
+ (NSString *)currentDateWithApplicationDefaultFormmater{
    // 生成时间
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentDate = [NSDate date];
    return [dateFormatter stringFromDate:currentDate];
}

+ (NSDictionary *)getDateElementFromApplicationDefaultFormmaterString:(NSString *)date{
    if (date != nil && date.length > 19) {
        int year = [[date substringWithRange:NSMakeRange(0, 4)] intValue];
        int month = [[date substringWithRange:NSMakeRange(6, 2)] intValue];
        int day = [[date substringWithRange:NSMakeRange(9, 2)] intValue];
        int hour = [[date substringWithRange:NSMakeRange(12, 2)] intValue];
        int minute = [[date substringWithRange:NSMakeRange(15, 2)] intValue];
        int second = [[date substringWithRange:NSMakeRange(18, 2)] intValue];
        return @{@"year" : [NSNumber numberWithInt:year],
                 @"month" : [NSNumber numberWithInt:month],
                 @"day" : [NSNumber numberWithInt:day],
                 @"hour" : [NSNumber numberWithInt:hour],
                 @"minute" : [NSNumber numberWithInt:minute],
                 @"second" : [NSNumber numberWithInt:second]};
    }else{
        return nil;
    }
}

@end
