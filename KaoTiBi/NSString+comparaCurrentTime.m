//
//  NSString+comparaCurrentTime.m
//  LinkPortal
//
//  Created by Stoull Hut on 17/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "NSString+comparaCurrentTime.h"

@implementation NSString (comparaCurrentTime)

+ (NSString *) compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
//    return  result;
    return str;
}

+ (NSString *)getYear:(NSString *)str{
    if (str.length < 19) {
        return @"";
    }
    NSString *year = [str substringWithRange:NSMakeRange(0, 4)];
    return [NSString stringWithFormat:@"%@年",year];
}

+ (NSString *)getMonth:(NSString *)str{
    if (str.length < 19) {
        return @"";
    }
    NSString *year = [str substringWithRange:NSMakeRange(6, 2)];
    return [NSString stringWithFormat:@"%@月",year];
}

+ (NSString *)getDay:(NSString *)str{
    if (str.length < 19) {
        return @"";
    }
    NSString *year = [str substringWithRange:NSMakeRange(10, 2)];
    return [NSString stringWithFormat:@"%@日",year];
}

@end
