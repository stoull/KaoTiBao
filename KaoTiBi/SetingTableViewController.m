//
//  SetingTableViewController.m
//  KaoTiBi
//
//  Created by linkapp on 07/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "SetingTableViewController.h"
#import "CommonViewController.h"
#import "KTBBaseDataStorer.h"
#import "KTBUserInfoController.h"
#import "HUD.h"
#import "KTBBaseAPI.h"
#import "KTDefine.h"
#import "GateControl.h"
#import "KTBUserManager.h"
#import "LBAlert.h"
#import "LBQRScaner.h"
#import "PenTableViewController.h"
#import "AboutViewController.h"

@interface SetingTableViewController ()

@property (nonatomic, strong) KTBUser *user;

// 用户信息相关
@property (weak, nonatomic) IBOutlet UIImageView *userPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;

@end

@implementation SetingTableViewController
#pragma mark - Set Get 方法
-(KTBUser *)currentUser{
    if (!_user) {
        _user = [KTBUserManager currentUser];
    }
    return _user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    self.tableView.backgroundView.backgroundColor = kBackgroundShallowColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置用户信息
    // 这个为试用版本
    if (self.currentUser.userId == -1) {
        self.usernameLabel.text = @"试用版本用户";
        self.userLevelLabel.text = @"当前等级: 0级";
    }else{
        self.usernameLabel.text = self.currentUser.username;
        self.userLevelLabel.text = [NSString stringWithFormat:@"当前等级: %ld级",self.currentUser.level];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.userPortraitImageView.layer.cornerRadius = self.userPortraitImageView.bounds.size.height / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 50;
    }else{
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.user.userId == -1) {
                [LBAlert showAlertWithTitle:@"当前为试用版本" message:@"是否登录／注册为正式用户？" completionBlock:^(NSUInteger actionIndex, UIAlertAction *alertAction) {
                    if (actionIndex == 1) {
                        [self logOutAction:nil];
                    }
                } cancelActionTitle:@"下次" otherActionTitles:@[@"确定"]];
            }else{
                KTBUserInfoController *userInfoVC = [[KTBUserInfoController alloc] initWithNibName:@"KTBUserInfoController" bundle:nil];
                [self.navigationController pushViewController:userInfoVC animated:YES];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            LBQRScaner *QRScaner = [[LBQRScaner alloc] init];
            [self.navigationController pushViewController:QRScaner animated:YES];
        }else if (indexPath.row == 1){
            PenTableViewController *penCV = [[PenTableViewController alloc] initWithNibName:@"PenTableViewController" bundle:nil];
            [self.navigationController pushViewController:penCV animated:YES];
        }else if (indexPath.row == 4){
            AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }else{
            CommonViewController *commmonController = [[CommonViewController alloc] initWithNibName:@"CommonViewController" bundle:nil];
            [self.navigationController pushViewController:commmonController animated:YES];
        }
    }
}

- (void)logOutAction:(id)sender {
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
