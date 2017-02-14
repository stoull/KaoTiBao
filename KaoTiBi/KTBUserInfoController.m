//
//  KTBUserInfoController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 05/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBUserInfoController.h"
#import "GateControl.h"
#import "KTBUserInfoController.h"
#import "KTBUserManager.h"
#import "KTDefine.h"
#import "KTBBaseAPI.h"
#import "HUD.h"

@interface KTBUserInfoController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation KTBUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的信息";
    self.logoutButton.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutAction:(id)sender {
    KTBUser *currentUser = [KTBUserManager currentUser];
    // 这个为试用版本
    if (currentUser.userId == -1) {
        [KTBUserInfoController logOutSettings];
    }else{
        [[HUD shareHUD] showActivityWithText:@"正注销..."];
        [KTBBaseAPI logoutWithUserId:currentUser.userId successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg) {
            if (kTBAPIResponseStatusSuccessful == status) {
                [self.navigationController popViewControllerAnimated:YES];
                [[HUD shareHUD] hintMessage:@"注销成功！"];
                [KTBUserInfoController logOutSettings];
            }else{
                [[HUD shareHUD] hintMessage:emsg];
            }
        } failure:^(NSString * _Nonnull errorMessage) {
            [[HUD shareHUD] hintMessage:errorMessage];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (void)loggingOffUser{
    KTBUser *currentUser = [KTBUserManager currentUser];
    // 这个为试用版本
    if (currentUser.userId == -1) {
        [self logOutSettings];
    }else{
        [KTBBaseAPI logoutWithUserId:currentUser.userId successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg) {
            if (kTBAPIResponseStatusSuccessful == status) {
                [self logOutSettings];
            }else{
            }
        } failure:^(NSString * _Nonnull errorMessage) {
        }];
    }
}

+ (void)logOutSettings{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:false forKey:kisLocalAuthorization];
    [userDef synchronize];
    [KTBUserManager removeCurrentUserInfo];
    [KTBUserManager removeOnTrial];
    [GateControl switchControllerWithlogOut];
}

@end
