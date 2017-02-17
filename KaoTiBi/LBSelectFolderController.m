//
//  LBSelectFolderController.m
//  LinkPortal
//
//  Created by linkapp on 14/02/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//

#import "LBSelectFolderController.h"
#import "LBSelectFolderTableViewCell.h"
#import "HUD.h"
#import "DocumentMgr.h"

#define kLBSelectFolderControllerIdentifier @"kLBSelectFolderControllerIdentifier"
#define KConfirmButtonHeigth 50

@interface LBSelectFolderController ()

@property (nonatomic, strong) NSMutableArray *folderArray;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *confirmView;
@property (nonatomic, assign) BOOL isConfirmViewShow;

@property (nonatomic, strong) UIView *emptyHintView;
@property (nonatomic, assign) BOOL isEmptyHintViewIsShow;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic,strong) NSIndexPath *selectedPath;
@end

@implementation LBSelectFolderController
-(UIView *)emptyHintView{
    if (!_emptyHintView) {
        _emptyHintView = [[[NSBundle mainBundle] loadNibNamed:@"LBBaseEmptyBGView" owner:self options:nil] lastObject];
        _emptyHintView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 40);
        UILabel *hintLabel;
        for (UIView *subView in _emptyHintView.subviews){
            if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
                hintLabel = (UILabel *)subView;
            }
        }
        _isEmptyHintViewIsShow = NO;
        if (hintLabel != nil) {
            hintLabel.text = @"当前目录没有文件夹哦！";
        }
    }
    return _emptyHintView;
}

-(UIView *)confirmView{
    if (!_confirmView) {
        _confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KConfirmButtonHeigth)];
        _isConfirmViewShow = NO;
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, self.view.bounds.size.width, KConfirmButtonHeigth - 4)];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.backgroundColor = kThemeColor;
        confirmButton.layer.cornerRadius = 5.0;
        [confirmButton addTarget:self action:@selector(confirmSelectThisFile:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmView addSubview:confirmButton];
    }
    return _confirmView;
}

#pragma -mark 确定按钮的推出
- (void)showConfirmView{
    if (_isConfirmViewShow) {
        return;
    }
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    self.confirmView.frame = CGRectMake(0, mainWindow.bounds.size.height, mainWindow.bounds.size.width, KConfirmButtonHeigth);
    [mainWindow addSubview:self.confirmView];
    [UIView animateWithDuration:0.25 animations:^{
        self.confirmView.frame = CGRectMake(0, mainWindow.bounds.size.height - KConfirmButtonHeigth, mainWindow.bounds.size.width, KConfirmButtonHeigth);
    }];
    _isConfirmViewShow = YES;
}

- (void)hiddenConfirmView{
    if (!_isConfirmViewShow) {
        return;
    }
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.25 animations:^{
        self.confirmView.frame = CGRectMake(0, mainWindow.bounds.size.height, mainWindow.bounds.size.width, KConfirmButtonHeigth);
    } completion:^(BOOL finished) {
        [self.confirmView removeFromSuperview];
        _isConfirmViewShow = NO;
    }];
}

- (void)confirmSelectThisFile:(UIButton *)button{
    NSIndexPath *selecIndexPaht = [[self.tableView indexPathsForSelectedRows] lastObject];
    NSString *newFolderName = self.folderArray[selecIndexPaht.row];
    [DocumentMgr updateDocumentDateNameIdentifers:self.documets property:@"folderName" newValue:newFolderName];
    
    if ([self.delegate respondsToSelector:@selector(successfullMoveDocumentsWithSelectedIndexPath:)]) {
        [self.delegate successfullMoveDocumentsWithSelectedIndexPath:self.selectedIndexPath];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        //  进行载入提示
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.center = self.view.center; //CGPointMake(160, 230);
        _activityView.color = [UIColor grayColor];
        [_activityView setHidesWhenStopped:YES];
        [self.view addSubview:_activityView];
    }
    return _activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"LBSelectFolderTableViewCell" bundle:nil] forCellReuseIdentifier:kLBSelectFolderControllerIdentifier];

    self.title = @"选择文件夹";
    self.folderArray = [[DocumentMgr directoryInfor] mutableCopy];
    for (int i = 0; i < self.folderArray.count; i++){
        NSString *dirName = self.folderArray[i];
        if ([dirName isEqualToString:self.oldFolderName]) {
            [self.folderArray removeObjectAtIndex:i];
            break;
        }
    }

    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancleButton addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    
    [self.tableView setEditing:YES];
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.emptyHintView removeFromSuperview];
    [self hiddenConfirmView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelSelected:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBSelectFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLBSelectFolderControllerIdentifier forIndexPath:indexPath];
    NSString *folderName = self.folderArray[indexPath.row];
    cell.folderName = folderName;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        NSArray *selectIndexPath = [tableView indexPathsForSelectedRows];
        for (NSIndexPath *innPaht in selectIndexPath){
            if (innPaht != indexPath) {
                LBSelectFolderTableViewCell *cell = [tableView cellForRowAtIndexPath:innPaht];
                [cell setSelected:NO];
            }
        }
        self.selectedPath = indexPath;

        if (selectIndexPath.count > 0) {
            [self showConfirmView];
        }else{
            [self hiddenConfirmView];
        }
    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        NSArray *selectedIndexPath = [tableView indexPathsForSelectedRows];
        if (selectedIndexPath.count > 0) {
            [self showConfirmView];
        }else{
            [self hiddenConfirmView];
        }
    }
}

@end
