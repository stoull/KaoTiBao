//
//  SignInViewController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "SignInViewController.h"
#import "HolomorphyValidate.h"
#import "NSString+blankSpace.h"
#import "KTBBaseAPI.h"
#import "HUD.h"

@interface SignInViewController (){
    NSInteger kCountdownTime;
}
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *nickNameRequiedImageView;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *PwdRequiedImageView;
@property (weak, nonatomic) IBOutlet UITextField *confirmPWDTextField;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPWDRequiedImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *emailRequeiedImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *verifRequiedImageView;

@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;
@property (nonatomic, strong)NSTimer *verificationTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allToTopConstraint;
@property (nonatomic, assign) CGFloat originToTopConstraint;
@end

@implementation SignInViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.signInButton.layer.cornerRadius = 10.0;
    self.title = @"注册";
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
    self.originToTopConstraint = self.allToTopConstraint.constant;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInAction:(id)sender {
    NSString *nickName = [NSString removeBlankSpace:self.nickNameTextField.text];
    NSString *realName = [NSString removeBlankSpace:self.realNameTextField.text];
    NSString *password = [NSString removeBlankSpace:self.passwordTextField.text];
    NSString *confirmPWD = [NSString removeBlankSpace:self.confirmPWDTextField.text];
    NSString *emailText = [NSString removeBlankSpace:self.emailTextField.text];
    NSString *phoneNumber = [NSString removeBlankSpace:self.phoneNumberTextField.text];
    NSString *vierification = [NSString removeBlankSpace:self.verificationTextField.text];
    
    if (nickName.length == 0) {
        [[HUD shareHUD] hintMessage:@"昵称不能为空哦！"];
        [self.nickNameRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }else if (nickName.length > 20){
        [[HUD shareHUD] hintMessage:@"昵称只能小于20个字符哦！"];
        [self.nickNameRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }
    
    if (realName.length == 0) {
        
    }else{
        
    }
    
    if (password.length == 0) {
        [[HUD shareHUD] hintMessage:@"密码不能为空哦！"];
        [self.PwdRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }else if ([HolomorphyValidate validatePasswordWithText:password]){
        [[HUD shareHUD] hintMessage:@"密码为6-20个字符，必须包含字母大小以及数字哦！"];
        [self.PwdRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }
    
    if (![password isEqualToString:confirmPWD]) {
        [[HUD shareHUD] hintMessage:@"两次输入的密码不同哦！"];
        [self.confirmPWDRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }
    
    if (emailText.length == 0) {
        [[HUD shareHUD] hintMessage:@"邮箱不能为空哦！"];
        [self.emailRequeiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }else if (![HolomorphyValidate validateEmailWithText:emailText]){
        [[HUD shareHUD] hintMessage:@"邮箱格式不正确哦！"];
        [self.emailRequeiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
        return;
    }
    
    if (phoneNumber.length == 0) {
        
    }
    
//    if (vierification.length == 0) {
//        [[HUD shareHUD] hintMessage:@"验证码不能为空哦！"];
//        [self.verifRequiedImageView setImage:[UIImage imageNamed:@"Required_Red"]];
//        return;
//    }
    
    NSDictionary *parameDic = @{@"username" : nickName,
                                @"password" : password,
                                @"comfirmPassword" : confirmPWD,
                                @"email": emailText,
//                                @"phoneNumber" : phoneNumber,
//                                @"name" : realName,
//                                @"type" : @"",
//                                @"code" : @"",
//                                @"age" : @"",
//                                @"gender" : @"",
////                                @"birthday" : @"",
//                                @"address" : @"",
//                                @"region" : @"",
//                                @"school" : @"",
//                                @"grade" : @"",
//                                @"job" : @"",
//                                @"phoneType" : @"",
//                                @"phoneVersion" : @"",
//                                @"phoneInfo" : @"",
//                                @"sns" : @""
                                };
    
    [[HUD shareHUD] showActivityWithText:@"正注册..."];
    [KTBBaseAPI registerWithParameter:parameDic successful:^(kTBAPIResponseStatus status, NSString * _Nullable msg, NSString * _Nullable emsg) {
        if (kTBAPIResponseStatusSuccessful == status) {
            [self.navigationController popViewControllerAnimated:YES];
            [[HUD shareHUD] hintMessage:@"注册成功！"];
        }else{
            [[HUD shareHUD] hintMessage:emsg];
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [[HUD shareHUD] hintMessage:errorMessage];
        
    }];
}


// 获取验证码
- (IBAction)getVerificationCodeClick:(id)sender {
//    NSString *phoneNumber = [NSString removeBlankSpace:self.phoneNumberTextField.text];
//    self.phoneNumberTextField.text = phoneNumber;
//    BOOL isPhoneNumberValidate = [HolomorphyValidate validatePhoneNumberWithText:phoneNumber];
//    if (!isPhoneNumberValidate) {
//        [[HUD shareHUD] hintMessage:@"手机号码不正确！"];
//        return;
//    }
    
    NSString *email = [NSString removeBlankSpace:self.emailTextField.text];
    self.emailTextField.text = email;
    BOOL isEmailValidate = [HolomorphyValidate validateEmailWithText:email];
    if (!isEmailValidate) {
        [[HUD shareHUD] hintMessage:@"邮箱地址不正确！"];
        return;
    }
    
    self.verificationCodeButton.enabled = NO;
    
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(upDateCountdown:) userInfo:nil
                                                             repeats:YES];
    /*
     loginname		登录名， 可以是 email， phoneNumber,  关联好友号username..
     loginType		登录方式， 2 email， 3 phoneNumber， 4 username2
     */
    
    NSDictionary *paraDic = @{@"loginname" : email,
                              @"loginType" : @"3"};
    
    [KTBBaseAPI getVcodeWithUserName:email successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
        if (kTBAPIResponseStatusSuccessful == status) {
            LBLog(@"验证码已发送 : %@",resDic);
            [[HUD shareHUD] hintMessage:@"验证码已发送！"];
            kCountdownTime = 60;
            [self.verificationTimer fire];
            [self.verificationCodeButton setTitle:@"重新获取（59）" forState:UIControlStateNormal];
            self.verificationCodeButton.enabled = NO;
        }else{
            [[HUD shareHUD] hintMessage:emsg];
            [self.verificationTimer invalidate];
            self.verificationTimer = nil;
            self.verificationCodeButton.enabled = YES;
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [self.verificationTimer invalidate];
        self.verificationTimer = nil;
        self.verificationCodeButton.enabled = YES;
        [[HUD shareHUD] hintMessage:errorMessage];
    }];
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

- (IBAction)backToLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
