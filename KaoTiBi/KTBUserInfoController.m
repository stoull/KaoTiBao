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
#import "KTBUserManager.h"
#import "LBFileIconCell.h"
#import "KTBBaseAPI.h"
#import "SignInViewController.h"
#import "HUD.h"
#import "ResetPWDController.h"
#define iconCellIdentifier @"iconcellIndecfitel"
#define cellIdentifier  @"informationCell"


@interface KTBUserInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) KTBUser *currentUser;

@property (nonatomic, strong) NSDictionary *fileInforDic;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) ResetPWDController *resetPWDController;

@end

@implementation KTBUserInfoController
-(ResetPWDController *)resetPWDController{
    if (!_resetPWDController) {
        _resetPWDController = [[ResetPWDController alloc] initWithNibName:@"ResetPWDController" bundle:nil];
        _resetPWDController.isChangPassword = YES;
    }
    return _resetPWDController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Setting.myInformation", @"我的信息");
    self.logoutButton.layer.cornerRadius = 5.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBFileIconCell" bundle:nil] forCellReuseIdentifier:iconCellIdentifier];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.tableView setSeparatorColor:kTabelViewSeparatorColor];
    
    [self getSystemInfo];
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _activityView.center = self.navigationController.view.center;
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView.hidesWhenStopped = YES;
        [self.navigationController.view addSubview:_activityView];
    }
    return _activityView;
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
        [[HUD shareHUD] showActivityWithText:NSLocalizedString(@"Setting.processLogout", @"正注销...")];
        [KTBBaseAPI logoutWithUserId:currentUser.userId successful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg) {
            if (kTBAPIResponseStatusSuccessful == status) {
                [self.navigationController popViewControllerAnimated:YES];
                [[HUD shareHUD] hintMessage:NSLocalizedString(@"Setting.logoutSuccessful", @"注销成功！")];
                [KTBUserInfoController logOutSettings];
            }else{
                if ([emsg isEqualToString:@"用户尚未登录"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[HUD shareHUD] hintMessage:NSLocalizedString(@"Setting.logoutSuccessful", @"注销成功！")];
                    [KTBUserInfoController logOutSettings];
                }else{
                    [[HUD shareHUD] hintMessage:emsg];
                }
            }
        } failure:^(NSString * _Nonnull errorMessage) {
            [[HUD shareHUD] hintMessage:errorMessage];
        }];
    }
}

- (void)getSystemInfo{
    self.currentUser = [KTBUserManager currentUser];
}

#pragma mark - Table view data sourc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else{
        return 2;
    }
}

 /*
 用户名
 姓名
 绑定邮箱
 绑定手机
 注册时间
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBFileIconCell *cell = [tableView dequeueReusableCellWithIdentifier:iconCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleName.text = @"";
    cell.valueLabel.text = @"";
    
    if (indexPath.section == 0) {
        cell.isShowHintView = YES;
        switch (indexPath.row) {
            case 0:
            {
                cell.titleName.text = NSLocalizedString(@"Setting.username", @"用户名:");
                cell.valueLabel.text = self.currentUser.username;
            }
                break;
            case 1:
                cell.titleName.text = NSLocalizedString(@"Login.realName", @"姓名:");
                cell.valueLabel.text = self.currentUser.name;
                break;
                
            case 2:
                cell.titleName.text = NSLocalizedString(@"Setting.registerTime", @"注册时间:");
                cell.valueLabel.text = self.currentUser.registerTime;
                break;
            case 3:
            {
                cell.titleName.text = NSLocalizedString(@"Setting.emailNoAppend", @"绑定邮箱:");
                cell.valueLabel.text = self.currentUser.email;
            }
                break;
            case 4:
            {
                cell.titleName.text = NSLocalizedString(@"Setting.phoneNoAppend", @"绑定手机:");
                cell.valueLabel.text = self.currentUser.phoneNumber;
            }
                break;
            default:
                break;
        }
    }else{
        cell.isShowHintView = NO;
        if (indexPath.row == 0) {
            cell.titleName.text = NSLocalizedString(@"Setting.modifyUserInfo", @"修改个人资料");
        }else if (indexPath.row == 1){
            cell.titleName.text = NSLocalizedString(@"Login.modifyPassword", @"修改密码");
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            SignInViewController *singVC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            singVC.isChangUserInfo = YES;
            [self.navigationController pushViewController:singVC animated:YES];
        }else{
                    [self.navigationController pushViewController:self.resetPWDController animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

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
