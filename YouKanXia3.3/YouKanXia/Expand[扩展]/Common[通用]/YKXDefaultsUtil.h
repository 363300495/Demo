//
//  YKXDefaultsUtil.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKXDefaultsUtil : NSObject

#pragma mark 记录动态加载小红点图标
+ (void)setRemindVersion:(NSString *)remindVersion;

+ (NSString *)getRemindVersion;

#pragma mark 发现页面
//保存发现页面Id
+ (void)setDiscoveryId:(NSString *)discoveryId;

//获取发现页面Id
+ (NSString *)getDiscoveryId;

//保存发现UA
+ (void)setDiscoveryUserAgent:(NSArray *)discoveryUserAgent;

//获取发现UA
+ (NSArray *)getDiscoveryUserAgent;

//保存发现页面每个标题模块对应的ID
+ (void)setDiscoveryModularId:(NSArray *)discoveryModularIdArray;

//获取发现页面每个标题模块对应的ID
+ (NSArray *)getDiscoveryModularId;

//保存发现页面名称
+ (void)setDiscoveryName:(NSArray *)discoveryNameArray;

//获取发现页面名称
+ (NSArray *)getDiscoveryName;

//保存发现页面URL
+ (void)setDiscoveryURL:(NSArray *)discoveryUrlArray;

//获取发现页面URL
+ (NSArray *)getDiscoveryURL;

//保存发现页面拦截字符串
+ (void)setDiscoveryResDomainArray:(NSArray *)discoveryResDomainArray;

//获取发现页面拦截字符串
+ (NSArray *)getDiscoveryResDomainArray;

//保存发现页面拦截类型
+ (void)setDiscoveryRelDomainArray:(NSArray *)discoveryRelDomainArray;

//获取发现页面拦截类型
+ (NSArray *)getDiscoveryRelDomainArray;

//保存发现页面JS字符串
+ (void)setDiscoveryJSStrArray:(NSArray *)discoveryJSStrArray;

//获取发现页面JS字符串
+ (NSArray *)getDiscoveryJSStrArray;

#pragma mark 活动弹框
//保存活动Id
+ (void)setActivityId:(NSString *)activityId;

//获取活动Id
+ (NSString *)getActivityId;

//保存活动UA
+ (void)setActivityUserAgent:(NSString *)activityUserAgent;

//获取活动UA
+ (NSString *)getActivityUserAgent;

#pragma mark 个人中心
//保存个人中心Id
+ (void)setCenterId:(NSString *)centerId;

//获取个人中心Id
+ (NSString *)getCenterId;
//
////保存个人中心图片名称
//+ (void)setCenterIcon:(NSArray *)iconArray;
//
////获取个人中心图片名称
//+ (NSArray *)getCenterIcon;
//
////保存个人中心名称
//+ (void)setCenterName:(NSArray *)centerNameArray;
//
////获取个人中心名称
//+ (NSArray *)getCenterName;
//
////保存个人中心URL
//+ (void)setCenterURL:(NSArray *)centerUrlArray;
//
////获取个人中心URL
//+ (NSArray *)getCenterUrl;

#pragma mark 通告中心
//保存通告中心Id
+ (void)setNoticeId:(NSString *)noticeId;

//获取通告中心Id
+ (NSString *)getNoticeId;

////保存通告中心UA
//+ (void)setNoticeUserAgent:(NSString *)noticeUserAgent;
//
////获取通告中心UA
//+ (NSString *)getNoticeUserAgent;

//保存底部通告中心title
+ (void)setNoticeTitle:(NSArray *)noticeTitleArray;

//获取底部通告中心title
+ (NSArray *)getNoticeTitle;

//保存底部通告中心URL
+ (void)setNoticeURL:(NSArray *)noticeURLArray;

//获取底部通告中心URL
+ (NSArray *)getNoticeURL;

////保存分享、推荐服务头部UA
//+ (void)setNoticeADUserAgent:(NSString *)noticeADUserAgent;
//
////获取VIP专享、推荐服务头部UA
//+ (NSString *)getNoticeADUserAgent;

//保存VIP专享、推荐服务头部AD title
+ (void)setNoticeADTitle:(NSArray *)noticeADTitleArray;

//获取VIP专享、推荐服务头部AD title
+ (NSArray *)getNoticeADTitleArray;

//保存VIP专享、推荐服务头部AD URL连接
+ (void)setNoticeADURL:(NSArray *)noticeADURLArray;

//获取VIP专享、推荐服务头部AD URL连接
+ (NSArray *)getNoticeADURLArray;
#pragma mark 轮播图
//保存轮播图Id
+ (void)setCarouselId:(NSString *)carouselId;

//获取轮播图Id
+ (NSString *)getCarouselId;

////保存轮播图UA
//+ (void)setCarouseUserAgent:(NSString *)userAgent;
//
////获取轮播图UA
//+ (NSString *)getCarouselUserAgent;

//保存轮播图标题
+ (void)setCarouselTitle:(NSArray *)carouselArray;

//获取轮播图标题
+ (NSArray *)getCarouselTitleArray;

//保存轮播图图片
+ (void)setCarouselImageURL:(NSArray *)carouselImageURLArray;

//获取轮播图图片
+ (NSArray *)getCarouselImageURLArray;

//保存轮播图链接
+ (void)setCarouselURL:(NSArray *)carouselURLArray;

//获取轮播图连接
+ (NSArray *)getCarouselURLArray;

//保存轮播图loadJS
+ (void)setCarouselLoadJS:(NSArray *)carouselLoadJSArray;

//获取轮播图loadJS
+ (NSArray *)getCarouselLoadJSArray;

//保存轮播图域名拦截字符串
+ (void)setCarouselResDomainArray:(NSArray *)carouselResDomainArray;

//获取轮播图域名拦截字符串
+ (NSArray *)getCarouselResDomainArray;

//保存轮播图域名拦截类型
+ (void)setCarouselRelDomainArray:(NSArray *)carouselRelDomainArray;

//获取轮播图域名拦截类型
+ (NSArray *)getCarouselRelDomainArray;

#pragma mark VIP视频
//保存VIP视频Id
+ (void)setVipVwebId:(NSString *)vwebId;

//获取VIP视频Id
+ (NSString *)getVipVwebId;

#pragma mark 推荐服务
//保存推荐服务Id
+ (void)setRecserveId:(NSString *)recserveId;

//获取推荐服务Id
+ (NSString *)getRecserveId;

//保存推荐服务UA
+ (void)setCollectionUserAgent:(NSArray *)collectionUserAgent;

//获取推荐服务UA
+ (NSArray *)getCollectionUserAgent;

//保存collectioncell的标题
+ (void)setCollectionTitle:(NSArray *)titleArray;

//获取collectioncell的标题
+ (NSArray *)getCollectionTitleArray;

//保存collectioncell的子标题
+ (void)setCollectionDetail:(NSArray *)detailArray;

//获取collectioncell的子标题
+ (NSArray *)getCollectionDetailArray;

//保存collectioncell的图片链接
+ (void)setCollectionImageURL:(NSArray *)imageURLArray;

//获取collectioncell的图片链接
+ (NSArray *)getCollectionImageURLArray;

//保存collectioncell的链接
+ (void)setCollectionURL:(NSArray *)URLArray;

//获取collectioncell的链接
+ (NSArray *)getCollectionURLArray;

//保存collectioncell的链接类型
+ (void)setCollectionVweb:(NSArray *)vwebArray;

//获取collectioncell的链接类型
+ (NSArray *)getCollectionVwebArray;

//保存collectioncell弹出提示框标题
+ (void)setCollectionAlertTitle:(NSArray *)alertTitleArray;

//获取collectioncell弹出提示框标题
+ (NSArray *)getCollectionAlertTitleArray;

//保存collectioncell加载JS类型
+ (void)setCollectionJSArray:(NSArray *)collectionJsArray;

//获取collectioncell加载JS类型
+ (NSArray *)getCollectionJSArray;

//保存collection拦截字符串
+ (void)setCollectionResDomainArray:(NSArray *)collectionResDomainArray;

//获取Collection拦截字符串
+ (NSArray *)getCollectionResDomainArray;

//保存collection拦截类型
+ (void)setCollectionRelDomainArray:(NSArray *)collectionRelDomainArray;

//获取Collection拦截类型
+ (NSArray *)getCollectionRelDomainArray;

//保存是否发送心跳包
+ (void)setCollectionPingType:(NSArray *)collectionPingTypeArray;

//获取collection心跳包
+ (NSArray *)getCollectionPingTypeArray;

#pragma mark 保存登录信息
//保存当前版本号
+ (void)setSystemVersion:(NSString *)syetemVersion;

//获取当前版本号
+ (NSString *)getSystemVersion;


//保存登录信息
+ (void)setLoginUserInfo:(NSDictionary *)loginUserInfo;

//获取登录信息
+ (NSDictionary *)getLoginUserInfo;

//保存过期时间
+ (void)setExpiretime:(NSString *)expireTime;

//获取过期时间
+ (NSString *)getExpiretime;

//保存我的过期时间图标
+ (void)setMineExpireImage:(NSString *)mineExpireImage;

//获取我的过期时间图标
+ (NSString *)getMineExpireImage;

////保存心跳发送时间
//+ (void)setPinetime:(NSString *)pingtime;
//
////获取心跳发送时间
//+ (NSString *)getPingtime;

//保存是否第一次安装APP
+ (void)setIsFirst:(NSString *)isFirst;

//获取是否第一次安装APP
+ (NSString *)getIsFirst;

//保存上一次的好友消息请求时间
+ (void)setLastRequestTime:(NSString *)timeString;

//获取上一次好友消息的请求时间
+ (NSString *)getLastRequestTime;

//保存上一次新消息的请求时间
+ (void)setFriendNewMessageTime:(NSDictionary *)friendNewMessage friendId:(NSString *)friendId;

//获取上一次的新消息时间
+ (NSDictionary *)getFriendNewMessageTimeFriendId:(NSString *)friendId;

//保存好友定时器请求时间
+ (void)setFriendListPingTime:(NSString *)friendListPingTime;

//获取好友定时器请求时间
+ (NSString *)getFriendListPingTime;

//保存新消息定时器请求时间
+ (void)setNewsListPingTime:(NSString *)newsListPingTime;

//获取新消息定时器请求时间
+ (NSString *)getNewsListPingTime;

//保存初始的userAgent
+ (void)setAppInfoUserAgent:(NSArray *)appInfoUserAgent;

//获取初始的userAgent
+ (NSArray *)getAppInfoUserAgent;


//保存签到链接的URL
+ (void)setSignURLString:(NSString *)signUrlString;

//获取签到链接的URL
+ (NSString *)getSignURLString;

//保存签到说明链接的URL
+ (void)setSignInformationURLString:(NSString *)informationSignUrl;

//获取签到说明链接的URL
+ (NSString *)getSignInformationUrl;

//保存找回密码链接
+ (void)setFindPasswordURLStr:(NSString *)findPasswordURL;

//获取找回密码链接
+ (NSString *)getFindPasswordURLStr;


#pragma mark 获取广点通ID
//获取广点通主ID
+ (void)setGDTMainID:(NSString *)mainID;

+ (NSString *)getGDTMainID;

//1.获取开屏广告ID
+ (void)setGDTPlacementID:(NSString *)placementID;

+ (NSString *)getGDTPlacementID;

//7.获取发现短视频广告ID
+ (void)setGDTCellNativeID:(NSString *)cellNativeID;

+ (NSString *)getGDTCellNativeID;

//3.获取SVIP广告ID
+ (void)setGDTVIPNativeID:(NSString *)VIPNativeID;

+ (NSString *)getGDTVIPNativeID;

//2.获取视频平台退出广告ID
+ (void)setGDTExitNativeID:(NSString *)exitID;

+ (NSString *)getGDTExitID;

//8.获取签到ID
+ (void)setGDTSignNativeID:(NSString *)signID;

+ (NSString *)getGDTSignNativeID;


//4.获取SVIP选集广告ID
+ (void)setSVIPXuanJiBannerID:(NSString *)xuanjiNativeID;

+ (NSString *)getSVIPXuanJiBannerID;


//5.获取首页BannerID
+ (void)setYouKanBannerID:(NSString *)youKanBannerID;

+ (NSString *)getYouKanBannerID;

//6.获取消息BannerID
+ (void)setMessageBannerID:(NSString *)messageBannerID;

+ (NSString *)getMessageBannerID;


//9.获取使用卡券界面ID
+ (void)setUseCardNativeID:(NSString *)useCardNativeID;

+ (NSString *)getUseCardNativeID;

//10.获取领券界面ID
+ (void)setGetCardNativeID:(NSString *)getCardNativeID;

+ (NSString *)getGetCardNativeID;


#pragma mark 关于我们
//关于我们文字
+ (void)setAboutusAppInfoString:(NSString *)appInfoString;

+ (NSString *)getAboutusAppInfoString;

//关于我们二维码
+ (void)setAboutusCodeURL:(NSString *)codeURL;

+ (NSString *)getAboutusCodeURL;

//常见问题
+ (void)setQuestionAndAnswerString:(NSString *)prombleString;

+ (NSString *)getQuestionAndAnswerString;

//充值
+ (void)setAPPRechargeURL:(NSString *)rechargeURL;

+ (NSString *)getAPPRechargeURL;


//存特殊号码登录
+ (void)setPhonenumberStatus:(NSString *)phonenumber;

//获取特殊号码登录
+ (NSString *)getPhonenumberStatus;

@end
