//
//  YKXCommonUtil.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKXCommonUtil : NSObject

//弹框显示信息1秒
+ (void)showToastWithTitle:(NSString *)title view:(UIView *)view;

//弹框显示信息
+ (void)showToastWithTitle:(NSString *)title view:(UIView *)view time:(NSTimeInterval)time;

// 封装指示器
+ (void)showHudWithTitle:(NSString *)title view:(UIView *)view;

// 移除指示器
+ (void)hiddenHud;

//判断是不是有新的版本
+ (BOOL)isFirstBuildVesion;

//获取当前网络状态
+ (NSString *)getNetWorkStates;

//判断合法的电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNumber;

//判断只包含字母或数字
+ (BOOL)containsNumberLetter:(NSString *)numberLetterString;

//获取当前连接的wifi名
+ (NSString *)currentWifiSSID;

//获取6位随机数
+ (NSString *)getRandomNumber;

//时间戳转换为时间
+ (NSString *)timeStamp:(NSInteger)time;

//根据日期判断星期几
+ (NSString*)detailDayStr:(NSInteger)format;

//获取当前时间戳字符串
+ (NSString *)longLongTime;

// 获取当前时间字符串
+ (NSString *)getCurrentTimeStamp;


+ (NSString *)encodeString:(NSString*)unencodedString;

//获取当前版本号
+ (NSString *)getCurrentSystemVersion;

//清除所有cookie
+ (void)removeAllCookies;

//设置手机的ua
+ (void)setDeviceUserAgent:(NSString *)userAgent;

//获取手机型号
+ (NSString *)iphoneType;

//获取设备型号
+ (NSString *)deviceType;

//获取公网IP
+ (NSDictionary *)deviceWANIPAdress;

+ (NSString *)replaceDeviceSystemUrl:(NSString *)urlStr;
@end
