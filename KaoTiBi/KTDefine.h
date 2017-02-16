//
//  KTDefine
//  KTDefine
//
//  Created by Hut on 8/22/16.
//  Copyright © 2017 CCApril. All rights reserved.
//

#ifndef KTDefine_h
#define KTDefine_h
//typedef enum : NSInteger {
//    ClassSortTypeYiNianJi = 0, // 一年级
//    ClassSortTypeErNianJi,
//    ClassSortTypeSanNianJi,
//    ClassSortTypeSiNianJi,
//    ClassSortTypeWuNianJi,
//    ClassSortTypeLiuNianJi,
//    ClassSortTypeChuYi,     // 初一
//    ClassSortTypeChuEr,
//    ClassSortTypeChuSan,
//    ClassSortTypeGaoYi,     // 高一
//    ClassSortTypeGaoEr,
//    ClassSortTypeGaoSan
//}ClassSortType;

typedef enum : NSInteger {
    KTBDocManagerTypeByTime = 0,    // 按时间排序
    KTBDocManagerTypeByFileSystem   // 按文件系统管理
}KTBDocManagerType;

typedef enum : NSInteger {
    KTBDocManagerTimeSortTypeDay,
    KTBDocManagerTimeSortTypeMonth,
    KTBDocManagerTimeSortTypeYear
}KTBDocManagerTimeSortType;

#pragma mark -网络API

#pragma mark -消息通知

/* ================= Userdefault keys =================*/
#pragma mark -Userdefault keys
// 服务器地址 value 为字符串
#define kKTServerDomain @"http://120.77.250.30/"

// 当前网络状态 value 为 LBNetworkStatus
#define kCurrentNetWorkStatus @"kLBCurrentNetWorkStatus"

// 当前用户选择的是那一种管理方式 value  为 KTBDocManagerType
#define kKTBDocManagerType @"kKTBDocManagerType"

// 当前用户选择的是那一种时间维度查看 value  为 kKTBDocManagerType
#define kKTBDocManagerTimeSortType @"kKTBDocManagerTimeSortType"

// 是否是本地授权 value 为 BOOL
#define kisLocalAuthorization @"kLBIsLocalAuthorization"

// 是否是本地试用 value 为 BOOL
#define kisOnTrial @"kisOnTrial"

// 是否需要更新数据，主要是单例中的Get方法中使用 value 为 BOOL
#define kIsNeedUpdateSingle @"kIsNeedUpdateSingle"

// 是否是仅wifi传输 value 为 BOOL
#define kIsTransferOnlyWifi @"kIsTransferOnlyWifi"

// 记录用户仅wifi传输情况下对是否用移动网络进行传输的选择，每次程序启动的时候判断次 value 为 BOOL
#define kUserTransferPreferenceUsingMobileNetwork @"kUserChooseTransferUsingWifi"
// 记录用户是否有移动文件的操作,如果有值则有需要刷新的目录，对应的值为NSInterge,即对应的pid
#define kMoveTagrgtePid  @"kMoveTagretPid"

#pragma mark -文件存储路径
/* ================= 文件存储路径 =================*/


//-------------------文件目录-------------------------

#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 存储打开文件时下载的文件的临时目录路径
#define kPathFileOpenTemp         [kPathTemp stringByAppendingPathComponent:@"FileOpenCache"]

// 存储用户登录信息的路径
#define kAccountStoragePath [kPathDocument stringByAppendingPathComponent:@"accountLogConfig"]

#endif /* LinkPortalDefine_h */
