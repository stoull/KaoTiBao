//
//  NSString+countFileSize.m
//  LinkBox
//
//  Created by stoull on 1/9/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "NSString+countFileSize.h"

@implementation NSString (countFileSize)

#pragma -mark 计算文件大小转换
+ (NSString *)stringWithFileSize:(double)size{
    if (size < 1024 * 0.6 ) {
        return [NSString stringWithFormat:@"%.2lf B",size/1.0];
    }
    else if (size < 1024 * 1024 * 0.6)
    {
        return [NSString stringWithFormat:@"%.2lf KB",size/1024.0];
    } else if (size < 1024 * 1024 *1024 * 0.6)
    {
        return [NSString stringWithFormat:@"%.2lf M",size/1024.0/1024.0];
    }else
        return [NSString stringWithFormat:@"%.2lf G",size/1024/1024/1024.0];
}


@end
