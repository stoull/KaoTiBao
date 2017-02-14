//
//  UIImage+ChangeSize.h
//  LeYaoXiu
//
//  Created by AChang on 6/16/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChangeSize)

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//指定宽度按比例缩放
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//指定高度按比例缩放
+(UIImage *) imageCompressForHeight:(UIImage *)sourceImage targetHeight:(CGFloat)defineHeigth;

// 调整图片大小(指定大小)
-(UIImage *)scaleImageToSize:(CGSize)size;


// 切圆并描边
+ (UIImage *)scaleRoundImage:(UIImage *)image withStrokeColor:(UIColor *)color;

// 切圆并描边并加上选中的勾
+ (UIImage *)scaleRoundAndAddATrickWithImage:(UIImage *)image withStrokeColor:(UIColor *)color;


@end
