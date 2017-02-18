//
//  KTBBaseAPI.h
//  KaoTiBi
//
//  Created by Stoull Hut on 26/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum:NSInteger {
    kTBAPIResponseStatusSuccessful = 1, //  1 表示成功，
    kTBAPIResponseStatusError,          //  2 表示失败，
    kTBAPIResponseStatusServiceError,   //  3 表示异常，
    kTBAPIResponseStatusUnkonwError     //  4 表示请求超时或 无响应
}kTBAPIResponseStatus;

@interface KTBBaseAPI : NSObject

/* 注册
 parameterDic必填：
 username		用户名/昵称
 password		密码
 comfirmPassword	重复密码
 email			电子邮件， 不为空则需要验证是否可用，验证功能先不做
 
 选填：
 phoneNumber		手机号， 不为空则需要验证是否可用，是否为当前手机号，验证功能先不做
 name			真实姓名，必须是2-4个汉字，一旦认证后， 不可更改
 type			证件类型
 code			证件号码
 age			年纪
 gender			性别，男，女，保密，未知
 birthday			生日
 address			住址
 region			国家/地区/省份，如内地各大城市，香港/台湾/美国等等
 school			学校
 grade			年级
 job			职业
 phoneType		手机型号，比如iphone/华为/三星/小米/oppo/索尼/nokia/乐视/魅族/360
 phoneVersion		手机版本
 phoneInfo		手机信息，包括机型/尺寸/内存信息/存储空间信息/手机版本 等等
 sns			社交网站 信息， 比如qq号/微信号/微博号/人人号 等等
 */
+ (void)registerWithParameter:(nonnull NSDictionary *)parameterDic
                       successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable msg, NSString * _Nullable emsg))successHandler
                          failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 登录
+ (void)loginWithParameter:(nonnull NSDictionary *)parameterDic
                successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                   failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;
// 自动
+ (void)atuoLoginSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                   failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 注销
+ (void)logoutWithUserId:(NSInteger)userId
              successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                 failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 获取重置密码的验证码及key
+ (void)getForgetPassInfoWithUserName:(nonnull NSString *)loginname
                           successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                              failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;
// 忘记密码，重置密码
/*
 loginname		登录名， 可以是 email， phoneNumber,  关联好友号username。。
 loginType		登录方式， 2 email， 3 phoneNumber， 4 username2
 resetCodeKey		重置密码验证码的Key, forgetPass操作返回的key
 resetCode		重置密码验证码，这个参数是用户填写的
 newpassword		新密码
 comfirmPassword	重复密码
 */
+ (void)resetPasswordWithParaDic:(nonnull NSDictionary *)resestParaDic
                           successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                              failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;
// 修改密码
/*
 userId			用户id
 password		原密码
 newpassword		新密码
 comfirmPassword	重复密码
 vcodeKey		验证码key, 这个参数是进入changePass页面后，发送genVcode请求新生成的
 vcode			验证码, 这个参数是用户填写的

 */
+ (void)changePasswordWithParaDic:(nonnull NSDictionary *)resestParaDic
                       successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                          failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 激活荧光笔
+ (void)activatePenWithAcId:(nonnull NSString *)acId
                           successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                              failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 获取所有激活码信息 如果是全部的话 就填all 如果是其它的话那就是
+ (void)getAllACsWithColor:(nonnull NSString *)color
                 successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                    failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

//获取用户信息 其中包括 可用的笔的信息
+ (void)getUserSettingsSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                   failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

// 获取系统信息
+ (void)getSystemInfoSuccessful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                        failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;
// 获取验证码
+ (void)getVcodeWithUserName:(nonnull NSString *)loginname
                  successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                     failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

//设置默认颜色
+ (void)setDefaultColorWithColor:(nonnull NSString *)color
                      successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic))successHandler
                         failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

+ (void)changeUserInfoWithParaDic:(nonnull NSDictionary *)resestParaDic
                      successful:(nullable void (^)(kTBAPIResponseStatus status, NSString * _Nullable emsg))successHandler
                          failure:(nullable void (^)(NSString * _Nonnull errorMessage))failureHandler;

@end
