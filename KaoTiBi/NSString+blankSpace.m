//
//  NSString+removeBlankSapce.m
//  LinkPortal
//
//  Created by Stoull Hut on 8/24/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "NSString+blankSpace.h"

@implementation NSString (blankSpace)

// 去除空格
+ (NSString *)removeBlankSpace:(NSString *_Nonnull)string{
    if (string == nil) {
        return @"";
    }
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    string = [filteredArray componentsJoinedByString:@""];
    return string;
}

@end
