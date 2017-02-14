//
//  LYHolomorphyValidate.m
//  LeYaoXiu
//
//  Created by AChang on 5/31/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "HolomorphyValidate.h"
@implementation HolomorphyValidate

+ (BOOL)isEmptyWithText:(NSString *)text
{
    return text.length == 0;
}

+ (BOOL)validateEmailWithText:(NSString *)text
{
    return [self validateWithRegExp: @"^[a-zA-Z0-9]{4,}@[a-z0-9A-Z]{2,}\\.[a-zA-Z]{2,}$" WithText:text];
}

+(BOOL)validateQQWithText:(NSString *)text
{
    //匹配输入的联系方式
    NSString *patternQQ = @"^[1-9](\\d){4,9}$";
  
    return [self validateWithRegExp:patternQQ WithText:text];

}
+ (BOOL)validateAuthenWithText:(NSString *)text
{
    return [self validateWithRegExp: @"^\\d{5,6}$" WithText:text];
}


+ (BOOL)validatePasswordWithText:(NSString *)text
{
    NSString * length = @"^\\w{6,20}$";//长度
    NSString * number = @"^\\w*\\d+\\w*$";//数字
    NSString * lower = @"^\\w*[a-z]+\\w*$";//小写字母
    NSString * upper = @"^\\w*[A-Z]+\\w*$";//大写字母
    return [self validateWithRegExp: length WithText:text] && [self validateWithRegExp: number WithText:text] && [self validateWithRegExp: lower WithText:text] && [self validateWithRegExp: upper WithText:text];
    return [self validateWithRegExp: length WithText:text];
}

+ (BOOL)validatePhoneNumberWithText:(NSString *)text

{
     NSString * reg = @"^1\\d{10}$";
    return [self validateWithRegExp:reg WithText:text];
}

+ (BOOL)validateWithRegExp: (NSString *)regExp WithText:(NSString *)text
{
     NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    
    return [predicate evaluateWithObject:text];
}

+ (BOOL)isAllNum:(NSString *)string
{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

// 判断是否有特殊字符
+ (BOOL)checkIsHaveSpecialCharaterWithString:(NSString *)str
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/\\:*?\"<>|"];
    NSRange range = [str rangeOfCharacterFromSet:doNotWant];
    
    BOOL isHaveEmoji = [HolomorphyValidate stringContainsEmoji:str];
    
    if (isHaveEmoji || range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

//判断是否有中文
+ (BOOL)isHasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
