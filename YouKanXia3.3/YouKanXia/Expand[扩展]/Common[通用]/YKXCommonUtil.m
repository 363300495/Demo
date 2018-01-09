//
//  YKXCommonUtil.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCommonUtil.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AdSupport/AdSupport.h>
@implementation YKXCommonUtil

// 弹框显示信息1秒
+ (void)showToastWithTitle:(NSString *)title view:(UIView *)view{
    [self showToastWithTitle:title view:view time:1];
}

//弹框显示信息
+ (void)showToastWithTitle:(NSString *)title view:(UIView *)view time:(NSTimeInterval)time{
    [SVProgressHUD showSuccessWithStatus:title];
    //设置HUD和文本的颜色
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"#333333"]];
    //设置HUD背景颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"#E5E6E7"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18.0f]];
    //设置弹框最小尺寸
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
    [SVProgressHUD setContainerView:view];
    [SVProgressHUD dismissWithDelay:time];
}

// 封装指示器
+ (void)showHudWithTitle:(NSString *)title view:(UIView *)view{
    [SVProgressHUD showWithStatus:title];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHexString:@"#333333"]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"#E5E6E7"]];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18.0f]];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 100)];
    [SVProgressHUD setContainerView:view];
}

// 移除指示器
+ (void)hiddenHud{
    [SVProgressHUD dismiss];
}


+ (BOOL)isFirstBuildVesion
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"Vesion"]) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *systemVesion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        BOOL isFirstV = [systemVesion isEqualToString:[defaults objectForKey:@"Vesion"]];
        //不论是不是当前版本 都存入新值
        [defaults setObject:systemVesion forKey:@"Vesion"];
        [defaults synchronize];
        
        //比较存入的版本号是否相同 如果相同则进入tabBar页面否则进入滚动视图
        if (isFirstV) {
            return NO;
        }
        return YES;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *systemVesion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [defaults setObject:systemVesion forKey:@"Vesion"];
    [defaults synchronize];
    
    return YES;
}


//获取当前网络状态

+ (NSString *)getNetWorkStates{
    
    NSString *networkState = [[NSString alloc] init];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable:
            networkState = @"无网络";
            break;
        case ReachableViaWWAN:
            networkState = @"GPS";
            break;
        case ReachableViaWiFi:
            networkState = @"wifi";
            break;
    }
    
    return networkState;
}


//获取当前连接的wifi名
+ (NSString *)currentWifiSSID
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}


//获取6位随机数
+ (NSString *)getRandomNumber{
    NSTimeInterval random = [NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.6f",random];
    NSString *code = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return code;
}


//判断合法的电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNumber{
    
    if(mobileNumber.length == 11){
        //手机号码
        // NSString *MOBILE = @"^1[3578]\\d{5,9}$";
        
        NSString *MOBILE = @"^(13[0-9]|15([0-9])|14[0-9]|17[0-9]|18[0-9])\\d{8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        if ([regextestmobile evaluateWithObject:mobileNumber] == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else{
        return NO;
    }
}

//判断只包含字母或数字
+ (BOOL)containsNumberLetter:(NSString *)numberLetterString{
    
    NSString *regex = @"[a-zA-Z_0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([predicate evaluateWithObject:numberLetterString] == YES){
        return YES;
    }else{
        return NO;
    }
}

//获取当前时间戳字符串
+ (NSString *)longLongTime{
    NSDate *date = [NSDate date];
    NSInteger time = [[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] integerValue];
    return [NSString stringWithFormat:@"%ld",time];
}


//时间戳转换为时间
+ (NSString *)timeStamp:(NSInteger)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


//根据日期判断星期几
+ (NSString *)detailDayStr:(NSInteger)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
 
    //获取当前时间戳
    NSDate *date = [NSDate date];
    NSInteger nowStamp = [[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] integerValue];
    
    NSTimeInterval oneDay = 24*60*60;
    NSTimeInterval twoDay = 24*60*60*2;
    NSTimeInterval sevenDay = 24*60*60*7;
    
    NSString *timeStr;
   
    if(nowStamp - time <= oneDay){
        
        NSString *tempStr = [confromTimespStr substringFromIndex:10];
        
        timeStr = [NSString stringWithFormat:@"今天 %@",tempStr];
        
    }else if (nowStamp - time > oneDay && nowStamp - time <= twoDay){
        
        NSString *tempStr = [confromTimespStr substringFromIndex:10];
        
        timeStr = [NSString stringWithFormat:@"昨天 %@",tempStr];
        
    }else if(nowStamp - time > twoDay && nowStamp - time <= sevenDay){
        
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
        NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:confromTimesp];
        NSString *weekStr = [weekdays objectAtIndex:theComponents.weekday];
        NSString *tempStr = [confromTimespStr substringFromIndex:10];
        timeStr = [NSString stringWithFormat:@"%@%@",weekStr,tempStr];
        
    }else{
        
        timeStr = [confromTimespStr substringFromIndex:5];
    }

    return timeStr;
}

// 获取当前时间字符串
+ (NSString *)getCurrentTimeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}


+ (NSString *)encodeString:(NSString*)unencodedString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
    
}

//获取当前版本号
+ (NSString *)getCurrentSystemVersion{
    
    //获取当前所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //获取app当前版本号
    NSString *systemVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *versionCode = [NSString stringWithFormat:@"%d",(int)([systemVersion floatValue]*10)];
    
    return versionCode;
    
}

//清除所有cookie
+ (void)removeAllCookies{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records)
                         {
                             
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                    }];
                         }
                     }];
}

//设置手机的ua
+ (void)setDeviceUserAgent:(NSString *)userAgent{
    
    NSMutableDictionary *uaDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:uaDic];
}

//获取手机型号
+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";

    return @"";


}


//获取设备型号
+ (NSString *)deviceType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    return platform;
    
}


//获取公网IP
+ (NSDictionary *)deviceWANIPAdress {
    
    NSError *error;
    
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    //判断返回字符串是否为所需数据
    
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        
        //对字符串进行处理，然后进行json解析
        
        //删除字符串多余字符串
        
        NSRange range = NSMakeRange(0, 19);
        
        [ip deleteCharactersInRange:range];
        
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        
        //将字符串转换成二进制进行Json解析
        
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        return dict;
    }
    
    return nil;
}

+ (NSString *)replaceDeviceSystemUrl:(NSString *)urlStr {
    
    NSString *openUDID = [OpenUDID value];
    
//    //用户公网IP
//    NSDictionary *IPAddressDic = [[self class] deviceWANIPAdress];
//    NSString *cip;
//    if(IPAddressDic.count > 0) {
//        cip = IPAddressDic[@"cip"];
//    }else{
//        cip = @"";
//    }
    
    //获取手机机型
    NSString *iphoneType = [[self class] iphoneType];
    
    NSString *screenWidth = [NSString stringWithFormat:@"%.f",SCREEN_WIDTH];
    
    NSString *screenHeight = [NSString stringWithFormat:@"%.f",SCREEN_HEIGHT];
    
    NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //手机版本号
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *deviceType = [[self class] deviceType];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-imei" withString:openUDID];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-idfa" withString:IDFA];
//    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-IP" withString:cip];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-sysv" withString:phoneVersion];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-devbn" withString:deviceType];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-model" withString:iphoneType];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-swidth" withString:screenWidth];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-sheight" withString:screenHeight];
    
    return urlStr;
}

@end
