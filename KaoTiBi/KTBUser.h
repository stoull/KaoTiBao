//
//  KTBUser.h
//  KaoTiBi
//
//  Created by Stoull Hut on 02/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSingleton.h"

@interface KTBUser : NSObject<NSCoding>
singleton_interface(KTBUser)

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *descripteStr;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *errmsg;
@property (nonatomic, copy) NSString *experience;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *lastLoggedLoc;
@property (nonatomic, copy) NSString *lastLoggedTime;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger loggedTimes;
@property (nonatomic, assign) u_long maxSpace;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *organization;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *portrait2;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *sms;
@property (nonatomic, copy) NSString *sns;
@property (nonatomic, assign) u_long usedSpace;
@property (nonatomic, assign) NSInteger usedTime;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger version;

- (instancetype)initWithUserInforDic:(NSDictionary *)infor;
@end
