//
//  Base64.m
//  LinkPortal
//
//  Created by Stoull Hut on 25/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "Base64.h"

@implementation Base64
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+(NSString *)base64Encode:(NSData *)data
{
    return [data base64EncodedStringWithOptions:0];
    
//    if (data.length == 0)
//        return nil;
//    
//    char *characters = malloc(data.length * 3 / 2);
//    
//    if (characters == NULL)
//        return nil;
//    
//    int end = data.length - 3;
//    int index = 0;
//    int charCount = 0;
//    int n = 0;
//    
//    while (index <= end) {
//        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
//        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
//        
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = encodingTable[d & 63];
//        
//        index += 3;
//        
//        if(n++ >= 14)
//        {
//            n = 0;
//            characters[charCount++] = ' ';
//        }
//    }
//    
//    if(index == data.length - 2)
//    {
//        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
//        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = encodingTable[(d >> 6) & 63];
//        characters[charCount++] = '=';
//    }
//    else if(index == data.length - 1)
//    {
//        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
//        characters[charCount++] = encodingTable[(d >> 18) & 63];
//        characters[charCount++] = encodingTable[(d >> 12) & 63];
//        characters[charCount++] = '=';
//        characters[charCount++] = '=';
//    }
//    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
//    return rtnStr;
    
}

+(NSData *)base64Decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

NSString *AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

@end
