//
//  CCSideSlipView.m
//  CCSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
#define SLIP_WIDTH 150

#import "CCSideSlipView.h"
#import <Accelerate/Accelerate.h>

@interface CCSideSlipView()
@property (nonatomic,strong) UIView *backView;
@end

@implementation CCSideSlipView
-(UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(nil, @"please init with -initWithSender:sender");
    }
    return self;
}

- (instancetype)initWithSender:(UIViewController*)sender{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(-SLIP_WIDTH, 0, SLIP_WIDTH, bounds.size.height);
    LBLog(@"frameString : %@",NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViews:sender];
    }
    return self;
}

-(void)buildViews:(UIViewController*)sender{
    _sender = sender;
    //_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMenu)];
    //_tap.numberOfTapsRequired = 1;
    
    _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    _tapGest.delegate = self;
    
    //[_sender.view addGestureRecognizer:_tap];
    [self.backView addGestureRecognizer:_leftSwipe];
    [sender.view addGestureRecognizer:_rightSwipe];
    
    _blurImageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.userInteractionEnabled = YES;
    _blurImageBackView.userInteractionEnabled = YES;
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor grayColor];
    //_blurImageView.layer.borderWidth = 5;
    //_blurImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_blurImageBackView addSubview:_blurImageView];
    [self.backView addSubview:_blurImageBackView];
    [self.backView addGestureRecognizer:_tapGest];
}

-(void)setContentView:(UIView*)contentView{
    if (contentView) {
        _contentView = contentView;
    }
    _contentView.frame = CGRectMake(0, 25, self.frame.size.width, self.frame.size.height);
    [self addSubview:_contentView];
}

-(void)show:(BOOL)show{
    UIImage *image =  [self imageFromView:_sender.view];
    if (!isOpen) {
        _blurImageView.alpha = 1;
        _blurImageBackView.alpha = 0.0;
        self.backView.alpha = 1.0;
        [_sender.view insertSubview:self.backView belowSubview:self];
    }
    
    CGFloat x = show?0:-SLIP_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
        if(!isOpen){
            _blurImageView.image = image;
            _blurImageBackView.alpha = 1.0;
            _blurImageBackView.image = [self blurryImage:_blurImageView.image withBlurLevel:0.1];
            _blurImageView.image= [self blurryImage:_blurImageView.image withBlurLevel:0.1];
            _blurImageView.frame = CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }else{
            _blurImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }completion:^(BOOL finished) {
        isOpen = show;
        if(!isOpen){
            [self.backView removeFromSuperview];
            _blurImageView.alpha = 0;
            _blurImageBackView.alpha = 0.0;
            _blurImageView.image = nil;
        }
    }];
}


-(void)switchMenu{
    [self show:!isOpen];
}
-(void)show{
    [self show:YES];

}

-(void)hide {
    [self show:NO];
}


#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Blur


- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

#pragma UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isMemberOfClass:[UITableViewCell class]]){
//        return false;
//    }else{
        return true;
//    }
}

@end
