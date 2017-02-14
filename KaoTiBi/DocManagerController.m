//
//  DocManagerController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 02/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocManagerController.h"
#import "DocManagerCell.h"
#import "DocumentViewController.h"
#import "DocumentMgr.h"
#import "KTDefine.h"
#import "CCSideSlipView.h"
#import "MenuView.h"
#import "DocManagerCellFooterView.h"
#import "DocMgrCellFooterLayout.h"
#import "MWPhotoBrowser.h"
#import "DocumentCollectionController.h"

#define kDocManagerCellIdentifier @"kDocManagerCellIdentifier"
#define kDocumentCellIdentifier @"kDocumentCellIdentifier"
#define kDocmentFooterViewIdentifier @"kDocmentFooterViewIdentifier"

@interface DocManagerController ()<UITableViewDelegate,UITableViewDataSource,DocManagerCellDelegate,DocManagerCellFooterViewDelegate>{
    CCSideSlipView *_sideSlipView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *statusBarBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;

@property (nonatomic, strong) NSMutableArray *structRecords;

@property (nonatomic, strong) NSArray *menuArrays;
@property (nonatomic, strong) NSMutableArray *menuButtonArray;
@property (nonatomic, strong) UIButton *selectedButton;

// 图片查看器
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) NSFetchedResultsController *resulutController;
@end

@implementation DocManagerController

-(NSMutableArray *)menuButtonArray{
    if (!_menuButtonArray) {
        _menuButtonArray = [NSMutableArray array];
    }
    return _menuButtonArray;
}

- (NSMutableArray *)structRecords{
    if (!_structRecords) {
        _structRecords = [NSMutableArray array];
    }
    return _structRecords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.statusBarBackgroundView.backgroundColor = kThemeColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBackgroundShallowColor;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DocManagerCell" bundle:nil] forCellReuseIdentifier:kDocManagerCellIdentifier];
    [self.tableView registerClass:[DocManagerCellFooterView class] forHeaderFooterViewReuseIdentifier:kDocmentFooterViewIdentifier];
    
    NSArray *menuArray = @[@"语文",@"数学",@"物理",@"化学",@"英语",@"生物"];
    self.menuArrays = menuArray;
    
    CGFloat originY = 2;
    CGFloat buttonWidth = 80;
    CGFloat buttonGap = 2;
    CGFloat buttonHeight = 34;
    int i = 0;
    for (NSString *menu in menuArray){
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(i * (buttonWidth + buttonGap), originY, buttonWidth, buttonHeight)];
        [menuButton setTitle:menu forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        if (i == 0) {
            [menuButton setSelected:true];
        }
        menuButton.tag = i;
        [menuButton addTarget:self action:@selector(headerMenuButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerScrollView addSubview:menuButton];
        [self.menuButtonArray addObject:menuButton];
        i++;
    }
    self.headerScrollView.contentSize = CGSizeMake(i * (buttonWidth + buttonGap) + buttonGap, self.headerScrollView.frame.size.height);
    self.headerScrollView.showsHorizontalScrollIndicator = false;
    
    // Set sideslipView
    [self setSideSlipView];
    [self setRefreshView];
    
    self.resulutController = [DocumentMgr selectGroupWithDay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark 设置tableview刷新控件
- (void)setRefreshView{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlStatusDidChange:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}

- (void)refreshControlStatusDidChange:(UIRefreshControl *)refreshControl{
    self.resulutController = [DocumentMgr selectGroupWithDay];
    // 生成结构数据
    [self.tableView reloadData];
    [self performSelector:@selector(refreshControlEndRefreshing) withObject:nil afterDelay:1.0];
}

- (void)refreshControlEndRefreshing{
    [self.tableView.refreshControl endRefreshing];
}

#pragma mark - 设置侧滑菜单
- (void)setSideSlipView{
    _sideSlipView = [[CCSideSlipView alloc] initWithSender:self];
    _sideSlipView.backgroundColor = [UIColor clearColor];
    MenuView *menu = [MenuView menuView];
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        NSLog(@"click");
        
//        [_sideSlipView hide];
    }];
    menu.items = @[@{@"title":@"二年级",@"imagename":@"4"},
                   @{@"title":@"三年级",@"imagename":@"4"},
                   @{@"title":@"四年级",@"imagename":@"4"},
                   @{@"title":@"五年级",@"imagename":@"4"},
                   @{@"title":@"六年级",@"imagename":@"4"},
                   @{@"title":@"初一",@"imagename":@"1"},
                   @{@"title":@"初二",@"imagename":@"2"},
                   @{@"title":@"初三",@"imagename":@"1"},
                   @{@"title":@"高一",@"imagename":@"1"},
                   @{@"title":@"高二",@"imagename":@"2"},
                   @{@"title":@"高三",@"imagename":@"3"}];
    [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
}

#pragma mark - 头部菜单被点击
- (void)headerMenuButtonDidClick:(UIButton *)button{
    if (self.selectedButton == button) {
        return;
    }
    [button setSelected:!button.isSelected];
    self.selectedButton = button;
    
    for (UIButton *otherButton in self.menuButtonArray){
        if (otherButton.tag != button.tag) {
            [otherButton setSelected:false];
        }
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGPoint point = CGPointMake(button.frame.origin.x - (screenSize.width / 2 - button.frame.size.width / 2), 0);
    
    [self.headerScrollView setContentOffset:point animated:YES];
    
    LBLog(@"Click : %@",self.menuArrays[button.tag]);
}

#pragma mark 分类被点击
- (IBAction)switchTouched:(id)sender {
    
    [_sideSlipView switchMenu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resulutController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.structRecords.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kDocManagerCellIdentifier forIndexPath:indexPath];
    
    NSString *title = [self.resulutController.sections objectAtIndex:indexPath.section].name;

    //特定section下的信息array,再允許indexPath.row找某條消息
    NSArray *array = [self.resulutController.sections objectAtIndex:indexPath.section].objects;
    
//    Document *document = array[0];
    
    title = [NSString stringWithFormat:@"%@ (%ld)",title, array.count];
    cell.title = title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self.resulutController.sections objectAtIndex:indexPath.section].objects;
    DocCollectionViewLayout *flowLayout = [[DocCollectionViewLayout alloc] init];
    DocumentCollectionController *docController = [[DocumentCollectionController alloc] initWithCollectionViewLayout:flowLayout];
    docController.docments = array;
    [self.navigationController pushViewController:docController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray *array = [self.resulutController.sections objectAtIndex:section].objects;
    NSInteger itemCount = array.count;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = (screenSize.width - (kRow + 1) * kLeftMagin) / kRow;
    CGFloat collectionHeight = itemWidth + 2*kLeftMagin;
    
    int lineCount = (int)(itemCount / kRow);
    if (itemCount % kRow) {
        lineCount +=1;
    }
    
    if (itemCount > kRow) {
        collectionHeight = lineCount * itemWidth + 2 *kLeftMagin + kItemMinLineSpacing * lineCount;
    }
    return collectionHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    //特定section下的信息array,再允許indexPath.row找某條消息
    NSArray *array = [self.resulutController.sections objectAtIndex:section].objects;
    
    //    Document *document = array[0];
    
    DocManagerCellFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kDocmentFooterViewIdentifier];
    if (footerView == nil) {
        footerView = [[DocManagerCellFooterView alloc] initWithReuseIdentifier:kDocmentFooterViewIdentifier];
    }
    footerView.documents = array;
    footerView.delegate = self;
    return footerView;
}


//- (nullable UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section{
//    UITableViewHeaderFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kDocmentFooterViewIdentifier];
//    return footerView;
//}

#pragma mark - DocManagerCellFooterViewDelegate
- (void)didSelectedSectionIndex:(NSInteger)section withDocment:(Document *)doc{
    [self previewPhotosWithPhotoBrowserWithFile:doc atSection:section];
}

#pragma -mark MWPhoto图片查看器
- (void)previewPhotosWithPhotoBrowserWithFile:(Document *)document atSection:(NSInteger)section{
    NSString *port;
    NSString *thumbPort;
    NSArray *array = [self.resulutController.sections objectAtIndex:section].objects;
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

@end
