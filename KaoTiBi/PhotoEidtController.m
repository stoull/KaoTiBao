//
//  PhotoEidtController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 12/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "PhotoEidtController.h"
#import "DocumentMgr.h"
#import "Document.h"
#import "KTBPopInputView.h"
#import "KTBSelectTableView.h"
#import "HUD.h"
#import "KTDefine.h"

@import Photos;

typedef enum : NSInteger{
    CurrentInputTypeName,
    CurrentInputTypeDescrible
}CurrentInputType;

@interface PhotoEidtController ()<KTBPopInputViewDelegate, KTBSelectTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *eidtImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property (nonatomic, strong) KTBPopInputView *popInputView;
@property (nonatomic, strong) KTBSelectTableView *selectDirView;

@property (nonatomic, strong) Document *currentDoc;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *docName;
@property (nonatomic, copy) NSString *docDescrible;
@property (nonatomic, copy) NSString *directoryName;

@property (nonatomic, assign) CurrentInputType inputType;

@end

@implementation PhotoEidtController

-(KTBPopInputView *)popInputView{
    if (!_popInputView) {
        _popInputView = [[[NSBundle mainBundle] loadNibNamed:@"KTBPopInputView" owner:self options:nil] lastObject];
        _popInputView.frame = [UIScreen mainScreen].bounds;
        _popInputView.delegate = self;
    }
    return _popInputView;
}

-(KTBSelectTableView *)selectDirView{
    if (!_selectDirView) {
        _selectDirView = [[[NSBundle mainBundle] loadNibNamed:@"KTBSelectTableView" owner:self options:nil] lastObject];
        _selectDirView.frame = [UIScreen mainScreen].bounds;
        _selectDirView.delegate = self;
        _selectDirView.folderArray = [DocumentMgr directoryInfor];
        _selectDirView.title = @"请选择目录";
    }
    return _selectDirView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIBarButtonItem *item in self.bottomToolBar.items){
        [item setTintColor:kThemeColor];
        NSDictionary *testArrribute = @{NSForegroundColorAttributeName : kThemeColor};
        [item setTitleTextAttributes:testArrribute forState:UIControlStateNormal];
    }
    
    for (UIView *subview in self.headerView.subviews){
        if ([subview isKindOfClass:[UIButton class]]) {
            if (subview.tag != 0 || subview.tag != 1) {
                subview.layer.cornerRadius = subview.frame.size.width / 2;
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.backgroundColor = kThemeColor;
    if (self.assetURL != nil) {
        self.currentDoc = [[Document alloc] initWithAssetURL:self.assetURL];
        [self loadImageWithAssetURl:self.assetURL];
    }
    
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    NSString *defalutFolderName = [useDef objectForKey:KDefaultSaveDirectory];
    if (defalutFolderName) {
        NSArray *direcos = [DocumentMgr directoryInfor];
        BOOL isEixt = NO;
        for (NSString *folderName in direcos){
            if ([folderName isEqualToString:defalutFolderName]) {
                self.directoryName = defalutFolderName;
                isEixt = YES;
                break;
            }
        }
        if (!isEixt) {
            self.directoryName = [direcos firstObject];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[HUD shareHUD] showActivityWithText:@"正分析红色标记..."];
}

- (void)loadImageWithAssetURl:(NSURL *)assetUrl{
    PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[assetUrl] options:nil] firstObject];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    if (asset.mediaType == PHAssetMediaTypeImage){
        [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            self.imageData = imageData;
            if (imageData != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.eidtImageView.image = [UIImage imageWithData:imageData];
                });
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions 

// 保存
- (IBAction)saveButtonDidClick:(id)sender {
    if (self.docName) {
        self.currentDoc.name = self.docName;
    }
    if (self.docDescrible) {
        self.currentDoc.describleString = self.docDescrible;
    }
    if (self.directoryName) {
        self.currentDoc.folderName = self.directoryName;
    }
    
    [self.currentDoc saveToDataBase];
    [self didCancelClick:nil];
    [DocumentMgr shareDocumentMgr].isNeedUpdate = YES;
}

// cancel
- (IBAction)didCancelClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// caculate the pic
- (IBAction)colorDidSelected:(UIButton *)sender {
    switch (sender.tag) {
        case 11:            // 红色
            [[HUD shareHUD] showActivityWithText:@"正分析红色标记..."];
            break;
        case 12:            // 橙色
            [[HUD shareHUD] showActivityWithText:@"正分析橙色标记..."];
            break;
        case 13:            // 绿色
            [[HUD shareHUD] showActivityWithText:@"正分析绿色标记..."];
            break;
        case 14:            // 青色
            [[HUD shareHUD] showActivityWithText:@"正分析青色标记..."];
            break;
        case 15:            // 淡蓝色
            [[HUD shareHUD] showActivityWithText:@"正分析淡蓝色标记..."];
            break;
        case 16:            // 蓝色
            [[HUD shareHUD] showActivityWithText:@"正分析蓝色标记..."];
            break;
        default:
            break;
    }
    [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:2.0];
}

- (void)hiddenHUD{
    [[HUD shareHUD] hidden];
}

- (IBAction)toolBarButtonItemAction:(UIBarButtonItem *)sender {
    
    LBLog(@"sender : %ld",sender.tag);
    
    if (sender.tag == 0) { // 目录
        [self.selectDirView showInView:self.view];
    }else if (sender.tag == 1){ // 名称
        self.popInputView.title = @"给照片取个名字";
        self.popInputView.placeHoldText = @"输入照片名字";
        self.popInputView.inputText = self.docName;
        self.popInputView.maxInputCount = 50;
        self.popInputView.inputViewHeight = 44;
        self.inputType = CurrentInputTypeName;
        [self.popInputView showInView:self.view];
    }else if (sender.tag == 2){ // 描述
        self.popInputView.title = @"给照片添加描述";
        self.popInputView.placeHoldText = @"输入照片描述";
        self.popInputView.inputText = self.docDescrible;
        self.popInputView.maxInputCount = 250;
        self.popInputView.inputViewHeight = 130;
        self.inputType = CurrentInputTypeDescrible;
        [self.popInputView showInView:self.view];
    }
}

#pragma mark - KTBPopInputViewDelegate
- (void)confirmButtondidClickWithInputString:(NSString *)inpuString{
    if (self.inputType == CurrentInputTypeName) {
        self.docName = inpuString;
    }else{
        self.docDescrible = inpuString;
    }
}

#pragma mark - KTBSelectTableViewDelegate
- (void)confirmButtondidClickWithTitle:(NSString *)title andIndex:(NSInteger)index{
    self.directoryName = title;
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
