//
//  AppDelegate.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidePageViewController.h"
#import <UMMobClick/MobClick.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "MusicDownloadDataSource.h"
#import "TaskEntity.h"
#import "ShenHeMainController.h"



static UIBackgroundTaskIdentifier bgTaskIdentifier;
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //友盟统计
    [self setUMConfigInstance];
    
    //友盟分享
    [self setUMShare];
    
    //友盟推送
    [self setUMPushLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self goToNextController];
    [self.window makeKeyAndVisible];
    
    //设置广点通
    [self setSplashView];
    
    //初始化为下载完成的列表
    [[MusicPartnerDownloadManager sharedInstance] initUnFinishedTask];
    return YES;
}


- (void)goToNextController{

    if([YKXNetworkUtil isIpv6]){
        
        //IPV6情况下第一次默认启动审核界面
        NSString *opIpv6 = [[NSUserDefaults standardUserDefaults] objectForKey:@"op"];
        
        if(opIpv6.length == 0){
            
            ShenHeMainController *mainVC = [[ShenHeMainController alloc] init];
            self.window.rootViewController = mainVC;
            
        }else{
            
            if([opIpv6 isEqualToString:@"1"]){
                
                ShenHeMainController *mainVC = [[ShenHeMainController alloc] init];
                self.window.rootViewController = mainVC;
            }else{
                //主界面
                MainViewController *mainVC = [[MainViewController alloc] init];
                self.window.rootViewController = mainVC;
                
                self.mainVC = mainVC;
                
                [self setTabBarBadge];
                
            }
        }
        
        NSString *yybox = @"0";
        
        //手机唯一码
        NSString *openUDID = [OpenUDID value];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        
        NSString *devType = @"2";
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",yybox,openUDID,devType,timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataPostIPV6Displayyybox:yybox imei:openUDID versionCode:versionCode devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
            
            NSString *errorCode = responseObject[@"error_code"];
            
            if([[NSString stringWithFormat:@"%@",errorCode] isEqualToString:@"0"]){
                
                NSString *op = responseObject[@"op"];
                
                [[NSUserDefaults standardUserDefaults] setObject:op forKey:@"op"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        } failure:^(NSError *error) {
        }];
        
    }else{

        //主界面
        MainViewController *mainVC = [[MainViewController alloc] init];
        self.window.rootViewController = mainVC;

        self.mainVC = mainVC;

        [self setTabBarBadge];

    }
}

- (void)setTabBarBadge{
    
    //从数据库获取好友列表
    FMDBManager *manager = [FMDBManager sharedFMDBManager];
    //给其他设置小红点
    NSArray *dbRemindList = [manager receiveRemindInfoList];
    
    if(dbRemindList.count >0){
        
        for(NSDictionary *remindDic in dbRemindList){
            
            NSString *remindId = remindDic[@"remind_id"];
            NSString *type = remindDic[@"type"];
            if([remindId isEqualToString:@"4"]){
                if([type isEqualToString:@"0"]){
                    
                    [self.mainVC.tabBar hideMarkIndex:0];
                }else{
                    [self.mainVC.tabBar showPointMarkIndex:0];
                }
            }else if ([remindId isEqualToString:@"5"]){
                if([type isEqualToString:@"0"]){
                    
                    [self.mainVC.tabBar hideMarkIndex:2];
                }else{
                    [self.mainVC.tabBar showPointMarkIndex:2];
                }
            }else if ([remindId isEqualToString:@"6"]){
                if([type isEqualToString:@"0"]){
                    
                    [self.mainVC.tabBar hideMarkIndex:3];
                }else{
                    [self.mainVC.tabBar showPointMarkIndex:3];
                }
            }
        }
    }
    
    
    NSDictionary *loginInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginInfo.count == 0){
        return;
    }
    
    
    NSArray *dbArray = [manager receiveFriendList];
    
    for (NSDictionary *dict in dbArray){
        
        NSString *count = dict[@"count"];
        NSInteger badge = [count integerValue];
        _badgeCount += badge;
    }
    
    //给消息设置角标
    [self.mainVC.tabBar showBadgeMark:_badgeCount index:1];
    
}

//控制全部不支持横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}


//友盟统计
- (void)setUMConfigInstance{
    
    UMConfigInstance.appKey = UMKey;
    UMConfigInstance.channelId = @"App store";
    [MobClick startWithConfigure:UMConfigInstance];
    //获取当前所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app版本号
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:appVersion];
}

//友盟分享
- (void)setUMShare{
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:QQID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatKey appSecret:WechatSecrect redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WechatKey appSecret:WechatSecrect redirectURL:@"http://mobile.umeng.com/social"];
    
}

//UMeng分享、登录的回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


//设置开屏广告
- (void)setSplashView{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
        NSString *placementID = [YKXDefaultsUtil getGDTPlacementID];
        
        if(GDTMainID.length == 0 || placementID.length == 0 || [GDTMainID isEqualToString:@"0"] || [placementID isEqualToString:@"0"]){
            
            GDTMainID = GDTID;
            
            placementID = GDTPlacementID;
        }
        
        GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:GDTMainID placementId:placementID];
        
        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
        if(IPHONE5){
            
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"startup320x568"]];
            
        }else if (IPHONE6){
            
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"startup375x667"]];
            
        }else{
            
            //这里是414-736一定要使用与屏幕一样大的图片 把分辨率调一下
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"startup414x736"]];
            
        }
        
        splashAd.delegate = self;
        //设置开屏拉取时长限制，若超时则不再展示广告

    
        //设置开屏底部自定义LogoView，展示半屏开屏广告
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 81*kWJHeightCoefficient)];
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo"]];
        logo.frame = CGRectMake(_bottomView.frame.origin.x, _bottomView.frame.origin.y, _bottomView.frame.size.width, _bottomView.frame.size.height);
        [_bottomView addSubview:logo];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        //跳过按钮
        _skipView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 34, 18)];
        _skipView.layer.cornerRadius = 9;
        _skipView.layer.masksToBounds = YES;
        _skipView.alpha = 0.5;
        _skipView.backgroundColor = [UIColor colorWithHexString:@"#9F9F9F"];
        
        
        UILabel *skipLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 1, 18, 16)];
        skipLabel.text = @"跳过";
        skipLabel.font = [UIFont systemFontOfSize:8.0f];
        skipLabel.textColor = [UIColor whiteColor];
        [_skipView addSubview:skipLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(skipLabel.frame), 1, 10, 16)];
        textLabel.text = @"4";
        textLabel.font = [UIFont systemFontOfSize:8.0f];
        textLabel.textColor = [UIColor whiteColor];
        self.textLabel = textLabel;
        
        
        [splashAd loadAdAndShowInWindow:self.window withBottomView:_bottomView skipView:_skipView];
        self.splash = splashAd;
        
        
        _skiptimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(skipTime) userInfo:nil repeats:YES];
        [_skipView addSubview:textLabel];
    }
}

- (void)skipTime{
    
    _runLoopTimes++;
    _textLabel.text = [NSString stringWithFormat:@"%ld", 4-_runLoopTimes];
    
    if(_runLoopTimes == 4){
        [_skiptimer invalidate];
        _skiptimer = nil;
    }
}

- (void)setUMPushLaunchOptions:(NSDictionary *)launchOptions{
    //初始化适配https
    [UMessage startWithAppkey:UMKey launchOptions:launchOptions httpsEnable:YES];
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types = UNAuthorizationOptionBadge| UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSString *oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldTimeValue"];
    
    NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
    
    NSString *nowTime = [NSString stringWithFormat:@"%f",timeInterVal];
    
    NSInteger minusTime = [nowTime integerValue] - [oldTime integerValue];
    
    if(minusTime >= 300){
        
        [self setSplashView];
    }
    
    if(![YKXNetworkUtil isIpv6]){
        
        [self endBackgroundTask];
        //进入前台后取消延迟执行
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(getBackgroundTask) object:nil];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    _textLabel.text = @"4";
    _runLoopTimes = 0;
    [self.skipView removeFromSuperview];
    self.skipView = nil;
    
    NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
    
    NSString *nowTime = [NSString stringWithFormat:@"%f",timeInterVal];
    
    [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:@"oldTimeValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if(![YKXNetworkUtil isIpv6]){
        
        //如果有正在下载的任务，延长APP后台运行时间，dataTask支持后台运行下载
        MusicDownloadDataSource *dataSource = [[MusicDownloadDataSource alloc] init];
        [dataSource loadUnFinishedTasks];
        
        NSMutableArray *downloadState = [NSMutableArray array];
        
        for(TaskEntity *taskEntity in dataSource.unFinishedTasks){
            //添加所有下载中的任务的状态
            [downloadState addObject:@(taskEntity.taskDownloadState)];
            
        }
        
        //如果有正在下载的任务延迟APP后台运行
        if([downloadState containsObject:@(1)]){
            
            [self getBackgroundTask];
        }
    }
}


/**
 *  获取后台任务
 */
- (void)getBackgroundTask {
    
    UIBackgroundTaskIdentifier tempTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    if (bgTaskIdentifier != UIBackgroundTaskInvalid) {
        
        [self endBackgroundTask];
    }
    
    bgTaskIdentifier = tempTask;
    
    
    
    //所有任务下载完成时取消APP后台运行
    MusicDownloadDataSource *dataSource = [[MusicDownloadDataSource alloc] init];
    [dataSource loadUnFinishedTasks];
    
    
    NSMutableArray *downloadState = [NSMutableArray array];
    
    for(TaskEntity *taskEntity in dataSource.unFinishedTasks){
        
        //添加所有下载中的任务的状态
        [downloadState addObject:@(taskEntity.taskDownloadState)];
    }
    
    //如果有正在下载的任务
    if(![downloadState containsObject:@(1)]){
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(getBackgroundTask) object:nil];
        
        return;
    }
    
    [self performSelector:@selector(getBackgroundTask) withObject:nil afterDelay:120];
    
}


/**
 *  结束后台任务
 */
- (void)endBackgroundTask{
    
    [[UIApplication sharedApplication] endBackgroundTask:bgTaskIdentifier];
    bgTaskIdentifier = UIBackgroundTaskInvalid;
}


@end
