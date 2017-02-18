//
//  LBFileAttributeViewController.m
//  LinkPortal
//
//  Created by Stoull Hut on 10/1/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBAttributeViewController.h"
#import "LBFileIconCell.h"
#import "Masonry.h"

@interface LBAttributeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *informationTableview;

@property (nonatomic, strong) NSDictionary *fileInforDic;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

static NSString *iconCellIdentifier = @"iconcellIndecfitel";
static NSString *cellIdentifier = @"informationCell";
@implementation LBAttributeViewController

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
    self.informationTableview = [[UITableView alloc] init];
    self.informationTableview.delegate = self;
    self.informationTableview.dataSource = self;
    [self.view addSubview:self.informationTableview];
    // Do any additional setup after loading the view from its nib.
    [self.informationTableview registerNib:[UINib nibWithNibName:@"LBFileIconCell" bundle:nil] forCellReuseIdentifier:iconCellIdentifier];
    
    self.informationTableview.tableFooterView = [UIView new];
    [self.informationTableview setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.informationTableview setSeparatorColor:kTabelViewSeparatorColor];
    [self setRefreshView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getTheFileInformation];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.informationTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
}

#pragma mark 设置tableview刷新控件
- (void)setRefreshView{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlStatusDidChange:) forControlEvents:UIControlEventValueChanged];
    self.informationTableview.refreshControl = refreshControl;
}

- (void)refreshControlStatusDidChange:(UIRefreshControl *)refreshControl{
    
}

- (void)getTheFileInformation{
//    [self.activityView startAnimating];
//    [LBBaseAPI getFileInformationWithID:self.file.ID dirPosition:(int)self.file.fileType successful:^(BOOL isSuccessful, NSString * _Nullable message, NSDictionary * _Nullable responseObject) {
//        [self.activityView stopAnimating];
//        self.fileInforDic = responseObject[@"rows"];
//        self.accessUsers = responseObject[@"adminRows"];
//        if (self.file.fileType == LBReceiveShareType || self.file.fileType ==LBMyShareType) {
//            self.fileInforDic = [responseObject[@"rows"] firstObject];
//            self.accessUsers = self.fileInforDic[@"userList"];
//            self.departmentList = self.fileInforDic[@"departmentList"];
//        }
//        [self.informationTableview reloadData];
//    } failure:^(NSString * _Nonnull errorMessage) {
//        [self.activityView stopAnimating];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBFileIconCell *cell = [tableView dequeueReusableCellWithIdentifier:iconCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleName.text = @"";
    cell.valueLabel.text = @"";
    switch (indexPath.row) {
        case 0:
        {
            cell.titleName.text = @"共享给:";
            }
            break;
        case 1:
            cell.titleName.text = @"共享时间:";
            cell.valueLabel.text = self.fileInforDic[@"addDate"];
            break;
            
        case 2:
            cell.titleName.text = @"修改时间:";
            cell.valueLabel.text = self.fileInforDic[@"lastModified"];
            break;
        case 3:
        {
            cell.titleName.text = @"共享权限:";
            NSString *permissions = self.fileInforDic[@"rw"];
            NSString *PMDescr = @"阅读";
            if ([permissions rangeOfString:@"w"].location == NSNotFound) {
                [PMDescr stringByAppendingString:@"/下载"];
            }
            cell.valueLabel.text = PMDescr;
        } 
            break;
        case 4:
        {
            cell.titleName.text = @"共享消息:";
            NSString *des = self.fileInforDic[@"description"];
            if (des == nil || des.length == 0) {
                cell.valueLabel.text = @"无";
            }else{
                cell.valueLabel.text = des;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1){
//        if (self.file.fileType == LBDataBaseType && self.accessUsers.count > 1) {
//            LBAccessUserController *accessUserController = [[LBAccessUserController alloc] init];
//            accessUserController.accessUserArray = self.accessUsers;
//            [self.navigationController pushViewController:accessUserController animated:YES];
//        }
//    }else{
//
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

@end
