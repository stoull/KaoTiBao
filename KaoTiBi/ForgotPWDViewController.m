//
//  ForgotPWDViewController.m
//  KaoTiBi
//
//  Created by linkapp on 07/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "ForgotPWDViewController.h"
#import "ResetPWDController.h"
#import "NSString+blankSpace.h"
#import "HUD.h"
#import "KTBBaseAPI.h"
#import "HolomorphyValidate.h"
#import "LBAlert.h"

@interface ForgotPWDViewController (){
    NSInteger kCountdownTime;
    int getResponseCount;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;
@property (nonatomic, strong)NSTimer *verificationTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allToTopConstraint;
@property (nonatomic, assign) CGFloat originToTopConstraint;

@property (nonatomic, strong)ResetPWDController *resetPWDController;

@end

@implementation ForgotPWDViewController
-(ResetPWDController *)resetPWDController{
    if (!_resetPWDController) {
        _resetPWDController = [[ResetPWDController alloc] initWithNibName:@"ResetPWDController" bundle:nil];
    }
    return _resetPWDController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.nextButton.layer.cornerRadius = 10;
    getResponseCount = 0;
    
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
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.originToTopConstraint = 90;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    CGRect actualRect = [self.view convertRect:self.verificationTextField.frame toView:nil];
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

#pragma mark 重置密码
- (IBAction)nextResetPasswordAction:(id)sender {
    NSString *userName = [NSString removeBlankSpace:self.usernameTextField.text];
    if (userName.length == 0) {
        [[HUD shareHUD] hintMessage:@"用户名不能为空哦！"];
        return;
    }
    
    NSString *loginType;
    if ([HolomorphyValidate validatePhoneNumberWithText:userName]) {
        loginType = @"3";
        [LBAlert showAlertWithTitle:@"暂不支持手机重置密码" message:@"暂只支持邮箱找回密码，请输入注册的邮箱进行重置" completionBlock:^(NSUInteger actionIndex, UIAlertAction *alertAction) {
        } cancelActionTitle:@"知道了" otherActionTitles:nil];
        return;
    }else if ([HolomorphyValidate validateEmailWithText:userName]){
        loginType = @"2";
    }else{
        loginType = @"1";
        [LBAlert showAlertWithTitle:@"暂不支持用户名重置密码" message:@"暂只支持邮箱找回密码，请输入注册的邮箱进行重置" completionBlock:^(NSUInteger actionIndex, UIAlertAction *alertAction) {
        } cancelActionTitle:@"知道了" otherActionTitles:nil];
        return;
    }
    
    [[HUD shareHUD] showActivityWithText:@"正验证信息..."];
    [KTBBaseAPI getForgetPassInfoWithUserName:userName successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
        if (kTBAPIResponseStatusSuccessful == status) {
            [[HUD shareHUD] hidden];
            NSString *rsetCodeKey = resDic[@"resetCodeKey"];
            
            self.resetPWDController.resetCodeKey = rsetCodeKey;
            self.resetPWDController.logInName = userName;
            self.resetPWDController.loginType = loginType;
            getResponseCount++;
            if (getResponseCount == 2) {
                getResponseCount = 0;
                [self.navigationController pushViewController:self.resetPWDController animated:YES];
            }else{
                getResponseCount++;
            }
        }else{
            [[HUD shareHUD] hintMessage:emsg];
            getResponseCount = 0;
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [[HUD shareHUD] hintMessage:errorMessage];
        getResponseCount = 0;
    }];
    
    
    [KTBBaseAPI getVcodeWithUserName:userName successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
        NSString *vcodeKey = resDic[@"vcodeKey"];
        NSString *vcode = resDic[@"vcode"];
        if (vcodeKey == nil) {
            vcodeKey = @"";
        }
        if (vcode == nil) {
            vcode = @"";
        }
        self.resetPWDController.vcodeKey = vcodeKey;
        self.resetPWDController.vcode = vcode;
        if (getResponseCount == 2) {
            getResponseCount = 0;
            [self.navigationController pushViewController:self.resetPWDController animated:YES];
        }else{
            getResponseCount++;
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        getResponseCount = 0;
    }];

}


// 获取验证码
- (IBAction)getVerificationCodeClick:(id)sender {
    NSString *phoneNumber = [NSString removeBlankSpace:self.phoneNumberTextField.text];
    self.phoneNumberTextField.text = phoneNumber;
    BOOL isPhoneNumberValidate = [HolomorphyValidate validatePhoneNumberWithText:phoneNumber];
    if (!isPhoneNumberValidate) {
        [[HUD shareHUD] hintMessage:@"手机号码不正确！"];
        return;
    }
    
    self.verificationCodeButton.enabled = NO;
    
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(upDateCountdown:) userInfo:nil
                                                             repeats:YES];
    
    //    [LYLoginManager loginGetCapthca:self.phoneNumberTextField.text success:^(BOOL isSuccessful, NSString * _Nullable message) {
    //        if (isSuccessful) {
    //            [[HUD shareHUD] hintMessage:@"验证码已发送！"];
    kCountdownTime = 60;
    [self.verificationTimer fire];
    [self.verificationCodeButton setTitle:@"重新获取（59）" forState:UIControlStateNormal];
    self.verificationCodeButton.enabled = NO;
    //        }else{
    //            [[LPPopup shareLPPopup] hintLabel:message];
    //            [self.verificationTimer invalidate];
    //            self.verificationTimer = nil;
    //            self.verificationCodeButton.enabled = YES;
    //        }
    //    } failure:^(NSString * _Nonnull errorMessage) {
    //        [self.verificationTimer invalidate];
    //        self.verificationTimer = nil;
    //        self.verificationCodeButton.enabled = YES;
    //        //        [[LPPopup shareLPPopup] hintLabel:errorMessage];
    //        [[LPPopup shareLPPopup] hintLabel:@"获取验证码失败"];
    //    }];
}

// 重新获取验证码倒计时
- (void)upDateCountdown:(NSTimer *)timer{
    if (kCountdownTime-- < 1) {
        self.verificationCodeButton.enabled = YES;
        [self.verificationCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.verificationTimer invalidate];
        self.verificationTimer = nil;
    }else{
        NSString *timeStr = [NSString stringWithFormat:@"重新获取（%ld）",kCountdownTime];
        [self.verificationCodeButton setTitle:timeStr forState:UIControlStateNormal];
        self.verificationCodeButton.titleLabel.text = timeStr;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
