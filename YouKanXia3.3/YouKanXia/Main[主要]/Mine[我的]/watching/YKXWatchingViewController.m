//
//  YKXWatchingViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/10/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXWatchingViewController.h"
#import "WatchingListCell.h"
#import "WatchingListModel.h"
#import "YKXSVIPViewController.h"

@interface YKXWatchingViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;

//tableView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;


@property (nonatomic , strong) NSMutableArray *dataList;

@end

@implementation YKXWatchingViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self initData];
}

- (void)createNavc {
    
    [super createNavc];
    self.navigationItem.title = @"观看历史";
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 40, 22);
    [rightNavcButton setTitle:@"清空" forState:UIControlStateNormal];
    [rightNavcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightNavcButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightNavcButton addTarget:self action:@selector(DeleteHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}


- (void)createView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    
    //cell底部分割线颜色
    tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建头部刷新控件
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //隐藏更新时间
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    self.refreshHeader = refreshHeader;
    
    
}

- (void)initData {
    
    FMDBManager *manager = [FMDBManager sharedFMDBManager];
    
    NSMutableArray *totalDataArray = [manager receiveWatchList];

    for(NSDictionary *watchListDic in totalDataArray){
        
        NSString *watchTime = watchListDic[@"time"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:watchTime];
        NSTimeInterval dateInterval = [date timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:-7*24*60*60]];
        
        if(dateInterval < 0){

            [manager deleteWatchListByWatchingTime:watchTime];
        
        }
    }
    
    NSMutableArray *dataArray = [manager receiveWatchList];

    self.dataList = [WatchingListModel mj_objectArrayWithKeyValuesArray:dataArray];

    //刷新加载空白页
    [self.tableView reloadEmptyDataSet];
    [self.tableView reloadData];
    
    [self.refreshHeader endRefreshing];
}

//刷新重新加载数据
- (void)refreshData{
    [self initData];
}

#pragma mark 点击事件
- (void)DeleteHistoryAction {
    
    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"清空观看记录" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
        
        if(actionType == 1){
            
            FMDBManager *manager = [FMDBManager sharedFMDBManager];
            
            [manager deleteAllWatchList];
            
            [self.dataList removeAllObjects];
            
            [self.tableView reloadData];
            
        }
    }];
    [alertView show];

}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *watchIdentifier = @"watchIdentifier";
    
    WatchingListCell *cell = [tableView dequeueReusableCellWithIdentifier:watchIdentifier];
    if(!cell) {
        
        cell = [[WatchingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:watchIdentifier];
    }
    
    WatchingListModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    cell.playBlock = ^(UIButton *btn) {
        

        [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];

        NSString *title = model.title;
        //当前点击的播放视频连接
        NSString *currentUrl = model.url;
        
        NSString *type = model.type;
        
        if(title == nil || title.length == 0){
            return;
        }
        
        if(currentUrl == nil || currentUrl.length == 0){
            return;
        }
        
        NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
        NSString *uid = loginUserInfo[@"uid"];
        NSString *token = loginUserInfo[@"token"];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",title,currentUrl,@"1",uid,token,type,@"2",timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataSVIPChannelTitle:title URL:currentUrl versionCode:versionCode line:@"1" uid:uid token:token vweb:type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
            
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
                
                ykxSVIPVC.name = title;
                ykxSVIPVC.type = type;
                //网页播放的链接
                ykxSVIPVC.currentUrl = currentUrl;
                ykxSVIPVC.currentTitle = title;
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

    };
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70*kWJHeightCoefficient;
}


//设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        WatchingListModel *model = self.dataList[indexPath.row];
        
        FMDBManager *manager = [FMDBManager sharedFMDBManager];
        
        [manager deleteWatchListByWatchingTime:model.time];
        
        [self.dataList removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"没有查询到数据哦";
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16*kWJFontCoefficient],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_search_result"];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -100*kWJHeightCoefficient;
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithHexString:BACKGROUND_COLOR];
}

#pragma mark 是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark 是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark 图片是否要动画效果，默认NO
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return NO;
}


@end
