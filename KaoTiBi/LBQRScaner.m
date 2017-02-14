//
//  LBQRScaner.m
//  LinkPortal
//
//  Created by Stoull Hut on 10/3/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBQRScaner.h"
#import <AVFoundation/AVFoundation.h>
#import "LBQRFilePreview.h"

@interface LBQRScaner ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *scanWindow;
@end

@implementation LBQRScaner

-(UIImageView *)scanWindow{
    if (!_scanWindow) {
        _scanWindow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _scanWindow.center = self.view.center;
        _scanWindow.image = [UIImage imageNamed:@"QRScaner"];
        [self.view addSubview:_scanWindow];
    }
    return _scanWindow;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描";
    [self createQRScaner];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noPermission", @"express user have not permission") message:NSLocalizedString(@"appNeedAlbumPermission", @"请到设置里面，设置允许文件云访问手机的相机！") delegate:self cancelButtonTitle:NSLocalizedString(@"confirm",@"") otherButtonTitles:nil];
        [alertView show];
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonInde{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)createQRScaner{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:self.scanWindow.bounds readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        LBQRFilePreview *filePreview = [[LBQRFilePreview alloc] init];
        filePreview.fileUrl = metadataObject.stringValue;
        [self.navigationController pushViewController:filePreview animated:YES];
    }
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}



@end
