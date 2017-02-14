//
//  LBNetworker.m
//  LinkPortal
//
//  Created by Stoull Hut on 8/23/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBNetworker.h"
#import "KTDefine.h"

static AFHTTPSessionManager *httpManager = nil;
static dispatch_once_t onceToken1;

static AFURLSessionManager *sessionManager = nil;
static dispatch_once_t onceToken2;

NSString * const LBNetworkStatusDidChangeNotification = @"cn.linkapp.LBNetworkStatusDidChange";

@implementation LBNetworker
singleton_implementation(LBNetworker)

+ (AFHTTPSessionManager *)HTTPManager{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *baseURLString = kKTServerDomain;
    dispatch_once(&onceToken1, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        if (baseURLString == nil) {
            LBLog(@"统一设置网络服务时，服务器站点为空！");
            httpManager = [[AFHTTPSessionManager alloc] init];
        }else{
            NSURL *baseURL = [NSURL URLWithString:baseURLString];
            httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:sessionConfiguration];
            
        }
        AFHTTPRequestSerializer *requestSerialization = [AFHTTPRequestSerializer serializer];
        //    [requestSerialization setValue:@"Accept" forHTTPHeaderField:@"application/json"];
        //    [requestSerialization setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        requestSerialization.timeoutInterval = 15;
        
        AFHTTPResponseSerializer *responseSerialization = [AFHTTPResponseSerializer serializer];
        responseSerialization.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
        
        // ssl安全策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        
        httpManager.requestSerializer = requestSerialization;
        httpManager.responseSerializer = responseSerialization;
        httpManager.securityPolicy = securityPolicy;
    });
    return httpManager;
}

+ (AFURLSessionManager *)sessionManager{
    dispatch_once(&onceToken2, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        // ssl安全策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        
        sessionManager.securityPolicy = securityPolicy;
    });
    return sessionManager;
}

+ (NSMutableURLRequest *)defaultSessionManagerRequestWith:(NSString *)path{
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod=@"GET";
    // 生成请求头
    NSMutableDictionary *defaultHeaders = [NSMutableDictionary dictionary];
    defaultHeaders[@"Accept"] = @"application/octet-stream";
    
    //构建请求头
    request.allHTTPHeaderFields = defaultHeaders;
    [request setCachePolicy: NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval: 15];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    return request;
}

// 监测网络类型
+ (void)moinitorNetworking{
    AFNetworkReachabilityManager *reachabilitymanager = [AFNetworkReachabilityManager sharedManager];
    [reachabilitymanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [userDef setInteger:LBReachabilityStatusUnknown forKey:kCurrentNetWorkStatus];
                LBLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [userDef setInteger:LBReachabilityStatusNotReachable forKey:kCurrentNetWorkStatus];
                LBLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [userDef setInteger:LBReachabilityStatusWWAN forKey:kCurrentNetWorkStatus];
                LBLog(@"正在使用3G网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [userDef setInteger:LBReachabilityStatusWiFi forKey:kCurrentNetWorkStatus];
                LBLog(@"正在使用wifi网络");
                break;
        }
        
        NSDictionary *networkStatus = @{@"kCurrentNetWorkStatus" : [NSNumber numberWithInteger:status]};
        [userDef synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:LBNetworkStatusDidChangeNotification object:networkStatus];
    }];
    [reachabilitymanager startMonitoring];
}

+ (LBNetworkStatus)networkStatus{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *baseURLString = kKTServerDomain;
    NSNumber *currentNetWorkStatus = [userDef objectForKey:kCurrentNetWorkStatus];
    if (baseURLString == nil) {
        baseURLString = @"https://www.baidu.com";
    }
    AFNetworkReachabilityManager *reachabilitymanager = [AFNetworkReachabilityManager managerForDomain:baseURLString];
    if (currentNetWorkStatus != nil) {
        return (LBNetworkStatus)[currentNetWorkStatus integerValue];
    }else{
        return (LBNetworkStatus)reachabilitymanager.networkReachabilityStatus;
    }
}


/**
 *  清除Cookie, 需要重新配置网络信息
 */
+ (void)clearCookie{
    onceToken1 = 0;
    onceToken2 = 0;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}

+ (NSDictionary *)convertResposeObjectToDictionary:(id)responseObject{
    // 如果返回的是 data 则转换成 json
    if ([responseObject isKindOfClass:[NSData class]])
    {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
        if (error) {
            NSLog(@"网络返回的数据类型不能转成JSON数据格式！：%@",error.userInfo);
            return nil;
        }else
            return dict;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) // 如果返回的是 json ，则直接回传
    {
        return responseObject;
    }else{
        NSLog(@"网络返回未知的数据类型");
        return nil;
    }
}

@end
