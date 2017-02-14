//
//  HUD.h
//
//  Created by AChang on 5/30/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "CCSingleton.h"


@interface HUD : MBProgressHUD
singleton_interface(HUD)

@property (nonatomic, assign) float progress;

// 弹出一个文字提示框，时长为2s
-(void)hintMessage:(NSString *_Nullable)message;

// 弹出一个进行提示框，可以加文字，时长为2s
- (void)showActivityWithText:(NSString *_Nullable)text;

// 进度提示
- (void)showProgressWithText:(NSString *_Nullable)text;

- (void)showProgressWithText:(NSString *_Nullable)text withTask:(NSURLSessionDownloadTask * _Nullable)task;

- (void)showActivityWithText:(NSString *_Nullable)text withTask:(NSURLSessionDownloadTask * _Nullable)task;

- (void)hidden;
@end
