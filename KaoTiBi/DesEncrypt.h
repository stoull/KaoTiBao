//
//  DesEncrypt.h
//  LinkPortal
//
//  Created by Stoull Hut on 25/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncrypt : NSObject

+(NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
@end
