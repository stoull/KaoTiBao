//
//  KTBUserManager.m
//  KaoTiBi
//
//  Created by linkapp on 04/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBUserManager.h"
#import "LBMD5.h"
#import "KTDefine.h"

@implementation KTBUserManager
singleton_implementation(KTBUserManager)

+ (void)useAppOnTrial{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:true forKey:kisOnTrial];
    [userDef synchronize];
}

+ (void)removeOnTrial{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:false forKey:kisOnTrial];
    [userDef synchronize];
}

+ (BOOL)isOnTrial{
    BOOL isOnTrial = [[NSUserDefaults standardUserDefaults] boolForKey:kisOnTrial];
    return isOnTrial;
}

+ (void)storageUserToLocal:(KTBUser*)user{
    if (user == nil) {
        return;
    }
    if ([NSKeyedArchiver archiveRootObject:user toFile:kAccountStoragePath])
    {
        LBLog(@" Save UserInfor successful !");
    }else{
        LBLog(@" Save UserInfor failed !");
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:false forKey:kisOnTrial];
    [userDef synchronize];
}

+ (KTBUser *)currentUser{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kisOnTrial]) {
        KTBUser *onTrialUser = [[KTBUser alloc] init];
        onTrialUser.userId = -1;
        onTrialUser.name = @"OnTrialUser";
        return onTrialUser;
    }else{
        return [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountStoragePath];
    }
}

+ (void)removeCurrentUserInfo{
    [[NSFileManager defaultManager] removeItemAtPath:kAccountStoragePath error:nil];
}

// 获取用户的唯一标识符
+ (NSString *)userUniqueIdentifer{
    NSString *unqiueStr = @"";
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kisOnTrial]) {
        unqiueStr = @"OnTrialUser";
        return [LBMD5 getmd5WithString:unqiueStr];
    }else{
        KTBUser *currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountStoragePath];
        unqiueStr = [NSString stringWithFormat:@"%ld%@",currentUser.userId, currentUser.username];
        return [LBMD5 getmd5WithString:unqiueStr];
    }
}

// 是否需要更新数据，主要是单例中的Get方法中使用
+ (void)setIsNeedUpdateUser:(BOOL)isNeedUpdate{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:isNeedUpdate forKey:kIsNeedUpdateSingle];
}

+ (NSString *)isNeedUpdateUser{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:kIsNeedUpdateSingle];
}
@end
