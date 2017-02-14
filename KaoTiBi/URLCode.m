//
//  URLCode.m
//  LinkPortal
//
//  Created by Stoull Hut on 26/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "URLCode.h"

@implementation URLCode

// URLEncode
+ (NSString *)urlEncodeString:(NSString *)plainText{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)plainText,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

// URLDEcode
+(NSString *)urlDecodeString:(NSString*)encodedString
{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
