//
//  GateControl.m
//  KaoTiBi
//
//  Created by Stoull Hut on 06/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "GateControl.h"
#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "KTDefine.h"
#import "ShootingController.h"
#import "LogInViewController.h"
#import "KTBUserManager.h"

@implementation GateControl
+ (void)switchControllerWithWindow:(UIWindow *)window{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    if ([KTBUserManager isOnTrial]) {
        RootTabBarController *rootBar = [[RootTabBarController alloc] init];
        window.rootViewController = rootBar;
        [window makeKeyAndVisible];
        return;
    }
    
    if ([userDef boolForKey:kisLocalAuthorization]) {
        RootTabBarController *rootBar = [[RootTabBarController alloc] init];
        
        window.rootViewController = rootBar;
        [window makeKeyAndVisible];
    }else{
        LogInViewController *logController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        RootNavigationController *logNav = [[RootNavigationController alloc] initWithRootViewController:logController];
        window.rootViewController = logNav;
        [window makeKeyAndVisible];
    }
}

+ (void)switchControllerWithlogOut{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LogInViewController *logController = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
    RootNavigationController *logNav = [[RootNavigationController alloc] initWithRootViewController:logController];
    window.rootViewController = logNav;
    [window makeKeyAndVisible];
}
@end
