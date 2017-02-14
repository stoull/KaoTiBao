//
//  Base64.h
//  LinkPortal
//
//  Created by Stoull Hut on 25/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(NSString *)base64Encode:(NSData *)data;
+(NSData *)base64Decode:(NSString *)data;
NSString *AFBase64EncodedStringFromString(NSString *string);
@end
