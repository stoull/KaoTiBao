//
//  UserColorPenTime.h
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserColorPenInfo : NSObject
@property (nonatomic, assign) u_int64_t redTime;
@property (nonatomic, assign) u_int64_t orangeTime ;
@property (nonatomic, assign) u_int64_t yellowTime;
@property (nonatomic, assign) u_int64_t cyanTime;
@property (nonatomic, assign) u_int64_t greenTime;
@property (nonatomic, assign) u_int64_t blueTime;
@property (nonatomic, assign) u_int64_t blackTime;
@property (nonatomic, assign) u_int64_t darkTime;
@property (nonatomic, assign) u_int64_t grayTime;
@property (nonatomic, assign) u_int64_t pinkTime;
@property (nonatomic, copy) NSString *defautlColor;
@property (nonatomic, assign) u_int64_t defaultTime;
-(instancetype)initWithDic:(NSDictionary *)resDic;
@end
