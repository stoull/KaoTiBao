//
//  KTBSearchViewController.m
//  KaoTiBi
//
//  Created by linkapp on 16/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBSearchViewController.h"
#import "DocumentMgr.h"
#import "DocumentCellTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "KTDefine.h"

@interface KTBSearchViewController ()<UISearchBarDelegate,MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchHeardView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray *resulutArray;

@property (nonatomic, strong) UIView *noSearchResultHintView;
@property (nonatomic, assign) BOOL isnoSearchResultHintViewIsShow;
@property (nonatomic ,strong) UIView *begainSearchHintView;
@property (nonatomic, assign) BOOL isShowSearchView;
@property (nonatomic, copy) NSString *lastTimeKeyWords;

// 图片查看器
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@end
#define kDocumentCellTableViewCellIdentifier @"kDocumentCellTableViewCellIdentifier"
@implementation KTBSearchViewController
-(NSMutableArray *)resulutArray{
    if (!_resulutArray) {
        _resulutArray = [NSMutableArray array];
    }
    return _resulutArray;
}

-(UIView *)noSearchResultHintView{
    if (!_noSearchResultHintView) {
        _noSearchResultHintView = [[[NSBundle mainBundle] loadNibNamed:@"LBBaseEmptyBGView" owner:self options:nil] lastObject];
        _noSearchResultHintView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height - 40);
        UILabel *hintLabel;
        for (UIView *subView in _noSearchResultHintView.subviews){
            if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
                hintLabel = (UILabel *)subView;
            }
        }
        _isnoSearchResultHintViewIsShow = NO;
        if (hintLabel != nil) {
            hintLabel.text = @"没有搜索到任务结果哦！";
        }
    }
    return _noSearchResultHintView;
}

-(UIView *)begainSearchHintView{
    if (!_begainSearchHintView) {
        _begainSearchHintView = [[[NSBundle mainBundle] loadNibNamed:@"LBSearchNoResultView" owner:self options:nil] lastObject];
        _begainSearchHintView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height - 40);
        UILabel *hintLabel;
        for (UIView *subView in _begainSearchHintView.subviews){
            if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
                hintLabel = (UILabel *)subView;
            }
        }
        if (hintLabel != nil) {
            hintLabel.text = @"点击【搜索】按钮进行搜索！";
        }
    }
    return _begainSearchHintView;
}

- (void)updateView{
    if (self.resulutArray.count > 0) {
        [self.noSearchResultHintView removeFromSuperview];
        [self.begainSearchHintView removeFromSuperview];
        self.isShowSearchView = NO;
        self.isnoSearchResultHintViewIsShow = NO;
        [self.tableView reloadData];
    }else{
        if (!_isnoSearchResultHintViewIsShow) {
            [self.tableView addSubview:self.noSearchResultHintView];
        }
    }
    
}

- (void)judgeBegainSearchHintViewWithtext:(NSString *)text{
    if ([self.lastTimeKeyWords isEqualToString:text]) {
        [self.begainSearchHintView removeFromSuperview];
        _isShowSearchView = NO;
    }else{
        if (!_isShowSearchView) {
            [self.tableView addSubview:self.begainSearchHintView];
            _isShowSearchView = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.backGroundImage != nil) {
        self.bgImageView = [[UIImageView alloc] initWithImage:self.backGroundImage];
        self.bgImageView.frame = [UIScreen mainScreen].bounds;

        [self.view insertSubview:self.bgImageView atIndex:0];
    }
    
    self.lastTimeKeyWords = @" ";
    
    self.searchHeardView.frame = CGRectMake(kSCREEN_WIDTH - 50, 0, kSCREEN_WIDTH, 64);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchHeardView.frame), kSCREEN_WIDTH, 0);
    self.searchHeardView.backgroundColor = kThemeColor;
    self.searchBar.backgroundColor = kThemeColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DocumentCellTableViewCell" bundle:nil] forCellReuseIdentifier:kDocumentCellTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.searchBar layoutIfNeeded];
        self.searchHeardView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 64);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchHeardView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        } completion:^(BOOL finished) {
            [self.bgImageView removeFromSuperview];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resulutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocumentCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDocumentCellTableViewCellIdentifier forIndexPath:indexPath];
    Document *docuemt = self.resulutArray[indexPath.row];
    cell.type = DocumentCellTypeCell;
    cell.document = docuemt;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Document *doc = self.resulutArray[indexPath.row];
    [self previewPhotosWithPhotoBrowserWithFile:doc];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keywords = searchBar.text;
    self.lastTimeKeyWords = keywords;
    if (keywords) {
        self.resulutArray = [DocumentMgr selectDocumentsWithName:keywords];
        [self updateView];
    }
    [self.searchBar endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self updateView];
    [self judgeBegainSearchHintViewWithtext:@""];
}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self judgeBegainSearchHintViewWithtext:searchText];
}


#pragma -mark MWPhoto图片查看器
- (void)previewPhotosWithPhotoBrowserWithFile:(Document *)document{
    NSString *port;
    NSString *thumbPort;
    NSArray *array = self.resulutArray;
    NSMutableArray *docs = [array mutableCopy];
    
    
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
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:currentIndex];
    
    // Show
    self.navigationController.navigationBar.hidden = NO;
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
    
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"原图" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item2.tag = index;
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"答案" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item4.tag = index;
//    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithTitle:@"题目" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item6.tag = index;
    
    
    //    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [button6 setTitle:@"aa" forState:UIControlStateNormal];
    //    [button6 addTarget:self action:@selector(photoBrowserButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithCustomView:button6];
    
//    UIBarButtonItem *item7 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
//    [captionView setItems:@[item1,item2,item3,item4,item5,item6,item7]];
    
    return captionView;        //此方法可以定制图片游览页下边的toorBar
}

//- (void)photoBrowserButtonItemDidClick:(UIBarButtonItem *)item{
//    if ([item.title isEqualToString:@"原图"]) {
//        LBLog(@"原图 picIndex: %ld",item.tag);
//    }else if ([item.title isEqualToString:@"答案"]){
//        LBLog(@"答案 picIndex: %ld",item.tag);
//    }else if ([item.title isEqualToString:@"题目"]){
//        LBLog(@"题目 picIndex: %ld",item.tag);
//    }
//}
@end
