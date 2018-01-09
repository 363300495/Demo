//
//  YouKanViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YouKanViewController.h"
#import "CustomHotServiceCell.h"
#import "CustomRecommendCell.h"
#import "YKXVideoViewController.h"
#import "YKXServiceViewController.h"
#import "YKXLoginViewController.h"
#import "YKXCustomActivityView.h"
#import "FreeCardViewController.h"
#import "YKXSVIPViewController.h"
#import "CardListViewController.h"
#import "FreeCardViewController.h"
#import "ShareActivityController.h"
#import "YKXSystemSettingController.h"
#import "YKXCollectionListController.h"
#import "YKXWatchingViewController.h"
#import "DownloadViewController.h"
#import "YkXUserSignViewController.h"
#import <AdSupport/AdSupport.h>
#import "AppDelegate.h"

@interface YouKanViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

/**
数据库
 */
@property (nonatomic,strong) FMDBManager *manager;

//头部轮播图名称
@property (nonatomic,strong) NSMutableArray *carouselNameArray;
//头部轮播图图片
@property (nonatomic,strong) NSMutableArray *carouselImageURLArray;
//头部轮播图链接
@property (nonatomic,strong) NSMutableArray *carouselURLArray;
//头部轮播图loadjs
@property (nonatomic,strong) NSMutableArray *carouselLoadJSArray;
//头部轮播图拦截链接字符串
@property (nonatomic,strong) NSMutableArray *carouselResDomainArray;
//头部轮播图未拦截链接字符串
@property (nonatomic,strong) NSMutableArray *carouselRelDomainArray;

//分组头部标题
@property (nonatomic,strong) NSMutableArray *headTitleArray;
//分组头部链接
@property (nonatomic,strong) NSMutableArray *headURLArray;

//collection标题数据
@property (nonatomic,strong) NSMutableArray *collectionHeadTitleList;
//collection详情数据
@property (nonatomic,strong) NSMutableArray *collectionHeadDetailList;
//collection图片数据
@property (nonatomic,strong) NSMutableArray *collectionHeadImageList;
//collection网站类型
@property (nonatomic,strong) NSMutableArray *collectionHeadVwebList;
//collection链接数据
@property (nonatomic,strong) NSMutableArray *collectionHeadURLList;
//collection弹出框标题
@property (nonatomic,strong) NSMutableArray *collectionHeadAlertTitleList;
//collectionjs类型
@property (nonatomic,strong) NSMutableArray *collectionHeadLoadJSList;
//collection拦截链接字符串
@property (nonatomic,strong) NSMutableArray *collectionHeadResDomainList;
//collection未拦截链接字符串
@property (nonatomic,strong) NSMutableArray *collectionHeadRelDomainList;
//collection userAgent
@property (nonatomic,strong) NSMutableArray *collectionHeadUserAgentList;
//collection是否发送心跳包
@property (nonatomic,strong) NSMutableArray *collectionHeadTypeList;



//底部通告
@property (nonatomic,strong) NSArray *noticeArray;

//导航栏底部的横线
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;
//导航栏左侧的按钮
@property (nonatomic,strong) UIButton *leftNavcButton;
//导航栏右侧的按钮
@property (nonatomic,strong) UIButton *rightNavcButton;

//头部滑动视图
@property (nonatomic,strong) UIScrollView *headScrollView;
//头部pageControl
@property (nonatomic,strong) UIPageControl *headPageControl;
//创建collectionView
@property (nonatomic,strong) UICollectionView *collectionView;
//创建collectionView第一组头部视图
@property (nonatomic,strong) UIView *rootRecommendView;
//创建collectionView第二组头部视图
@property (nonatomic,strong) UIView *rootHotServiceView;

//通告滑动视图
@property (nonatomic,strong) UIScrollView *noticeScrollView;
//头部广告定时器
@property (nonatomic,strong) NSTimer *headScrollViewTimer;

//通告定时器
@property (nonatomic,strong) NSTimer *noticeTimer;


//防止collectionCell重复点击
@property (nonatomic,assign) BOOL isSelected;


@end

@implementation YouKanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navBarHairlineImageView.hidden = YES;
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];

    //开启定时器
    if(self.headScrollViewTimer){
       [self.headScrollViewTimer setFireDate:[NSDate distantPast]];
    }
    if(self.noticeTimer){
        [self.noticeTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navBarHairlineImageView.hidden = NO;
    
    //暂停定时器
    if(self.headScrollViewTimer){
        [self.headScrollViewTimer setFireDate:[NSDate distantFuture]];
    }
    if(self.noticeTimer){
        [self.noticeTimer setFireDate:[NSDate distantFuture]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //激活码成功后修改APP信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAppInfo) name:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (UIView *subView in appDelegate.mainVC.tabBar.subviews) {
        if (subView.tag == 1001) {
            [appDelegate.mainVC.tabBar bringSubviewToFront:subView];
        }
    }
    
    
    [self initArray];
    [self createNavc];
    [self createView];
    
    
    //刷新collectionView列表
    NSTimer *APPInfoTimer = [NSTimer timerWithTimeInterval:1800 target:self selector:@selector(initData) userInfo:nil repeats:YES];
    [APPInfoTimer fire];
    [[NSRunLoop mainRunLoop] addTimer:APPInfoTimer forMode:NSRunLoopCommonModes];
    
}


#pragma mark  初始化数据
/**
 初始化数组
 */
- (void)initArray{
    
    _manager = [FMDBManager sharedFMDBManager];
    _carouselNameArray = [NSMutableArray array];
    _carouselImageURLArray = [NSMutableArray array];
    _carouselURLArray = [NSMutableArray array];
    _carouselLoadJSArray = [NSMutableArray array];
    _carouselResDomainArray = [NSMutableArray array];
    _carouselRelDomainArray = [NSMutableArray array];
    _headTitleArray = [NSMutableArray array];
    _headURLArray = [NSMutableArray array];
    _collectionHeadTitleList = [NSMutableArray array];
    _collectionHeadDetailList = [NSMutableArray array];
    _collectionHeadImageList = [NSMutableArray array];
    _collectionHeadURLList = [NSMutableArray array];
    _collectionHeadVwebList = [NSMutableArray array];
    _collectionHeadLoadJSList = [NSMutableArray array];
    _collectionHeadAlertTitleList = [NSMutableArray array];
    _collectionHeadResDomainList = [NSMutableArray array];
    _collectionHeadRelDomainList = [NSMutableArray array];
    _collectionHeadUserAgentList = [NSMutableArray array];
    _collectionHeadTypeList = [NSMutableArray array];
}


/**
 每个模块请求的id与当前对应的id比较，不一致就请求对应模块的数据
 */
- (void)initData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *tempCarouselNameArray = [YKXDefaultsUtil getCarouselTitleArray];
        NSArray *tempCarouselImageURLArray = [YKXDefaultsUtil getCarouselImageURLArray];
        NSArray *tempCarouselURLArray = [YKXDefaultsUtil getCarouselURLArray];
        NSArray *tempCarouselLoadJSArray = [YKXDefaultsUtil getCarouselLoadJSArray];
        NSArray *tempCarouselResDomainArray = [YKXDefaultsUtil getCarouselResDomainArray];
        NSArray *tempCarouselRelDomainArray = [YKXDefaultsUtil getCarouselRelDomainArray];
        
        //头部滑动视图数据
        if(tempCarouselNameArray.count >0){
            self.carouselNameArray = [NSMutableArray arrayWithArray:tempCarouselNameArray];
        }
        if(tempCarouselImageURLArray.count >0){
           self.carouselImageURLArray = [NSMutableArray arrayWithArray:tempCarouselImageURLArray];
        }
        if(tempCarouselURLArray.count >0){
           self.carouselURLArray = [NSMutableArray arrayWithArray:tempCarouselURLArray];
        }
        if(tempCarouselLoadJSArray.count >0){
            self.carouselLoadJSArray = [NSMutableArray arrayWithArray:tempCarouselLoadJSArray];
        }
        if(tempCarouselResDomainArray.count >0){
            self.carouselResDomainArray = [NSMutableArray arrayWithArray:tempCarouselResDomainArray];
        }
        if(tempCarouselRelDomainArray.count >0){
            self.carouselRelDomainArray = [NSMutableArray arrayWithArray:tempCarouselRelDomainArray];
        }
        

        NSArray *tempHeadNameArray = [YKXDefaultsUtil getNoticeADTitleArray];
        NSArray *tempHeadURLArray = [YKXDefaultsUtil getNoticeADURLArray];
        
        //分组头部视图数据
        if(tempHeadNameArray.count >0){
           self.headTitleArray = [NSMutableArray arrayWithArray:tempHeadNameArray];
        }
        if(tempHeadURLArray.count >0){
           self.headURLArray = [NSMutableArray arrayWithArray:tempHeadURLArray];
        }
        
        
        NSArray *temptitleList = [YKXDefaultsUtil getCollectionTitleArray];
        NSArray *tempdetailList = [YKXDefaultsUtil getCollectionDetailArray];
        NSArray *tempImageList = [YKXDefaultsUtil getCollectionImageURLArray];
        NSArray *tempURLList = [YKXDefaultsUtil getCollectionURLArray];
        NSArray *tempVwebList = [YKXDefaultsUtil getCollectionVwebArray];
        NSArray *tempAlertTitleList = [YKXDefaultsUtil getCollectionAlertTitleArray];
        NSArray *tempLoadjsList = [YKXDefaultsUtil getCollectionJSArray];
        NSArray *tempCollectionResDomainList = [YKXDefaultsUtil getCollectionResDomainArray];
        NSArray *tempCollectionRelDomainList = [YKXDefaultsUtil getCollectionRelDomainArray];
        NSArray *tempCollectionUserAgentList = [YKXDefaultsUtil getCollectionUserAgent];
        NSArray *tempCollectionPingTypeList = [YKXDefaultsUtil getCollectionPingTypeArray];
        
        //collection的数据
        if(temptitleList.count >0){
            self.collectionHeadTitleList = [NSMutableArray arrayWithArray:temptitleList];
        }
        if(tempdetailList.count >0){
            self.collectionHeadDetailList = [NSMutableArray arrayWithArray:tempdetailList];
        }
        if(tempImageList.count >0){
            self.collectionHeadImageList = [NSMutableArray arrayWithArray:tempImageList];
        }
        if(tempURLList.count >0){
            self.collectionHeadURLList = [NSMutableArray arrayWithArray:tempURLList];
        }
        if(tempVwebList.count >0){
            self.collectionHeadVwebList = [NSMutableArray arrayWithArray:tempVwebList];
        }
        if(tempLoadjsList.count >0){
            self.collectionHeadLoadJSList = [NSMutableArray arrayWithArray:tempLoadjsList];
        }
        if(tempAlertTitleList.count >0){
            self.collectionHeadAlertTitleList = [NSMutableArray arrayWithArray:tempAlertTitleList];
        }
        if(tempCollectionResDomainList.count >0){
            self.collectionHeadResDomainList = [NSMutableArray arrayWithArray:tempCollectionResDomainList];
        }
        if(tempCollectionRelDomainList.count >0){
            self.collectionHeadRelDomainList = [NSMutableArray arrayWithArray:tempCollectionRelDomainList];
        }
        if(tempCollectionUserAgentList.count >0){
            self.collectionHeadUserAgentList = [NSMutableArray arrayWithArray:tempCollectionUserAgentList];
        }
        if(tempCollectionPingTypeList.count >0){
            self.collectionHeadTypeList = [NSMutableArray arrayWithArray:tempCollectionPingTypeList];
        }
    
        //获取本地渠道Id
        NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
        NSString *uid;
        NSString *token;
        if(loginUserInfo.count == 0){
            
            uid = @"0";
            token = @"0";
        }else{
            uid = loginUserInfo[@"uid"];
            token = loginUserInfo[@"token"];
        }
        
        
        NSString *channel_Id;
        if(loginUserInfo.count == 0){
            channel_Id = @"0";
        }else{
            channel_Id = loginUserInfo[@"channel_id"];
        }
        
        NSString *lastRemindVersion = [YKXDefaultsUtil getRemindVersion];
        if(lastRemindVersion == nil){
            lastRemindVersion = @"0";
        }
        
        //获取本地活动弹框模块Id
        NSString *lastAtId = [YKXDefaultsUtil getActivityId];
        if(lastAtId == nil){
            lastAtId = @"0";
        }
        
        //获取本地发现模块Id
        NSString *lastDiscoveryId = [YKXDefaultsUtil getDiscoveryId];
        if(lastDiscoveryId == nil){
            lastDiscoveryId = @"0";
        }
        
        //获取本地个人中心模块Id
        NSString *lastUcenterId = [YKXDefaultsUtil getCenterId];
        if(lastUcenterId == nil){
            lastUcenterId = @"0";
        }
        
        //获取通告中心模块Id
        NSString *lastNoticeId = [YKXDefaultsUtil getNoticeId];
        if(lastNoticeId == nil){
            lastNoticeId = @"0";
        }
        
        //获取轮播图模块Id
        NSString *lastCarouselId = [YKXDefaultsUtil getCarouselId];
        if(lastCarouselId == nil){
            lastCarouselId = @"0";
        }
        
        //获取推荐服务模块Id
        NSString *lastRecserveId = [YKXDefaultsUtil getRecserveId];
        if(lastRecserveId == nil){
            lastRecserveId = @"0";
        }
        
        //获取视频播放模块Id
        NSString *lastVipvwebId = [YKXDefaultsUtil getVipVwebId];
        if(lastVipvwebId == nil){
            lastVipvwebId = @"0";
        }
        
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //获取app当前版本号
        NSString *systemVesion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        //获取本地保存版本号
        NSString *lastSystemVersion = [YKXDefaultsUtil getSystemVersion];
        if(lastSystemVersion == nil){
            lastSystemVersion = @"0";
        }

    
        //如果版本号不同，则修改Id更新模块数据
        if(![lastSystemVersion isEqualToString:systemVesion]){
            
            lastRemindVersion = @"0";
            lastAtId = @"0";
            lastDiscoveryId = @"0";
            lastUcenterId = @"0";
            lastNoticeId = @"0";
            lastCarouselId = @"0";
            lastRecserveId = @"0";
            lastVipvwebId = @"0";
        }
        
        
        //获取手机机型
        NSString *iphoneType = [YKXCommonUtil iphoneType];
        
        NSString *screenWidth = [NSString stringWithFormat:@"%.f",SCREEN_WIDTH];
        
        NSString *screenHeight = [NSString stringWithFormat:@"%.f",SCREEN_HEIGHT];
        
        NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        //手机版本号
        NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
        
        NSString *deviceType = [YKXCommonUtil deviceType];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        
        //手机唯一码
        NSString *openUDID = [OpenUDID value];

        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",channel_Id,systemVesion,lastAtId,lastDiscoveryId,lastUcenterId,lastNoticeId,lastCarouselId,lastRecserveId,lastVipvwebId,@"2",timeStamp,YOYO,randCode];
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        //获取活动、发现页面、个人中心链接
        [HttpService loadDataPostChannel_id:channel_Id imei:openUDID uid:uid token:token remind:lastRemindVersion iphoneType:iphoneType screenWidth:screenWidth screenHeight:screenHeight idfa:IDFA iphoneVersion:phoneVersion deviceType:deviceType version:systemVesion versionCode:versionCode atid:lastAtId findmenu_v:lastDiscoveryId ucenter_v:lastUcenterId notice_v:lastNoticeId carousel_v:lastCarouselId recserve_v:lastRecserveId vweb_v:lastVipvwebId devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
            
            
            NSString *errorCode = responseObject[@"error_code"];
            
            if([errorCode isEqualToString:@"0"]){
                
                NSString *aboutusInfoString = responseObject[@"app_info"];
                if(aboutusInfoString == nil){
                    aboutusInfoString = @"";
                }
                [YKXDefaultsUtil setAboutusAppInfoString:aboutusInfoString];
                
                NSString *infoCodeURL = responseObject[@"info_qr_code_url"];
                if(infoCodeURL == nil){
                    infoCodeURL = @"";
                }
                [YKXDefaultsUtil setAboutusCodeURL:infoCodeURL];
                
                NSString *problemString = responseObject[@"problem_url"];
                if(problemString == nil){
                    problemString = @"";
                }
                [YKXDefaultsUtil setQuestionAndAnswerString:problemString];
                
                NSString *rechargeString = responseObject[@"recharge_url"];
                if(rechargeString == nil){
                    rechargeString = @"";
                }
                [YKXDefaultsUtil setAPPRechargeURL:rechargeString];
                
                //保存当前返回的版本号
                NSString *version = responseObject[@"version"];
                if(version == nil){
                    return ;
                }
                [YKXDefaultsUtil setSystemVersion:version];
                
                NSMutableArray *tempAppInfoUserAgentArray = [NSMutableArray array];
                //保存userAgent
                NSString *appInfoUserAgent1 = responseObject[@"user_agent_1"];
                NSString *appInfoUserAgent2 = responseObject[@"user_agent_2"];
                NSString *appInfoUserAgent3 = responseObject[@"user_agent_3"];
                NSString *appInfoUserAgent4 = responseObject[@"user_agent_4"];
                
                [tempAppInfoUserAgentArray addObject:appInfoUserAgent1];
                [tempAppInfoUserAgentArray addObject:appInfoUserAgent2];
                [tempAppInfoUserAgentArray addObject:appInfoUserAgent3];
                [tempAppInfoUserAgentArray addObject:appInfoUserAgent4];
                [YKXDefaultsUtil setAppInfoUserAgent:tempAppInfoUserAgentArray];
                
                
                NSString *GDTMainID = responseObject[@"ad_appid"];
                
                if(GDTMainID == nil){
                    GDTMainID = @"0";
                }
                [YKXDefaultsUtil setGDTMainID:GDTMainID];
                
                //获取开屏广告ID
                NSString *placementID = responseObject[@"ad_appid_1"];
                
                if(placementID == nil){
                    placementID = @"0";
                }
                [YKXDefaultsUtil setGDTPlacementID:placementID];
                
                //获取发现短视频广告ID
                NSString *cellID = responseObject[@"ad_appid_2"];
                if(cellID == nil){
                    cellID = @"0";
                }
                [YKXDefaultsUtil setGDTCellNativeID:cellID];
                
                //获取SVIP广告ID
                NSString *VIPID = responseObject[@"ad_appid_3"];
                if(VIPID == nil){
                    VIPID = @"0";
                }
                [YKXDefaultsUtil setGDTVIPNativeID:VIPID];
                
                //获取视频平台退出广告ID
                NSString *exitID = responseObject[@"ad_appid_9"];
                if(exitID == nil){
                    exitID = @"0";
                }
                [YKXDefaultsUtil setGDTExitNativeID:exitID];
                
                //获取签到ID
                NSString *signID = responseObject[@"ad_appid_5"];
                if(signID == nil){
                    signID = @"0";
                }
                [YKXDefaultsUtil setGDTSignNativeID:signID];
                
                
                //获取SVIP选集广告ID
                NSString *xuanjiID = responseObject[@"ad_appid_11"];
                if(xuanjiID == nil){
                    xuanjiID = @"0";
                }
                [YKXDefaultsUtil setSVIPXuanJiBannerID:xuanjiID];
                
                //获取首页BannerID
                NSString *youkanBannerID = responseObject[@"ad_appid_7"];
                if(youkanBannerID == nil){
                    youkanBannerID = @"0";
                }
                [YKXDefaultsUtil setYouKanBannerID:youkanBannerID];
                
                //获取消息BannerID
                NSString *messageBannerID = responseObject[@"ad_appid_8"];
                if(messageBannerID == nil){
                    messageBannerID = @"0";
                }
                [YKXDefaultsUtil setMessageBannerID:messageBannerID];
                
                //获取使用卡券界面ID
                NSString *useCardID = responseObject[@"ad_appid_4"];
                if(useCardID == nil){
                    useCardID = @"0";
                }
                [YKXDefaultsUtil setUseCardNativeID:useCardID];
                
                //获取领券界面ID
                NSString *getCardID = responseObject[@"ad_appid_6"];
                if(getCardID == nil){
                    getCardID = @"0";
                }
                [YKXDefaultsUtil setGetCardNativeID:getCardID];
                

                
                NSString *signURL = responseObject[@"signurl"];
                if(signURL == nil){
                    return;
                }
                [YKXDefaultsUtil setSignURLString:signURL];
                
                
                NSString *signInformationURL = responseObject[@"signinfourl"];
                if(signInformationURL == nil){
                    return;
                }
                [YKXDefaultsUtil setSignInformationURLString:signInformationURL];
                
                
                //保存修改密码链接
                NSString *findpasswordURL = responseObject[@"retrievalpwdurl"];
                if(findpasswordURL == nil){
                    return;
                }
                [YKXDefaultsUtil setFindPasswordURLStr:findpasswordURL];
//                NSString *pingtime = responseObject[@"pingtime"];
//                if(pingtime == nil){
//                    return ;
//                }
//                [YKXDefaultsUtil setPinetime:pingtime];
               
                //保存好友消息定时器时间
                NSString *frienListPingTime = responseObject[@"getfriends_pingtime"];
                if(frienListPingTime == nil){
                    return;
                }
                [YKXDefaultsUtil setFriendListPingTime:frienListPingTime];
                //保存新消息定时器时间
                NSString *newsListPingTime = responseObject[@"getnews_pingtime"];
                if(newsListPingTime == nil){
                    return;
                }
                [YKXDefaultsUtil setNewsListPingTime:newsListPingTime];
                
                
                //remind动态图标
                NSString *currentRemindVersion = responseObject[@"remind_v"];
                if(currentRemindVersion == nil){
                    return;
                }
                [YKXDefaultsUtil setRemindVersion:currentRemindVersion];
                
                
                NSMutableArray *remindIdArray = [NSMutableArray array];
                NSArray *dbRemindList = [_manager receiveRemindInfoList];
                
                for(NSDictionary *dbRemindDic in dbRemindList){
                    
                    NSString *remindId = dbRemindDic[@"remind_id"];
                    
                    if(![remindIdArray containsObject:remindId]){
                        [remindIdArray addObject:remindId];
                    }
                }
                
                
                if(![[NSString stringWithFormat:@"%@",lastRemindVersion] isEqualToString:[NSString stringWithFormat:@"%@",currentRemindVersion]]){
                    
                    NSArray *remindDataArray = responseObject[@"remind"];
                    
                    if(remindDataArray.count >0){
                        
                        for(NSDictionary *remindDic in remindDataArray){
                            
                            NSString *img_url = remindDic[@"img_url"];
                            NSString *remind_id = remindDic[@"remind_id"];
                            NSString *type = remindDic[@"type"];
                            
                            if([remindIdArray containsObject:remind_id]){//更新数据
                                
                                [_manager updateRemindList:remindDic remindId:remind_id];
                                
                            }else{//添加数据
                                
                                [_manager insertRemindInfoList:remindDic];
                            }
                            
                            
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            if([remind_id isEqualToString:@"1"]){
                                if([type isEqualToString:@"0"]){
                                    self.leftNavcButton.hidden = YES;
                                }else{
                                    
                                    [self.leftNavcButton sd_setImageWithURL:[NSURL URLWithString:img_url] forState:UIControlStateNormal];
                                }
                            }else if ([remind_id isEqualToString:@"4"]){
                                if([type isEqualToString:@"0"]){
                                    [appDelegate.mainVC.tabBar hideMarkIndex:0];
                                }else{
                                    [appDelegate.mainVC.tabBar showPointMarkIndex:0];
                                }
                                
                            }else if ([remind_id isEqualToString:@"5"]){
                                if([type isEqualToString:@"0"]){
                                    [appDelegate.mainVC.tabBar hideMarkIndex:2];
                                }else{
                                    [appDelegate.mainVC.tabBar showPointMarkIndex:2];
                                }
                                
                            }else if([remind_id isEqualToString:@"6"]){
                                if([type isEqualToString:@"0"]){
                                    [appDelegate.mainVC.tabBar hideMarkIndex:3];
                                }else{
                                    [appDelegate.mainVC.tabBar showPointMarkIndex:3];
                                }
                            }
                        }
                    }
                }
                

                
                //活动提示框
                NSString *currentAtid = responseObject[@"atid"];
                if(currentAtid == nil){
                    return ;
                }
                [YKXDefaultsUtil setActivityId:currentAtid];
                //如果请求的Id和本地Id不一样就弹出活动提示框
                
                if(![[NSString stringWithFormat:@"%@",lastAtId] isEqualToString:[NSString stringWithFormat:@"%@",currentAtid]]){
                    
                    if([responseObject[@"activity"] count] > 0){
                        
                        NSDictionary *activityDic = responseObject[@"activity"];
                        
                        NSString *titleImage = activityDic[@"img_url"];
                        NSString *title = activityDic[@"title"];
                        NSString *content = activityDic[@"content"];
                        NSString *buttonContent = activityDic[@"bt_content"];
                        NSString *activityUrl = activityDic[@"url"];
                        NSString *loadJS = activityDic[@"loadjs"];
                        NSString *userAgent = activityDic[@"user_agent"];
                        
                        YKXCustomActivityView *ykxActivityView = [[YKXCustomActivityView alloc] initWithTitleImage:titleImage title:title content:content buttonTitle:buttonContent];
                        [ykxActivityView show];
                    
                        ykxActivityView.activityBlock = ^{
                            if(activityUrl == nil || activityUrl.length == 0){
                                return ;
                            }
                            
                            if([loadJS isEqualToString:@"0"]){
                                YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
                                activityVC.urlStr = activityUrl;
                                activityVC.userAgent = userAgent;
                                [self.navigationController pushViewController:activityVC animated:YES];
                            }else{
                                
                                [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
                                
                                NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
                                NSString *uid;
                                NSString *token;
                                if(loginDic.count == 0){
                                    uid = @"0";
                                    token = @"0";
                                }else{
                                    uid = loginDic[@"uid"];
                                    token = loginDic[@"token"];
                                }
                                
                                //请求数据获取JS文件，修改爱奇艺等界面
                                NSString *tempJSStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,loadJS,@"2",timeStamp,YOYO,randCode];
                                //获取签名
                                NSString *signJS = [MyMD5 md5:tempJSStr];
                                
                                [HttpService loadDataGetJSServiceUid:uid token:token versionCode:versionCode loadJs:loadJS devtype:@"2" timestamp:timeStamp randcode:randCode sign:signJS sucess:^(id responseObjectSuccess) {
                                    
                                    [YKXCommonUtil hiddenHud];
                                    
                                    NSString *errorCodeSuccess = responseObjectSuccess[@"error_code"];
                                    
                                    if([errorCodeSuccess isEqualToString:@"0"]){
                                        
                                        NSDictionary *dataDic = responseObjectSuccess[@"data"];
                                        if([dataDic isKindOfClass:[NSNull class]]){
                                            return ;
                                        }
                                        
                                        NSString *reviseJS = dataDic[@"js_1"];
                                        NSString *adJS = dataDic[@"js_2"];
                                        
                                        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
                                        activityVC.urlStr = activityUrl;
                                        activityVC.reviseJS = reviseJS;
                                        activityVC.adJS = adJS;
                                        activityVC.userAgent = userAgent;
                                        [self.navigationController pushViewController:activityVC animated:YES];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    [YKXCommonUtil hiddenHud];
                                    [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
                                }];
                            }
                        };
                    }
                }
                
                //发现界面
                NSString *currentFindmenuId = responseObject[@"findmenu_v"];
                if(currentFindmenuId == nil){
                    return ;
                }
                [YKXDefaultsUtil setDiscoveryId:currentFindmenuId];
                
                if(![[NSString stringWithFormat:@"%@",lastDiscoveryId] isEqualToString:[NSString stringWithFormat:@"%@",currentFindmenuId]]){
                    
                    //删除在重新存
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryNameArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryURL"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryResDomainArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryRelDomainArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryUserAgent"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryJSStrArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryModularIdArray"];
                    
                    if([responseObject[@"findmenu"] count] > 0){
                        
                        NSMutableArray *urlArray = [NSMutableArray array];
                        NSMutableArray *nameArray = [NSMutableArray array];
                        NSMutableArray *resDomainArray = [NSMutableArray array];
                        NSMutableArray *relDomainArray = [NSMutableArray array];
                        NSMutableArray *userAgentArray = [NSMutableArray array];
                        NSMutableArray *jsArray1 = [NSMutableArray array];
                        NSMutableArray *jsArray2 = [NSMutableArray array];
                        NSMutableArray *modularIdArray = [NSMutableArray array];
                        NSArray *dataArray = responseObject[@"findmenu"];
                        for(NSDictionary *dataDic in dataArray){
                            NSString *name = dataDic[@"name"];
                            NSString *url = dataDic[@"url"];
                            NSString *resDomain = dataDic[@"res_domain"];
                            NSString *relDomain = dataDic[@"rel_domain"];
                            NSString *userAgent = dataDic[@"user_agent"];
                            NSString *js1 = dataDic[@"js_1"];
                            NSString *js2 = dataDic[@"js_2"];
                            NSString *modularId = dataDic[@"id"];
                            
                            [urlArray addObject:url];
                            [nameArray addObject:name];
                            [resDomainArray addObject:resDomain];
                            [relDomainArray addObject:relDomain];
                            [userAgentArray addObject:userAgent];
                            [jsArray1 addObject:js1];
                            [jsArray2 addObject:js2];
                            [modularIdArray addObject:modularId];
                        }
                        
                        NSArray *discoveryJSArray = @[jsArray1,jsArray2];
                        
                        //保存发现页面URL
                        [YKXDefaultsUtil setDiscoveryURL:urlArray];
                        [YKXDefaultsUtil setDiscoveryName:nameArray];
                        [YKXDefaultsUtil setDiscoveryResDomainArray:resDomainArray];
                        [YKXDefaultsUtil setDiscoveryRelDomainArray:relDomainArray];
                        [YKXDefaultsUtil setDiscoveryUserAgent:userAgentArray];
                        [YKXDefaultsUtil setDiscoveryJSStrArray:discoveryJSArray];
                        [YKXDefaultsUtil setDiscoveryModularId:modularIdArray];
                    }
                }
                
                
                //个人中心
//                NSString *currentCenterId = responseObject[@"ucenter_v"];
//                if(currentCenterId == nil){
//                    return ;
//                }
//                [YKXDefaultsUtil setCenterId:currentCenterId];
//                if(![[NSString stringWithFormat:@"%@",lastUcenterId] isEqualToString:[NSString stringWithFormat:@"%@",currentCenterId]]){
//                    
//                    //删除在重新存
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"icon"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"centerNameArray"];
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"centerUrlArray"];
//                    
//                    if([responseObject[@"ucenterurl"] count] > 0){
//                        
//                        NSMutableArray *centerIconArr = [NSMutableArray array];
//                        NSMutableArray *centerNameArr = [NSMutableArray array];
//                        NSMutableArray *centerURLArr = [NSMutableArray array];
//                        
//                        NSArray *dataArray = responseObject[@"ucenterurl"];
//                        
//                        for(NSDictionary *dic in dataArray){
//                            NSString *icon = dic[@"icon"];
//                            NSString *name = dic[@"name"];
//                            NSString *url = dic[@"url"];
//                            
//                            [centerIconArr addObject:icon];
//                            [centerNameArr addObject:name];
//                            [centerURLArr addObject:url];
//                        }
//                        
//                        //保存个人中心游戏内容
//                        [YKXDefaultsUtil setCenterIcon:centerIconArr];
//                        [YKXDefaultsUtil setCenterName:centerNameArr];
//                        [YKXDefaultsUtil setCenterURL:centerURLArr];
//                    }
//                }
                
                //分组头部标题
                NSString *noticeId = responseObject[@"notice_v"];
                if(noticeId == nil){
                    return ;
                }
                [YKXDefaultsUtil setNoticeId:noticeId];
                if(![[NSString stringWithFormat:@"%@",lastNoticeId] isEqualToString:[NSString stringWithFormat:@"%@",noticeId]]){
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeTitleArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeURLArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeADTitleArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeADURLArray"];
                    
                    //底部通告中心
                    if([responseObject[@"notice"] count] > 0){
                        
                        NSMutableArray *noticeNameArr = [NSMutableArray array];
                        NSMutableArray *noticeURLArr = [NSMutableArray array];
                        
                        NSArray *dataArray = responseObject[@"notice"];
                        for(NSDictionary *dic in dataArray){
                            
                            NSString *title = dic[@"title"];
                            NSString *url = dic[@"url"];
                            [noticeNameArr addObject:title];
                            [noticeURLArr addObject:url];
                        }
                        
                        //保存通告中心内容
                        [YKXDefaultsUtil setNoticeTitle:noticeNameArr];
                        [YKXDefaultsUtil setNoticeURL:noticeURLArr];
                    }
                    
                    
                    //分组头部标题
                    if([responseObject[@"notice_ad"] count] > 0){
                        
                        [self.headTitleArray removeAllObjects];
                        [self.headURLArray removeAllObjects];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeADTitleArray"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeADURLArray"];
                        
                        NSArray *dataArray = responseObject[@"notice_ad"];
                        for(NSDictionary *dic in dataArray){
                            NSString *adTitle = dic[@"title"];
                            NSString *adURL = dic[@"url"];
                            [self.headTitleArray addObject:adTitle];
                            [self.headURLArray addObject:adURL];
                        }
                        
                        //保存分组AD内容
                        [YKXDefaultsUtil setNoticeADTitle:self.headTitleArray];
                        [YKXDefaultsUtil setNoticeADURL:self.headURLArray];
                    }
                }
                
                //轮播广告
                NSString *carouselId = responseObject[@"carousel_v"];
                if(carouselId == nil){
                    return ;
                }
                [YKXDefaultsUtil setCarouselId:carouselId];
                
                if(![[NSString stringWithFormat:@"%@",lastCarouselId] isEqualToString:[NSString stringWithFormat:@"%@",carouselId]]){
                    
                    [self.carouselNameArray removeAllObjects];
                    [self.carouselImageURLArray removeAllObjects];
                    [self.carouselURLArray removeAllObjects];
                    [self.carouselLoadJSArray removeAllObjects];
                    [self.carouselResDomainArray removeAllObjects];
                    [self.carouselRelDomainArray removeAllObjects];
                    
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselImageURLArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselURLArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselLoadJSArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselResDomainArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselRelDomainArray"];
                    
                    if([responseObject[@"carousel_ad"] count] > 0){
                        
                        NSArray *dataArray = responseObject[@"carousel_ad"];
                        for(NSDictionary *dic in dataArray){
                            
                            NSString *title = dic[@"title"];
                            NSString *imgURL = dic[@"img_url"];
                            NSString *URL = dic[@"url"];
                            NSString *loadJS = dic[@"loadjs"];
                            NSString *resDomain = dic[@"res_domain"];
                            NSString *relDomain = dic[@"rel_domain"];
                            [self.carouselNameArray addObject:title];
                            [self.carouselImageURLArray addObject:imgURL];
                            [self.carouselURLArray addObject:URL];
                            [self.carouselLoadJSArray addObject:loadJS];
                            [self.carouselResDomainArray addObject:resDomain];
                            [self.carouselRelDomainArray addObject:relDomain];
                        }
                        
                        [YKXDefaultsUtil setCarouselTitle:self.carouselNameArray];
                        [YKXDefaultsUtil setCarouselImageURL:self.carouselImageURLArray];
                        [YKXDefaultsUtil setCarouselURL:self.carouselURLArray];
                        [YKXDefaultsUtil setCarouselLoadJS:self.carouselLoadJSArray];
                        [YKXDefaultsUtil setCarouselResDomainArray:self.carouselResDomainArray];
                        [YKXDefaultsUtil setCarouselRelDomainArray:self.carouselRelDomainArray];
                    }
                }
                
                
                //collectionCell
                NSString *vipVwebId = responseObject[@"vweb_v"];
                NSString *recserveId = responseObject[@"recserve_v"];
                if(vipVwebId == nil){
                    return ;
                }
                [YKXDefaultsUtil setVipVwebId:vipVwebId];
                if(recserveId == nil){
                    return ;
                }
                [YKXDefaultsUtil setRecserveId:recserveId];
                
                
                if(![[NSString stringWithFormat:@"%@",lastRecserveId] isEqualToString:[NSString stringWithFormat:@"%@",recserveId]] || ![[NSString stringWithFormat:@"%@",lastVipvwebId] isEqualToString:[NSString stringWithFormat:@"%@",vipVwebId]]){
                    
                    [self.collectionHeadTitleList removeAllObjects];
                    [self.collectionHeadDetailList removeAllObjects];
                    [self.collectionHeadImageList removeAllObjects];
                    [self.collectionHeadURLList removeAllObjects];
                    [self.collectionHeadVwebList removeAllObjects];
                    [self.collectionHeadAlertTitleList removeAllObjects];
                    [self.collectionHeadLoadJSList removeAllObjects];
                    [self.collectionHeadResDomainList removeAllObjects];
                    [self.collectionHeadRelDomainList removeAllObjects];
                    [self.collectionHeadUserAgentList removeAllObjects];
                    [self.collectionHeadTypeList removeAllObjects];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionTitleArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionDetailArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionImageURLArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionURLArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionVwebArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alertTitleArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionJsArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionResDomainArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionRelDomainArray"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionUserAgent"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"collectionPingTypeArray"];
                    
                    NSDictionary *iosDataDic = responseObject[@"ios_data"];
                    if([iosDataDic isKindOfClass:[NSNull class]]){
                        return ;
                    }
                    NSArray *recserveArray = iosDataDic[@"recserve"];
                    NSArray *vipwebArray = iosDataDic[@"vipweb"];
                    
                    //VIP视频
                    NSMutableArray *vipTitleArray = [NSMutableArray array];
                    NSMutableArray *vipImageURLArray = [NSMutableArray array];
                    NSMutableArray *vipURLArray = [NSMutableArray array];
                    NSMutableArray *vipVwebArray = [NSMutableArray array];
                    NSMutableArray *vipAlertTitleArray = [NSMutableArray array];
                    NSMutableArray *vipLoadJSArray = [NSMutableArray array];
                    NSMutableArray *vipResDomainArray = [NSMutableArray array];
                    NSMutableArray *vipRelDomainArray = [NSMutableArray array];
                    NSMutableArray *vipPingTypeArray = [NSMutableArray array];
                    if(vipwebArray.count > 0){
                        
                        NSArray *dataArray = responseObject[@"vipweb"];
                        if([dataArray isKindOfClass:[NSNull class]]){
                            return;
                        }
                        
                        for (NSDictionary *dic in dataArray){
                            
                            NSString *name = dic[@"name"];
                            NSString *imgURL = dic[@"img_url"];
                            NSString *url = dic[@"url"];
                            NSString *vweb = dic[@"vweb"];
                            NSString *alertTitle = dic[@"title"];
                            NSString *loadjs = dic[@"loadjs"];
                            NSString *resDomain = dic[@"res_domain"];
                            NSString *relDomain = dic[@"rel_domain"];
                            NSString *pingType = dic[@"ping"];
                            [vipTitleArray addObject:name];
                            [vipImageURLArray addObject:imgURL];
                            [vipURLArray addObject:url];
                            [vipVwebArray addObject:vweb];
                            [vipLoadJSArray addObject:loadjs];
                            [vipAlertTitleArray addObject:alertTitle];
                            [vipResDomainArray addObject:resDomain];
                            [vipRelDomainArray addObject:relDomain];
                            [vipPingTypeArray addObject:pingType];
                        }
                    }
                    
                    //推荐服务
                    NSMutableArray *serviceTitleArray = [NSMutableArray array];
                    NSMutableArray *serviceDetailArray = [NSMutableArray array];
                    NSMutableArray *serviceImageURLArray = [NSMutableArray array];
                    NSMutableArray *serviceURLArray = [NSMutableArray array];
                    NSMutableArray *serviceJSArray = [NSMutableArray array];
                    NSMutableArray *serviceResDomainArray = [NSMutableArray array];
                    NSMutableArray *serviceRelDomainArray = [NSMutableArray array];
                    NSMutableArray *serviceUserAgentArray = [NSMutableArray array];
                    if(recserveArray.count > 0){
                        
                        NSArray *dataArray = responseObject[@"recserve"];
                        if([dataArray isKindOfClass:[NSNull class]]){
                            return;
                        }
                        for (NSDictionary *dic in dataArray){
                            
                            NSString *name = dic[@"yk_name"];
                            NSString *title = dic[@"title"];
                            NSString *imgURL = dic[@"img_url"];
                            NSString *url = dic[@"url"];
                            NSString *loadjs = dic[@"loadjs"];
                            NSString *resDomain = dic[@"res_domain"];
                            NSString *relDomain = dic[@"rel_domain"];
                            NSString *userAgent = dic[@"user_agent"];
                            [serviceTitleArray addObject:name];
                            [serviceDetailArray addObject:title];
                            [serviceImageURLArray addObject:imgURL];
                            [serviceURLArray addObject:url];
                            [serviceJSArray addObject:loadjs];
                            [serviceResDomainArray addObject:resDomain];
                            [serviceRelDomainArray addObject:relDomain];
                            [serviceUserAgentArray addObject:userAgent];
                        }
                    }
                    
                    
                    [self.collectionHeadTitleList addObject:vipTitleArray];
                    [self.collectionHeadTitleList addObject:serviceTitleArray];
                    [self.collectionHeadDetailList addObject:@[@""]];
                    [self.collectionHeadDetailList addObject:serviceDetailArray];
                    [self.collectionHeadImageList addObject:vipImageURLArray];
                    [self.collectionHeadImageList addObject:serviceImageURLArray];
                    [self.collectionHeadURLList addObject:vipURLArray];
                    [self.collectionHeadURLList addObject:serviceURLArray];
                    [self.collectionHeadVwebList addObject:vipVwebArray];
                    [self.collectionHeadVwebList addObject:@[@""]];
                    [self.collectionHeadAlertTitleList addObject:vipAlertTitleArray];
                    [self.collectionHeadAlertTitleList addObject:@[@""]];
                    [self.collectionHeadLoadJSList addObject:vipLoadJSArray];
                    [self.collectionHeadLoadJSList addObject:serviceJSArray];
                    [self.collectionHeadResDomainList addObject:vipResDomainArray];
                    [self.collectionHeadResDomainList addObject:serviceResDomainArray];
                    [self.collectionHeadRelDomainList addObject:vipRelDomainArray];
                    [self.collectionHeadRelDomainList addObject:serviceRelDomainArray];
                    [self.collectionHeadUserAgentList addObject:@""];
                    [self.collectionHeadUserAgentList addObject:serviceUserAgentArray];
                    [self.collectionHeadTypeList addObject:vipPingTypeArray];
                    [self.collectionHeadTypeList addObject:@""];
                    
                    [YKXDefaultsUtil setCollectionTitle:self.collectionHeadTitleList];
                    [YKXDefaultsUtil setCollectionDetail:self.collectionHeadDetailList];
                    [YKXDefaultsUtil setCollectionImageURL:self.collectionHeadImageList];
                    [YKXDefaultsUtil setCollectionURL:self.collectionHeadURLList];
                    [YKXDefaultsUtil setCollectionVweb:self.collectionHeadVwebList];
                    [YKXDefaultsUtil setCollectionJSArray:self.collectionHeadLoadJSList];
                    [YKXDefaultsUtil setCollectionAlertTitle:self.collectionHeadAlertTitleList];
                    [YKXDefaultsUtil setCollectionResDomainArray:self.collectionHeadResDomainList];
                    [YKXDefaultsUtil setCollectionRelDomainArray:self.collectionHeadRelDomainList];
                    [YKXDefaultsUtil setCollectionUserAgent:self.collectionHeadUserAgentList];
                    [YKXDefaultsUtil setCollectionPingType:self.collectionHeadTypeList];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新数据列表
                    [self.collectionView reloadData];
                });
            }
        } failure:^(NSError *error) {
        }];
    });
}


#pragma mark 创建UI
- (void)createNavc{
    
    //创建左上角VIP按钮
    UIButton *leftNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavcButton.frame = CGRectMake(0, 0, 22, 22);
    [leftNavcButton addTarget:self action:@selector(leftNavcAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavcButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.leftNavcButton = leftNavcButton;
    
    
    //右侧的分享按钮
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 26, 26);
    [rightNavcButton setBackgroundImage:[UIImage imageNamed:@"ykxShare"] forState:UIControlStateNormal];
    [rightNavcButton addTarget:self action:@selector(systemShareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightNavcButton = rightNavcButton;
    

    self.navigationItem.title = DISPLAYNAME;


    //设置左边导航栏的图片
    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *img_url = remindDic[@"img_url"];
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *type = remindDic[@"type"];
        
        //优看左上角图标
        if([remind_id isEqualToString:@"1"]){
            
            if([type isEqualToString:@"0"]){
                self.leftNavcButton.hidden = YES;
            }else{
                self.leftNavcButton.hidden = NO;
                [self.leftNavcButton sd_setImageWithURL:[NSURL URLWithString:img_url] forState:UIControlStateNormal];
            }
        }
    }
}


- (void)createView{
    
    //再定义一个imageview来等同于这个黑线
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    //创建collectionView
    [self createCollectionView];
    
    //创建底部通知公告
    [self createNoticeView];
}

#pragma mark 创建collectionView
- (void)createCollectionView{
    
    //创建流布局
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    //左右的间距
    flow.minimumInteritemSpacing = 1;
    //上下的间距
    flow.minimumLineSpacing = 1;
    //上、左、下、右
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-30) collectionViewLayout:flow];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"] ;
    collectionView.delaysContentTouches = NO;
    collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:collectionView];
    
    //必须要注册cell
    [collectionView registerClass:[CustomRecommendCell class] forCellWithReuseIdentifier:@"recommendCell"];
    [collectionView registerClass:[CustomHotServiceCell class] forCellWithReuseIdentifier:@"hotServiceCell"];
    
    //注册头部或者尾部(分别注册，防止复用)
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"serviceHeader"];
    
    //注册尾部视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"bannerViewFooter"];
    
    self.collectionView = collectionView;
    
}

- (void)createNoticeView{
    
    WEAKSELF(weakSelf);
    //底部的通知栏
    UIView *noticeView = [[UIView alloc] init];
    noticeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noticeView];
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
        make.height.mas_equalTo(@(30));
    }];
    
    UILabel *topLineLabel = [[UILabel alloc] init];
    topLineLabel.backgroundColor = [UIColor lightGrayColor];
    [noticeView addSubview:topLineLabel];
    [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(noticeView);
        make.height.mas_equalTo(@(0.3));
    }];
    
    UIImageView *noticeImageView = [[UIImageView alloc] init];
    noticeImageView.image = [UIImage imageNamed:@"notice"];
    [noticeView addSubview:noticeImageView];
    [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14));
        make.top.equalTo(topLineLabel.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    //不是列表数据不能刷新
    NSArray *nameArr = [YKXDefaultsUtil getNoticeTitle];
    if(nameArr.count == 0){//第一次安装APP此时没有值
        
        [YKXDefaultsUtil setIsFirst:@"1"];
        _noticeArray = @[[NSString stringWithFormat:@"%@VIP工具",DISPLAYNAME]];
        
        UIButton *noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noticeButton setTitle:_noticeArray[0] forState:UIControlStateNormal];
        [noticeButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        noticeButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [noticeView addSubview:noticeButton];
        [noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noticeImageView.mas_right).offset(10);
            make.top.equalTo(topLineLabel.mas_bottom);
            make.right.bottom.equalTo(noticeView);
        }];
        //设置按钮文字左对齐
        noticeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        noticeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
    }else if(nameArr.count == 1){//此时通告不滚动
        
        [YKXDefaultsUtil setIsFirst:@"0"];
        _noticeArray = [NSArray arrayWithArray:nameArr];
        
        UIButton *noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noticeButton setTitle:_noticeArray[0] forState:UIControlStateNormal];
        [noticeButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        noticeButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [noticeView addSubview:noticeButton];
        [noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noticeImageView.mas_right).offset(10);
            make.top.equalTo(topLineLabel.mas_bottom);
            make.right.bottom.equalTo(noticeView);
        }];
        //设置按钮文字左对齐
        noticeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        noticeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [noticeButton addTarget:self action:@selector(onClickActivity:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [YKXDefaultsUtil setIsFirst:@"0"];
        _noticeArray = [NSArray arrayWithArray:nameArr];
        
        //这里后面可以用masonry添加
        UIScrollView *noticeScrollView = [[UIScrollView alloc] init];
        [noticeView addSubview:noticeScrollView];
        noticeScrollView.frame = CGRectMake(50, CGRectGetMaxY(topLineLabel.frame)+1, SCREEN_WIDTH-50, 29);
        noticeScrollView.showsVerticalScrollIndicator = NO;
        noticeScrollView.showsHorizontalScrollIndicator = NO;
        noticeScrollView.pagingEnabled = YES;
        noticeScrollView.scrollEnabled = NO;
        
        CGFloat scrollWidth = noticeScrollView.frame.size.width;
        CGFloat scrollHeight = noticeScrollView.frame.size.height;
        
        noticeScrollView.contentSize = CGSizeMake(scrollWidth, (self.noticeArray.count+2)*scrollHeight);
        noticeScrollView.contentOffset = CGPointMake(0, scrollHeight);
        
        for(int i=0;i<self.noticeArray.count+2;i++){
            
            UIButton *noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [noticeButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
            noticeButton.frame = CGRectMake(0, i*scrollHeight, scrollWidth, scrollHeight);
            if(i==0){
                [noticeButton setTitle:self.noticeArray[self.noticeArray.count-1] forState:UIControlStateNormal];
            }else if(i==self.noticeArray.count+1){
                [noticeButton setTitle:self.noticeArray[0] forState:UIControlStateNormal];
                
            }else{
                noticeButton.tag = 100+i;
                [noticeButton setTitle:self.noticeArray[i-1] forState:UIControlStateNormal];
            }
            noticeButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            //设置按钮的文字左对齐
            noticeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            noticeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            
            [noticeButton addTarget:self action:@selector(onClickActivity:) forControlEvents:UIControlEventTouchUpInside];
            [noticeScrollView addSubview:noticeButton];
        }
        
        self.noticeScrollView = noticeScrollView;
        
        //设置通告广告定时器
        NSTimer *noticeTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(noticeTimeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:noticeTimer forMode:NSRunLoopCommonModes];
        self.noticeTimer = noticeTimer;
    }
}



#pragma mark 头部广告视图定时器变化
- (void)headScrollTimeChange:(NSTimer *)timer{
    
    [UIView animateWithDuration:1 animations:^{
        CGPoint point = self.headScrollView
        .contentOffset;
        point.x += SCREEN_WIDTH;
        self.headScrollView.contentOffset = point;
        
    } completion:^(BOOL finished) {
        
    }];
    if(self.headScrollView.contentOffset.x == (self.carouselImageURLArray.count+1)*SCREEN_WIDTH)
    {
        self.headScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    self.headPageControl.currentPage = self.headScrollView.contentOffset.x/SCREEN_WIDTH-1;
}

#pragma mark 底部通告定时器变化
- (void)noticeTimeChange:(NSTimer *)timer{
    
    [UIView animateWithDuration:1 animations:^{
        CGPoint point = self.noticeScrollView
        .contentOffset;
        point.y += self.noticeScrollView.frame.size.height;
        self.noticeScrollView.contentOffset = point;
        
    } completion:^(BOOL finished) {
        
    }];
    if(self.noticeScrollView.contentOffset.y == (self.noticeArray.count+1)*self.noticeScrollView.bounds.size.height)
    {
        self.noticeScrollView.contentOffset = CGPointMake(0, self.noticeScrollView.bounds.size.height);
    }
}


- (void)changeAppInfo{
    
    //将模块的Id清除
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activityId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"centerId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recserveId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vwebId"];

    [self initData];
}


//点击底部通告
- (void)onClickActivity:(UIButton *)btn{
    
    NSString *isFirst = [YKXDefaultsUtil getIsFirst];
    if([isFirst isEqualToString:@"0"]){
        
        NSArray *noticeUrlArray = [YKXDefaultsUtil getNoticeURL];
        if(noticeUrlArray.count == 1){
            
            NSString *urlStr = noticeUrlArray[0];
            
            [self headViewActionURL:urlStr];
        }else{
            
            NSString *urlStr = noticeUrlArray[btn.tag-100-1];
            
            [self headViewActionURL:urlStr];
        }
    }
}


- (void)didSelectRow{
    self.isSelected = NO;
}

//强制旋转屏幕
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//通过一个方法来找到这个黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark 头部滑动视图点击事件
- (void)onClickBannerView:(UITapGestureRecognizer *)sender{
    
    NSInteger tag = sender.view.tag;
    NSInteger index = tag - 200 - 1;
    
    if(self.carouselURLArray.count >0){
        
        NSString *urlString = self.carouselURLArray[index];
        
        if(urlString == nil || urlString.length == 0){
            return;
        }
        
        urlString = [YKXCommonUtil replaceDeviceSystemUrl:urlString];

        if([urlString containsString:@"uu-svip"] || [urlString containsString:@"UU-SVIP"]){
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
            
            
            NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
            
            if(loginDic.count == 0){
                
                [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
                
            }else{
                
                [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
                
                NSString *uid = loginDic[@"uid"];
                NSString *token = loginDic[@"token"];
                
                NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
                //时间戳
                NSString *timeStamp = [YKXCommonUtil longLongTime];
                //获取6位随机数
                NSString *randCode = [YKXCommonUtil getRandomNumber];
                
                NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"",urlString,@"1",uid,token,@"0",@"2",timeStamp,YOYO,randCode];
                
                //获取签名
                NSString *sign = [MyMD5 md5:tempStr];
                
                [HttpService loadDataSVIPChannelTitle:@"" URL:urlString versionCode:versionCode line:@"1" uid:uid token:token vweb:@"0" devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
                    
                    [YKXCommonUtil hiddenHud];
                    
                    NSString *errorcode = responseObject[@"error_code"];
                    
                    if([errorcode isEqualToString:@"0"]){
                        
                        NSDictionary *dataDic = responseObject[@"data"];
                        if([dataDic isKindOfClass:[NSNull class]]){
                            return ;
                        }
                        
                        NSString *reviseJS = dataDic[@"js_1"];
                        NSString *adJS = dataDic[@"js_2"];
                        NSString *resDomain = dataDic[@"res_domain"];
                        NSString *relDomain = dataDic[@"rel_domain"];
                        NSString *userAgent = dataDic[@"user_agent"];
                        NSString *sVIPurl = dataDic[@"url"];
                        
                        
                        NSString *playType = dataDic[@"play_type"];
                        NSString *playUrl = dataDic[@"play_url"];
                        NSString *down_url = dataDic[@"down_url"];
                        
                        NSString *svipAdOpen = dataDic[@"svip_ad_open"];
                        NSArray *xuanjiArray = responseObject[@"xuanji"];
                        
                        
                        YKXSVIPViewController *ykxSVIPVC = [[YKXSVIPViewController alloc] init];
                        ykxSVIPVC.reviseJS = reviseJS;
                        ykxSVIPVC.adJS = adJS;
                        ykxSVIPVC.resDomain = resDomain;
                        ykxSVIPVC.relDomain = relDomain;
                        ykxSVIPVC.userAgent = userAgent;
                        
                        ykxSVIPVC.name = @"";
                        ykxSVIPVC.type = @"";
                        //网页播放的链接
                        ykxSVIPVC.currentUrl = urlString;
                        ykxSVIPVC.currentTitle = @"";
                        ykxSVIPVC.downloadURL = down_url;
                        ykxSVIPVC.svipAdOpen = svipAdOpen;
                        ykxSVIPVC.xuanjiArray = xuanjiArray;
                        
                        //网页播放链接
                        ykxSVIPVC.urlStr = sVIPurl;
                        //原生播放的链接
                        ykxSVIPVC.playURL = playUrl;
                        //网页播放类型 1代表网页播放 2代表原生播放
                        ykxSVIPVC.playType = playType;
                        
                        [self.navigationController pushViewController:ykxSVIPVC animated:YES];
                        
                    }else{
                        
                        [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
                    }
                    
                } failure:^(NSError *error) {
                    [YKXCommonUtil hiddenHud];
                    [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
                }];
                
            }
        }else if([urlString containsString:@"uu-ext"] || [urlString containsString:@"UU-EXT"]){
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            
        }else if ([urlString containsString:@"uu-new"] || [urlString containsString:@"UU-NEW"]){

            urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-new" withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-NEW" withString:@""];
            
            YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
            ykxActivityVC.urlStr = urlString;
            [self.navigationController pushViewController:ykxActivityVC animated:YES];
            
        }else{
            YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
            ykxActivityVC.urlStr = urlString;
            [self.navigationController pushViewController:ykxActivityVC animated:YES];
        }
    }
}


#pragma mark VIP专享头部点击事件
- (void)onClickRecommend{
    
    if(self.headURLArray.count >= 1){
        
        NSString *urlStr = self.headURLArray[0];
        
       [self headViewActionURL:urlStr];
    }
}

#pragma mark 推荐服务头部点击事件
- (void)onClickHotService{
    
    if(self.headURLArray.count >= 2){
        
        NSString *urlStr = self.headURLArray[1];
        
        [self headViewActionURL:urlStr];
    }
}

- (void)headViewActionURL:(NSString *)urlStr{
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    
    if([urlStr isEqualToString:@"101"]){//卡券列表
        CardListViewController *cardVC = [[CardListViewController alloc] init];
        [self.navigationController pushViewController:cardVC animated:YES];
    }else if ([urlStr isEqualToString:@"102"]){//免费领券
        FreeCardViewController *freeCardVC = [[FreeCardViewController alloc] init];
        [self.navigationController pushViewController:freeCardVC animated:YES];
    }else if ([urlStr isEqualToString:@"103"]){//分享有奖
        ShareActivityController *shareVC = [[ShareActivityController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }else if ([urlStr isEqualToString:@"104"]){//设置界面
        YKXSystemSettingController *systemSettingVC = [[YKXSystemSettingController alloc] init];
        [self.navigationController pushViewController:systemSettingVC animated:YES];
    }else if ([urlStr isEqualToString:@"105"]){
        YKXCollectionListController *collectionListVC = [[YKXCollectionListController alloc] init];
        [self.navigationController pushViewController:collectionListVC animated:YES];
    }else if ([urlStr isEqualToString:@"106"]){
        YKXWatchingViewController *watchVC = [[YKXWatchingViewController alloc] init];
        [self.navigationController pushViewController:watchVC animated:YES];
    }else if ([urlStr isEqualToString:@"107"]){
        DownloadViewController *downLoadVC = [[DownloadViewController alloc] init];
        [self.navigationController pushViewController:downLoadVC animated:YES];
        
    }else if ([urlStr isEqualToString:@"108"]){
        YkXUserSignViewController *userSignVC = [[YkXUserSignViewController alloc] init];
        [self.navigationController pushViewController:userSignVC animated:YES];
        
    }else if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){//跳到外部链接
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else{
        
        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
        activityVC.urlStr = urlStr;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
}


#pragma mark 左侧导航栏按钮点击事件
- (void)leftNavcAction{
    
    FMDBManager *manager = [FMDBManager sharedFMDBManager];
    //设置左边导航栏的图片
    NSArray *remindDataArray = [manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *urlStr = remindDic[@"url"];
        
        //优看左上角图标
        if([remind_id isEqualToString:@"1"]){
            
            [self headViewActionURL:urlStr];
        }
    }
}

#pragma mark 右侧分享
- (void)systemShareAction{
    
    [self shareVideoShareType:@"1" vid:@"0"];
}

- (void)shareVideoShareType:(NSString *)shareType vid:(NSString *)vid {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginUserInfo.count == 0){
        
        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
        
    }else{
        
        NSString *uid = loginUserInfo[@"uid"];
        NSString *token = loginUserInfo[@"token"];
        
        [self shareVideoUid:uid token:token shareType:shareType vid:vid];
    }
    
}

- (void)shareVideoUid:(NSString *)uid token:(NSString *)token shareType:(NSString *)shareType vid:(NSString *)vid {
    
    WEAKSELF(weakSelf);
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        NSString *type;
        if(platformType == UMSocialPlatformType_WechatSession){
            type = @"1";
            
        }else if(platformType == UMSocialPlatformType_WechatTimeLine){
            type = @"2";
            
        }else if (platformType == UMSocialPlatformType_QQ){
            type = @"3";
            
        }else if(platformType == UMSocialPlatformType_Qzone){
            type = @"4";
            
        }
        
        
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",type,uid,token,@"2",timeStamp,YOYO,randCode];
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataSharePostType:type uid:uid token:token shareType:shareType shareId:vid versionCode:versionCode devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
            
            NSString *errorcode = responseObject[@"error_code"];
            
            if([errorcode isEqualToString:@"40000"] || [errorcode isEqualToString:@"40001"] || [errorcode isEqualToString:@"40002"] || [errorcode isEqualToString:@"40003"] || [errorcode isEqualToString:@"40004"]){
                
                SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"状态错误，请重新登录" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                    
                }];
                [alertView show];
                return ;
            }
            
            if([errorcode isEqualToString:@"0"]){
                NSDictionary *dict = responseObject[@"data"];
                if([dict isKindOfClass:[NSNull class]]){
                    return;
                }
                
                NSString *title = dict[@"title"];
                NSString *content = dict[@"content"];
                NSString *urlStr = dict[@"url"];
                NSString *iconURLStr = dict[@"icon_url"];
                
                NSURL *iconURL = [NSURL URLWithString:iconURLStr];
                NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
                
                
                urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
                
                UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageWithData:iconData]];
                webPageObject.webpageUrl = urlStr;
                messageObject.shareObject = webPageObject;
                
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:weakSelf completion:^(id result, NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
        }];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.collectionHeadTitleList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.collectionHeadTitleList[section] count];
}

//配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        CustomRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = self.collectionHeadTitleList[indexPath.section][indexPath.row];
        [cell.imageView sd_setImageWithURL:self.collectionHeadImageList[indexPath.section][indexPath.row] placeholderImage:[UIImage imageNamed:@"logoDefault"]];
        return cell;
        
    }else{
        
        CustomHotServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotServiceCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = self.collectionHeadTitleList[indexPath.section][indexPath.row];
        cell.detailLabel.text = self.collectionHeadDetailList[indexPath.section][indexPath.row];
        [cell.imageView sd_setImageWithURL:self.collectionHeadImageList[indexPath.section][indexPath.row] placeholderImage:[UIImage imageNamed:@"serviceDefault"]];
        return cell ;
    }
}

//设置头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){

        if(indexPath.section == 0){

            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader" forIndexPath:indexPath];
            //设置头部视图的背景颜色
            header.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"];
            [self addHeaderContent];
            [header addSubview:self.rootRecommendView];

            return header ;
        }else{

            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"serviceHeader" forIndexPath:indexPath];
            //设置头部视图的背景颜色
            header.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"];
            [self addHeaderTitle];
            [header addSubview:self.rootHotServiceView];

            return header ;
        }
        
    }else{

        if(indexPath.section == 0){

            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"bannerViewFooter" forIndexPath:indexPath];
            
            return footer;

        }else{
            
            NSString *youKanBannerID = [YKXDefaultsUtil getYouKanBannerID];
            
            if(youKanBannerID.length == 0 || [youKanBannerID isEqualToString:@"0"]){
                
                youKanBannerID = GDTYouKanBannerID;
            }
            
            UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"bannerViewFooter" forIndexPath:indexPath];
            
            SRAlertView *alertView = [[SRAlertView alloc] initSR_BannerViewWithSuperVC:self bannerID:youKanBannerID];
            
            [footer addSubview:alertView];
            
            return footer;
        }
    }
}

- (void)addHeaderTitle{
    
    //防止刷新列表重新创建
    if(!self.rootHotServiceView){
        
        UIView *rootHotServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
        self.rootHotServiceView = rootHotServiceView;
        
        //左侧标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 36)];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.text = @"推荐服务";
        titleLabel.textColor = [UIColor colorWithHexString:@"#828282"];
        [rootHotServiceView addSubview:titleLabel];
        
        if(self.headTitleArray.count >= 2){//防止数组越界
            
            NSString *title = self.headTitleArray[1];
            
            if(title == nil || title.length == 0){
                return;
            }
            
            //右侧活动
            YLButton *hotServiceButton = [YLButton buttonWithType:UIButtonTypeCustom];
            [hotServiceButton setTitle:title forState:UIControlStateNormal];
            hotServiceButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [hotServiceButton setTitleColor:[UIColor colorWithHexString:@"#FF0000"] forState:UIControlStateNormal];
            [hotServiceButton setImage:[UIImage imageNamed:@"youkanarrow"] forState:UIControlStateNormal];
            hotServiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            hotServiceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            hotServiceButton.titleRect = CGRectMake(0, 0, 200, 36);
            hotServiceButton.imageRect = CGRectMake(200, 11, 14, 14);
            [rootHotServiceView addSubview:hotServiceButton];
            [hotServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(rootHotServiceView);
                make.top.equalTo(rootHotServiceView);
                make.size.mas_equalTo(CGSizeMake(220, 36));
            }];
            [hotServiceButton addTarget:self action:@selector(onClickHotService) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


- (void)addHeaderContent{
    
    //防止刷新列表时重新创建
    if(!self.rootRecommendView){
        
        UIView *rootRecommendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36+160*kWJHeightCoefficient)];
        self.rootRecommendView = rootRecommendView;
        
        
        UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, rootRecommendView.frame.size.height-36)];
        headScrollView.delegate = self;
        headScrollView.pagingEnabled = YES;
        headScrollView.showsVerticalScrollIndicator = NO;
        headScrollView.showsHorizontalScrollIndicator = NO;
        headScrollView.contentSize = CGSizeMake((self.carouselImageURLArray.count+2)*SCREEN_WIDTH, headScrollView.frame.size.height);
        headScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [rootRecommendView addSubview:headScrollView];
        self.headScrollView = headScrollView;
        
        for(int i=0;i<self.carouselImageURLArray.count+2;i++){
            
            UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, headScrollView.frame.size.height)];

            topImageView.userInteractionEnabled = YES;
            if(i==0){
                
                [topImageView sd_setImageWithURL:[self.carouselImageURLArray lastObject] placeholderImage:[UIImage imageNamed:@"yktop"]];
                
            }else if (i==self.carouselImageURLArray.count+1){
                
                [topImageView sd_setImageWithURL:[self.carouselImageURLArray firstObject] placeholderImage:[UIImage imageNamed:@"yktop"]];
            }else{
                
                [topImageView sd_setImageWithURL:self.carouselImageURLArray[i-1] placeholderImage:[UIImage imageNamed:@"yktop"]];
                topImageView.tag = 200 + i;
            }
            [headScrollView addSubview:topImageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBannerView:)];
            [topImageView addGestureRecognizer:tapGesture];
        }
        
        //设置头部广告定时器
        NSTimer *headScrollViewTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(headScrollTimeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:headScrollViewTimer forMode:NSRunLoopCommonModes];
        self.headScrollViewTimer = headScrollViewTimer;
        
        
        UIPageControl *headPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, headScrollView.frame.size.height-30, SCREEN_WIDTH, 20)];
        headPageControl.numberOfPages = self.carouselImageURLArray.count;
        headPageControl.currentPage = 0;
        headPageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        [rootRecommendView addSubview:headPageControl];
        self.headPageControl = headPageControl;
        
        //左侧标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(headScrollView.frame), SCREEN_WIDTH, 36)];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.text = @"VIP专享";
        titleLabel.textColor = [UIColor colorWithHexString:@"#828282"];
        [rootRecommendView addSubview:titleLabel];
        
        
        if(self.headTitleArray.count >= 1){//防止数组越界
            NSString *title = self.headTitleArray[0];
            
            if(title == nil || title.length == 0){
                return;
            }
            
            //右侧活动
            YLButton *recommendButton = [YLButton buttonWithType:UIButtonTypeCustom];
            [recommendButton setTitle:title forState:UIControlStateNormal];
            recommendButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [recommendButton setTitleColor:[UIColor colorWithHexString:@"#FF0000"] forState:UIControlStateNormal];
            [recommendButton setImage:[UIImage imageNamed:@"youkanarrow"] forState:UIControlStateNormal];
            recommendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            recommendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            recommendButton.titleRect = CGRectMake(0, 0, 200, 36);
            recommendButton.imageRect = CGRectMake(200, 11, 14, 14);
            [rootRecommendView addSubview:recommendButton];
            [recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(rootRecommendView);
                make.top.equalTo(headScrollView.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(220, 36));
            }];
            [recommendButton addTarget:self action:@selector(onClickRecommend) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout
//设置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        if(IPHONE6P){
            return CGSizeMake((SCREEN_WIDTH-2)/3.0, 102);
        }else{
            return CGSizeMake((SCREEN_WIDTH-2)/3.0, 88);
        }
        
    }else{
        if(IPHONE6P){
            return CGSizeMake((SCREEN_WIDTH-3)/4.0, 142);
        }else{
            return CGSizeMake((SCREEN_WIDTH-3)/4.0, 116);
        }
    }
}

//设置头部视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        
        return CGSizeMake(SCREEN_WIDTH, 36+160*kWJHeightCoefficient);
    }else{
        
        return CGSizeMake(SCREEN_WIDTH, 36);
    }
}

//设置尾部视图的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if(section == 0){
        
        return CGSizeZero;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 80);
    }
}

#pragma mark UICollectionViewDelegate
//允许选中时高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//高亮完成后回调
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
}

//有高亮转成非高亮完成时的回调
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if(self.collectionHeadVwebList.count == 0 || self.collectionHeadURLList.count == 0 || self.collectionHeadTitleList.count == 0 || self.collectionHeadLoadJSList.count == 0 || self.collectionHeadAlertTitleList.count == 0 || self.collectionHeadResDomainList.count == 0 || self.collectionHeadRelDomainList.count == 0 || self.collectionHeadTypeList.count == 0){
            return;
        }
        
        [self loginVideoWithType:self.collectionHeadVwebList[indexPath.section][indexPath.row] videoUrl:self.collectionHeadURLList[indexPath.section][indexPath.row] name:self.collectionHeadTitleList[indexPath.section][indexPath.row] loadJS:self.collectionHeadLoadJSList[indexPath.section][indexPath.row] alertTitle:self.collectionHeadAlertTitleList[indexPath.section][indexPath.row] resDomain:self.collectionHeadResDomainList[indexPath.section][indexPath.row] relDomain:self.collectionHeadRelDomainList[indexPath.section][indexPath.row] pingType:self.collectionHeadTypeList[indexPath.section][indexPath.row]];
        
    }else{
        
        if(self.collectionHeadURLList.count == 0 || self.collectionHeadTitleList.count == 0 || self.collectionHeadDetailList.count == 0 || self.collectionHeadLoadJSList.count == 0 || self.collectionHeadUserAgentList.count == 0){
            return;
        }
        
        NSString *urlStr = self.collectionHeadURLList[indexPath.section][indexPath.row];
        
        urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];

        if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){//跳到外部链接
            
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
            
        }else{
            
            [self loginServiceWithServiceUrl:urlStr name:self.collectionHeadTitleList[indexPath.section][indexPath.row] title:self.collectionHeadDetailList[indexPath.section][indexPath.row] loadJs:self.collectionHeadLoadJSList[indexPath.section][indexPath.row] userAgent:self.collectionHeadUserAgentList[indexPath.section][indexPath.row]];
        }
    }
}

#pragma mark 登录爱奇艺、优酷、搜狐
//登录爱奇艺、优酷、搜狐视频
- (void)loginVideoWithType:(NSString *)type videoUrl:(NSString *)videoUrl name:(NSString *)name loadJS:(NSString *)loadjs alertTitle:(NSString *)alertTitle resDomain:(NSString *)resDomain relDomain:(NSString *)relDomain pingType:(NSString *)pingType{
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    if(loginDic.count == 0){//未登录状态
        
        NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
        if(!([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"])){
            
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"当前网络不可用" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                
            }];
            [alertView show];
            return;
        }
        
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"您还未登录,去登录？" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            
            if(actionType == 1){
                
                YKXLoginViewController *loginVC = [[YKXLoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }];
        [alertView show];
        
    }else{//登录状态
        
        NSString *uid = loginDic[@"uid"];
        NSString *token = loginDic[@"token"];
        
        NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
        
        if([networkStatus isEqualToString:@"GPS"]){
            
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"已为您开启移动网络省流量模式，请放心使用！" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                
                if(actionType == 1){
                    
                    [self getCookieUid:uid token:token type:type videoUrl:videoUrl name:name loadJS:loadjs alertTitle:alertTitle resDomain:resDomain relDomain:relDomain pingType:pingType];
                }
            }];
            [alertView show];
        }else if([networkStatus isEqualToString:@"wifi"]){
            
           [self getCookieUid:uid token:token type:type videoUrl:videoUrl name:name loadJS:loadjs alertTitle:alertTitle resDomain:resDomain relDomain:relDomain pingType:pingType];
            
        }else{
            
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"当前网络不可用" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
        }
    }
}

- (void)getCookieUid:(NSString *)uid token:(NSString *)token type:(NSString *)type videoUrl:(NSString *)videoUrl name:(NSString *)name loadJS:(NSString *)loadjs alertTitle:(NSString *)alertTitle resDomain:(NSString *)resDomain relDomain:(NSString *)relDomain pingType:(NSString *)pingType{
    
    //链接为空
    if(videoUrl == nil || videoUrl.length == 0){
        
        //弹出框有内容时，弹出提示框
        if(alertTitle.length >0){
            
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:alertTitle leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
            
        }
        return;
    }
    
    videoUrl = [YKXCommonUtil replaceDeviceSystemUrl:videoUrl];
    
    //标题没有内容时，cell为空白此时不能点击
    if(name == nil || name.length == 0){
        return;
    }
    
    if(self.isSelected == NO){
        [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
        self.isSelected = YES;
        [self performSelector:@selector(didSelectRow) withObject:nil afterDelay:2 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            NSString *tempCookieStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,type,@"2",timeStamp,YOYO,randCode];
            
            //获取签名
            NSString *signCookie = [MyMD5 md5:tempCookieStr];
            
            [HttpService loadDataPostUid:uid token:token versionCode:versionCode vweb:type devType:@"2" timeStamp:timeStamp randCode:randCode sign:signCookie sucess:^(id responseObject) {
                
                NSString *errorcode = responseObject[@"error_code"];
                
                if([errorcode isEqualToString:@"40000"] || [errorcode isEqualToString:@"40001"] || [errorcode isEqualToString:@"40002"] || [errorcode isEqualToString:@"40003"] || [errorcode isEqualToString:@"40004"]){
                    
                    [YKXCommonUtil hiddenHud];
                    
                    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"状态错误，请重新登录" leftActionTitle:@"确定" rightActionTitle:@"重新登录" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                        
                        if(actionType == 1){
                            
                            //清空登录信息
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginUserInfo"];
                            
                            //将各个模块的Id全部清空
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activityId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"centerId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recserveId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vwebId"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remindVersion"];
                            
                            //修改登录信息
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY object:nil];
                            
                            //修改消息界面登录信息
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
                            
                            
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timeString"];
                            
                            NSArray *dbArray = [_manager receiveFriendList];
                            for (NSDictionary *dbDict in dbArray){
                                
                                NSString *dbFriendId = dbDict[@"friends_id"];
                                
                                //删除存储的消息时间
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"friend%@",dbFriendId]];
                            }
                            //避免数据丢失
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            //删除好友信息列表
                            [_manager deleteFriendList];
                            //删除消息列表
                            [_manager deleteChatList];
                            
                            //退出登录去掉角标
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            [appDelegate.mainVC.tabBar hideMarkIndex:1];
                            appDelegate.badgeCount = 0;
                            
                            //跳到登录页面
                            YKXLoginViewController *loginVC = [[YKXLoginViewController alloc] init];
                            [self.navigationController pushViewController:loginVC animated:YES];
                        }
                    }];
                    [alertView show];
                    return ;
                }
                
               
                if([errorcode isEqualToString:@"40005"]){
                    
                    [YKXCommonUtil hiddenHud];
                    [YKXCommonUtil showToastWithTitle:@"大家都忙着看片,没空闲的资源,请稍后重试" view:self.view.window];
                    return ;
                }
                
                if([errorcode isEqualToString:@"40007"]){
                    
                    [YKXCommonUtil hiddenHud];
                    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"VIP已过期，去免费领取VIP？" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                        
                        if(actionType == 1){
                            
                            FreeCardViewController *freeCardVC = [[FreeCardViewController alloc] init];
                            [self.navigationController pushViewController:freeCardVC animated:YES];
                        }
                    }];
                    [alertView show];
                    return;
                }

                if([errorcode isEqualToString:@"0"]){
                    
                    NSString *userAgent = responseObject[@"user_agent"];
                    
                    //获取groupid
                    NSString *groupid = responseObject[@"groupid"];
                    //获取cookie数据
                    NSArray *cookieArray = responseObject[@"data"];
                    
                    NSString *svipJS = responseObject[@"svip_js_2"];
                    
                    NSString *svipUploadJS = responseObject[@"svip_upload_url"];
                    
                    if(cookieArray.count >0){
                        
                        //如果js类型为0,则不加载JS
                        if([loadjs isEqualToString:@"0"]){
                            
                            [YKXCommonUtil hiddenHud];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                YKXVideoViewController *YKXVideoVC = [[YKXVideoViewController alloc] init];
                                YKXVideoVC.type = type;
                                YKXVideoVC.name = name;
                                YKXVideoVC.videoUrl = videoUrl;
                                YKXVideoVC.userAgent = userAgent;
                                YKXVideoVC.cookieArray = cookieArray;
                                YKXVideoVC.groupid = groupid;
                                YKXVideoVC.resDomain = resDomain;
                                YKXVideoVC.relDomain = relDomain;
                                YKXVideoVC.pingType = pingType;
                                YKXVideoVC.svipJS = svipJS;
                                YKXVideoVC.svipLoadURL = svipUploadJS;
                                
                                [self.navigationController pushViewController:YKXVideoVC animated:YES];
                                
                            });
                        }else{
                            
                            //请求数据获取JS文件，修改爱奇艺等界面
                            NSString *tempJSStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",uid,token,type,@"3",@"2",timeStamp,YOYO,randCode];
                            //获取签名
                            NSString *signJS = [MyMD5 md5:tempJSStr];
                            
                            [HttpService loadDataGetJSReviseUid:uid token:token versionCode:versionCode vweb:type loadtype:@"3" devtype:@"2" timestamp:timeStamp randcode:randCode sign:signJS sucess:^(id responseObjectjs) {
                                
                                [YKXCommonUtil hiddenHud];
                                
                                NSString *errorCodeSuccess = responseObjectjs[@"error_code"];
                                
                                if([errorCodeSuccess isEqualToString:@"0"]){
                                    
                                    //获取要注入的js字符串
                                    NSDictionary *dataDic = responseObjectjs[@"data"];
                                    if([dataDic isKindOfClass:[NSNull class]]){
                                        return ;
                                    }
                                    
                                    //修改类型的JS
                                    NSString *reviseJS = dataDic[@"js_1"];
                                    //增加广告的JS
                                    NSString *adJS = dataDic[@"js_2"];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        YKXVideoViewController *YKXVideoVC = [[YKXVideoViewController alloc] init];
                                        YKXVideoVC.type = type;
                                        YKXVideoVC.name = name;
                                        YKXVideoVC.videoUrl = videoUrl;
                                        YKXVideoVC.userAgent = userAgent;
                                        YKXVideoVC.cookieArray = cookieArray;
                                        YKXVideoVC.reviseJS = reviseJS;
                                        YKXVideoVC.adJS = adJS;
                                        YKXVideoVC.groupid = groupid;
                                        YKXVideoVC.resDomain = resDomain;
                                        YKXVideoVC.relDomain = relDomain;
                                        YKXVideoVC.pingType = pingType;
                                        YKXVideoVC.svipJS = svipJS;
                                        YKXVideoVC.svipLoadURL = svipUploadJS;
  
                                        [self.navigationController pushViewController:YKXVideoVC animated:YES];
                                        
                                    });
                                }
                            } failure:^(NSError *error) {
                                [YKXCommonUtil hiddenHud];
                            }];
                        }
                    }
                }
            } failure:^(NSError *error) {
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
        });
    }
}


#pragma mark 登录短视频、美女直播等
- (void)loginServiceWithServiceUrl:serviceUrl name:serviceName title:serviceTitle loadJs:loadJS userAgent:(NSString *)userAgent{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    if(!([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"])){
      
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"当前网络不可用" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
        
        }];
        [alertView show];
        
        return;
    }
    
    
    //防止界面重复点击
    if(self.isSelected == NO){
        
        self.isSelected = YES;
        [self performSelector:@selector(didSelectRow) withObject:nil afterDelay:2 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];

         //如果js类型为0,则不加载JS
        if([loadJS isEqualToString:@"0"]){
            
            YKXServiceViewController *serviceVC = [[YKXServiceViewController alloc] init];
            serviceVC.serviceName = serviceName;
            serviceVC.serviceTitle = serviceTitle;
            serviceVC.serviceUrl = serviceUrl;
            serviceVC.userAgent = userAgent;

            [self.navigationController pushViewController:serviceVC animated:YES];
            
        }else{
            
            [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
            
            NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
            NSString *uid;
            NSString *token;
            if(loginDic.count == 0){
                uid = @"0";
                token = @"0";
            }else{
                uid = loginDic[@"uid"];
                token = loginDic[@"token"];
            }
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            //请求数据获取JS文件，修改爱奇艺等界面
            NSString *tempJSStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,loadJS,@"2",timeStamp,YOYO,randCode];
            //获取签名
            NSString *signJS = [MyMD5 md5:tempJSStr];
            
            [HttpService loadDataGetJSServiceUid:uid token:token versionCode:versionCode loadJs:loadJS devtype:@"2" timestamp:timeStamp randcode:randCode sign:signJS sucess:^(id responseObject) {
                
                [YKXCommonUtil hiddenHud];
                NSString *error_code = responseObject[@"error_code"];
                
                if([error_code isEqualToString:@"0"]){
                    
                    [YKXCommonUtil hiddenHud];
                    NSDictionary *dataDic = responseObject[@"data"];
                    if([dataDic isKindOfClass:[NSNull class]]){
                        return ;
                    }
                    
                    NSString *reviseJS = dataDic[@"js_1"];
                    NSString *adJS = dataDic[@"js_2"];
                    
                    YKXServiceViewController *serviceVC = [[YKXServiceViewController alloc] init];

                    serviceVC.serviceName = serviceName;
                    serviceVC.serviceTitle = serviceTitle;
                    serviceVC.serviceUrl = serviceUrl;
                    serviceVC.reviseJS = reviseJS;
                    serviceVC.adJS = adJS;
                    serviceVC.userAgent = userAgent;
                    [self.navigationController pushViewController:serviceVC animated:YES];
                }
                
            } failure:^(NSError *error) {
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showHudWithTitle:@"请检查网络设置" view:self.view.window];
            }];
        }
    }
}


#pragma mark scrollView代理
//手动滑动图片
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //防止与collectionView冲突
    if(scrollView == self.headScrollView){
        
        if(scrollView.contentOffset.x == (self.carouselImageURLArray.count+1)*SCREEN_WIDTH){
            
            scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }
        else if (scrollView.contentOffset.x == 0){
            
            scrollView.contentOffset = CGPointMake(self.carouselImageURLArray.count*SCREEN_WIDTH, 0);
        }
    }
    self.headPageControl.currentPage = self.headScrollView.contentOffset.x/SCREEN_WIDTH-1;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];

}

@end
