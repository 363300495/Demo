//
//  HttpService.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject


//设置IPV6界面是否隐藏
+ (void)loadDataPostIPV6Displayyybox:(NSString *)yybox imei:(NSString *)imei versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;



//发现模块
+ (void)loadDataPostChannel_id:(NSString *)channel_id imei:(NSString *)imei uid:(NSString *)uid token:(NSString *)token remind:(NSString *)remind iphoneType:(NSString *)iphoneType screenWidth:(NSString *)screenWidth screenHeight:(NSString *)screenHeight idfa:(NSString *)idfa iphoneVersion:(NSString *)phoneVersion deviceType:(NSString *)deviceType version:(NSString *)version versionCode:(NSString *)versionCode atid:(NSString *)atid findmenu_v:(NSString *)findmenu_v ucenter_v:(NSString *)ucenter_v notice_v:(NSString *)notice_v carousel_v:(NSString *)carousel_v recserve_v:(NSString *)recserve_v vweb_v:(NSString *)vweb_v devType:(NSString *)devtype timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//发送验证码
+ (void)loadDataPostMobile:(NSString *)mobile imei:(NSString *)imei versionCode:(NSString *)versionCode type:(NSString *)type devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//手机登录
+ (void)loadDataPhoneLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode Channel_id:(NSString *)channel_id Mobile:(NSString *)mobile smsCode:(NSString *)smsCode model:(NSString *)model imei:(NSString *)imei sysVersion:(NSString *)sysVersion devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//游客登录
+ (void)loadDataVisitorLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode channel_id:(NSString *)channel_id model:(NSString *)model imei:(NSString *)imei syversion:(NSString *)syversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//QQ、微信登录
+ (void)loadDataqqOrWechatLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode channel_id:(NSString *)channel_id openId:(NSString *)openId nickName:(NSString *)nickName sex:(NSString *)sex headImageURL:(NSString *)headImageURL province:(NSString *)province city:(NSString *)city model:(NSString *)model imei:(NSString *)imei syversion:(NSString *)sysversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//用户注册
+ (void)loadDataUserRegisterPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode imei:(NSString *)imei username:(NSString *)username phoneNumber:(NSString *)phoneNumber oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword action:(NSString *)action channelId:(NSString *)channelId devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//用户登录
+ (void)loadDataUserLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode username:(NSString *)username password:(NSString *)password channelId:(NSString *)channelId model:(NSString *)model imei:(NSString *)imei sysversion:(NSString *)sysversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//绑定手机号码、绑定微信、绑定QQ
+ (void)loadDataBindUserInfoUid:(NSString *)uid token:(NSString *)token channel_id:(NSString *)channelId versionCode:(NSString *)versionCode type:(NSString *)type mobile:(NSString *)mobile smsCode:(NSString *)smsCode headImgurl:(NSString *)headImgurl devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//获取用户信息
+ (void)loadDataUserinfoPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//用户退出
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取消息列表
+ (void)loadDataMessageListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//意见反馈
+ (void)loadDataFeedbackPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb label:(NSString *)label content:(NSString *)content currentUrl:(NSString *)url devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//分享请求
+ (void)loadDataSharePostType:(NSString *)type uid:(NSString *)uid token:(NSString *)token shareType:(NSString *)shareType shareId:(NSString *)shareId versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取cookie信息
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//心跳包
+ (void)loadDataDoPingPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//释放cookie资源
+ (void)loadDataReleaseCookiePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//获取待领取卡券
+ (void)loadDataGetWiatCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devtype:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//免费领取卡券
+ (void)loadDataGetFreeCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode activity_id:(NSString *)activity_id devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取卡券包
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode type:(NSString *)type devType:(NSString *)devType timeStamp:(NSString *)timeStamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//使用卡券
+ (void)loadDataUseCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode cid:(NSString *)cid devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//转赠卡券
+ (void)loadDataGiveCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode cid:(NSString *)cid devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//使用激活码
+ (void)loadDataEnteryActivationCodePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode code:(NSString *)code devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//分享领取日志
+ (void)loadDataShareReceiveLogPostPage:(NSString *)page uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//分享日志
+ (void)loadDataShareLogPostPage:(NSString *)page uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取JS修改爱奇艺等界面
+ (void)loadDataGetJSReviseUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb loadtype:(NSString *)loadtype devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取短视频、美女直播等jS
+ (void)loadDataGetJSServiceUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode loadJs:(NSString *)loadJs devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//手动切换账号
+ (void)loadDataSwitchAccountNumberUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb groupid:(NSString *)groupid devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//SVIP通道
+ (void)loadDataSVIPChannelTitle:(NSString *)title URL:(NSString *)url versionCode:(NSString *)versionCode line:(NSString *)line uid:(NSString *)uid token:(NSString *)token vweb:(NSString *)vweb devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//获取消息列表
+ (void)loadDataGetFriendMessageListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode lastRequest:(NSString *)lastRequest devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取新消息
+ (void)loadDataGetFriendNewMessagePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode friendId:(NSString *)friendId lastRequest:(NSString *)lastRequest devtype:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//发送消息
+ (void)loadDataGetFriendSendMessagePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode friendId:(NSString *)friendId content:(NSString *)content devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取小视频列表
+ (void)loadDataVideoListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取签到信息
+ (void)loadDataSignIntegerUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//视频收藏添加
+ (void)loadDataAddColectionUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb title:(NSString *)title url:(NSString *)url devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//视频收藏删除
+ (void)loadDataDeleteCollectionPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode collection_id:(NSString *)collectionId devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//视频收藏列表
+ (void)loadDataCollectionListUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

//获取视频下载列表
+ (void)loadDataGetVideoDownloadListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//大家都在下列表
+ (void)loadDataDownloadRecommendPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;


//检测是否需要获取m3u8文件
+ (void)loadDataPostCheckSvipURLCurrentURL:(NSString *)url uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;

@end
