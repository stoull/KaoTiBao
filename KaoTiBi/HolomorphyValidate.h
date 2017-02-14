//
//  LYHolomorphyValidate.h
//  LeYaoXiu
//
//  Created by AChang on 5/31/16.
//  Copyright © 2016 AChang. All rights reserved.
//

// 正则变换 判断字符的合法性

#import <Foundation/Foundation.h>

@interface HolomorphyValidate : NSObject

/*! 判断string是否为空（非正则表达式）*/
+ (BOOL)isEmptyWithText:(NSString * _Nonnull)text;

/*! 判断邮箱是否正确*/

+ (BOOL)validateEmailWithText:(NSString *_Nonnull)text;

/*! 判断验证码是否正确*/

+ (BOOL)validateAuthenWithText:(NSString *_Nonnull)text;

/*! 判断密码格式是否正确*/

+ (BOOL)validatePasswordWithText:(NSString *_Nonnull)text;

/*! 判断手机号码是否正确*/

+ (BOOL)validatePhoneNumberWithText:(NSString *_Nonnull)text;

/*! 自己写正则传入进行判断*/

+ (BOOL)validateWithRegExp: (NSString *_Nonnull)regExp WithText:(NSString *_Nonnull)text;

//-(BOOL)validateQQWithText:(NSString *_Nonnull)text;

// 判断是否都为数字
+ (BOOL)isAllNum:(NSString *_Nonnull)string;

// 判断是否有特殊字符
+ (BOOL)checkIsHaveSpecialCharaterWithString:(NSString *_Nonnull)userName;

//判断是否有中文
+ (BOOL)isHasChinese:(NSString *_Nonnull)str;

@end
