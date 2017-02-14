//
//  UIImage+UICycle.m
//  CCMusicPlayer
//
//  Created by April on 6/16/15.
//  Copyright (c) 2015 gunzi. All rights reserved.
//

#import "UIImage+UICycle.h"

@implementation UIImage (UICycle)


+(UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth boraderColor:(UIColor *)borderColor
{
    //1.开启上下文
    UIImage *sourceImage = [UIImage imageNamed:name];
    
    CGFloat imageWidth = sourceImage.size.width +2 *borderWidth;
    CGFloat imageHieght = sourceImage.size.height + 2*borderWidth;
    //
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHieght), NO, 0);
    //    //2.获取上下文
    UIGraphicsGetCurrentContext(); //CGContextRef context = UIGraphicsGetCurrentContext();
    // 3. 画圆
    CGFloat radius = sourceImage.size.width<sourceImage.size.height ? sourceImage.size.width *0.5 :sourceImage.size.height*0.5;
    // 4.使用bezierPath时行剪切
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHieght*0.5) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [borderColor setStroke];
    [bezierPath stroke];
    //5.剪切
    [bezierPath addClip];
    
    //5.从内存中创建新建的图片对象
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    //6.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)scaleImage:(UIImage *)sourceImage toSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

// 给照片去色
-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth boraderColor:(UIColor *)borderColor{
    //1.开启上下文
    UIImage *sourceImage = image;
    CGFloat imageWidth = sourceImage.size.width +2 *borderWidth;
    CGFloat imageHieght = sourceImage.size.height + 2*borderWidth;
    //
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHieght), NO, 0);
    //    //2.获取上下文
    UIGraphicsGetCurrentContext(); //CGContextRef context = UIGraphicsGetCurrentContext();
    // 3. 画圆
    CGFloat radius = sourceImage.size.width<sourceImage.size.height ? sourceImage.size.width *0.5 :sourceImage.size.height*0.5;
    // 4.使用bezierPath时行剪切
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHieght*0.5) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [borderColor setStroke];
    [bezierPath stroke];
    //5.剪切
    [bezierPath addClip];
    
    //5.从内存中创建新建的图片对象
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}
@end
