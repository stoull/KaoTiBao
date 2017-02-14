//
//  PhotoEidtController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 12/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "PhotoEidtController.h"
#import "Document.h"
#import "HUD.h"
@import Photos;

@interface PhotoEidtController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *eidtImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;

@property (nonatomic, strong) Document *currentDoc;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, weak) NSString *docName;

@end

@implementation PhotoEidtController

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
    [self.currentDoc saveToDataBase];
    [self didCancelClick:nil];
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
    if (sender.tag == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (self.docName != nil) {
                textField.placeholder = self.docName;
            }else{
                textField.placeholder = @"给照片取个名字";
                textField.textColor = kThemeColor;
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *nameField = alertController.textFields.firstObject;
            NSString *foreheaderStr = nameField.text;
            self.docName = foreheaderStr;
            if (foreheaderStr.length > 5) {
                foreheaderStr = [foreheaderStr substringToIndex:4];
                foreheaderStr = [NSString stringWithFormat:@"%@...",foreheaderStr];
            }
            
            [sender setTitle:foreheaderStr];
//            NSDictionary *testArrribute = @{NSForegroundColorAttributeName : kThemeColor};
//            [sender setTitleTextAttributes:testArrribute forState:UIControlStateNormal];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:comfirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (sender.tag == 1){
        
    }else if (sender.tag == 2){
        
    }
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
