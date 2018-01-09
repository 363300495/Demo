//
//  YKXStringCore.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/6.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,userInfoLoginType){
    userInfoLoginTypePhone = 1,
    userInfoLoginTypeWechat,
    userInfoLoginTypeQQ,
    userInfoLoginTypeVisitor,
    userInfoLoginTypeUsername
};

@interface YKXStringCore : NSObject

#pragma mark 用户登录的监听广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY;

#pragma mark 用户退出登录的监听广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY;

#pragma mark 用户激活码激活成功后修改启动信息的监听广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_APPINFO_STATUS_FREQUENCY;

#pragma mark 修改用户登录的个人信息的广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_USERINFO_STATUS_FREQUENCY;

#pragma mark 修改用户登录的消息的广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY;

#pragma mark 卡券使用后的广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_CARDUSER_STATUS_FREQUENCY;

#pragma mark 特殊号码登录的监听广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_SPECIAL_LOGIN_STATUS_CHANGE_FREQUENCY;

#pragma mark 特殊号码退出登录的监听广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_SPECIAL_EXIT_STAUS_CHANGE_FREQUENCY;

#pragma mark 特殊号码登录消息的广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_SPECIAL_LOGIN_MESSAGE_FREQUENCY;

#pragma mark 特殊号码退出登录消息的广播频段
UIKIT_EXTERN NSString *const NOTIFICATION_SPECIAL_EXIT_MESSAGE_FREQUENCY;



@end
