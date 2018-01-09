//
//  YKXVideoListViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXVideoListViewController.h"
#import "YKXSVIPViewController.h"
#import "CustomVideoListCell.h"
#import "VideoModel.h"
#import <AdSupport/AdSupport.h>
@interface YKXVideoListViewController () <UITableViewDelegate,UITableViewDataSource,CustomVideoListCellDelegete>

{
    NSInteger currentPage;
}

@property (nonatomic,strong) NSMutableArray *tableTempList;
@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) MJRefreshAutoNormalFooter *refreshFooter;

@end

@implementation YKXVideoListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    currentPage = 0;
    _tableTempList = [NSMutableArray array];

    [self loadDataVideoListPage:currentPage];
    
    //每次新增任务时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewAndmpDownloadCompleteTask) name:MpDownLoadingTask object:nil];
    
    //任务完成时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewAndmpDownloadCompleteTask) name:MpDownLoadCompleteTask object:nil];
    
    //下载完成的任务和正在下载的任务删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewAndmpDownloadCompleteTask) name:MpDownLoadCompleteDeleteCount object:nil];
    
}

- (void)loadNewAndmpDownloadCompleteTask{
    
    //刷新列表更新界面UI
    [self.tableView reloadData];
    
}

- (void)loadDataVideoListPage:(NSInteger)page {

    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devType = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,[NSString stringWithFormat:@"%ld",page],devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataGetVideoDownloadListPostUid:uid token:token versionCode:versionCode page:[NSString stringWithFormat:@"%ld",page] devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }

            if(dataArray.count == 0){
                //设置没有更多文字
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                for(NSDictionary *tempDic in dataArray){
                    [self.tableTempList addObject:tempDic];
                }
                
                self.dataList = [VideoModel mj_objectArrayWithKeyValuesArray:self.tableTempList];
            }
            
            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

//刷新重新加载数据
- (void)refreshData{
    currentPage = 0;
    [self.tableTempList removeAllObjects];
    [self loadDataVideoListPage:currentPage];
}

- (void)loadData{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        
        currentPage = 0;
        [self.tableTempList removeAllObjects];
        [self loadDataVideoListPage:currentPage];
    }
}

- (void)createView{

    [super createView];
    
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    //cell底部分割线颜色
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        currentPage++;
        
        [self loadDataVideoListPage:currentPage];
    }];
    [refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
    //设置加载完成时的文字
    [refreshFooter setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = refreshFooter;
    self.refreshFooter = refreshFooter;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *downloadIdentifier = @"downloadIdentifier";
    
    CustomVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadIdentifier];
    if(!cell) {
        
        cell = [[CustomVideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadIdentifier];
    }
    cell.index = indexPath;
    cell.delegete = self;
    cell.model = self.dataList[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70*kWJHeightCoefficient;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoModel *model = self.dataList[indexPath.row];
    
    [self headViewActionURL:model.url];
}

- (void)headViewActionURL:(NSString *)urlStr{
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    if ([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else if([urlStr containsString:@"uu-svip"] || [urlStr containsString:@"UU-SVIP"]){
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
        
        [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
        
        NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
        NSString *uid = loginDic[@"uid"];
        NSString *token = loginDic[@"token"];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"",urlStr,@"1",uid,token,@"0",@"2",timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataSVIPChannelTitle:@"" URL:urlStr versionCode:versionCode line:@"1" uid:uid token:token vweb:@"0" devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
            
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
                ykxSVIPVC.currentUrl = urlStr;
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
        
    }else if ([urlStr containsString:@"uu-new"] || [urlStr containsString:@"UU-NEW"]){
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-new" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-NEW" withString:@""];
        
        YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
        ykxActivityVC.urlStr = urlStr;
        [self.navigationController pushViewController:ykxActivityVC animated:YES];
        
    }else{
        YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
        ykxActivityVC.urlStr = urlStr;
        [self.navigationController pushViewController:ykxActivityVC animated:YES];
    }
}


- (void)addDownLoadTaskAction:(NSIndexPath *)indexPath{
    
    //获取正在下载的任务数量
    NSInteger count =  [[MusicPartnerDownloadManager sharedInstance] getDownLoadingTaskCount];
    if(count == 5){
        
        [YKXCommonUtil showToastWithTitle:@"下载的任务最多为5个" view:self.view.window];
        
        return;
    }
    
    
    VideoModel *model = self.dataList[indexPath.row];
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *downLoadUrl = [NSString stringWithFormat:@"%@",model.down_url];
    
    if(downLoadUrl.length >0){
        
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
        
        MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:downLoadUrl];
        
        switch (taskState) {
            case MPTaskCompleted:
                
                [YKXCommonUtil showToastWithTitle:@"下载完成，请到[下载管理]中查看" view:self.view.window];
                
                break;
            case MPTaskExistTask:
                
                
                [YKXCommonUtil showToastWithTitle:@"正在下载，请到[下载管理]中查看进度" view:self.view.window];
                
                break;
            case MPTaskNoExistTask:
            {
                //这里给taskEntity赋值
                MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                downLoadEntity.downLoadUrlString = downLoadUrl;
                downLoadEntity.extra = model.mj_keyValues;
                [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                
                [YKXCommonUtil showToastWithTitle:@"添加成功，正在下载" view:self.view.window];
                
            }
                break;
            default:
                break;
        }
    }
    
    
}

@end
