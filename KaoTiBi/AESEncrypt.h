//
//  LBEncryption.h
//  LinkPortal
//
//  Created by Stoull Hut on 8/23/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESEncrypt : NSObject

// gkey 16位自定义密码
+ (NSString*) AES128Encrypt:(NSString *)plainText withGKey:(NSString *)gkey;

+ (NSString*) AES128Decrypt:(NSString *)encryptText withGKey:(NSString *)gkey;


@end
