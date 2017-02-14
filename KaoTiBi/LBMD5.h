//
//  LBMD5.h
//  LinkPortal
//
//  Created by Stoull Hut on 9/20/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMD5 : NSObject

// 计算文件的md5
+ (NSString *)fileMD5HashCreateWithPath:(NSString *)path;

+ (NSString*)getMD5WithData:(NSData *)data;

+ (NSString*)getmd5WithString:(NSString *)string;

@end
