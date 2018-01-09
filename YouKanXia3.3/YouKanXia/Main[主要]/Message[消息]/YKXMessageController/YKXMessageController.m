//
//  YKXMessageController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/3.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXMessageController.h"
#import "YKXMessageCell.h"
#import "YKXMessageModel.h"
#import "YKXChatViewController.h"
#import <AdSupport/AdSupport.h>
#import "AppDelegate.h"
#import "GDTMobBannerView.h"

@interface YKXMessageController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,YKXChatViewControllerDelegate>


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *tempArray;

@property (nonatomic,strong) FMDBManager *manager;

@property (nonatomic,assign) BOOL isEmptyDataSetShouldDisplay;

//顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//中间转动指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;


@property (nonatomic,strong) GDTMobBannerView  *bannerView;

@end

@implementation YKXMessageController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [FMDBManager sharedFMDBManager];
    _tempArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageInfo:) name:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
    
    
    [self createNavc];
    [self createView];
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        [self viewDidLoadWithNetworkingStatus];
        
    }else{
        [self viewDidLoadWithNoNetworkingStatus];
    }
}

#pragma mark 创建UI
- (void)createNavc{
    
    //创建左上角VIP按钮
    UIButton *leftNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavcButton.frame = CGRectMake(0, 0, 22, 22);
    [leftNavcButton addTarget:self action:@selector(leftNavcAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavcButton];

    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 80, 26);
    [rightNavcButton setTitle:@"忽略未读" forState:UIControlStateNormal];
    rightNavcButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightNavcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavcButton addTarget:self action:@selector(onClickIgnoreRead) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;



    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *img_url = remindDic[@"img_url"];
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *type = remindDic[@"type"];
        
        
        if([remind_id isEqualToString:@"2"]){
            
            if([type isEqualToString:@"0"]){
                leftNavcButton.hidden = YES;
            }else{
                leftNavcButton.hidden = NO;
                [leftNavcButton sd_setImageWithURL:[NSURL URLWithString:img_url] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    //创建顶部刷新控件
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self initData];
    }];
    [self.refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = self.refreshHeader;
    
    
    //创建指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
    activityIndicatorView.transform = transform;
    [activityIndicatorView startAnimating];
    self.activityIndicatorView = activityIndicatorView;
    
    
    NSString *messageBannerID = [YKXDefaultsUtil getMessageBannerID];
    
    if(messageBannerID.length == 0 || [messageBannerID isEqualToString:@"0"]){
        
        messageBannerID = GDTMessageBannerID;
    }
    
    _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 60) appkey:GDTID placementId:messageBannerID];
    
    _bannerView.isAnimationOn = NO;
    _bannerView.showCloseBtn = YES;
    _bannerView.currentViewController = self;
    _bannerView.interval = 10;
    _bannerView.isGpsOn = YES;

    tableView.tableFooterView = _bannerView;
}


#pragma mark 初始化数据
- (void)viewDidLoadWithNoNetworkingStatus{
    
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginDic.count == 0){
        
        [self.dataList removeAllObjects];
        
    }else{
        
        //从数据库获取好友列表
        NSArray *dbArray = [_manager receiveFriendListByTime];
        
        self.dataList = [YKXMessageModel mj_objectArrayWithKeyValuesArray:dbArray];
    }

    //请求数据之后将空白页显示出来
    self.isEmptyDataSetShouldDisplay = YES;
    //刷新加载空白页
    [self.tableView reloadEmptyDataSet];
    
    [self.tableView reloadData];
}


- (void)viewDidLoadWithNetworkingStatus{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *friendListTime = [YKXDefaultsUtil getFriendListPingTime];
    
    NSTimer *friendListTimer = [NSTimer timerWithTimeInterval:[friendListTime integerValue] target:self selector:@selector(initData) userInfo:nil repeats:YES];
    [friendListTimer fire];
    [[NSRunLoop mainRunLoop] addTimer:friendListTimer forMode:NSRunLoopCommonModes];
    appDelegate.friendListTimer = friendListTimer;
}


- (void)initData{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginUserInfo.count == 0){
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        [self.dataList removeAllObjects];
        
        self.isEmptyDataSetShouldDisplay = YES;
        //刷新加载空白页
        [self.tableView reloadEmptyDataSet];
        
        [self.tableView reloadData];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        return;
    }
    

    NSMutableArray *friendIdArray = [NSMutableArray array];
    //从数据库获取好友列表
    NSArray *dbArray = [_manager receiveFriendList];
    
    for (NSDictionary *dbDict in dbArray){
        
        NSString *dbFriendId = dbDict[@"friends_id"];
        
        //存入所有不重复的好友Id
        if(![friendIdArray containsObject:dbFriendId]){
            [friendIdArray addObject:dbFriendId];
        }
    }
    
    //请求数据获取好友列表
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *lastRequest = [YKXDefaultsUtil getLastRequestTime];
    if(lastRequest == nil){
        lastRequest = @"0";
    }
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,lastRequest,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataGetFriendMessageListPostUid:uid token:token versionCode:versionCode lastRequest:lastRequest devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"0"]){
            //保存后台返回的时间戳
            NSString *lastTime = responseObject[@"lastrequest"];
            
            //保存当前时间戳
            [YKXDefaultsUtil setLastRequestTime:lastTime];
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return;
            }

            for (NSDictionary *dict in dataArray){
                
                NSString *friendId = dict[@"friends_id"];
                NSString *name = dict[@"name"];
                NSString *title = dict[@"title"];
                NSString *url = dict[@"url"];
                NSString *headimgurl = dict[@"headimgurl"];
                NSString *time = dict[@"time"];
                NSString *count = dict[@"count"];
                
                //数据库中包含该类型的数据，就更新数据
                if([friendIdArray containsObject:friendId]){

                    NSArray *countArray = [_manager receiveFriendListByFriendId:friendId];
                    
                    if(countArray.count >0){
                        
                        NSDictionary *countDic = countArray[0];
                        //当前数据库中的数字角标
                        NSString *dbcount = countDic[@"count"];
                        
                        NSInteger addCount = [dbcount integerValue] + [count integerValue];
                        
                        NSString *updateCount = [NSString stringWithFormat:@"%ld",addCount];
                        
                        NSDictionary *updateDic = @{@"friends_id":friendId,@"name":name,@"title":title,@"url":url,@"headimgurl":headimgurl,@"time":time,@"count":updateCount};
                        
                       [_manager updateFriendList:updateDic ByFriendId:friendId];
                    }
                    
                }else{
                    
                    [_manager insertFriendList:dict];
                }
            }
            
            
            NSArray *newDbArray = [_manager receiveFriendListByTime];
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dbDict in newDbArray){
                
                [tempArray addObject:dbDict];
            }
            
            self.dataList = [YKXMessageModel mj_objectArrayWithKeyValuesArray:tempArray];

            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            
            [self.tableView reloadData];
            
            [self setTabbarBadgeArray:tempArray];
            
            
            //加载广告
            [_bannerView loadAdAndShow];
            
            self.tableView.tableFooterView = _bannerView;
            
        }
    } failure:^(NSError *error) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
    }];
}



#pragma mark 点击事件
- (void)leftNavcAction{

    //设置左边导航栏的图片
    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *urlStr = remindDic[@"url"];
        
        //优看左上角图标
        if([remind_id isEqualToString:@"2"]){
            
            [self headViewActionURL:urlStr];
        }
    }
}


- (void)headViewActionURL:(NSString *)urlStr{
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]
       ){//跳到外部链接
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else{
        
        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
        activityVC.urlStr = urlStr;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
}


- (void)onClickIgnoreRead{
    
    //修改当前tabbar的角标
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *dbArray = [_manager receiveFriendList];
    for (NSDictionary *dbDict in dbArray){
        
        NSString *friendId = dbDict[@"friends_id"];
        [_manager updateFriendListInCount:@"0" ByFriendId:friendId];
    }
    NSArray *newdbArray = [_manager receiveFriendListByTime];
    self.dataList = [YKXMessageModel mj_objectArrayWithKeyValuesArray:newdbArray];
    
    [self.tableView reloadData];
    
    [appDelegate.mainVC.tabBar hideMarkIndex:1];
    appDelegate.badgeCount = 0;
}


- (void)changeMessageInfo:(NSNotification *)noti{
    
    [self initData];
    
}


- (void)setTabbarBadgeArray:(NSArray *)array{
    
    //修改当前tabbar的角标
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.badgeCount = 0;
    
    for (NSDictionary *dict in array){
        
        NSString *count = dict[@"count"];
        NSInteger badge = [count integerValue];
        appDelegate.badgeCount += badge;
    }
    
    //给消息设置角标
    [appDelegate.mainVC.tabBar showBadgeMark:appDelegate.badgeCount index:1];
}

- (void)chatListTextMessage:(NSString *)messageText time:(NSString *)messageTime friendId:(NSString *)friendId{
    
    [_manager updateFriendListContent:messageText time:messageTime ByFriendId:friendId];
    
    NSArray *dbArray = [_manager receiveFriendListByTime];
    
    self.dataList = [YKXMessageModel mj_objectArrayWithKeyValuesArray:dbArray];
    
    [self.tableView reloadData];
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

#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *friendCell = @"friendCell";
    YKXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCell];
    if(!cell){
        
        cell = [[YKXMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCell];
    }
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YKXMessageModel *model = self.dataList[indexPath.row];
    NSString *friendId = model.friends_id;
    NSString *name = model.name;
    NSString *headImageurl = model.headimgurl;
    //修改当前的角标为0
    [_manager updateFriendListInCount:@"0" ByFriendId:friendId];
    
    NSArray *dbArray = [_manager receiveFriendListByTime];
    
    [self setTabbarBadgeArray:dbArray];
    
    self.dataList = [YKXMessageModel mj_objectArrayWithKeyValuesArray:dbArray];
    
    [self.tableView reloadData];
    
    YKXChatViewController *chatVC = [[YKXChatViewController alloc] init];
    chatVC.name = name;
    chatVC.friendId = friendId;
    chatVC.headimgurl = headImageurl;
    chatVC.delegete = self;
    [self.navigationController pushViewController:chatVC animated:YES];
}

//设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        YKXMessageModel *model = self.dataList[indexPath.row];
        
        //删除数据库中的数据
        [_manager deleteFriendListByFriendId:model.friends_id];
        
        //删除列表数据
        [self.dataList removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray *dbArray = [_manager receiveFriendListByTime];
        
        [self setTabbarBadgeArray:dbArray];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无消息";
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16*kWJFontCoefficient],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noMessage"];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -60*kWJHeightCoefficient;
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithHexString:BACKGROUND_COLOR];
}

#pragma mark 是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.isEmptyDataSetShouldDisplay;
}


#pragma mark 是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark 图片是否要动画效果，默认NO
- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return NO;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];

}

@end
