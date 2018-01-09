//
//  YKXURLMacro.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#ifndef YKXURLMacro_h
#define YKXURLMacro_h

#define YOYO @"yoyo"



#define SVIPHELP_UEL @"svip/player_help.php?vweb=%@&version_code=%@&title=%@&url=%@"

#define QFA_URL @"http://a.ykxia.com/html/faq/?dev=2"

#define PAY_URL @"https://ykxpay.wlanap.com/pay.php?uid={uid}&token={token}&devtype=2&id=1"

//#define PUBLIC @"http://ykxapi.ldpoly.cn/"

//是否进入IPV6界面
#define YYBOX_URL @"https://ykxapi.ykxia.cn/api/common/getconfig_ip/"


#define PUBLIC @"https://ykxapi.ykxia.cn/"


//发送验证码
#define SENDMESSAGE_URL @"api/user/getsmscode/"

//登录
#define LOGIN_URL @"api/user/login/"

//用户注册
#define USERREGISTER_URL @"api/user/account/"

//用户信息
#define USERINFO_URL @"api/user/getinfo/"

//多账号互通
#define USERBIND_URL @"api/user/interflow/"

//消息列表
#define MESSAGELIST_URL @"api/user/getmsg/"

//退出登录
#define EXIT_URL @"api/user/logout/"

//意见反馈
#define FEEDBACK_URL @"api/user/infofeedback/"

//分享请求
#define SHARELAUNCH_URL @"api/user/share_launch/"

//发现模块
#define FIND_URL @"api/common/getconfig/"

//获取cookie信息
#define GETCOOKIE_URL @"api/web/getinfo/"

//心跳包
#define DOPING_URL @"api/web/ping/"

//释放资源
#define RELEASECOOKIE_URL @"api/web/release/"

//获取待领取卡券列表
#define WAITCARD_URL @"api/card/getnewlist/"

//免费领取卡券
#define FREECARD_URL @"api/card/receive/"

//获取卡券包列表
#define GETCARDLIST_URL @"api/card/getlist/"

//使用卡券
#define USECARD_URL @"api/card/use/"

//转赠卡券
#define GIVENCARD_URL @"api/card/give/"

//激活卡券
#define ACTIVATIONCODE_URL @"api/card/exchange/"

//分享领取日志
#define SHARERECEIVELOG_URL @"api/user/share_receivelog/"

//分享日志
#define SHARELOG_URL @"api/user/share_log/"

//获取爱奇艺等JS
#define JSCONTENT_URL @"api/web/loadjs/"

//获取短视频、直播等JS
#define JSSERVICE_URL @"api/js/load/"

//手动切换账号
#define SWITCH_URL @"api/web/switch/"

//sVip通道
#define SVIP_URL @"api/web/svipconf/"

//好友消息列表
#define FRIENDMESSAGE_URL @"/api/news/get_friends_list/"

//好友新消息
#define FRIENDNEWMESSAGE_URL @"api/news/get_friends_news/"

//发送消息
#define FRIENDSENDMESSAGE_URL @"api/news/sendnews/"

//小视频列表
#define VIDEOLIST_URL @"api/smallvideo/getlist/"

//签到信息
#define SIGN_URL @"api/user/sign/"

//视频添加收藏
#define ADDCOLLECTION_URL @"api/web/collection/add/"

//视频删除收藏
#define DELETECOLLECTION_URL @"api/web/collection/del/"

//获取视频列表
#define GETCOLLECTIONLIST_URL @"api/web/collection/list/"

//获取视频播放列表
#define GETVIDEODOWNLOADLIST_URL @"api/web/downfile/getlist/"

//获取下载资源文件
#define GETVIDEORESOURCE_URL @"api/web/downfile/getdownurl/"

//大家都在下
#define DOWNLOADRECOMMEND_URL @"api/web/downfile/recommdown/"

//检测是否需要获取m3u8文件
#define CHECKSVIPURL @"api/web/svip_check_url/"

#endif /* YKXURLMacro_h */
