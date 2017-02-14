//
//  HUD.m
//
//  Created by AChang on 5/30/16.
//  Copyright © 2016 AChang. All rights reserved.
//


#import "HUD.h"
#import "LBProgressView.h"

@interface HUD()
@property (nonatomic, strong) LBProgressView *progressView;

@property (nonatomic, strong)NSURLSessionDownloadTask *task;

@property (nonatomic, weak) UIWindow *mainWindow;

@end

@implementation HUD
singleton_implementation(HUD)
@dynamic progress;

-(UIWindow *)mainWindow{
    if (!_mainWindow) {
        _mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _mainWindow;
}

-(void)hintMessage:(NSString *_Nullable)message
{
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.mainWindow addSubview:self];
    
    self.mode = MBProgressHUDModeText;
    self.label.text = message;
    [self showAnimated:YES];
    [self hideAnimated:YES afterDelay:2.0];
}

- (void)showActivityWithText:(NSString *_Nullable)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self.mainWindow addSubview:self];
        self.mode = MBProgressHUDModeIndeterminate;
        self.label.text = text;
        [self showAnimated:YES];
    });
}

-(void)setProgress:(float)progress{
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super setProgress:progress];
            self.progress = progress;
            
            if (self.mode == MBProgressHUDModeCustomView) {
                self.progressView.progress = progress;
            }
//            self.progressView.progress = progress;
        });
    }
}

- (void)showProgressWithText:(NSString *_Nullable)text{
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.mainWindow addSubview:self];
    self.progress = 0.0;
    
    self.mode = MBProgressHUDModeDeterminate;
    
//    self.mode = MBProgressHUDModeCustomView;
//    self.progressView = [[LBProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    self.progressView.center = view.center;
//    [self addSubview:self.progressView];
    self.label.text = text;
    [self showAnimated:YES];
}

- (void)showProgressWithText:(NSString *_Nullable)text withTask:(NSURLSessionDownloadTask *)task{
    if (task != nil) {
        _task = task;
    }
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self.mainWindow addSubview:self];
    self.progress = 0.0;
    self.mode = MBProgressHUDModeDeterminate;
    
    self.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.backgroundView.color =[UIColor colorWithWhite:0.f alpha:.2f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHUDView:)];
    [self addGestureRecognizer:tapGesture];
    
    //    self.mode = MBProgressHUDModeCustomView;
    //    self.progressView = [[LBProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    self.progressView.center = view.center;
    //    [self addSubview:self.progressView];
    self.label.text = text;
    [self showAnimated:YES];
    
}

- (void)showActivityWithText:(NSString *_Nullable)text withTask:(NSURLSessionDownloadTask *)task{
    if (task != nil) {
        _task = task;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self.mainWindow addSubview:self];
        self.mode = MBProgressHUDModeIndeterminate;
        self.label.text = text;
        [self showAnimated:YES];
    });

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHUDView:)];
    [self addGestureRecognizer:tapGesture];
    
    //    self.mode = MBProgressHUDModeCustomView;
    //    self.progressView = [[LBProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //    self.progressView.center = view.center;
    //    [self addSubview:self.progressView];
    self.label.text = text;
    [self showAnimated:YES];
    
}



- (void)hidden{
    if (_task != nil) {
        [_task cancel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideAnimated:YES];
    });
}

-(void)removeFromSuperview{
    if (_task != nil) {
        [_task cancel];
    }
}

- (void)didTapHUDView:(UITapGestureRecognizer *)tapGesture{
    [self hidden];
    if (_task != nil) {
        [_task cancel];
        _task = nil;
    }
}

@end


