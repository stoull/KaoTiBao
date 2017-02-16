//
//  ScreenShot.m
//  KaoTiBi
//
//  Created by linkapp on 16/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "ScreenShot.h"
#import <QuartzCore/QuartzCore.h> 

@implementation ScreenShot
+ (UIImage *)screenShot{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(window.bounds.size);
    }
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *screenImage;
    if (imageData) {
        screenImage = [UIImage imageWithData:imageData];
    } else {
        NSLog(@"error while taking screenshot");
    }
    return screenImage;
}
@end
