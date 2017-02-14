//
//  KTBBaseAPI.m
//  KaoTiBi
//
//  Created by Stoull Hut on 26/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBBaseAPI.h"
#import "KTBAPIDefine.h"
#import "LBNetworker.h"
#import "UIDevice+deviceModel.h"
#import "HolomorphyValidate.h"

@implementation KTBBaseAPI

+ (void)registerWithParameter:(nonnull NSDictionary *)parameterDic
                   successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable msg, NSString * _Nullable emsg))successHandler
                      failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    [[LBNetworker HTTPManager] POST:kAPIReginster parameters:parameterDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常",responseObject);
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSString *emsg = responseObject[@"emsg"];
        NSDictionary *dataDic = responseObject[@"data"];
        successHandler(status,msg,emsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

+ (void)loginWithParameter:(nonnull NSDictionary *)parameterDic
                successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                   failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    [[LBNetworker HTTPManager] POST:kAPILogin parameters:parameterDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常",responseObject);
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSString *emsg = responseObject[@"emsg"];
        NSDictionary *dataDic = responseObject[@"data"];
        successHandler(status,emsg,dataDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

// 注销
+ (void)logoutWithUserId:(NSInteger)userId
              successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                 failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    NSDictionary *paraDic = @{@"userId"     : [NSNumber numberWithInteger:userId],
                              @"phoneType"  : [UIDevice phoneAndOperartionSysInfor]};
    [[LBNetworker HTTPManager] POST:kAPILogout parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常");
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *emsg = responseObject[@"emsg"];
        successHandler(status,emsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

// 获取重置密码的验证码及key
+ (void)getForgetPassInfoWithUserName:(nonnull NSString *)loginname
                           successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                              failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    NSString *loginType;
    if ([HolomorphyValidate validatePhoneNumberWithText:loginname]) {
        loginType = @"3";
    }else if ([HolomorphyValidate validateEmailWithText:loginname]){
        loginType = @"2";
    }else{
        loginType = @"1";
    }
    NSDictionary *loginParaDic = @{@"loginname" : loginname,
                                   @"loginType" : loginType};
    [[LBNetworker HTTPManager] POST:kAPIForgetPass parameters:loginParaDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常",responseObject);
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSString *emsg = responseObject[@"emsg"];
        NSDictionary *dataDic = responseObject[@"data"];
        successHandler(status,emsg,dataDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

// 忘记密码，重置密码
+ (void)resetPasswordWithParaDic:(nonnull NSDictionary *)resestParaDic
                      successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                         failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    [[LBNetworker HTTPManager] POST:kAPIForgetPassReset parameters:resestParaDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常");
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *emsg = responseObject[@"emsg"];
        successHandler(status,emsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

+ (void)getVcodeWithUserName:(nonnull NSString *)loginname
                  successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                     failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    NSString *loginType;
    if ([HolomorphyValidate validatePhoneNumberWithText:loginname]) {
        loginType = @"3";
    }else if ([HolomorphyValidate validateEmailWithText:loginname]){
        loginType = @"2";
    }else{
        loginType = @"1";
    }
    NSDictionary *loginParaDic = @{@"loginname" : loginname,
                                   @"loginType" : loginType};
    [[LBNetworker HTTPManager] POST:kAPIGenVcode
                         parameters:loginParaDic
                           progress:^(NSProgress * _Nonnull uploadProgress) {
    }
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            successHandler(NO, @"返回数据异常",responseObject);
            return;
        }
        responseObject = [LBNetworker convertResposeObjectToDictionary:responseObject];
        kTBAPIResponseStatus status = (kTBAPIResponseStatus)[responseObject[@"status"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSString *emsg = responseObject[@"emsg"];
        NSDictionary *dataDic = responseObject[@"data"];
        successHandler(status,emsg,dataDic);
    }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
        failureHandler(errorMessage);
    }];
}

@end
