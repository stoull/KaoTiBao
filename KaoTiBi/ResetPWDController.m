//
//  ResetPWDController.m
//  KaoTiBi
//
//  Created by linkapp on 07/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "ResetPWDController.h"
#import "KTBBaseAPI.h"
#import "HolomorphyValidate.h"
#import "NSString+blankSpace.h"
#import "HUD.h"

@interface ResetPWDController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *RePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *vCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPWDButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allToTopConstraint;
@property (nonatomic, assign) CGFloat originToTopConstraint;
@end

@implementation ResetPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    self.resetPWDButton.layer.cornerRadius = 10.0;
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

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.allToTopConstraint.constant = 120;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    CGRect actualRect = [self.view convertRect:self.RePasswordTextField.frame toView:nil];
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

#pragma mark - 重置密码
- (IBAction)resetPasswordAction:(id)sender {
    NSString *password = self.passwordTextField.text = [NSString removeBlankSpace:self.passwordTextField.text];
    NSString *confirmPWD = self.RePasswordTextField.text = [NSString removeBlankSpace:self.RePasswordTextField.text];
    NSString *vCode = self.vCodeTextField.text = [NSString removeBlankSpace:self.vCodeTextField.text];
    
    if (password.length == 0) {
        [[HUD shareHUD] hintMessage:@"密码不能为空哦！"];
        return;
    }else if ([HolomorphyValidate validatePasswordWithText:password]){
        [[HUD shareHUD] hintMessage:@"密码为6-20个字符，必须包含字母大小以及数字哦！"];
        return;
    }
    
    if (![password isEqualToString:confirmPWD]) {
        [[HUD shareHUD] hintMessage:@"两次输入的密码不同哦！"];
        return;
    }
    
    if (vCode.length != 6) {
        [[HUD shareHUD] hintMessage:@"输入的验证码不正确哦！"];
        return;
    }
    
    /*
     loginname		登录名， 可以是 email， phoneNumber,  关联好友号username。。
     loginType		登录方式， 2 email， 3 phoneNumber， 4 username2
     resetCodeKey		重置密码验证码的Key, forgetPass操作返回的key
     resetCode		重置密码验证码，这个参数是用户填写的
     newpassword		新密码
     comfirmPassword	重复密码
     */
    NSDictionary *resetDic = @{@"loginname" : self.logInName,
                               @"loginType" : self.loginType,
                               @"vcodeKey"  : self.vcodeKey,
                               @"vcode"     : self.vcode,
                               @"resetCodeKey" : self.resetCodeKey,
                               @"resetCode" : vCode,
                               @"password" : password,
                               @"comfirmPassword" : confirmPWD};
    [[HUD shareHUD] showActivityWithText:@"正重置密码..."];
    [KTBBaseAPI resetPasswordWithParaDic:resetDic successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg) {
        if (kTBAPIResponseStatusSuccessful == status) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HUD shareHUD] hintMessage:@"重置成功"];
        }else{
            [[HUD shareHUD] hintMessage:emsg];
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [[HUD shareHUD] hintMessage:errorMessage];
    }];
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
