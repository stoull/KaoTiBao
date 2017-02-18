//
//  PenTableViewController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "PenTableViewController.h"
#import "KTBBaseAPI.h"
#import "UserColorPenInfo.h"
#import "HUD.h"
#import "penTableViewCell.h"
#import "KTBBaseDataStorer.h"

#define kCellIdeintww @"penTableViewCellIdentifier"

@interface PenTableViewController ()
@property (nonatomic, strong) UserColorPenInfo *colorPenInfo;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation PenTableViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的荧光笔";
    [self.tableView registerNib:[UINib nibWithNibName:@"penTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdeintww];
    [self getPenInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPenInformation{
    [[HUD shareHUD] showActivityWithText:@"正获取荧光笔信息..."];
    [KTBBaseAPI getUserSettingsSuccessful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
        if (kTBAPIResponseStatusSuccessful == status) {
            self.colorPenInfo = [[UserColorPenInfo alloc] initWithDic:resDic];
            [self.tableView reloadData];
            [[HUD shareHUD] hidden];
        }else{
            NSDictionary *penDic = [KTBBaseDataStorer colorPenInfor];
            if (penDic == nil) {
                self.colorPenInfo = [[UserColorPenInfo alloc] initWithDic:penDic];
                [self.tableView reloadData];
                [[HUD shareHUD] hidden];
            }else{
                [[HUD shareHUD] hintMessage:@"获取失败！"];
            }
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        NSDictionary *penDic = [KTBBaseDataStorer colorPenInfor];
        if (penDic == nil) {
            self.colorPenInfo = [[UserColorPenInfo alloc] initWithDic:penDic];
            [self.tableView reloadData];
            [[HUD shareHUD] hidden];
        }else{
            [[HUD shareHUD] hintMessage:@"获取失败！"];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.colorPenInfo == nil) {
        return 0;
    }else
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    penTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdeintww forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.colorPenInfo == nil) {
        cell.colorType = ColorTypeBlack;
        cell.lastTime = 0;
        return cell;
    }
    switch (indexPath.row) {
        case 0:
            cell.colorType = ColorTypeRed;
            cell.lastTime = self.colorPenInfo.redTime;
            break;
        case 1:
            cell.colorType = ColorTypeOrange;
            cell.lastTime = self.colorPenInfo.orangeTime;
            break;
        case 2:
            cell.colorType = ColorTypeCyan;
            cell.lastTime = self.colorPenInfo.cyanTime;
            break;
        case 3:
            cell.colorType = ColorTypeGreen;
            cell.lastTime = self.colorPenInfo.greenTime;
            break;
        case 4:
            cell.colorType = ColorTypeBlack;
            cell.lastTime = self.colorPenInfo.blackTime;
            break;
        case 5:
            cell.colorType = ColorTypeYellow;
            cell.lastTime = self.colorPenInfo.yellowTime;
            break;
        case 6:
            cell.colorType = ColorTypeGray;
            cell.lastTime = self.colorPenInfo.grayTime;
            break;
        case 7:
            cell.colorType = ColorTypePink;
            cell.lastTime = self.colorPenInfo.pinkTime;
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
@end
