//
//  YKXStringCore.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/6.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXStringCore.h"

@implementation YKXStringCore

#pragma mark 用户登录的监听广播频段
NSString *const NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY = @"loginStatusChangeFrequency";

#pragma mark 用户退出登录的监听广播频段
NSString *const NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY = @"exitStatusChangeFrequency";

#pragma mark 用户激活码激活成功后修改启动信息的监听广播频段
NSString *const NOTIFICATION_APPINFO_STATUS_FREQUENCY = @"appInfoStatusChangeFrequency";

#pragma mark 修改用户登录的个人信息的广播频段
NSString *const NOTIFICATION_USERINFO_STATUS_FREQUENCY = @"userInfoStausChangeFrequency";

#pragma mark 修改用户登录的消息的广播频段
NSString *const NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY = @"messageInfoStatusChangeFrequency";

#pragma mark 卡券使用后的广播频段
NSString *const NOTIFICATION_CARDUSER_STATUS_FREQUENCY = @"cardUserStatusFrequency";

#pragma mark 特殊号码的登录的监听广播频段
NSString *const NOTIFICATION_SPECIAL_LOGIN_STATUS_CHANGE_FREQUENCY = @"specialLoginStatusChangeFrequency";

#pragma mark 特殊号码退出登录的监听广播频段
NSString *const NOTIFICATION_SPECIAL_EXIT_STAUS_CHANGE_FREQUENCY = @"specialExitStatusChangeFrequency";

#pragma mark 特殊号码登录消息的广播频段
NSString *const NOTIFICATION_SPECIAL_LOGIN_MESSAGE_FREQUENCY = @"specialLoginMessageChangeFrequency";

#pragma mark 特殊号码退出登录消息的广播频段
NSString *const NOTIFICATION_SPECIAL_EXIT_MESSAGE_FREQUENCY = @"specialExitMesageChangeFrequency";
@end
