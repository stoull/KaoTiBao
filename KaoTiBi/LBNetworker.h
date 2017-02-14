//
//  LBNetworker.h
//  LinkPortal
//
//  Created by Stoull Hut on 8/23/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CCSingleton.h"

typedef enum : NSInteger{
    LBReachabilityStatusUnknown = -1,
    LBReachabilityStatusNotReachable = 0,
    LBReachabilityStatusWWAN = 1,
    LBReachabilityStatusWiFi = 2
}LBNetworkStatus;

@interface LBNetworker : NSObject
singleton_interface(LBNetworker)
+ (AFHTTPSessionManager *)HTTPManager;

+ (AFURLSessionManager *)sessionManager;

// // 监测网络状态
+ (void)moinitorNetworking;


+ (BOOL)isChangeToDiffernetNetworkStatus;

/**
 *  清除Cookie
 */
+ (void)clearCookie;

// 获取当前网络状态
+ (LBNetworkStatus)networkStatus;

+ (NSMutableURLRequest *)defaultSessionManagerRequestWith:(NSString *)path;


FOUNDATION_EXPORT NSString * const LBNetworkStatusDidChangeNotification;

// 将Data类型转换成NSDictionary
+ (NSDictionary *)convertResposeObjectToDictionary:(id)responseObject;

@end
