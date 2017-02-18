//
//  ShootingController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 02/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "ShootingController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "GPUImage.h"
#import "UIDevice+deviceModel.h"
#import "KTBBaseDataStorer.h"
#import "PhotoEidtController.h"
#import "Masonry.h"
#import "Document.h"
#import "UserColorPenInfo.h"

#define kWitheBlanceSelectViewWidth 320
int lineCount = 3;
int rowCount = 2;
CGFloat offset = 2;

@interface ShootingController (){
    GPUImageStillCamera *stillCamera;
    UIButton *photoCaptureButton;
    GPUImageOutput<GPUImageInput> *currentFilter;
    CGFloat currentPhotoHeightWidthScale;
    
    CGFloat blanceViewWidth;
    CGFloat blanceViewHeight;
}

@property (weak, nonatomic) IBOutlet UIView *headerBackView;

@property (nonatomic ,strong) UIView *whiteBlanceSelectView;
@property (nonatomic, assign) BOOL isBlanceSelectViewIsShow;

@end

@implementation ShootingController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [stillCamera stopCameraCapture];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [stillCamera startCameraCapture];
    
    blanceViewWidth = kWitheBlanceSelectViewWidth;
    blanceViewHeight = currentPhotoHeightWidthScale * (kWitheBlanceSelectViewWidth + (rowCount + 1) * offset);
}

- (void)loadView{
    [super loadView];
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    
    // Yes, I know I'm a caveman for doing all this by hand
    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
    primaryView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenFrame.size.width, 54)];
    headerView.backgroundColor = kThemeColor;
    
    UIButton *whiteBlanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenFrame.size.width - 42, 18, 40, 40)];
    [whiteBlanceBtn setTitle:@"" forState:UIControlStateNormal];//白平衡
    [whiteBlanceBtn setBackgroundImage:[UIImage imageNamed:@"white_balance"] forState:UIControlStateNormal];
    
    [whiteBlanceBtn addTarget:self action:@selector(selectWhiteBlance) forControlEvents:UIControlEventTouchUpInside];
    
    UserColorPenInfo *userPen = [[UserColorPenInfo alloc] initWithDic:[KTBBaseDataStorer colorPenInfor]];
    if (userPen != nil) {
        CGFloat hintLabelWidth = 75.0;
        UILabel *hintuseLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, hintLabelWidth, 30)];
        hintuseLabel.text = @"当前可用笔：";
        hintuseLabel.textColor = [UIColor whiteColor];
        hintuseLabel.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:hintuseLabel];
        int i = 1;
        CGFloat width = 20;
        CGFloat topOffset = 25;
        if (userPen.redTime > 0) {
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"RedPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.orangeTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"OrangePen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.yellowTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"YellowPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.cyanTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"CyanPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.greenTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"GreenPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.blueTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"BluePen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.pinkTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"PinkPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
        if (userPen.grayTime > 0){
            UIImageView *rePenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width +  i * 5 + hintLabelWidth, topOffset, width, width)];
            rePenImageView.image = [UIImage imageNamed:@"GrayPen"];
            [headerView addSubview:rePenImageView];
            i++;
        }
    }
    
    [headerView addSubview:whiteBlanceBtn];
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoCaptureButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 44.0 / 2.0), mainScreenFrame.size.height - 110.0, 44.0, 44.0);
    [photoCaptureButton setImage:[UIImage imageNamed:@"linecycle"] forState:UIControlStateNormal];
    [photoCaptureButton setTintColor:[UIColor whiteColor]];
//    photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [primaryView addSubview:headerView];
    [primaryView addSubview:photoCaptureButton];
    
    self.view = primaryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *curentScreenSize = [[UIDevice currentDevice] iPhoneScreenSize];
    if ([curentScreenSize isEqualToString:iPhone_3_5_Inch]) {// 3.5英寸
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        currentPhotoHeightWidthScale = 640/480;
    }else if ([curentScreenSize isEqualToString:iPhone_4_0_Inch]) {// 4.0英寸
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        currentPhotoHeightWidthScale = 640/480;
    }else if ([curentScreenSize isEqualToString:iPhone_4_7_Inch]) {// 4.7英寸
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame1280x720 cameraPosition:AVCaptureDevicePositionBack];
        currentPhotoHeightWidthScale = 1280/720;
    }else if ([curentScreenSize isEqualToString:iPhone_5_5_Inch]) {// 5.5英寸
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
        currentPhotoHeightWidthScale = 1920/1080;
    }else{
        stillCamera = [[GPUImageStillCamera alloc] init];
    }

    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    currentFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    [(GPUImageWhiteBalanceFilter *)currentFilter setTemperature:5000];
    [(GPUImageWhiteBalanceFilter *)currentFilter setTint:0];
    //    filter = [[GPUImageGammaFilter alloc] init];
//    filter = [[GPUImageSketchFilter alloc] init];
    //    filter = [[GPUImageUnsharpMaskFilter alloc] init];
    //    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
    //    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
    //    filter = [[GPUImageSmoothToonFilter alloc] init];
    //    filter = [[GPUImageSepiaFilter alloc] init];
    //    filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.5, 0.5, 0.5, 0.5)];
    //    secondFilter = [[GPUImageSepiaFilter alloc] init];
    //    terminalFilter = [[GPUImageSepiaFilter alloc] init];
    //    [filter addTarget:secondFilter];
    //    [secondFilter addTarget:terminalFilter];
    
    //	[filter prepareForImageCapture];
    //	[terminalFilter prepareForImageCapture];
    
    [stillCamera addTarget:currentFilter];
    
    GPUImageView *filterView = (GPUImageView *)self.view;
    //    [filter addTarget:filterView];
    [currentFilter addTarget:filterView];
    //    [terminalFilter addTarget:filterView];
    
    //    [stillCamera.inputCamera lockForConfiguration:nil];
    //    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    //    [stillCamera.inputCamera unlockForConfiguration];
    
//    [stillCamera startCameraCapture];
    
    //    UIImage *inputImage = [UIImage imageNamed:@"Lambeau.jpg"];
    //    memoryPressurePicture1 = [[GPUImagePicture alloc] initWithImage:inputImage];
    //
    //    memoryPressurePicture2 = [[GPUImagePicture alloc] initWithImage:inputImage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateSliderValue:(id)sender
{
    [(GPUImagePixellateFilter *)currentFilter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
    [(GPUImageGammaFilter *)currentFilter setGamma:[(UISlider *)sender value]];
}

#pragma -mark 拍照
- (IBAction)takePhoto:(id)sender;
{
    [photoCaptureButton setEnabled:NO];
    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:currentFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:stillCamera.currentCaptureMetadata];
        [temp setObject:[NSNumber numberWithInt:1] forKey:@"Orientation"]; //your value
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:temp completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
                 
                 PhotoEidtController *eidtPhotoVC = [[PhotoEidtController alloc] initWithNibName:@"PhotoEidtController" bundle:nil];
                 eidtPhotoVC.assetURL = assetURL;
                 [self.navigationController pushViewController:eidtPhotoVC animated:YES];
             }
             
             runOnMainQueueWithoutDeadlocking(^{
                 [photoCaptureButton setEnabled:YES];
             });
         }];
    }];
}

#pragma mark 白平衡
- (void)selectWhiteBlance{
    if (self.isBlanceSelectViewIsShow) {
        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        [UIView animateWithDuration:0.25 animations:^{
            self.whiteBlanceSelectView.frame = CGRectMake(mainScreenFrame.size.width, 60, blanceViewWidth, blanceViewHeight);
        }];
        [self.whiteBlanceSelectView removeFromSuperview];
        self.isBlanceSelectViewIsShow = false;
    }else{
        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:self.whiteBlanceSelectView];
        [UIView animateWithDuration:0.25 animations:^{
            self.whiteBlanceSelectView.frame = CGRectMake(mainScreenFrame.size.width - blanceViewWidth, 60, blanceViewWidth, blanceViewHeight);
        }];
        self.isBlanceSelectViewIsShow = true;
    }
}

-(UIView *)whiteBlanceSelectView{
    if (!_whiteBlanceSelectView) {
        CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
        _whiteBlanceSelectView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenFrame.size.width, 60, blanceViewWidth, blanceViewHeight)];
        _whiteBlanceSelectView.backgroundColor = [UIColor whiteColor];
        
        int line = 0;
        int row = 0;
        CGFloat viewHeight = (blanceViewHeight - 4 * offset) / lineCount;
        CGFloat viewWidth  = (blanceViewWidth - 2 *offset) / rowCount;
        for (int i = 0; i < 6; i++){
            line = i / rowCount;
            row = i % rowCount;
            LBLog(@"line : %d     row : %d",line,row);
            GPUImageView *fliterView = [[GPUImageView alloc] initWithFrame:CGRectMake(offset* (row + 1) + viewWidth *row, line * viewHeight + (line+1)*offset, viewWidth, viewHeight)];
            fliterView.fillMode = kGPUImageFillModeStretch;
            fliterView.tag = i;
            UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blanceSelectSelectView:)];
            [fliterView addGestureRecognizer:tapGuesture];
            
            GPUImageWhiteBalanceFilter *specialFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            [specialFilter setTemperature:2000 + (i * 1000)];
//            [specialFilter setTint:-200 + (i * 100)];
            
            [specialFilter forceProcessingAtSize:fliterView.sizeInPixels];
            
            [stillCamera addTarget:fliterView];
            [stillCamera addTarget:specialFilter];
            [specialFilter addTarget:fliterView];
            
            
            [_whiteBlanceSelectView addSubview:fliterView];
        }
        
    }
    return _whiteBlanceSelectView;
}

#pragma 点击选择白平衡View
- (void)blanceSelectSelectView:(UITapGestureRecognizer *)tapGesture{
    [self selectWhiteBlance];
    NSInteger i = tapGesture.view.tag;
    [(GPUImageWhiteBalanceFilter *)currentFilter setTemperature:2000 + (i * 1000)];
    LBLog(@" i : %ld",i);
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

@end
