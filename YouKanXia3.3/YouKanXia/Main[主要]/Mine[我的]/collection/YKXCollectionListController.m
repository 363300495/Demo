//
//  YKXCollectionListController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/30.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCollectionListController.h"
#import "CollectionListCell.h"
#import "CollectionListModel.h"
#import "YKXSVIPViewController.h"

@interface YKXCollectionListController () <UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _page;
}

@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation YKXCollectionListController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 0;
    [self initData];
}

- (void)createNavc {
    
    [super createNavc];
    self.navigationItem.title = @"我的收藏";
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 40, 22);
    [rightNavcButton setTitle:@"清空" forState:UIControlStateNormal];
    [rightNavcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightNavcButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightNavcButton addTarget:self action:@selector(DeleteCollectionAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


- (void)createView {
    
    [super createView];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 );
    //cell底部分割线颜色
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

}

- (void)initData {
    
    [self loadDataCollectionListPage:_page];
}


- (void)loadDataCollectionListPage:(NSInteger)page {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devType = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,[NSString stringWithFormat:@"%ld",_page],devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataCollectionListUid:uid token:token versionCode:versionCode page:[NSString stringWithFormat:@"%ld",_page] devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.refreshHeader endRefreshing];
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            
            self.dataList = [CollectionListModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [self.refreshHeader endRefreshing];
    }];
}

//刷新重新加载数据
- (void)refreshData{
    [self initData];
}

- (void)loadData{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] ||[networkStatus isEqualToString:@"wifi"]){
        
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        [self initData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *collectionIdentifier = @"collectionIdentifier";
    
    CollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionIdentifier];
    if(!cell){
        cell = [[CollectionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:collectionIdentifier];

    }

    CollectionListModel *model = self.dataList[indexPath.row];
    
    cell.model = model;
    
    
    cell.playBlock = ^(UIButton *btn) {
        
        [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
        
        NSString *title = model.title;
        
        NSString *currentUrl = model.url;
        
        NSString *type = model.vweb;
        
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

#pragma mark 清空列表
- (void)DeleteCollectionAction {
    
    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"清空收藏记录" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
        
        if(actionType == 1){
            
            NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
            NSString *uid = loginUserInfo[@"uid"];
            NSString *token = loginUserInfo[@"token"];
            
            NSString *devType = @"2";
            
            NSString *collectionId = @"0";
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,collectionId,devType,timeStamp,YOYO,randCode];
            
            //获取签名
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataDeleteCollectionPostUid:uid token:token versionCode:versionCode collection_id:collectionId devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
                
                if([responseObject[@"error_code"] isEqualToString:@"0"]){
                    
                    [self.dataList removeAllObjects];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSError *error) {
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
            
        }
    }];
    [alertView show];
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
        
        CollectionListModel *model = self.dataList[indexPath.row];
        
        [self deleteCollectionListByCollectionId:model.collection_id indexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}


- (void)deleteCollectionListByCollectionId:(NSString *)collectionId indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devType = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,collectionId,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataDeleteCollectionPostUid:uid token:token versionCode:versionCode collection_id:collectionId devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"视频删除成功" view:self.view.window];
            
            [self.dataList removeObjectAtIndex:indexPath.row];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


@end
