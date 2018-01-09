//
//  YKXSysMacro.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#ifndef YKXSysMacro_h
#define YKXSysMacro_h


#ifdef DEBUG
#define YKXDEBUGLog(format, ...) printf("[%s] [DEBUG] %s [第%d行] %s \n", [[YKXCommonUtil getCurrentTimeStamp] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define YKXDEBUGLog(__FORMAT__, ...)
#endif

#define DISPLAYNAME @"优看侠"
#define PREVIOUSNAME @"优看"
#define SPECIALPHONENUMBER @"18589090018"

//各种key
#define UMKey @"590c5af404e20597ec000eec"

#define QQID @"1106074021"
#define QQKey @"zzfDZZCX8IvYIoZC"

#define WechatKey @"wx26b574a4f74bdc48"
#define WechatSecrect @"4ce8cf798ebb4673185bc33d9f8ee0bd"


#define GDTID @"1106061407"

//开屏
#define GDTPlacementID @"5070426572568913"
//VIP退出框
#define GDTExitNativeID @"8000929875318868"
//sVIP
#define GDTVIPNativeID @"4000024502636909"
//选集ID
#define GDTXuanJiNativeID @"2080423816259950"
//首页BannerID
#define GDTYouKanBannerID @"4050528835121774"
//消息BannerID
#define GDTMessageBannerID @"6000823845024715"
//播放cell
#define GDTCellNativeID @"4050224559143977"
//签到
#define GDTSignNativeID @"6020524633371595"
//领券ID
#define GDTGetCardNativeID @"4020622521994822"
//使用卡券
#define GDTUseCardNativeID @"8020426855311869"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define contentEdgeTop 20
#define contentEdgeLeft 10
#define contentEdgeBottom 20
#define contentEdgeRight 15

//导航栏颜色
#define DISCOVERYNAVC_BAR_COLOR @"#0185F0"
//发现未选中标题颜色
#define SEGTITLE_SELECTED_COLOR @"#9DD1FA"
//背景色
#define BACKGROUND_COLOR @"#F7F7F7"
//网页加载进度条颜色
#define PROGRESS_COLOR @"#FF9933"
//字体颜色
#define DEEP_COLOR @"#333333"
#define LIGHT_COLOR @"#C7C7CD"
//无网状态提示背景
#define NONETWORKING_COLOR @"#4E9BE8"


// 图标：标签栏按钮
#define ICON_TAB_BAR_ITEM_YOUKAN_NORMAL            @"launcher_btn_yk_normal"
#define ICON_TAB_BAR_ITEM_YOUKAN_SELECT            @"launcher_btn_yk_selected"
#define ICON_TAB_BAR_ITEM_MESSAGE_NORMAL           @"launcher_btn_message_normal"
#define ICON_TAB_BAR_ITEM_MESSAGE_SELECT           @"launcher_btn_message_selected"
#define ICON_TAB_BAR_ITEM_DISCOVERY_NORMAL         @"launcher_btn_news_normal"
#define ICON_TAB_BAR_ITEM_DISCOVERY_SELECT         @"launcher_btn_news_selected"
#define ICON_TAB_BAR_ITEM_MINE_NORMAL              @"launcher_btn_more_normal"
#define ICON_TAB_BAR_ITEM_MINE_SELECT              @"launcher_btn_more_selected"


#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//弱引用
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self

//机型
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//状态栏
#define StatusBarTopHeight (SCREEN_HEIGHT == 812.0 ? 44 : 20)

//导航栏
#define SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)

//底部
#define TabBarBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 83 : 49)

//适配屏幕宽度
#define kWJWidthCoefficient (SCREEN_WIDTH/375.0)

//适配屏幕高度
#define kWJHeightCoefficient (SCREEN_HEIGHT == 812.0 ? 667.0/667.0 : SCREEN_HEIGHT/667.0)

//适配字体大小
#define kWJFontCoefficient (SCREEN_HEIGHT == 812.0 ? 667.0/667.0 : SCREEN_HEIGHT/667.0)

#endif /* YKXSysMacro_h */
