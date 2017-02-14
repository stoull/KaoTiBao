//
//  AppDelegate.m
//  KaoTiBi
//
//  Created by Stoull Hut on 01/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "KTDefine.h"
#import "GateControl.h"
#import "KTBUserManager.h"
#import "KTBUserInfoController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [KTBUserManager removeOnTrial];
    // 测试用
//    [userDef setBool:false forKey:kisLocalAuthorization];
    
    
    // 初始化用户选择的年级
    if ([userDef objectForKey:kKTBSelectClassSortType] == nil) {
        [userDef setInteger:ClassSortTypeChuYi forKey:kKTBSelectClassSortType];
    }
    
    [userDef synchronize];
    
    [GateControl switchControllerWithWindow:self.window];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [KTBUserInfoController loggingOffUser];
}


@end
