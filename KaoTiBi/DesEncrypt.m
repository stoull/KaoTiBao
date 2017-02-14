//
//  DesEncrypt.m
//  LinkPortal
//
//  Created by Stoull Hut on 25/10/2016.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "DesEncrypt.h"
#import "Base64.h"
#import <CommonCrypto/CommonCryptor.h>
const Byte iv[] = {1,2,3,4,5,6,7,8};
@implementation DesEncrypt
#pragma mark- 加密算法
+(NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [Base64 base64Encode:data];
    }
//    ciphertext = [ciphertext stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return ciphertext;
}
#pragma mark- 解密算法
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [Base64 base64Decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

+(NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key andiv:(NSString *)iv
{
    //这个iv 是DES加密的初始化向量，可以用和密钥一样的MD5字符
    NSData * date = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSString *ciphertext = nil;
    NSUInteger dataLength = [clearText length];
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,//加密模式 kCCDecrypt 代表解密
                                          kCCAlgorithmDES,//加密方式
                                          kCCOptionPKCS7Padding,//填充算法
                                          [key UTF8String], //密钥字符串
                                          kCCKeySizeDES,//加密位数
                                          [date bytes],//初始化向量
                                          [textData bytes]  ,
                                          dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [DesEncrypt parseByteArray2HexString:bb];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

+(NSString *)parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}


@end
