//
//  DocumentViewController.m
//  KaoTiBi
//
//  Created by linkapp on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocumentTableViewController.h"
#import "DocumentCellTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "DocumentMgr.h"
#import "Document.h"
#import "KTDefine.h"
#import "HUD.h"
#import "KTBSearchViewController.h"
#import "ScreenShot.h"
#import "LBSelectFolderController.h"

#define KConfirmButtonHeigth 60

#define kDocumentCellTableViewCellIdentifier @"kDocumentCellTableViewCellIdentifier"
@interface DocumentTableViewController ()<MWPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource,LBSelectFloderControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL navigationBarOriginalShow;

// 图片查看器
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *confirmView;
@property (nonatomic, assign) BOOL isConfirmViewShow;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign) BOOL isShowEmptyView;
@end

@implementation DocumentTableViewController

-(UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"LBBaseEmptyBGView" owner:self options:nil] lastObject];
        _emptyView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height - 40);
        UILabel *hintLabel;
        for (UIView *subView in _emptyView.subviews){
            if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
                hintLabel = (UILabel *)subView;
            }
        }
        if (hintLabel != nil) {
            hintLabel.text = @"没有任何文档照片哦！";
        }
    }
    return _emptyView;
}

- (void)updateView{
    if (self.documents.count == 0) {
        [self.tableView addSubview:self.emptyView];
        _isShowEmptyView = YES;
    }else{
        if (_isShowEmptyView) {
            [self updateView];
            [self.emptyView removeFromSuperview];
            _isShowEmptyView = NO;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBarOriginalShow = self.navigationController.navigationBar.isHidden;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = self.navigationBarOriginalShow;
    [self hiddenConfirmView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBackgroundShallowColor;
    
    Document *document = [self.documents firstObject];
    if (document) {
        self.title = document.folderName;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DocumentCellTableViewCell" bundle:nil] forCellReuseIdentifier:kDocumentCellTableViewCellIdentifier];
    
    
    if (self.documents.count > 0) {
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        [searchButton setTitle:@"" forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"shousuo"] forState:UIControlStateNormal];
        searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
        UIBarButtonItem *searchItem =  [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        
        UIButton *creatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [creatButton addTarget:self action:@selector(createClick:) forControlEvents:UIControlEventTouchUpInside];
        [creatButton setTitle:@"" forState:UIControlStateNormal];
        [creatButton setImage:[UIImage imageNamed:@"creatFolder"] forState:UIControlStateNormal];
        creatButton.titleLabel.font = [UIFont systemFontOfSize:14];
        UIBarButtonItem *creatItem = [[UIBarButtonItem alloc] initWithCustomView:creatButton];
        
        self.navigationItem.rightBarButtonItems = @[searchItem, creatItem];
    }
    
    [self updateView];
}

- (void)searchClick:(UIButton*)button{
    UIImage *screenIm = [ScreenShot screenShot];
    KTBSearchViewController *searchController = [[KTBSearchViewController alloc] initWithNibName:@"KTBSearchViewController" bundle:nil];
    searchController.backGroundImage = screenIm;
    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:nVC animated:NO completion:^{
        
    }];
}

- (void)createClick:(UIButton *)button{
    [self switchMultipleOperation];
}

#pragma mark 设置tableview刷新控件
- (void)setRefreshView{;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlStatusDidChange:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}

- (void)refreshControlStatusDidChange:(UIRefreshControl *)refreshControl{
    [self updateView];
    [self performSelector:@selector(refreshControlEndRefreshing) withObject:nil afterDelay:1.0];
}

- (void)refreshControlEndRefreshing{
    [self.tableView.refreshControl endRefreshing];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDocumentCellTableViewCellIdentifier forIndexPath:indexPath];
    Document *doc = self.documents[indexPath.row];
    cell.type = DocumentCellTypeCell;
    cell.document = doc;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        NSArray *selectedIndexPath = [tableView indexPathsForSelectedRows];
        if (selectedIndexPath.count > 0) {
            [self showConfirmView];
        }else{
            [self hiddenConfirmView];
        }
    }else{
        Document *doc = self.documents[indexPath.row];
        [self previewPhotosWithPhotoBrowserWithFile:doc];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Document *docu = self.documents[indexPath.row];
        [self.documents removeObjectAtIndex:indexPath.row];
        [DocumentMgr deleteDocument:docu];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [DocumentMgr shareDocumentMgr].isNeedUpdate = YES;
    }
}

#pragma -mark MWPhoto图片查看器
- (void)previewPhotosWithPhotoBrowserWithFile:(Document *)document{
    NSString *port;
    NSString *thumbPort;
    NSMutableArray *docs = self.documents;
    
    
    // 如果是图片则用图片查看器进行查看
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    NSInteger photosIndex = 0;
    NSInteger currentIndex = 0;
    for (Document *doc in docs){
        NSString *docPath = [kPathDocument stringByAppendingPathComponent:doc.path];
        docPath = [docPath stringByAppendingPathComponent:doc.dateName];
        NSURL *docURL = [NSURL fileURLWithPath:docPath];
        [photos addObject:[MWPhoto photoWithURL:docURL]];
        if ([doc.path isEqualToString:document.path]) {
            currentIndex = photosIndex;
        }
        photosIndex++;
    }
    
    self.photos = photos;
//    self.thumbs = thumbs;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.photosArray = photos;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:currentIndex];
    
    // Show
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index{
    MWPhoto *photo = [self.photos objectAtIndex:index];
    
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    captionView.userInteractionEnabled = YES;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"原图" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
    item2.tag = index;
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"答案" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
    item4.tag = index;
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithTitle:@"题目" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
    item6.tag = index;

    
//    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [button6 setTitle:@"aa" forState:UIControlStateNormal];
//    [button6 addTarget:self action:@selector(photoBrowserButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithCustomView:button6];
    
    UIBarButtonItem *item7 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [captionView setItems:@[item1,item2,item3,item4,item5,item6,item7]];
    
    return captionView;        //此方法可以定制图片游览页下边的toorBar
}

- (void)photoBrowserButtonItemDidClick:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"原图"]) {
        LBLog(@"原图 picIndex: %ld",item.tag);
    }else if ([item.title isEqualToString:@"答案"]){
        LBLog(@"答案 picIndex: %ld",item.tag);
    }else if ([item.title isEqualToString:@"题目"]){
        LBLog(@"题目 picIndex: %ld",item.tag);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 多选切换
// 多选和取消操作
- (void)switchMultipleOperation{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
        [self hiddenConfirmView];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}

-(UIView *)confirmView{
    if (!_confirmView) {
        _confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KConfirmButtonHeigth)];
        _confirmView.backgroundColor = [UIColor whiteColor];
        _isConfirmViewShow = NO;
        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, self.view.bounds.size.width / 2 - 10, KConfirmButtonHeigth - 4)];
        [confirmButton setTitle:@"删除" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.backgroundColor = kThemeColor;
        confirmButton.layer.cornerRadius = 5.0;
        [confirmButton addTarget:self action:@selector(confirmDeleteFile:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmView addSubview:confirmButton];
        
        
        UIButton *moveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(confirmButton.frame) + 5, 2, self.view.bounds.size.width / 2 - 10, KConfirmButtonHeigth - 4)];
        [moveButton setTitle:@"移动" forState:UIControlStateNormal];
        [moveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        moveButton.backgroundColor = kThemeColor;
        moveButton.layer.cornerRadius = 5.0;
        [moveButton addTarget:self action:@selector(confirmMoveFile:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmView addSubview:moveButton];
        
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

#pragma mark - 确认删除
- (void)confirmDeleteFile:(UIButton *)deleteButton{
    NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
    if (selectRows.count == 0) {
        [[HUD shareHUD] hintMessage:@"未选择文件夹"];
        return;
    }
    [[HUD shareHUD] hintMessage:@"删除成功!"];
    [self switchMultipleOperation];
}
#pragma mark - 确认移动
- (void)confirmMoveFile:(UIButton *)moveButton{
    
    if ([DocumentMgr directoryInfor].count < 1) {
        [[HUD shareHUD] hintMessage:@"请新增文件夹后进行移动！"];
        return;
    }
    
    LBSelectFolderController *moveVC = [[LBSelectFolderController alloc] init];
    moveVC.title = @"移动";
    moveVC.oldFolderName = self.title;
    NSArray *selecIndex = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *docs = [NSMutableArray array];
    for (NSIndexPath *indexPH in selecIndex){
        [docs addObject:self.documents[indexPH.row]];
    }
    moveVC.documets = docs;
    moveVC.selectedIndexPath = selecIndex;
    moveVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:moveVC];
    [self presentViewController:nvc animated:YES completion:nil];
    [self switchMultipleOperation];
}

#pragma mark - LBSelectFloderControllerDelegate
- (void)successfullMoveDocumentsWithSelectedIndexPath:(NSArray *)selectedIndexPath{
    for (NSIndexPath *seInPath in selectedIndexPath){
        [self.documents removeObjectAtIndex:seInPath.row];
    }
    if (self.documents.count == 0){
        [self updateView];
    }else {
        [self.tableView deleteRowsAtIndexPaths:selectedIndexPath withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [DocumentMgr shareDocumentMgr].isNeedUpdate = YES;
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
