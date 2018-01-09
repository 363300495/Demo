//
//  HttpService.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService

//设置IPV6界面是否隐藏
+ (void)loadDataPostIPV6Displayyybox:(NSString *)yybox imei:(NSString *)imei versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    
    NSDictionary *parmas = @{@"yybox":yybox,@"imei":imei,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:YYBOX_URL parameters:parmas success:^(id responseObject) {
        
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//发现模块
+ (void)loadDataPostChannel_id:(NSString *)channel_id imei:(NSString *)imei uid:(NSString *)uid token:(NSString *)token remind:(NSString *)remind iphoneType:(NSString *)iphoneType screenWidth:(NSString *)screenWidth screenHeight:(NSString *)screenHeight idfa:(NSString *)idfa iphoneVersion:(NSString *)phoneVersion deviceType:(NSString *)deviceType version:(NSString *)version versionCode:(NSString *)versionCode atid:(NSString *)atid findmenu_v:(NSString *)findmenu_v ucenter_v:(NSString *)ucenter_v notice_v:(NSString *)notice_v carousel_v:(NSString *)carousel_v recserve_v:(NSString *)recserve_v vweb_v:(NSString *)vweb_v devType:(NSString *)devtype timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"channel_id":channel_id,@"imei":imei,@"uid":uid,@"token":token,@"remind_v":remind,@"model":iphoneType,@"swidth":screenWidth,@"sheight":screenHeight,@"deviceid":idfa,@"syversion":phoneVersion,@"devicebn":deviceType,@"version":version,@"version_code":versionCode,@"atid":atid,@"findmenu_v":findmenu_v,@"ucenter_v":ucenter_v,@"notice_v":notice_v,@"carousel_v":carousel_v,@"recserve_v":recserve_v,@"vweb_v":vweb_v,@"devtype":devtype,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FIND_URL] parameters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//发送验证码
+ (void)loadDataPostMobile:(NSString *)mobile imei:(NSString *)imei versionCode:(NSString *)versionCode type:(NSString *)type devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"mobile":mobile,@"imei":imei,@"version_code":versionCode,@"type":type,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SENDMESSAGE_URL] parameters:params success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//手机号码登录
+ (void)loadDataPhoneLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode Channel_id:(NSString *)channel_id Mobile:(NSString *)mobile smsCode:(NSString *)smsCode model:(NSString *)model imei:(NSString *)imei sysVersion:(NSString *)sysVersion devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"logintype":loginType,@"version_code":versionCode,@"channel_id":channel_id,@"mobile":mobile,@"smscode":smsCode,@"model":model,@"imei":imei,@"syversion":sysVersion,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,LOGIN_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//游客登录
+ (void)loadDataVisitorLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode channel_id:(NSString *)channel_id model:(NSString *)model imei:(NSString *)imei syversion:(NSString *)syversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"logintype":loginType,@"version_code":versionCode,@"channel_id":channel_id,@"model":model,@"imei":imei,@"syversion":syversion,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,LOGIN_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//QQ、微信登录
+ (void)loadDataqqOrWechatLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode channel_id:(NSString *)channel_id openId:(NSString *)openId nickName:(NSString *)nickName sex:(NSString *)sex headImageURL:(NSString *)headImageURL province:(NSString *)province city:(NSString *)city model:(NSString *)model imei:(NSString *)imei syversion:(NSString *)sysversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"logintype":loginType,@"version_code":versionCode,@"channel_id":channel_id,@"openid":openId,@"nickname":nickName,@"sex":sex,@"headimgurl":headImageURL,@"province":province,@"city":city,@"model":model,@"imei":imei,@"syversion":sysversion,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,LOGIN_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//用户注册
+ (void)loadDataUserRegisterPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode imei:(NSString *)imei username:(NSString *)username phoneNumber:(NSString *)phoneNumber oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword action:(NSString *)action channelId:(NSString *)channelId devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *parmas = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"imei":imei,@"user_name":username,@"safetycode":phoneNumber,@"user_pwd_old":oldPassword,@"user_pwd":newPassword,@"action":action,@"channel_id":channelId,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,USERREGISTER_URL] parameters:parmas success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//用户登录
+ (void)loadDataUserLoginPostLoginType:(NSString *)loginType versionCode:(NSString *)versionCode username:(NSString *)username password:(NSString *)password channelId:(NSString *)channelId model:(NSString *)model imei:(NSString *)imei sysversion:(NSString *)sysversion devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"logintype":loginType,@"version_code":versionCode,@"user_name":username,@"user_pwd":password,@"channel_id":channelId,@"model":model,@"imei":imei,@"syversion":sysversion,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,LOGIN_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//绑定手机号码、绑定微信、绑定QQ
+ (void)loadDataBindUserInfoUid:(NSString *)uid token:(NSString *)token channel_id:(NSString *)channelId versionCode:(NSString *)versionCode type:(NSString *)type mobile:(NSString *)mobile smsCode:(NSString *)smsCode headImgurl:(NSString *)headImgurl devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params;
    
    if([type isEqualToString:@"1"]){//手机号码
        
        params = @{@"uid":uid,@"token":token,@"channel_id":channelId,@"version_code":versionCode,@"type":type,@"mobile":mobile,@"smscode":smsCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    }else if ([type isEqualToString:@"2"]){//微信
        
        params = @{@"uid":uid,@"token":token,@"channel_id":channelId,@"version_code":versionCode,@"type":type,@"wx_openid":mobile,@"wx_nickname":smsCode,@"wx_headimgurl":headImgurl,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    }else if ([type isEqualToString:@"3"]){//QQ
        
        params = @{@"uid":uid,@"token":token,@"channel_id":channelId,@"version_code":versionCode,@"type":type,@"qq_openid":mobile,@"qq_nickname":smsCode,@"qq_headimgurl":headImgurl,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    }
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,USERBIND_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取用户信息
+ (void)loadDataUserinfoPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,USERINFO_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//用户退出
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,EXIT_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取消息列表
+ (void)loadDataMessageListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,MESSAGELIST_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//意见反馈
+ (void)loadDataFeedbackPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb label:(NSString *)label content:(NSString *)content currentUrl:(NSString *)url devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"label":label,@"content":content,@"url":url,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FEEDBACK_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//分享请求
+ (void)loadDataSharePostType:(NSString *)type uid:(NSString *)uid token:(NSString *)token shareType:(NSString *)shareType shareId:(NSString *)shareId versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"type":type,@"uid":uid,@"token":token,@"share_type":shareType,@"id":shareId,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SHARELAUNCH_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//获取cookie信息
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,GETCOOKIE_URL] parameters:params success:^(id responseObject) {
    
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//心跳包
+ (void)loadDataDoPingPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,DOPING_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


//释放cookie资源
+ (void)loadDataReleaseCookiePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,RELEASECOOKIE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//获取待领取卡券
+ (void)loadDataGetWiatCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devtype:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,WAITCARD_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//免费领取卡券
+ (void)loadDataGetFreeCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode activity_id:(NSString *)activity_id devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"activity_id":activity_id,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FREECARD_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取卡券包
+ (void)loadDataPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode type:(NSString *)type devType:(NSString *)devType timeStamp:(NSString *)timeStamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"type":type,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,GETCARDLIST_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//使用卡券
+ (void)loadDataUseCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode cid:(NSString *)cid devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"cid":cid,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,USECARD_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//转赠卡券
+ (void)loadDataGiveCardPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode cid:(NSString *)cid devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"cid":cid,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,GIVENCARD_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//使用激活码
+ (void)loadDataEnteryActivationCodePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode code:(NSString *)code devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"code":code,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,ACTIVATIONCODE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//分享领取日志
+ (void)loadDataShareReceiveLogPostPage:(NSString *)page uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"page":page,@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SHARERECEIVELOG_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//分享日志
+ (void)loadDataShareLogPostPage:(NSString *)page uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"page":page,@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SHARELOG_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取JS修改爱奇艺等界面
+ (void)loadDataGetJSReviseUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb loadtype:(NSString *)loadtype devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"loadtype":loadtype,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,JSCONTENT_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//获取短视频、美女直播等jS
+ (void)loadDataGetJSServiceUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode loadJs:(NSString *)loadJs devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"loadjs":loadJs,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,JSSERVICE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//手动切换账号
+ (void)loadDataSwitchAccountNumberUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb groupid:(NSString *)groupid devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"groupid":groupid,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SWITCH_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//SVIP通道
+ (void)loadDataSVIPChannelTitle:(NSString *)title URL:(NSString *)url versionCode:(NSString *)versionCode line:(NSString *)line uid:(NSString *)uid token:(NSString *)token vweb:(NSString *)vweb devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"title":title,@"url":url,@"version_code":versionCode,@"line":line,@"uid":uid,@"token":token,@"vweb":vweb,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SVIP_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//获取好友消息列表
+ (void)loadDataGetFriendMessageListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode lastRequest:(NSString *)lastRequest devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"lastrequest":lastRequest,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FRIENDMESSAGE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取新消息
+ (void)loadDataGetFriendNewMessagePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode friendId:(NSString *)friendId lastRequest:(NSString *)lastRequest devtype:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"friends_id":friendId,@"lastrequest":lastRequest,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FRIENDNEWMESSAGE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


//发送消息
+ (void)loadDataGetFriendSendMessagePostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode friendId:(NSString *)friendId content:(NSString *)content devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"friends_id":friendId,@"content":content,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,FRIENDSENDMESSAGE_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取小视频列表
+ (void)loadDataVideoListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure{
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"page":page,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,VIDEOLIST_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//获取签到信息
+ (void)loadDataSignIntegerUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,SIGN_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];    
}

//视频收藏添加
+ (void)loadDataAddColectionUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb title:(NSString *)title url:(NSString *)url devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"title":title,@"url":url,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,ADDCOLLECTION_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//视频收藏删除
+ (void)loadDataDeleteCollectionPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode collection_id:(NSString *)collectionId devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"collection_id":collectionId,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,DELETECOLLECTION_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//视频收藏列表
+ (void)loadDataCollectionListUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devtype:(NSString *)devtype timestamp:(NSString *)timestamp randcode:(NSString *)randcode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"page":page,@"devtype":devtype,@"timestamp":timestamp,@"randcode":randcode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,GETCOLLECTIONLIST_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//获取视频下载列表
+ (void)loadDataGetVideoDownloadListPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode page:(NSString *)page devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"page":page,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,GETVIDEODOWNLOADLIST_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//大家都在下列表
+ (void)loadDataDownloadRecommendPostUid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"uid":uid,@"token":token,@"version_code":versionCode,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,DOWNLOADRECOMMEND_URL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}


//检测是否需要获取m3u8文件
+ (void)loadDataPostCheckSvipURLCurrentURL:(NSString *)url uid:(NSString *)uid token:(NSString *)token versionCode:(NSString *)versionCode vweb:(NSString *)vweb devType:(NSString *)devType timeStamp:(NSString *)timeStamp randCode:(NSString *)randCode sign:(NSString *)sign sucess:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    
    NSDictionary *params = @{@"url":url,@"uid":uid,@"token":token,@"version_code":versionCode,@"vweb":vweb,@"devtype":devType,@"timestamp":timeStamp,@"randcode":randCode,@"sign":sign};
    
    [HttpServiceManager POST:[NSString stringWithFormat:@"%@%@",PUBLIC,CHECKSVIPURL] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
