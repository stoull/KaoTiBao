//
//  IPAddress.h
//  LinkBox
//
//  Created by stoull on 2/19/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddress : NSObject

- (NSString *)getIPAddress:(BOOL)preferIPv4;
- (NSDictionary *)getIPAddressDic;
@end
