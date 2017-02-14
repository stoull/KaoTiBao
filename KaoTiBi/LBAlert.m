//
//  LBAlert.m
//  LinkPortal
//
//  Created by Stoull Hut on 9/3/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBAlert.h"

@implementation LBAlert

+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
         completionBlock:(void (^)(NSUInteger actionIndex, UIAlertAction *alertAction))block cancelActionTitle:(NSString *)cancelActionTitle
       otherActionTitles:(NSArray *)othersActionTitles{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSInteger index = 0;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(index,action);
        }
    }];
    [alertController addAction:cancelAction];
    
    index++;
    for (NSString *title in othersActionTitles){
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(index,action);
                });
            }
        }];
        [alertController addAction:action];
        index ++;
    }
    
    [[LBAlert currentViewController] presentViewController:alertController animated:YES completion:nil];

    return alertController;
}

+ (UIViewController *)currentViewControllerKey{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    return keyWindow.rootViewController;
}

+(UIViewController*)currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [LBAlert findBestViewController:viewController];
}

+(UIViewController*)findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        // Return presented view controller
        return [LBAlert findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [LBAlert findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [LBAlert findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [LBAlert findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end
