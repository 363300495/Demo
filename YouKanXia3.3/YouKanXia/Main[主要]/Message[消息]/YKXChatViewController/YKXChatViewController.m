//
//  YKXChatViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXChatViewController.h"
#import "YKXChatReceiveCell.h"
#import "YKXChatSendCell.h"
#import "YKXChatReceiveModel.h"
#import "YKXChatInputView.h"
#import "YKXActivityViewController.h"
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

@interface YKXChatViewController () <UITableViewDelegate,UITableViewDataSource,YKXChatInputViewDelegate,YKXChatReceiveCellDelegete>
{
    //当前页数
    NSInteger page;
    //每页的数据条数
    NSInteger a;
    //数据总页数
    NSInteger totalPage;
}

@property (nonatomic,strong) FMDBManager *manager;

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *tempArray;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,assign) CGRect keyboardFrame;

@property (nonatomic,strong) YKXChatInputView *chatInputView;

@property (nonatomic,assign) BOOL isFirstBottom;

//存储最后一条消息的时间
@property (nonatomic,copy) NSString *lastAddTime;

@property (nonatomic,strong) NSTimer *newsListTimer;

@end

@implementation YKXChatViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    if(self.newsListTimer){
        [self.newsListTimer invalidate];
        self.newsListTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _tempArray = [NSMutableArray array];
    _isFirstBottom = YES;
    a = 20;
    page = 1;

    [self createView];
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] ||[networkStatus isEqualToString:@"wifi"]){
        
        [self viewDidLoadWithNetworkingStatus];
    }else{
        [self viewDidLoadWithNoNetworkingStatus];
    }
}

#pragma mark 创建UI
- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = self.name;
    
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 22, 22);
    [rightNavcButton addTarget:self action:@selector(rightMessageAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    _manager = [FMDBManager sharedFMDBManager];
    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *img_url = remindDic[@"img_url"];
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *type = remindDic[@"type"];
        
        
        if([remind_id isEqualToString:@"13"]){
            
            if([type isEqualToString:@"0"]){
                rightNavcButton.hidden = YES;
            }else{
                rightNavcButton.hidden = NO;
                [rightNavcButton sd_setImageWithURL:[NSURL URLWithString:img_url] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)createView{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:backView];
    self.backView = backView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- SafeAreaTopHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //iOS11必须设置的三个属性
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [backView addSubview:tableView];
    self.tableView = tableView;
    
    //创建底部输入框
    [self createChatInputView];
}

- (void)createChatInputView{
    
    YKXChatInputView *chatInputView = [[YKXChatInputView alloc] init];
    chatInputView.frame = CGRectMake(0, SCREEN_HEIGHT - SafeAreaTopHeight - SafeAreaBottomHeight, SCREEN_WIDTH, 49);
    chatInputView.backgroundColor = [UIColor whiteColor];
    chatInputView.delegate = self;
    [self.backView addSubview:chatInputView];
    self.chatInputView = chatInputView;
}


#pragma mark 初始化数据
//滑动到最底部
- (void)sd_scrollToBottomWithAnimated:(BOOL)animate{

    if (!self.dataList.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.dataList.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animate];
}

//获取当前的总页数
- (void)getTotalPage{
    
    //从数据库获取聊天列表
    NSArray *dbArray = [_manager receiveChatListByFriendId:self.friendId];
    NSInteger count = dbArray.count;
    //单页数
    float tempNum = (float)(count)/a;
    //总页数
    totalPage = ceilf(tempNum);
}

//加载第一页的数据
- (void)loadPageFirst{
    
    //查询最后的n条记录
    NSArray *array = [_manager receiveChatListByFriendId:self.friendId numStart:@"0" numEnd:[NSString stringWithFormat:@"%ld",a]];
    NSArray *array1 = [[array reverseObjectEnumerator] allObjects];
    
    for(NSDictionary *dic in array1){
        
        [_tempArray addObject:dic];
    }
    
    self.dataList = [YKXChatReceiveModel mj_objectArrayWithKeyValuesArray:_tempArray];
    
    [self.tableView reloadData];
}

//加载上拉刷新后的数据
- (void)loadPageRefresh{
    
    [self getTotalPage];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page++;
        
        if(page <= totalPage){
            
            NSArray *array = [_manager receiveChatListByFriendId:self.friendId numStart:[NSString stringWithFormat:@"%ld",(page-1)*a] numEnd:[NSString stringWithFormat:@"%ld",a]];
            
            for(NSDictionary *dic in array){
                
                [_tempArray insertObject:dic atIndex:0];
            }
        }
        
        self.dataList = [YKXChatReceiveModel mj_objectArrayWithKeyValuesArray:_tempArray];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}


- (void)viewDidLoadWithNoNetworkingStatus{
    
    [self loadPageFirst];
    
    if(_isFirstBottom){
        
        _isFirstBottom = NO;
        
        [self sd_scrollToBottomWithAnimated:NO];
    }
    
    [self loadPageRefresh];
}

- (void)viewDidLoadWithNetworkingStatus{
    
    [self initData];
    
    WEAKSELF(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf timeSatrt];
    });
}

- (void)timeSatrt{
    
    NSString *newsListTime = [YKXDefaultsUtil getNewsListPingTime];
    
    NSTimer *newsListTimer = [NSTimer timerWithTimeInterval:[newsListTime integerValue] target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    
    [newsListTimer fire];
    [[NSRunLoop mainRunLoop] addTimer:newsListTimer forMode:NSRunLoopCommonModes];
    
    self.newsListTimer = newsListTimer;
}


- (void)initData{

    //查询最后的n条记录
    NSArray *array = [_manager receiveChatListByFriendId:self.friendId numStart:@"0" numEnd:[NSString stringWithFormat:@"%ld",a]];
    NSArray *array1 = [[array reverseObjectEnumerator] allObjects];
    
    for(NSDictionary *dic in array1){
        
        [_tempArray addObject:dic];
    }
    
    self.dataList = [YKXChatReceiveModel mj_objectArrayWithKeyValuesArray:_tempArray];
    

    [self.tableView reloadData];
    
    [self sd_scrollToBottomWithAnimated:NO];
    
    [self loadPageRefresh];
}

- (void)loadData{

    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSDictionary *messageDic = [YKXDefaultsUtil getFriendNewMessageTimeFriendId:[NSString stringWithFormat:@"friend%@",self.friendId]];
    NSString *lastRequest = messageDic[self.friendId];

    if(lastRequest == nil){
        lastRequest = @"0";
    }
    
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",uid,token,self.friendId,lastRequest,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataGetFriendNewMessagePostUid:uid token:token versionCode:versionCode friendId:self.friendId lastRequest:lastRequest devtype:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {

        NSString *errorCode = responseObject[@"error_code"];

        if([errorCode isEqualToString:@"0"]){
            
            //保存后台返回的时间戳
            NSString *lastTime = responseObject[@"lastrequest"];
            
            NSDictionary *messageDic = @{self.friendId:lastTime};
            
            [YKXDefaultsUtil setFriendNewMessageTime:messageDic friendId:[NSString stringWithFormat:@"friend%@",self.friendId]];
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return;
            }
            
            NSString *isTimeShow;
            for(int i=0; i<dataArray.count; i++){
                
                NSDictionary *dict = dataArray[i];
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                tempDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                NSString *addTime = dict[@"addtime"];
                
                if(i == 0){
                    
                    isTimeShow = @"1";
                    
                }else{
                    
                    if([addTime integerValue] - [_lastAddTime integerValue] <120){
                        
                        isTimeShow = @"0";
                        
                    }else{
                        
                        isTimeShow = @"1";
                    }
                }
                _lastAddTime = addTime;
                
                [tempDic setObject:isTimeShow forKey:@"isTimeShow"];
                
                [_manager insertChatList:tempDic];
                
                [_tempArray addObject:tempDic];
            }
            
            self.dataList = [YKXChatReceiveModel mj_objectArrayWithKeyValuesArray:_tempArray];
        
            
            [self.tableView reloadData];
            
            
            if(dataArray.count >0){
                
                [self sd_scrollToBottomWithAnimated:NO];
            }
            
            [self getTotalPage];
        }
        
    } failure:^(NSError *error) {
    }];
}


#pragma mark private methods
- (void)keyBoardWillShow:(NSNotification *)notification{
    
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat height = self.keyboardFrame.size.height + 49 + SafeAreaTopHeight;
    
    self.chatInputView.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMinY(_chatInputView.frame));
    
    [self sd_scrollToBottomWithAnimated:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    self.chatInputView.chatText.frame = CGRectMake(10, 7, SCREEN_WIDTH-100, 35);
    self.chatInputView.frame = CGRectMake(0, SCREEN_HEIGHT - SafeAreaTopHeight - SafeAreaBottomHeight, SCREEN_WIDTH, 49);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMinY(_chatInputView.frame));
}

- (void)onClickBack{
    
    if (self.dataList.count >0){
        
        NSString *textMessage;
        
        YKXChatReceiveModel *model = self.dataList[self.dataList.count-1];
        
        if(model.content.length == 0){
            
            if(model.img_url.length != 0){
                textMessage = @"[图片]";
            }
        }else{
            
            textMessage = model.content;
        }
        
        //时间戳
        NSString *time = model.addtime;
        
        if(_delegete && [_delegete respondsToSelector:@selector(chatListTextMessage:time:friendId:)]){
            
            [_delegete chatListTextMessage:textMessage time:time friendId:self.friendId];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightMessageAction{
    
    FMDBManager *manager = [FMDBManager sharedFMDBManager];
    //设置左边导航栏的图片
    NSArray *remindDataArray = [manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *urlStr = remindDic[@"url"];
        
        
        if([remind_id isEqualToString:@"13"]){
            
            [self headViewActionURL:urlStr];
        }
    }
}

- (void)headViewActionURL:(NSString *)urlStr{
    
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

#pragma mark ---chatInputView代理
- (void)YKXChatInputView:(YKXChatInputView *)chatInputView sendTextMessage:(NSString *)textMessage{
    
    self.chatInputView.chatText.text = @"";
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,self.friendId,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataGetFriendSendMessagePostUid:uid token:token versionCode:versionCode friendId:self.friendId content:textMessage devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"0"]){
            
            NSString *isTimeShow;
            if([timeStamp integerValue] - [_lastAddTime integerValue] <120){
                isTimeShow = @"0";
            }else{
                isTimeShow = @"1";
            }
            _lastAddTime = timeStamp;
            
            NSDictionary *messageDic = @{@"friends_id":self.friendId,@"addtime":timeStamp,@"content":textMessage,@"fnid":@"",@"img_url":@"",@"title":@"",@"type":@"",@"url":@"",@"newstype":@"2",@"isTimeShow":isTimeShow,@"js_1":@"",@"js_2":@"",@"user_agent":@""};
            
            [_manager insertChatList:messageDic];
            
            [_tempArray addObject:messageDic];
            
            self.dataList = [YKXChatReceiveModel mj_objectArrayWithKeyValuesArray:_tempArray];
            
            [self.tableView reloadData];
            
            [self sd_scrollToBottomWithAnimated:YES];
            
            [self getTotalPage];
        }
    } failure:^(NSError *error) {
    }];
}


- (void)YKXChatInputView:(YKXChatInputView *)chatInputView chatHeight:(CGFloat)height{
    
    chatInputView.chatText.frame = CGRectMake(10, 7, SCREEN_WIDTH-100, height-14);
    chatInputView.sendButton.frame = CGRectMake(CGRectGetMaxX(chatInputView.chatText.frame)+10, (height-35)/2, 70, 35);
    
    chatInputView.frame = CGRectMake(0, SCREEN_HEIGHT-self.keyboardFrame.size.height-height-SafeAreaTopHeight, SCREEN_WIDTH, height);
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMinY(chatInputView.frame));
}


#pragma mark chatReceiveCell代理
- (void)currentCellUserAgent:(NSString *)userAgent contentUrl:(NSString *)contentUrl js_1:(NSString *)js1 js_2:(NSString *)js2{
    
    contentUrl = [YKXCommonUtil replaceDeviceSystemUrl:contentUrl];
    
    if([contentUrl isEqualToString:@"101"]){//卡券列表
        CardListViewController *cardVC = [[CardListViewController alloc] init];
        [self.navigationController pushViewController:cardVC animated:YES];
    }else if ([contentUrl isEqualToString:@"102"]){//免费领券
        FreeCardViewController *freeCardVC = [[FreeCardViewController alloc] init];
        [self.navigationController pushViewController:freeCardVC animated:YES];
    }else if ([contentUrl isEqualToString:@"103"]){//分享有奖
        ShareActivityController *shareVC = [[ShareActivityController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }else if ([contentUrl isEqualToString:@"104"]){//设置界面
        YKXSystemSettingController *systemSettingVC = [[YKXSystemSettingController alloc] init];
        [self.navigationController pushViewController:systemSettingVC animated:YES];
    }else if ([contentUrl isEqualToString:@"105"]){
        YKXCollectionListController *collectionListVC = [[YKXCollectionListController alloc] init];
        [self.navigationController pushViewController:collectionListVC animated:YES];
    }else if ([contentUrl isEqualToString:@"106"]){
        YKXWatchingViewController *watchVC = [[YKXWatchingViewController alloc] init];
        [self.navigationController pushViewController:watchVC animated:YES];
    }else if ([contentUrl isEqualToString:@"107"]){
        DownloadViewController *downLoadVC = [[DownloadViewController alloc] init];
        [self.navigationController pushViewController:downLoadVC animated:YES];
        
    }else if ([contentUrl isEqualToString:@"108"]){
        YkXUserSignViewController *userSignVC = [[YkXUserSignViewController alloc] init];
        [self.navigationController pushViewController:userSignVC animated:YES];
        
    }else if ([contentUrl containsString:@"uu-ext"] || [contentUrl containsString:@"UU-EXT"]){
        
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contentUrl] options:@{} completionHandler:nil];
        
    }else if([contentUrl containsString:@"uu-svip"] || [contentUrl containsString:@"UU-SVIP"]){
        
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
        
        [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
        
        NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
        NSString *uid = loginDic[@"uid"];
        NSString *token = loginDic[@"token"];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"",contentUrl,@"1",uid,token,@"0",@"2",timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataSVIPChannelTitle:@"" URL:contentUrl versionCode:versionCode line:@"1" uid:uid token:token vweb:@"0" devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
            
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
                ykxSVIPVC.currentUrl = contentUrl;
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
        
    }else if ([contentUrl containsString:@"uu-new"] || [contentUrl containsString:@"UU-NEW"]){
        
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"uu-new" withString:@""];
        contentUrl = [contentUrl stringByReplacingOccurrencesOfString:@"UU-NEW" withString:@""];
        
        YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
        ykxActivityVC.urlStr = contentUrl;
        ykxActivityVC.userAgent = userAgent;
        ykxActivityVC.reviseJS = js1;
        ykxActivityVC.adJS = js2;
        [self.navigationController pushViewController:ykxActivityVC animated:YES];
        
    }else{
        YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
        ykxActivityVC.urlStr = contentUrl;
        [self.navigationController pushViewController:ykxActivityVC animated:YES];
    }
}

#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKXChatReceiveModel *model = self.dataList[indexPath.row];
    
    if([model.newstype isEqualToString:@"1"]){
        
        static NSString *receiveCell = @"receiveCell";
        YKXChatReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveCell];
        if(!cell){
            
            cell = [[YKXChatReceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:receiveCell];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headimgurl]];
        cell.delegate = self;
        
        return cell;
        
    }else{
        
        static NSString *sendCell = @"sendCell";
        YKXChatSendCell *cell = [tableView dequeueReusableCellWithIdentifier:sendCell];
        if(!cell){
            
            cell = [[YKXChatSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendCell];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        return cell;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.chatInputView.chatText resignFirstResponder];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKXChatReceiveModel *model = self.dataList[indexPath.row];
    
    CGFloat hight = model.height;
    return hight;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
