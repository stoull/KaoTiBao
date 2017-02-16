//
//  Document.h
//  KaoTiBi
//
//  Created by linkapp on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject
@property (nonatomic, copy)     NSString    *date;     // yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy)     NSString    *dateName; // yyyyMMddHHmmss;
@property (nonatomic, copy)     NSString    *identifierYear;     // 年标识
@property (nonatomic, copy)     NSString    *identifierMonth;   // 月标识 yyyy-MM
@property (nonatomic, copy)     NSString    *identifierDay;     // 日标识 yyyy-MM-dd
@property (nonatomic, copy)     NSString    *folderName;          // 文件夹名称
@property (nonatomic, assign)   int16_t   year;     // 年
@property (nonatomic, assign)   int16_t   month;    // 月
@property (nonatomic, assign)   int16_t   day;      // 日
@property (nonatomic, copy)     NSString    *name;     // 文件名
@property (nonatomic, copy)     NSString    *describleString; // 文件描述
@property (nonatomic, assign)   int16_t   classfiy; // 难易度分类
@property (nonatomic, assign)   int64_t      fileSize; // 文件大小
@property (nonatomic, copy)     NSString    *path;    // 文件相对路径
@property (nonatomic, copy)     NSString    *assetURLString;    // 对应相册中的原图的AssetURL(因存储问题转成String类型)
@property (nonatomic, assign)   BOOL        isDelete; // 是否已删除
@property (nonatomic, assign)   BOOL        isSync;     // 是否已和服务同步
@property (nonatomic, assign)   int32_t   viewcount;  // 查看次数

- (instancetype)initWithAssetURL:(NSURL *)assetUrl;
// 存入数据库
- (void)saveToDataBase;
+ (Document *)copyWithManagedObject:(Document *)obDocument;
@end
