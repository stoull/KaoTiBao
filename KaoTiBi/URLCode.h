//
//  URLCode.h
//  LinkPortal
//
//  Created by Stoull Hut on 26/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCode : NSObject
// URLEncode
+ (NSString *)urlEncodeString:(NSString *)plainText;

// URLDEcode
+(NSString *)urlDecodeString:(NSString*)encodedString;
@end
