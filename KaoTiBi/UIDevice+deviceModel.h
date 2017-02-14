//
//  UIDevice+LYDeviceModel.h
//  LeYaoXiu
//
//  Created by shenyuanluo on 16/5/27.
//  Copyright © 2016年 AChang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 设备类型标识
extern NSString *const Device_Simulator;
extern NSString *const Device_iPod1;
extern NSString *const Device_iPod2;
extern NSString *const Device_iPod3;
extern NSString *const Device_iPod4;
extern NSString *const Device_iPod5;
extern NSString *const Device_iPad2;
extern NSString *const Device_iPad3;
extern NSString *const Device_iPad4;
extern NSString *const Device_iPhone4;
extern NSString *const Device_iPhone4S;
extern NSString *const Device_iPhone5;
extern NSString *const Device_iPhone5S;
extern NSString *const Device_iPhone5C;
extern NSString *const Device_iPadMini1;
extern NSString *const Device_iPadMini2;
extern NSString *const Device_iPadMini3;
extern NSString *const Device_iPadAir1;
extern NSString *const Device_iPadAir2;
extern NSString *const Device_iPhone6;
extern NSString *const Device_iPhone6plus;
extern NSString *const Device_iPhone6S;
extern NSString *const Device_iPhone6Splus;
extern NSString *const Device_iPhoneSE;
extern NSString *const Device_Unrecognized;

// iPhone 屏幕尺寸大小标志
extern NSString *const iPhone_3_5_Inch;     // 3.5英寸
extern NSString *const iPhone_4_0_Inch;     // 4.0英寸
extern NSString *const iPhone_4_7_Inch;     // 4.7英寸
extern NSString *const iPhone_5_5_Inch;     // 5.5英寸

@interface UIDevice (deviceModel)


/**
 *  获取当前设备的类型：iPhone 4s、iPhone 5s、iPhone 6s、iPhone 6s plus...
 *
 *  @return 具体的设备类型
 */
- (NSString *)deviceModel;



/**
 *  判断屏幕尺寸的大小
 *
 *  @return 屏幕尺寸大小字标识
 */
- (NSString *)iPhoneScreenSize;

// 返回手机类型+系统名称+系统型号)
+ (NSString *)phoneAndOperartionSysInfor;

@end
