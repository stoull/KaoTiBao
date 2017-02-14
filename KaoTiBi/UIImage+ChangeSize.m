//
//  UIImage+ChangeSize.m
//  LeYaoXiu
//
//  Created by AChang on 6/16/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "UIImage+ChangeSize.h"

@implementation UIImage (ChangeSize)

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
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


//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
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

//指定高度按比例缩放
+(UIImage *)imageCompressForHeight:(UIImage *)sourceImage targetHeight:(CGFloat)defineHeigth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = defineHeigth;
    
    CGFloat targetWidth = (height * targetHeight) / width;
    
    CGSize size = CGSizeMake(targetWidth, targetHeight);
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

//调整图片大小
-(UIImage *)scaleImageToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleRoundImage:(UIImage *)image withStrokeColor:(UIColor *)color{
    // 描边大小
    CGFloat borderWidth = image.size.width / 20;

    UIImage *sourceImage = image;
    CGFloat imageWidth = sourceImage.size.width +2 *borderWidth;
    CGFloat imageHieght = sourceImage.size.height + 2*borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHieght), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, imageWidth * 0.5, imageHieght * 0.5, (imageWidth - borderWidth) * 0.5, 0, M_PI * 2, 0);
    
    if (!color) {
        color = [UIColor clearColor];
    }
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokePath(context);
    
    // 3. 画圆
    CGFloat radius = sourceImage.size.width<sourceImage.size.height ? sourceImage.size.width *0.5 :sourceImage.size.height*0.5;
    
    // 4.使用bezierPath时行剪切
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHieght*0.5) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //5.剪切
    [bezierPath addClip];
    
    //5.从内存中创建新建的图片对象
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 切圆并描边并加上选中的勾
+ (UIImage *)scaleRoundAndAddATrickWithImage:(UIImage *)image withStrokeColor:(UIColor *)color{
    // 描边大小
    CGFloat borderWidth = image.size.width / 20;
    
    UIImage *sourceImage = image;
    CGFloat imageWidth = sourceImage.size.width +2 *borderWidth;
    CGFloat imageHieght = sourceImage.size.height + 2*borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHieght), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, imageWidth * 0.5, imageHieght * 0.5, (imageWidth - borderWidth) * 0.5, 0, M_PI * 2, 0);
    
    if (!color) {
        color = [UIColor clearColor];
    }
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokePath(context);
    
    // 3. 画圆
    CGFloat radius = sourceImage.size.width<sourceImage.size.height ? sourceImage.size.width *0.5 :sourceImage.size.height*0.5;
    
    // 4.使用bezierPath时行剪切
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHieght*0.5) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //5.剪切
    [bezierPath addClip];
    
    //5.从内存中创建新建的图片对象
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    
    
    // 6. 将勾图片画入进去
    UIImage *gouImge = [UIImage imageNamed:@"tuijian_selectFollow.png"];
//    CGRect gouRect = CGRectMake(imageWidth / 4, imageHieght / 4, imageWidth / 2, imageHieght / 2);
    
    CGRect gouRect = CGRectMake(0, 0, imageWidth, imageHieght);
    
    [gouImge drawInRect:gouRect blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
