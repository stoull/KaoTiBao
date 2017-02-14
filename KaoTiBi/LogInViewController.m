//
//  LogInViewController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "LogInViewController.h"
#import "GateControl.h"
#import "HUD.h"
#import "SignInViewController.h"
#import "ForgotPWDViewController.h"
#import "HolomorphyValidate.h"
#import "NSString+blankSpace.h"
#import "KTDefine.h"
#import "KTBBaseAPI.h"
#import "UIDevice+deviceModel.h"
#import "LBMD5.h"
#import "KTBUserManager.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allToTopConstraint;
@property (nonatomic, assign) CGFloat originToTopConstraint;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginButton.layer.cornerRadius = 10.0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [KTBUserManager setIsNeedUpdateUser:true];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.originToTopConstraint = self.allToTopConstraint.constant;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  登录
- (IBAction)loginAction:(id)sender {
    if ([self isValidedToLogin]) {
        NSString *loginType = @"";
        NSString *userName = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
//        NSString *password = [LBMD5 getmd5WithString:self.passwordTextField.text];
        NSString *phoneType = [UIDevice phoneAndOperartionSysInfor];
        
        if ([HolomorphyValidate validatePhoneNumberWithText:userName]) {
            loginType = @"3";
        }else if ([HolomorphyValidate validateEmailWithText:userName]){
            loginType = @"2";
        }else{
            loginType = @"1";
        }
        
        NSDictionary *paraDic = @{@"loginname" : userName,
                                  @"password"  : password,
                                  @"loginType" : loginType,
                                  @"phoneType" : phoneType};
        [[HUD shareHUD] showActivityWithText:@"正登录..."];
        [KTBBaseAPI loginWithParameter:paraDic successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
            if (kTBAPIResponseStatusSuccessful == status) {
                [self.navigationController popViewControllerAnimated:YES];
                [[HUD shareHUD] hintMessage:@"登录成功！"];
                
                // 存储用户信息
                KTBUser *user = [[KTBUser alloc] initWithUserInforDic:resDic];
                [KTBUserManager storageUserToLocal:user];
                
                // 跳转
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                [userDef setBool:true forKey:kisLocalAuthorization];
                [userDef synchronize];
                [GateControl  switchControllerWithWindow:[UIApplication sharedApplication].keyWindow];
            }else{
                [[HUD shareHUD] hintMessage:emsg];
            }
        } failure:^(NSString * _Nonnull errorMessage) {
            [[HUD shareHUD] hintMessage:errorMessage];
        }];
    }
}

- (BOOL)isValidedToLogin{
    self.usernameTextField.text = [NSString removeBlankSpace:self.usernameTextField.text];
    self.passwordTextField.text = [NSString removeBlankSpace:self.passwordTextField.text];
    if (!(self.usernameTextField.text != nil && self.usernameTextField.text.length > 0)) {
        [[HUD shareHUD] hintMessage:@"请输入登录名！"];
        return NO;
    }
    if (!(self.passwordTextField.text != nil && self.passwordTextField.text.length > 0)) {
        [[HUD shareHUD] hintMessage:@"请输入密码！"];
        return NO;
    }
    
    return YES;
}

#pragma mark 注册
- (IBAction)signInAction:(id)sender {
    SignInViewController *signController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self.navigationController pushViewController:signController animated:YES];
}

#pragma mark 试用
- (IBAction)guestTryUseAction:(id)sender {
    [KTBUserManager useAppOnTrial];
    [GateControl  switchControllerWithWindow:[UIApplication sharedApplication].keyWindow];
}

#pragma mark 忘记密码
- (IBAction)forgotPasswordAction:(id)sender {
    
//    [KTBBaseAPI logoutWithUserId:24 successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg) {
//        if (kTBAPIResponseStatusSuccessful == status) {
//            [self.navigationController popViewControllerAnimated:YES];
//            [[HUD shareHUD] hintMessage:@"注销成功！"];
//            // 跳转
//            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//            [userDef setBool:false forKey:kisLocalAuthorization];
//            [userDef synchronize];
//            [GateControl switchControllerWithlogOut];
//        }else{
//            [[HUD shareHUD] hintMessage:emsg];
//        }
//    } failure:^(NSString * _Nonnull errorMessage) {
//        [[HUD shareHUD] hintMessage:errorMessage];
//    }];
    
    ForgotPWDViewController *forgotPWDController = [[ForgotPWDViewController alloc] initWithNibName:@"ForgotPWDViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPWDController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -键盘动作通知
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyboarHeight = keyboardRect.size.height;
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 转换输入框的坐标
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect actualRect = [self.view convertRect:self.passwordTextField.frame toView:nil];
    CGFloat actualMaxY = CGRectGetMaxY(actualRect);
    CGFloat keyboardOffset = actualMaxY - (screenSize.height - keyboarHeight);
    keyboardOffset = keyboardOffset + 10;
    if (keyboardOffset > 0){
//        [UIView animateWithDuration:animationDuration animations:^{
            self.allToTopConstraint.constant = self.allToTopConstraint.constant - keyboardOffset;
//        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    // 获取通知信息字典
    NSDictionary* userInfo = [aNotification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
//    [UIView animateWithDuration:animationDuration animations:^{
        self.allToTopConstraint.constant = self.originToTopConstraint;
//    }];
}
- (IBAction)nextInputAction:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
