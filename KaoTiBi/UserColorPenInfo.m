//
//  UserColorPenInfo.m
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "UserColorPenInfo.h"

@implementation UserColorPenInfo
-(instancetype)initWithDic:(NSDictionary *)resDic{
    if (self = [super init]) {
        NSArray *allKey = [resDic allKeys];
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
        NSString *redInfo = resDic[@"red"];
        NSString *orangeInfo = resDic[@"orange"];
        NSString *yellowInfo = resDic[@"yellow"];
        NSString *cyanInfo = resDic[@"cyan"];
        NSString *greenInfo = resDic[@"green"];
        NSString *blueInfo = resDic[@"blue"];
        NSString *blackInfo = resDic[@"black"];
        NSString *darkInfo = resDic[@"dark"];
        NSString *grayInfo = resDic[@"gray"];
        NSString *pinkInfo = resDic[@"pink"];
        NSString *defaultInfo = resDic[@"defaultColor"];
        
        /*
         left = lastLeft - ( nowTime - lastActivationTime)
         
         lastLeft 剩余的可用时间， 以秒为单位
         nowTime 当前系统时间， 以秒为单位
         lastActivationTime 上次操作时间， 以秒为单位
         */
        if (redInfo != nil && redInfo.length > 5) {
            NSArray *timeArray = [redInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _redTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _redTime = 0;
        }
        
        if (orangeInfo != nil && orangeInfo.length > 5) {
            NSArray *timeArray = [orangeInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _orangeTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _orangeTime = 0;
        }
        
        if (yellowInfo != nil && yellowInfo.length > 5) {
            NSArray *timeArray = [yellowInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _yellowTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _yellowTime = 0;
        }
        
        if (cyanInfo != nil && cyanInfo.length > 0) {
            NSArray *timeArray = [cyanInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _cyanTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _cyanTime = 0;
        }
        
        if (greenInfo != nil && greenInfo.length > 0) {
            NSArray *timeArray = [greenInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _greenTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _greenTime = 0;
        }
        
        if (blueInfo != nil && blueInfo.length > 0) {
            NSArray *timeArray = [blueInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _blueTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _blueTime = 0;
        }
        
        
        if (blackInfo != nil && blackInfo.length > 0) {
            NSArray *timeArray = [blackInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _blackTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _blackTime = 0;
        }
        
        
        if (darkInfo != nil && darkInfo.length > 0) {
            NSArray *timeArray = [darkInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _darkTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _darkTime = 0;
        }
        
        
        if (grayInfo != nil && grayInfo.length > 0) {
            NSArray *timeArray = [grayInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _grayTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _grayTime = 0;
        }
        
        
        if (pinkInfo != nil && pinkInfo.length > 0) {
            NSArray *timeArray = [pinkInfo componentsSeparatedByString:@";"];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _pinkTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _pinkTime = 0;
        }
        
        if (defaultInfo != nil && defaultInfo.length > 0) {
            NSArray *timeArray = [defaultInfo componentsSeparatedByString:@";"];
            _defautlColor = [timeArray firstObject];
            NSString *lastLeftStr = timeArray[1];
            NSString *lastActtStr = timeArray[2];
            u_int64_t nowTime = [NSDate timeIntervalSinceReferenceDate];
            u_int64_t lasLeft = [lastLeftStr longLongValue];
            u_int64_t lastActivationTime = [lastActtStr longLongValue];
            _defaultTime = lasLeft - ( nowTime - lastActivationTime);
        }else{
            _defaultTime = 0;
        }
    }
    return self;
}
@end
