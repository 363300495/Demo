//
//  YKXDefaultsUtil.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXDefaultsUtil.h"

@implementation YKXDefaultsUtil

#pragma mark 记录动态加载小红点图标
//设置外部标记版本号
+ (void)setRemindVersion:(NSString *)remindVersion{
    [USER_DEFAULT setObject:remindVersion forKey:@"remindVersion"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getRemindVersion{
    return [USER_DEFAULT objectForKey:@"remindVersion"];
}

#pragma mark 发现页面
//保存发现页面Id
+ (void)setDiscoveryId:(NSString *)discoveryId{
    [USER_DEFAULT setObject:discoveryId forKey:@"discoveryId"];
    [USER_DEFAULT synchronize];
}

//获取发现页面Id
+ (NSString *)getDiscoveryId{
    return [USER_DEFAULT objectForKey:@"discoveryId"];
}

//保存发现UA
+ (void)setDiscoveryUserAgent:(NSArray *)discoveryUserAgent{
    [USER_DEFAULT setObject:discoveryUserAgent forKey:@"discoveryUserAgent"];
    [USER_DEFAULT synchronize];
}

//获取发现UA
+ (NSArray *)getDiscoveryUserAgent{
    return [USER_DEFAULT objectForKey:@"discoveryUserAgent"];
}


//保存发现页面每个标题模块对应的ID
+ (void)setDiscoveryModularId:(NSArray *)discoveryModularIdArray {
    [USER_DEFAULT setObject:discoveryModularIdArray forKey:@"discoveryModularIdArray"];
    [USER_DEFAULT synchronize];
}

//获取发现页面每个标题模块对应的ID
+ (NSArray *)getDiscoveryModularId {
    return [USER_DEFAULT objectForKey:@"discoveryModularIdArray"];
}

//保存发现页面名称
+ (void)setDiscoveryName:(NSArray *)discoveryNameArray{
    [USER_DEFAULT setObject:discoveryNameArray forKey:@"discoveryNameArray"];
    [USER_DEFAULT synchronize];
}

//获取发现页面名称
+ (NSArray *)getDiscoveryName{
    return [USER_DEFAULT objectForKey:@"discoveryNameArray"];
}

//保存发现页面URL
+ (void)setDiscoveryURL:(NSArray *)discoveryUrlArray{
    
    [USER_DEFAULT setObject:discoveryUrlArray forKey:@"discoveryURL"];
    [USER_DEFAULT synchronize];
}

//获取发现页面URL
+ (NSArray *)getDiscoveryURL{
    return [USER_DEFAULT objectForKey:@"discoveryURL"];
}


//保存发现页面拦截字符串
+ (void)setDiscoveryResDomainArray:(NSArray *)discoveryResDomainArray{
    [USER_DEFAULT setObject:discoveryResDomainArray forKey:@"discoveryResDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取发现页面拦截字符串
+ (NSArray *)getDiscoveryResDomainArray{
    return [USER_DEFAULT objectForKey:@"discoveryResDomainArray"];
}

//保存发现页面拦截类型
+ (void)setDiscoveryRelDomainArray:(NSArray *)discoveryRelDomainArray{
    [USER_DEFAULT setObject:discoveryRelDomainArray forKey:@"discoveryRelDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取发现页面拦截类型
+ (NSArray *)getDiscoveryRelDomainArray{
    return [USER_DEFAULT objectForKey:@"discoveryRelDomainArray"];
}

//保存发现页面JS字符串
+ (void)setDiscoveryJSStrArray:(NSArray *)discoveryJSStrArray{
    [USER_DEFAULT setObject:discoveryJSStrArray forKey:@"discoveryJSStrArray"];
    [USER_DEFAULT synchronize];
}

//获取发现页面JS字符串
+ (NSArray *)getDiscoveryJSStrArray{
    return [USER_DEFAULT objectForKey:@"discoveryJSStrArray"];
}

#pragma mark 活动弹框
//保存活动Id
+ (void)setActivityId:(NSString *)activityId{
    [USER_DEFAULT setObject:activityId forKey:@"activityId"];
    [USER_DEFAULT synchronize];
}

//获取活动Id
+ (NSString *)getActivityId{
    return [USER_DEFAULT objectForKey:@"activityId"];
}

//保存活动UA
+ (void)setActivityUserAgent:(NSString *)activityUserAgent{
    [USER_DEFAULT setObject:activityUserAgent forKey:@"activityUserAgent"];
    [USER_DEFAULT synchronize];
}

//获取活动UA
+ (NSString *)getActivityUserAgent{
    return [USER_DEFAULT objectForKey:@"activityUserAgent"];
}

#pragma mark 个人中心
//保存个人中心Id
+ (void)setCenterId:(NSString *)centerId{
    [USER_DEFAULT setObject:centerId forKey:@"centerId"];
    [USER_DEFAULT synchronize];
}

//获取个人中心Id
+ (NSString *)getCenterId{
    return [USER_DEFAULT objectForKey:@"centerId"];
}
//
////保存个人中心图片名称
//+ (void)setCenterIcon:(NSArray *)iconArray{
//    
//    [USER_DEFAULT setObject:iconArray forKey:@"icon"];
//    [USER_DEFAULT synchronize];
//}
//
////获取个人中心图片名称
//+ (NSArray *)getCenterIcon{
//    return [USER_DEFAULT objectForKey:@"icon"];
//}
//
////保存个人中心名称
//+ (void)setCenterName:(NSArray *)centerNameArray{
//    [USER_DEFAULT setObject:centerNameArray forKey:@"centerNameArray"];
//    [USER_DEFAULT synchronize];
//}
//
////获取个人中心名称
//+ (NSArray *)getCenterName{
//    return [USER_DEFAULT objectForKey:@"centerNameArray"];
//}
//
//
////保存个人中心URL
//+ (void)setCenterURL:(NSArray *)centerUrlArray{
//    [USER_DEFAULT setObject:centerUrlArray forKey:@"centerUrlArray"];
//    [USER_DEFAULT synchronize];
//}
//
////获取个人中心URL
//+ (NSArray *)getCenterUrl{
//    return [USER_DEFAULT objectForKey:@"centerUrlArray"];
//}

#pragma mark 通告中心
//保存通告中心Id
+ (void)setNoticeId:(NSString *)noticeId{
    [USER_DEFAULT setObject:noticeId forKey:@"noticeId"];
    [USER_DEFAULT synchronize];
}

//获取通告中心Id
+ (NSString *)getNoticeId{
    return [USER_DEFAULT objectForKey:@"noticeId"];
}

////保存通告中心UA
//+ (void)setNoticeUserAgent:(NSString *)noticeUserAgent{
//    [USER_DEFAULT setObject:noticeUserAgent forKey:@"noticeUserAgent"];
//    [USER_DEFAULT synchronize];
//}
//
////获取通告中心UA
//+ (NSString *)getNoticeUserAgent{
//    return [USER_DEFAULT objectForKey:@"noticeUserAgent"];
//}


//保存通告中心title
+ (void)setNoticeTitle:(NSArray *)noticeTitleArray{
    [USER_DEFAULT setObject:noticeTitleArray forKey:@"noticeTitleArray"];
    [USER_DEFAULT synchronize];
}

//获取通告中心title
+ (NSArray *)getNoticeTitle{
    return [USER_DEFAULT objectForKey:@"noticeTitleArray"];
}

//保存通告中心URL
+ (void)setNoticeURL:(NSArray *)noticeURLArray{
    [USER_DEFAULT setObject:noticeURLArray forKey:@"noticeURLArray"];
    [USER_DEFAULT synchronize];
}

//获取通告中心URL
+ (NSArray *)getNoticeURL{
    return [USER_DEFAULT objectForKey:@"noticeURLArray"];
}

////保存分享、推荐服务头部UA
//+ (void)setNoticeADUserAgent:(NSString *)noticeADUserAgent{
//    [USER_DEFAULT setObject:noticeADUserAgent forKey:@"noticeADUserAgent"];
//    [USER_DEFAULT synchronize];
//}
//
////获取VIP专享、推荐服务头部UA
//+ (NSString *)getNoticeADUserAgent{
//    return [USER_DEFAULT objectForKey:@"noticeADUserAgent"];
//}


//保存VIP专享、推荐服务头部AD title
+ (void)setNoticeADTitle:(NSArray *)noticeADTitleArray{
    [USER_DEFAULT setObject:noticeADTitleArray forKey:@"noticeADTitleArray"];
    [USER_DEFAULT synchronize];
}

//获取VIP专享、推荐服务头部AD title
+ (NSArray *)getNoticeADTitleArray{
    return [USER_DEFAULT objectForKey:@"noticeADTitleArray"];
}

//保存VIP专享、推荐服务头部AD URL连接
+ (void)setNoticeADURL:(NSArray *)noticeADURLArray{
    [USER_DEFAULT setObject:noticeADURLArray forKey:@"noticeADURLArray"];
    [USER_DEFAULT synchronize];
}

//获取VIP专享、推荐服务头部AD URL连接
+ (NSArray *)getNoticeADURLArray{
    return [USER_DEFAULT objectForKey:@"noticeADURLArray"];
}

#pragma mark 轮播图
//保存轮播图Id
+ (void)setCarouselId:(NSString *)carouselId{
    [USER_DEFAULT setObject:carouselId forKey:@"carouselId"];
    [USER_DEFAULT synchronize];
}

//获取轮播图Id
+ (NSString *)getCarouselId{
    return [USER_DEFAULT objectForKey:@"carouselId"];
}

////保存轮播图UA
//+ (void)setCarouseUserAgent:(NSString *)carouselUserAgent{
//    [USER_DEFAULT setObject:carouselUserAgent forKey:@"carouselUserAgent"];
//    [USER_DEFAULT synchronize];
//}
//
////获取轮播图UA
//+ (NSString *)getCarouselUserAgent{
//    return [USER_DEFAULT objectForKey:@"carouselUserAgent"];
//}


//保存轮播图标题
+ (void)setCarouselTitle:(NSArray *)carouselArray{
    [USER_DEFAULT setObject:carouselArray forKey:@"carouselArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图标题
+ (NSArray *)getCarouselTitleArray{
    return [USER_DEFAULT objectForKey:@"carouselArray"];
}

//保存轮播图图片
+ (void)setCarouselImageURL:(NSArray *)carouselImageURLArray{
    [USER_DEFAULT setObject:carouselImageURLArray forKey:@"carouselImageURLArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图图片
+ (NSArray *)getCarouselImageURLArray{
    return [USER_DEFAULT objectForKey:@"carouselImageURLArray"];
}

//保存轮播图链接
+ (void)setCarouselURL:(NSArray *)carouselURLArray{
    [USER_DEFAULT setObject:carouselURLArray forKey:@"carouselURLArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图连接
+ (NSArray *)getCarouselURLArray{
    return [USER_DEFAULT objectForKey:@"carouselURLArray"];
}

//保存轮播图loadJS
+ (void)setCarouselLoadJS:(NSArray *)carouselLoadJSArray{
    [USER_DEFAULT setObject:carouselLoadJSArray forKey:@"carouselLoadJSArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图loadJS
+ (NSArray *)getCarouselLoadJSArray{
    return [USER_DEFAULT objectForKey:@"carouselLoadJSArray"];
}

//保存轮播图域名拦截字符串
+ (void)setCarouselResDomainArray:(NSArray *)carouselResDomainArray{
    [USER_DEFAULT setObject:carouselResDomainArray forKey:@"carouselResDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图域名拦截字符串
+ (NSArray *)getCarouselResDomainArray{
    return [USER_DEFAULT objectForKey:@"carouselResDomainArray"];
}

//保存轮播图域名拦截类型
+ (void)setCarouselRelDomainArray:(NSArray *)carouselRelDomainArray{
    [USER_DEFAULT setObject:carouselRelDomainArray forKey:@"carouselRelDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取轮播图域名拦截类型
+ (NSArray *)getCarouselRelDomainArray{
    return [USER_DEFAULT objectForKey:@"carouselRelDomainArray"];
}

#pragma mark VIP视频
//保存VIP视频Id
+ (void)setVipVwebId:(NSString *)vwebId{
    [USER_DEFAULT setObject:vwebId forKey:@"vwebId"];
    [USER_DEFAULT synchronize];
}

//获取VIP视频Id
+ (NSString *)getVipVwebId{
    return [USER_DEFAULT objectForKey:@"vwebId"];
}

#pragma mark 推荐服务
//保存推荐服务Id
+ (void)setRecserveId:(NSString *)recserveId{
    [USER_DEFAULT setObject:recserveId forKey:@"recserveId"];
    [USER_DEFAULT synchronize];
}

//获取推荐服务Id
+ (NSString *)getRecserveId{
    return [USER_DEFAULT objectForKey:@"recserveId"];
}

//保存推荐服务UA
+ (void)setCollectionUserAgent:(NSArray *)collectionUserAgent{
    [USER_DEFAULT setObject:collectionUserAgent forKey:@"collectionUserAgent"];
    [USER_DEFAULT synchronize];
}

//获取推荐服务UA
+ (NSArray *)getCollectionUserAgent{
    return [USER_DEFAULT objectForKey:@"collectionUserAgent"];
}


//保存collectioncell的标题
+ (void)setCollectionTitle:(NSArray *)titleArray{
    [USER_DEFAULT setObject:titleArray forKey:@"collectionTitleArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell的标题
+ (NSArray *)getCollectionTitleArray{
    return [USER_DEFAULT objectForKey:@"collectionTitleArray"];
}

//保存collectioncell的子标题
+ (void)setCollectionDetail:(NSArray *)detailArray{
    [USER_DEFAULT setObject:detailArray forKey:@"collectionDetailArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell的子标题
+ (NSArray *)getCollectionDetailArray{
    return [USER_DEFAULT objectForKey:@"collectionDetailArray"];
}

//保存collectioncell的图片链接
+ (void)setCollectionImageURL:(NSArray *)imageURLArray{
    [USER_DEFAULT setObject:imageURLArray forKey:@"collectionImageURLArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell的图片链接
+ (NSArray *)getCollectionImageURLArray{
    return [USER_DEFAULT objectForKey:@"collectionImageURLArray"];
}

//保存collectioncell的链接
+ (void)setCollectionURL:(NSArray *)URLArray{
    [USER_DEFAULT setObject:URLArray forKey:@"collectionURLArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell的链接
+ (NSArray *)getCollectionURLArray{
    return [USER_DEFAULT objectForKey:@"collectionURLArray"];
}

//保存collectioncell的链接类型
+ (void)setCollectionVweb:(NSArray *)vwebArray{
    [USER_DEFAULT setObject:vwebArray forKey:@"collectionVwebArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell的链接类型
+ (NSArray *)getCollectionVwebArray{
    return [USER_DEFAULT objectForKey:@"collectionVwebArray"];
}


//保存collectioncell弹出提示框标题
+ (void)setCollectionAlertTitle:(NSArray *)alertTitleArray{
    [USER_DEFAULT setObject:alertTitleArray forKey:@"alertTitleArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell弹出提示框标题
+ (NSArray *)getCollectionAlertTitleArray{
    return [USER_DEFAULT objectForKey:@"alertTitleArray"];
}

//保存collectioncell加载JS类型
+ (void)setCollectionJSArray:(NSArray *)collectionJsArray{
    [USER_DEFAULT setObject:collectionJsArray forKey:@"collectionJsArray"];
    [USER_DEFAULT synchronize];
}

//获取collectioncell加载JS类型
+ (NSArray *)getCollectionJSArray{
    return [USER_DEFAULT objectForKey:@"collectionJsArray"];
}

//保存collection拦截字符串
+ (void)setCollectionResDomainArray:(NSArray *)collectionResDomainArray{
    [USER_DEFAULT setObject:collectionResDomainArray forKey:@"collectionResDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取Collection拦截字符串
+ (NSArray *)getCollectionResDomainArray{
    return [USER_DEFAULT objectForKey:@"collectionResDomainArray"];
}

//保存collection拦截类型
+ (void)setCollectionRelDomainArray:(NSArray *)collectionRelDomainArray{
    [USER_DEFAULT setObject:collectionRelDomainArray forKey:@"collectionRelDomainArray"];
    [USER_DEFAULT synchronize];
}

//获取Collection拦截类型
+ (NSArray *)getCollectionRelDomainArray{
    return [USER_DEFAULT objectForKey:@"collectionRelDomainArray"];
}


//保存是否发送心跳包
+ (void)setCollectionPingType:(NSArray *)collectionPingTypeArray{
    [USER_DEFAULT setObject:collectionPingTypeArray forKey:@"collectionPingTypeArray"];
    [USER_DEFAULT synchronize];
}

//获取collection心跳包
+ (NSArray *)getCollectionPingTypeArray{
    return [USER_DEFAULT objectForKey:@"collectionPingTypeArray"];
}

#pragma mark 保存登录信息
//保存当前版本号
+ (void)setSystemVersion:(NSString *)syetemVersion{
    [USER_DEFAULT setObject:syetemVersion forKey:@"syetemVersion"];
    [USER_DEFAULT synchronize];
}

//获取当前版本号
+ (NSString *)getSystemVersion{
    return [USER_DEFAULT objectForKey:@"syetemVersion"];
}

//保存登录信息
+ (void)setLoginUserInfo:(NSDictionary *)loginUserInfo{
    [USER_DEFAULT setObject:loginUserInfo forKey:@"loginUserInfo"];
    [USER_DEFAULT synchronize];
}

//获取登录信息
+ (NSDictionary *)getLoginUserInfo{
    return [USER_DEFAULT objectForKey:@"loginUserInfo"];
}


//保存过期时间
+ (void)setExpiretime:(NSString *)expireTime{
    [USER_DEFAULT setObject:expireTime forKey:@"expireTime"];
    [USER_DEFAULT synchronize];
}

//获取过期时间
+ (NSString *)getExpiretime{
    return [USER_DEFAULT objectForKey:@"expireTime"];
}

//保存我的过期时间图标
+ (void)setMineExpireImage:(NSString *)mineExpireImage{
    [USER_DEFAULT setObject:mineExpireImage forKey:@"mineExpireImage"];
    [USER_DEFAULT synchronize];
}

//获取我的过期时间图标
+ (NSString *)getMineExpireImage{
    return [USER_DEFAULT objectForKey:@"mineExpireImage"];
}

////保存心跳发送时间
//+ (void)setPinetime:(NSString *)pingtime{
//    [USER_DEFAULT setObject:pingtime forKey:@"pingtime"];
//    [USER_DEFAULT synchronize];
//}
//
////获取心跳发送时间
//+ (NSString *)getPingtime{
//    return [USER_DEFAULT objectForKey:@"pingtime"];
//}

//保存是否第一次安装APP
+ (void)setIsFirst:(NSString *)isFirst{
    [USER_DEFAULT setObject:isFirst forKey:@"isFirst"];
    [USER_DEFAULT synchronize];
}

//获取是否第一次安装APP
+ (NSString *)getIsFirst{
    return [USER_DEFAULT objectForKey:@"isFirst"];
}


//保存上一次的消息请求时间
+ (void)setLastRequestTime:(NSString *)timeString{
    [USER_DEFAULT setObject:timeString forKey:@"timeString"];
    [USER_DEFAULT synchronize];
}

//获取上一次消息的请求时间
+ (NSString *)getLastRequestTime{
    return [USER_DEFAULT objectForKey:@"timeString"];
}

//保存上一次新消息的请求时间
+ (void)setFriendNewMessageTime:(NSDictionary *)friendNewMessage friendId:(NSString *)friendId{
    [USER_DEFAULT setObject:friendNewMessage forKey:friendId];
    [USER_DEFAULT synchronize];
}

//获取上一次的新消息时间
+ (NSDictionary *)getFriendNewMessageTimeFriendId:(NSString *)friendId{
    return [USER_DEFAULT objectForKey:friendId];
}

//保存好友定时器请求时间
+ (void)setFriendListPingTime:(NSString *)friendListPingTime{
    [USER_DEFAULT setObject:friendListPingTime forKey:@"friendListPingTime"];
    [USER_DEFAULT synchronize];
}

//获取好友定时器请求时间
+ (NSString *)getFriendListPingTime{
    return [USER_DEFAULT objectForKey:@"friendListPingTime"];
}

//保存新消息定时器请求时间
+ (void)setNewsListPingTime:(NSString *)newsListPingTime{
    [USER_DEFAULT setObject:newsListPingTime forKey:@"newsListPingTime"];
    [USER_DEFAULT synchronize];
}

//获取新消息定时器请求时间
+ (NSString *)getNewsListPingTime{
    return [USER_DEFAULT objectForKey:@"newsListPingTime"];
}

//保存初始的userAgent
+ (void)setAppInfoUserAgent:(NSArray *)appInfoUserAgent{
    [USER_DEFAULT setObject:appInfoUserAgent forKey:@"appInfoUserAgent"];
    [USER_DEFAULT synchronize];
}

//获取初始的userAgent
+ (NSArray *)getAppInfoUserAgent{
    return [USER_DEFAULT objectForKey:@"appInfoUserAgent"];
}

//保存签到链接的URL
+ (void)setSignURLString:(NSString *)signUrlString{
    [USER_DEFAULT setObject:signUrlString forKey:@"signUrlString"];
    [USER_DEFAULT synchronize];
}

//获取签到链接的URL
+ (NSString *)getSignURLString{
    return [USER_DEFAULT objectForKey:@"signUrlString"];
}


//保存签到说明链接的URL
+ (void)setSignInformationURLString:(NSString *)informationSignUrl {
    [USER_DEFAULT setObject:informationSignUrl forKey:@"informationSignUrl"];
    [USER_DEFAULT synchronize];
}

//获取签到说明链接的URL
+ (NSString *)getSignInformationUrl {
    return [USER_DEFAULT objectForKey:@"informationSignUrl"];
}


//保存找回密码链接
+ (void)setFindPasswordURLStr:(NSString *)findPasswordURL{
    [USER_DEFAULT setObject:findPasswordURL forKey:@"findPasswordURL"];
    [USER_DEFAULT synchronize];
}

//获取找回密码链接
+ (NSString *)getFindPasswordURLStr{
    return [USER_DEFAULT objectForKey:@"findPasswordURL"];
}


#pragma mark 获取广点通ID
//获取广点通主ID
+ (void)setGDTMainID:(NSString *)mainID {
    [USER_DEFAULT setObject:mainID forKey:@"mainID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTMainID {
    return [USER_DEFAULT objectForKey:@"mainID"];
}


//获取开屏广告ID
+ (void)setGDTPlacementID:(NSString *)placementID {
    [USER_DEFAULT setObject:placementID forKey:@"placementID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTPlacementID {
    return [USER_DEFAULT objectForKey:@"placementID"];
}

//获取发现短视频广告ID
+ (void)setGDTCellNativeID:(NSString *)cellNativeID {
    [USER_DEFAULT setObject:cellNativeID forKey:@"cellNativeID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTCellNativeID {
    return [USER_DEFAULT objectForKey:@"cellNativeID"];
}

//获取SVIP广告ID
+ (void)setGDTVIPNativeID:(NSString *)VIPNativeID {
    [USER_DEFAULT setObject:VIPNativeID forKey:@"VIPNativeID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTVIPNativeID {
    return [USER_DEFAULT objectForKey:@"VIPNativeID"];
}

//获取视频平台退出广告ID
+ (void)setGDTExitNativeID:(NSString *)exitID {
    [USER_DEFAULT setObject:exitID forKey:@"exitID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTExitID {
    return [USER_DEFAULT objectForKey:@"exitID"];
}

//获取签到ID
+ (void)setGDTSignNativeID:(NSString *)signID {
    [USER_DEFAULT setObject:signID forKey:@"signID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGDTSignNativeID {
    return [USER_DEFAULT objectForKey:@"signID"];
}


//4.获取SVIP选集广告ID
+ (void)setSVIPXuanJiBannerID:(NSString *)xuanjiNativeID {
    
    [USER_DEFAULT setObject:xuanjiNativeID forKey:@"xuanjiNativeID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getSVIPXuanJiBannerID {
    
    return [USER_DEFAULT objectForKey:@"xuanjiNativeID"];
}


//5.获取首页BannerID
+ (void)setYouKanBannerID:(NSString *)youKanBannerID {
    
    [USER_DEFAULT setObject:youKanBannerID forKey:@"youKanBannerID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getYouKanBannerID {
    
    return [USER_DEFAULT objectForKey:@"youKanBannerID"];
}

//6.获取消息BannerID
+ (void)setMessageBannerID:(NSString *)messageBannerID {
    
    [USER_DEFAULT setObject:messageBannerID forKey:@"messageBannerID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getMessageBannerID {
    
    return [USER_DEFAULT objectForKey:@"messageBannerID"];
}


//9.获取使用卡券界面ID
+ (void)setUseCardNativeID:(NSString *)useCardNativeID {
    
    [USER_DEFAULT setObject:useCardNativeID forKey:@"useCardNativeID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getUseCardNativeID {
    
    return [USER_DEFAULT objectForKey:@"useCardNativeID"];
}

//10.获取领券界面ID
+ (void)setGetCardNativeID:(NSString *)getCardNativeID {
    
    [USER_DEFAULT setObject:getCardNativeID forKey:@"getCardNativeID"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getGetCardNativeID {
    
    return [USER_DEFAULT objectForKey:@"getCardNativeID"];
}


#pragma mark 关于我们
//关于我们文字
+ (void)setAboutusAppInfoString:(NSString *)appInfoString {
    
    [USER_DEFAULT setObject:appInfoString forKey:@"appInfoString"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getAboutusAppInfoString {
    
     return [USER_DEFAULT objectForKey:@"appInfoString"];
}

//关于我们二维码
+ (void)setAboutusCodeURL:(NSString *)codeURL {
    
    [USER_DEFAULT setObject:codeURL forKey:@"codeURL"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getAboutusCodeURL {
    
    return [USER_DEFAULT objectForKey:@"codeURL"];
}

//常见问题
+ (void)setQuestionAndAnswerString:(NSString *)prombleString {
    
    [USER_DEFAULT setObject:prombleString forKey:@"prombleString"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getQuestionAndAnswerString {
    
    return [USER_DEFAULT objectForKey:@"prombleString"];
}

//充值
+ (void)setAPPRechargeURL:(NSString *)rechargeURL {
    
    [USER_DEFAULT setObject:rechargeURL forKey:@"rechargeURL"];
    [USER_DEFAULT synchronize];
}

+ (NSString *)getAPPRechargeURL {
    
    return [USER_DEFAULT objectForKey:@"rechargeURL"];
}


//存特殊号码登录
+ (void)setPhonenumberStatus:(NSString *)phonenumber{
    [USER_DEFAULT setObject:phonenumber forKey:@"phonenumber"];
    [USER_DEFAULT synchronize];
}

//获取特殊号码登录
+ (NSString *)getPhonenumberStatus{
    return [USER_DEFAULT objectForKey:@"phonenumber"];
}

@end
