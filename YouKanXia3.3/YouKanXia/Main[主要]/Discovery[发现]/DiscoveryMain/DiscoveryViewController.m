//
//  DiscoveryViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/10/20.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "MLMSegmentManager.h"
#import "YKXCustomWkWebview.h"
#import <UMMobClick/MobClick.h>
#import "CustomVideoTableViewCell.h"
#import "CustomNativeAdViewCell.h"
#import "CusotmBackStageViewCell.h"
#import "YKXVideoModel.h"
#import "YKXSVIPViewController.h"


@interface DiscoveryViewController () <YKXCustomWkWebviewDelegate,UITableViewDelegate,UITableViewDataSource,CusotmBackStageViewCellDelegate>

{
    NSInteger currentPage;
}

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSMutableArray *urlArray;

@property (nonatomic,strong) MLMSegmentHead *segHead;
@property (nonatomic,strong) MLMSegmentScroll *segScroll;

@property (nonatomic,strong) UITableView *tableView;

//创建tableView
@property (nonatomic,strong) UITableView *videoTableView;

//悬浮的button
@property (nonatomic,strong) UIButton *topButton;

//tableView列表数据
@property (nonatomic,strong) NSMutableArray *tableTempList;
@property (nonatomic,strong) NSMutableArray *tableDataList;

/**
 播放器
 */
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self createView];
    
    [self initTableViewData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:@"news"];
    
     self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [MobClick endLogPageView:@"news"];
    
    [self.playerView resetPlayer];

    self.navigationController.navigationBar.hidden = NO;
}


- (void)initData{
    
    currentPage = 0;
    
    _titleArray = [YKXDefaultsUtil getDiscoveryName];
    
    //第一次安装没有请求到数据时
    if(_titleArray.count == 0){
        _titleArray = @[@"推荐",@"热门",@"娱乐"];
    }
}


- (void)createView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight)];
    titleView.userInteractionEnabled = YES;
    titleView.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [self.view addSubview:titleView];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, StatusBarTopHeight, SCREEN_WIDTH, 44) titles:_titleArray headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutCenter];
    _segHead.headColor = [UIColor clearColor];
    _segHead.bottomLineColor = [UIColor clearColor];
    _segHead.bottomLineHeight = 0;
    
    if(IPHONE5){
        _segHead.singleW_Add = 27;
    }else if(IPHONE6){
        _segHead.singleW_Add = 16;
    }else if(IPHONE6P){
        _segHead.singleW_Add = 22;
    }
    //设置字体大小
    _segHead.fontSize = 18;
    //设置初始选择位置
    _segHead.showIndex = 0;
    //设置选择状态的颜色
    _segHead.selectColor = [UIColor whiteColor];
    //设置未选中状态的颜色
    _segHead.deSelectColor = [UIColor colorWithHexString:SEGTITLE_SELECTED_COLOR];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight) vcOrViews:[self vcArr:_titleArray.count]];
    _segScroll.enableScroll = @"1";
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:NO completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    } selectEnd:nil];
}

#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *urlArray = [YKXDefaultsUtil getDiscoveryURL];
    
    NSArray *jsStrArray = [YKXDefaultsUtil getDiscoveryJSStrArray];
    
    NSArray *modularIdArray = [YKXDefaultsUtil getDiscoveryModularId];

    //第一次安装请求数据失败时请求默认数据(防止数组越界)
    if(urlArray.count == 0){
        
        modularIdArray = @[@"0",@"0",@"0"];
        urlArray = @[@"http://a.ykxia.com/html/flow/?id=1",@"http://a.ykxia.com/html/flow/?id=2",@"http://a.ykxia.com/html/flow/?id=3"];
    }
    
    for (NSInteger idx = 0; idx < count; idx ++) {
        
        NSString *modularId = modularIdArray[idx];
        
        if([[NSString stringWithFormat:@"%@",modularId] isEqualToString:@"10000"]) {
            
            [self createTableView];
            
            [arr addObject:self.videoTableView];
            
        }else{
            
            NSString *urlStr = urlArray[idx];
            
            urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
            
            YKXCustomWkWebview *weviewVC = [[YKXCustomWkWebview alloc] initWithUrlstr:urlStr];
            weviewVC.delegate = self;
            //重新刷新数据的时候会用到
            weviewVC.urlStr = urlStr;
            
            if(jsStrArray.count >0){
                weviewVC.reviseJS = [jsStrArray[0] objectAtIndex:idx];
            }
            if(jsStrArray.count >1){
                weviewVC.adJS = [jsStrArray[1] objectAtIndex:idx];
            }
            [arr addObject:weviewVC];
        }
    }
    return arr;
}


#pragma mark YKXCustomWkWebview代理
//点击网页上的按钮跳入下一个页面
- (void)goToNextViewControllerWithURLStr:(NSString *)urlStr reviseJS:(NSString *)reviseJS adJS:(NSString *)adJS{
    CommonViewController *commonVC = [[CommonViewController alloc] init];
    commonVC.urlStr = urlStr;
    commonVC.reviseJS = reviseJS;
    commonVC.adJS = adJS;
    [self.navigationController pushViewController:commonVC animated:YES];
}



- (void)initTableViewData{
    
    _tableTempList = [NSMutableArray array];
    _tableDataList = [NSMutableArray array];
    
    [self loadDataVideoListPage:currentPage];
}


- (void)loadDataVideoListPage:(NSInteger)page{
    
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
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempVideoStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *videosign = [MyMD5 md5:tempVideoStr];
    
    [HttpService loadDataVideoListPostUid:uid token:token versionCode:versionCode page:[NSString stringWithFormat:@"%ld",page] devType:@"2" timeStamp:timeStamp randCode:randCode sign:videosign sucess:^(id responseObject) {
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            
            //下拉加载没有数据
            if(dataArray.count == 0){
                
                [self.videoTableView.mj_header endRefreshing];
                [self.videoTableView.mj_footer endRefreshing];
                //设置没有数据时的状态
                self.videoTableView.mj_footer.state = MJRefreshStateNoMoreData;
                [self.videoTableView reloadData];
            }else{
                
                
                for(NSDictionary *tempDic in dataArray){
                    [self.tableTempList addObject:tempDic];
                }
                
                self.tableDataList = [YKXVideoModel mj_objectArrayWithKeyValuesArray:self.tableTempList];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.videoTableView.mj_header endRefreshing];
                    [self.videoTableView.mj_footer endRefreshing];
                    
                    //刷新数据列表
                    [self.videoTableView reloadData];
                });
            }
        }
    } failure:^(NSError *error) {
        
        [self.videoTableView.mj_header endRefreshing];
        [self.videoTableView.mj_footer endRefreshing];
        
        //刷新数据列表
        [self.videoTableView reloadData];
    }];
}

#pragma mark 创建tableView
- (void)createTableView {
    
    UITableView *videoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    videoTableView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"];
    videoTableView.showsVerticalScrollIndicator = NO;
    videoTableView.showsHorizontalScrollIndicator = NO;
    videoTableView.delegate = self;
    videoTableView.dataSource = self;
    videoTableView.scrollsToTop = NO;
    videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.videoTableView = videoTableView;
    videoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        currentPage = 0;
        [self.tableTempList removeAllObjects];
        
        [self loadDataVideoListPage:currentPage];
    }];
    [refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //隐藏更新时间
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    videoTableView.mj_header = refreshHeader;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        currentPage++;
        
        [self loadDataVideoListPage:currentPage];
    }];
    
    [refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    //设置加载完成时的文字
    [refreshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    videoTableView.mj_footer = refreshFooter;
    
}


#pragma mark 点击事件
- (void)topScrollAction:(UIButton *)sender{
    self.topButton.hidden = YES;
    
    [self.videoTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark 创建播放器
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        // 可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

// iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
// 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
- (BOOL)shouldAutorotate{
    
    return NO;
}


#pragma mark tableView代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH*9/16 + 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableDataList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __block YKXVideoModel *model        = self.tableDataList[indexPath.row];
    
    NSString *videoURL = model.videourl;
    
    if([model.type isEqualToString:@"1"]){
        
        static NSString *videoCellId = @"videoCellId";
        
        CustomVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellId];
        if(!cell){
            
            cell = [[CustomVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellId];
        }
        
        // 赋值model
        cell.model                         = model;
        
        if([videoURL containsString:@"uu-svip"] || [videoURL containsString:@"UU-SVIP"]){
            
            videoURL = [videoURL stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
            videoURL = [videoURL stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
            
            cell.playBlock = ^(UIButton *btn) {
                
                NSInteger line = 1;
                
                [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
                
                NSString *title = @"";
                NSString *currentUrl = videoURL;
                
                if(title == nil || currentUrl == nil){
                    
                    title = @"";
                    currentUrl = @"";
                }
                
                
                NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
                NSString *uid = loginDic[@"uid"];
                NSString *token = loginDic[@"token"];
                
                NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
                //时间戳
                NSString *timeStamp = [YKXCommonUtil longLongTime];
                //获取6位随机数
                NSString *randCode = [YKXCommonUtil getRandomNumber];
                
                NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",title,currentUrl,[NSString stringWithFormat:@"%ld",line],uid,token,@"",@"2",timeStamp,YOYO,randCode];
                
                //获取签名
                NSString *sign = [MyMD5 md5:tempStr];
                
                [HttpService loadDataSVIPChannelTitle:title URL:currentUrl versionCode:versionCode line:[NSString stringWithFormat:@"%ld",line] uid:uid token:token vweb:@"" devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
                    
                    [YKXCommonUtil hiddenHud];
                    
                    NSString *errroCode = responseObject[@"error_code"];
                    
                    if([errroCode isEqualToString:@"0"]){
                        

                        NSDictionary *dataDic = responseObject[@"data"];
                        if([dataDic isKindOfClass:[NSNull class]]){
                            return ;
                        }
                        NSString *reviseJS = dataDic[@"js_1"];
                        NSString *adJS = dataDic[@"js_2"];
                        
                        NSString *sVIPurl = dataDic[@"url"];
                        
                        YKXSVIPViewController *ykxSVIPVC = [[YKXSVIPViewController alloc] init];
                        ykxSVIPVC.reviseJS = reviseJS;
                        ykxSVIPVC.adJS = adJS;
                        ykxSVIPVC.urlStr = sVIPurl;
                        ykxSVIPVC.name = @"";
                        ykxSVIPVC.type = @"";
                        ykxSVIPVC.currentUrl = currentUrl;
                        ykxSVIPVC.currentTitle = title;

                        [self.navigationController pushViewController:ykxSVIPVC animated:YES];
                        
                    }else{
                        
                        [YKXCommonUtil showToastWithTitle:errroCode view:self.view.window];
                    }
                    
                } failure:^(NSError *error) {
                    
                    [YKXCommonUtil hiddenHud];
                    [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
                }];
                
            };
            
        }else{
            
            __block NSIndexPath *weakIndexPath = indexPath;
            __block CustomVideoTableViewCell *weakCell     = cell;
            WEAKSELF(weakSelf);
            // 点击播放的回调
            cell.playBlock = ^(UIButton *btn){
                
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.title            = model.title;
                playerModel.videoURL         = [NSURL URLWithString:videoURL];
                
                NSString *coverimgurl = model.coverimgurl;
                
                if([coverimgurl hasSuffix:@"webp"]){
                    
                    coverimgurl = [coverimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
                }
                
                playerModel.placeholderImageURLString = coverimgurl;
                playerModel.scrollView       = weakSelf.videoTableView;
                playerModel.indexPath        = weakIndexPath;
                // player的父视图tag
                playerModel.fatherViewTag    = weakCell.picImageView.tag;
                
                playerModel.displayType = model.displaytype;

                
                // 设置播放控制层和model
                [weakSelf.playerView playerControlView:nil playerModel:playerModel];
                // 自动播放
                [weakSelf.playerView autoPlayTheVideo];
            };
            
        }
        
        //分享
        cell.shareVideoBlock = ^(NSString *vid) {
            
            [self shareVideoShareType:@"2" vid:vid];
            
        };
        
        return cell;
    }else if([model.type isEqualToString:@"2"]){
        
        static NSString *nativeAdCellId = @"nativeAdCellId";
        
        CustomNativeAdViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nativeAdCellId];
        
        if(!cell){
            
            cell = [[CustomNativeAdViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nativeAdCellId];
        }
        
        cell.model = self.tableDataList[indexPath.row];
    
        return cell;
    }else{
        
        static NSString *backStageCellId = @"backStageCellId";
        
        CusotmBackStageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:backStageCellId];
        
        if(!cell){
            
            cell = [[CusotmBackStageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:backStageCellId];
        }
        
        cell.delegete = self;
        cell.model = self.tableDataList[indexPath.row];
        
        return cell;
    }
}


- (void)backStageURLClick:(NSString *)urlStr {
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){//跳到外部链接
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else{
        
        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
        activityVC.urlStr = urlStr;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
    
}

- (void)shareVideoShareType:(NSString *)shareType vid:(NSString *)vid {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if([shareType isEqualToString:@"2"]){
        
        NSString *uid;
        NSString *token;
        if(loginUserInfo.count == 0){
            
            uid = @"0";
            token = @"0";
            
        }else{
            
            uid = loginUserInfo[@"uid"];
            token = loginUserInfo[@"token"];
            
        }
        
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


//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


//#pragma mark navigationDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:animated];
//}


@end
