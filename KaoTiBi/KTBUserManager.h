//
//  KTBUserManager.h
//  KaoTiBi
//
//  Created by linkapp on 04/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSingleton.h"
#import "KTBUser.h"

@interface KTBUserManager : NSObject
singleton_interface(KTBUserManager)

+ (void)useAppOnTrial;
+ (void)removeOnTrial;
+ (BOOL)isOnTrial;

+ (void)storageUserToLocal:(KTBUser*)user;
+ (KTBUser *)currentUser;
+ (void)removeCurrentUserInfo;

// 获取用户的唯一标识符
+ (NSString *)userUniqueIdentifer;

// 是否需要更新数据，主要是单例中的Get方法中使用
+ (void)setIsNeedUpdateUser:(BOOL)isNeedUpdate;
+ (NSString *)isNeedUpdateUser;
@end
