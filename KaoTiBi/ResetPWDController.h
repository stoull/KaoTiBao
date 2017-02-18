//
//  ResetPWDController.h
//  KaoTiBi
//
//  Created by linkapp on 07/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPWDController : UIViewController


// 修改密码 为 yes 。 重置密码 为 no
@property (nonatomic, assign) BOOL isChangPassword;

@property (nonatomic, copy) NSString *resetCodeKey;
@property (nonatomic, copy) NSString *logInName;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *vcodeKey;
@property (nonatomic, copy) NSString *vcode;
@end
