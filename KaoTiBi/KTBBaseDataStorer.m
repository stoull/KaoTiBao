//
//  KTBBaseDataStorer.m
//  KaoTiBi
//
//  Created by Stoull Hut on 26/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBBaseDataStorer.h"
#import "KTDefine.h"
#import "KTBUserManager.h"

#define kDirectoryFileName @"colorPenInfo"

@implementation KTBBaseDataStorer
/*
 Printing description of resDic:
 {
 black = "";
 blue = "";
 cyan = "";
 dark = "";
 defaultColor = "";
 defaultName = "";
 defaultSize = "";
 defaultXX = "";
 description = "";
 enable = 0;
 errmsg = "";
 gray = "";
 green = "";
 id = 10;
 lastUpd = "2017-02-17 10:25:17";
 name = "";
 orange = "";
 pink = "";
 red = "180;1487341517175;1487341516995;";
 userId = 14;
 version = 0;
 yellow = "";
 
 }
 */

//+ (void)storageColorPenInfoWithDic:(NSDictionary *)dic{
//    dic writeToFile:<#(nonnull NSString *)#> atomically:<#(BOOL)#>
//}

+ (NSDictionary *)colorPenInfor{
    NSString *rootPath = [kPathDocument stringByAppendingPathComponent:[KTBUserManager userUniqueIdentifer]];
    NSString *directFilePath = [rootPath stringByAppendingPathComponent:kDirectoryFileName];
    NSDictionary *colorPenDic = [NSDictionary dictionaryWithContentsOfFile:directFilePath];
    return colorPenDic;
}

+ (void)saveColorPenInfo:(NSDictionary *)colorDic{
    NSString *rootPath = [kPathDocument stringByAppendingPathComponent:[KTBUserManager userUniqueIdentifer]];
    NSString *directFilePath = [rootPath stringByAppendingPathComponent:kDirectoryFileName];
    BOOL isSuccessfu = [colorDic writeToFile:directFilePath atomically:YES];
    if (isSuccessfu) {
        LBLog(@"目录信息写入成功");
    }else{
        LBLog(@"目录信息写入失败");
    }
}
@end
