//
//  DocumentCollectionController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 14/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocumentCollectionController.h"
#import "DocCollectionViewCell.h"
#import "KTDefine.h"
#import "MWPhotoBrowser.h"

@interface DocumentCollectionController ()

// 图片查看器
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation DocumentCollectionController

static NSString * const reuseIdentifier = @"DocCollectionViewCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DocCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.docments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DocCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = (screenSize.width - (kDocRow + 1) * kDocLeftMagin) / kDocRow;
    cell.itemWidth = itemWidth;
    cell.document = self.docments[indexPath.row];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Document *doc = self.docments[indexPath.row];
    [self previewPhotosWithPhotoBrowserWithFile:doc];
}

#pragma -mark MWPhoto图片查看器
- (void)previewPhotosWithPhotoBrowserWithFile:(Document *)document{
    NSString *port;
    NSString *thumbPort;
    NSMutableArray *docs = [self.docments mutableCopy];
    
    
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
    
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"原图" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item2.tag = index;
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"答案" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item4.tag = index;
//    UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithTitle:@"题目" style:UIBarButtonItemStylePlain target:self action:@selector(photoBrowserButtonItemDidClick:)];
//    item6.tag = index;
//    
//    
//    //    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    //    [button6 setTitle:@"aa" forState:UIControlStateNormal];
//    //    [button6 addTarget:self action:@selector(photoBrowserButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //    UIBarButtonItem *item6 = [[UIBarButtonItem alloc] initWithCustomView:button6];
//    
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
