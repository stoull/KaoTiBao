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
#import "KTBUserManager.h"
#import "KTBBaseDataStorer.h"

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

// 自动
+ (void)atuoLoginSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                    failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    
    NSString *loginType = @"";
    NSString *userName = currentUser.username;
    NSString *password = currentUser.password;
    //        NSString *password = [LBMD5 getmd5WithString:self.passwordTextField.text];
    NSString *phoneType = [UIDevice phoneAndOperartionSysInfor];
    
    if ([HolomorphyValidate validatePhoneNumberWithText:userName]) {
        loginType = @"3";
    }else if ([HolomorphyValidate validateEmailWithText:userName]){
        loginType = @"2";
    }else{
        loginType = @"1";
    }
    NSDictionary *paraDic = @{@"loginname" : userName,
                              @"password"  : password,
                              @"loginType" : loginType,
                              @"phoneType" : phoneType};
    [[LBNetworker HTTPManager] POST:kAPILogin parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

// 修改密码
+ (void)changePasswordWithParaDic:(nonnull NSDictionary *)resestParaDic
                      successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                         failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    [[LBNetworker HTTPManager] POST:kAPIChangePass parameters:resestParaDic progress:^(NSProgress * _Nonnull uploadProgress) {
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

// 激活荧光笔
+ (void)activatePenWithAcId:(nonnull NSString *)acId
                 successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                    failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    NSDictionary *actParaDic = @{@"userId" : [NSNumber numberWithInteger:currentUser.userId],
                                   @"acId" : acId};
    [[LBNetworker HTTPManager] POST:kAPIActivate
                         parameters:actParaDic
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

// 获取所有激活码信息 如果是全部的话 就填all 如果是其它的话那就是
+ (void)getAllACsWithColor:(nonnull NSString *)color
                successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                   failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    NSString *colorStr;
    if ([color isEqualToString:@"all"]) {
        colorStr = @"";
    }else{
        colorStr = color;
    }
    NSDictionary *actParaDic = @{@"userId" : [NSNumber numberWithInteger:currentUser.userId],
                                 @"color" : colorStr,
                                 @"option" : @"1"};
    [[LBNetworker HTTPManager] POST:kAPIGetACs
                         parameters:actParaDic
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

// 获取系统信息
+ (void)getSystemInfoSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                        failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    NSDictionary *actParaDic = @{@"userId" : [NSNumber numberWithInteger:currentUser.userId]};
    [[LBNetworker HTTPManager] POST:kAPISysInfo
                         parameters:actParaDic
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

//获取用户信息 其中包括 可用的笔的信息
+ (void)getUserSettingsSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                          failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    NSDictionary *actParaDic = @{@"userId" : [NSNumber numberWithInteger:currentUser.userId]};
    [[LBNetworker HTTPManager] POST:kGetUserSettings
                         parameters:actParaDic
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
                                if (dataDic) {
                                    [KTBBaseDataStorer saveColorPenInfo:dataDic];
                                }
                                successHandler(status,emsg,dataDic);
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
                                failureHandler(errorMessage);
                            }];
}

//设置默认颜色
+ (void)setDefaultColorWithColor:(nonnull NSString *)color
                      successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                         failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    KTBUser *currentUser = [KTBUserManager currentUser];
    NSDictionary *actParaDic = @{@"userId" : [NSNumber numberWithInteger:currentUser.userId],
                                 @"defaultColor" : color};
    [[LBNetworker HTTPManager] POST:kGetUserSettings
                         parameters:actParaDic
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
                                if (dataDic) {
                                    [KTBBaseDataStorer saveColorPenInfo:dataDic];
                                }
                                successHandler(status,emsg,dataDic);
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSString *errorMessage = error.userInfo[@"NSLocalizedDescription"];
                                failureHandler(errorMessage);
                            }];
}

/*
 userId			用户id
 username		用户名/昵称，当前界面不可更改，提供链接， 点击进入用户名修改界面
 password		密码，当前界面不可更改，提供链接， 点击进入密码修改界面
 email			电子邮件，当前界面不可更改，提供链接， 点击进入email修改界面
 
 可选修改：
 phoneNumber		手机号，当前界面不可更改，提供链接， 点击进入手机号修改界面
 name			真实姓名
 age			年纪
 gender			性别，男，女，保密，未知
 birthday			生日
 address			住址
 region			国家/地区/省份，如内地各大城市，香港/台湾/美国等等
 school			学校
 job			职业
 phoneType		手机型号，比如iphone/华为/三星/小米/oppo/索尼/nokia/乐视/魅族/360
 phoneVersion		手机版本
 phoneInfo		手机信息，包括机型/尺寸/内存信息/存储空间信息/手机版本 等等
 sns			社交网站 信息， 比如qq号/微信号/微博号/人人号 等等
 */

+ (void)changeUserInfoWithParaDic:(nonnull NSDictionary *)resestParaDic
                       successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                          failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler{
    [[LBNetworker HTTPManager] POST:kAPIModuser parameters:resestParaDic progress:^(NSProgress * _Nonnull uploadProgress) {
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
@end
