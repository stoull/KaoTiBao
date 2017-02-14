//
//  Document.m
//  KaoTiBi
//
//  Created by linkapp on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "Document.h"
#import "NSDate+customizedFormatter.h"
#import "LBMD5.h"
#import "DocumentMgr.h"
#import "DocmentDatabase.h"
#import "KTDefine.h"

@import Photos;

@implementation Document

// 转成模型
- (instancetype)initWithAssetURL:(NSURL *)assetUrl{
    if (self = [super init]) {
        NSString *currentDate = [NSDate currentDateWithApplicationDefaultFormmater];
        NSDictionary *dateELDic = [NSDate getDateElementFromApplicationDefaultFormmaterString:currentDate];
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyyMMddHHmmss";
        NSDate *date =[NSDate date];
        NSString *dateName = [dateformatter stringFromDate:date];
        _dateName = dateName;
        
        
        dateformatter.dateFormat = @"yyyy-MM";
        _identifierMonth = [dateformatter stringFromDate:date];
        
        dateformatter.dateFormat = @"yyyy-MM-dd";
        _identifierDay = [dateformatter stringFromDate:date];
        
        _date = currentDate;
        if (dateELDic != nil) {
            NSNumber *yearN = dateELDic[@"year"];
            NSNumber *monthN = dateELDic[@"month"];
            NSNumber *dayN = dateELDic[@"day"];
            
            _year = [yearN intValue];
            _month = [monthN intValue];
            _day = [dayN intValue];
        }
        _name = [NSString stringWithFormat:@"%@.jpg",currentDate];
        
        _assetURLString = assetUrl.absoluteString;
    }
    return self;
}


- (void)saveToDataBase{
    NSURL *assetUrl = [NSURL URLWithString:self.assetURLString];
    PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[assetUrl] options:nil] firstObject];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    if (asset.mediaType == PHAssetMediaTypeImage){
        [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData != nil) {
                _fileSize = imageData.length;
                NSString *dataMd5 = [LBMD5 getMD5WithData:imageData];
                _path = [NSString stringWithFormat:@"%@/%@",[DocumentMgr docuemntRelativeStorageRootPath],dataMd5];
                NSString *absolutpath = [DocumentMgr documentAbsoluteStorageRootPath];
                absolutpath = [absolutpath stringByAppendingPathComponent:dataMd5];
                
                [[NSFileManager defaultManager] createDirectoryAtPath:absolutpath withIntermediateDirectories:YES attributes:nil error:nil];
                absolutpath = [absolutpath stringByAppendingPathComponent:_dateName];
                
                LBLog(@" sfakdfaXXXX??? : %@",absolutpath);
                
                [imageData writeToFile:absolutpath atomically:YES];
                [[DocmentDatabase shareDocmentDatabase] insertCoreData:@[self]];
                
            }
        }];
    }
}

- (id)copyWithZone:(nullable NSZone *)zone{
    Document *doc = [[Document alloc] init];
    doc.date = self.date;
    doc.dateName = self.dateName;
    doc.identifierMonth = self.identifierMonth;
    doc.identifierDay = self.identifierDay;
    doc.year = self.year;
    doc.month = self.month;
    doc.day = self.day;
    doc.name = self.name;
    doc.describleString = self.describleString;
    doc.classfiy = self.classfiy;
    doc.fileSize = self.fileSize;
    doc.path = self.path;
    doc.assetURLString = self.assetURLString;
    doc.isDelete = self.isDelete;
    doc.isSync = self.isSync;
    doc.viewcount = self.viewcount;
    return doc;
}

+ (Document *)copyWithManagedObject:(Document *)obDocument{
    Document *doc = [[Document alloc] init];
    doc.date = obDocument.date;
    doc.dateName = obDocument.dateName;
    doc.identifierMonth = obDocument.identifierMonth;
    doc.identifierDay = obDocument.identifierDay;
    doc.year = obDocument.year;
    doc.month = obDocument.month;
    doc.day = obDocument.day;
    doc.name = obDocument.name;
    doc.describleString = obDocument.describleString;
    doc.classfiy = obDocument.classfiy;
    doc.fileSize = obDocument.fileSize;
    doc.path = obDocument.path;
    doc.assetURLString = obDocument.assetURLString;
    doc.isDelete = obDocument.isDelete;
    doc.isSync = obDocument.isSync;
    doc.viewcount = obDocument.viewcount;
    return doc;
}

@end
