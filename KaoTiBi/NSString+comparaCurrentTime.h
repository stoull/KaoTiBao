//
//  NSString+comparaCurrentTime.h
//  LinkPortal
//
//  Created by Stoull Hut on 17/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (comparaCurrentTime)

+ (NSString *)compareCurrentTime:(NSString *)str;

+ (NSString *)getYear:(NSString *)str;

+ (NSString *)getMonth:(NSString *)str;

+ (NSString *)getDay:(NSString *)st;

@end
