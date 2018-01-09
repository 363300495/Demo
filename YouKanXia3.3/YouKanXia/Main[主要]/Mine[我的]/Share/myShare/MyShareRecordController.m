//
//  MyShareRecordController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/3.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "MyShareRecordController.h"
#import "MyShareCell.h"
#import "MyShareModel.h"
@interface MyShareRecordController ()<UITableViewDelegate,UITableViewDataSource>

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,assign) NSInteger page;

@end

@implementation MyShareRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    [self initDataWithNextPage:_page];
    
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"我的分享";
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    [super createView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    //创建指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
    activityIndicatorView.transform = transform;
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView startAnimating];
}


- (void)loadData{
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] ||[networkStatus isEqualToString:@"wifi"]){
        
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        [self initDataWithNextPage:_page];
    }else{
        
    }
}


- (void)refreshData{
    [self initDataWithNextPage:_page];
}


- (void)initDataWithNextPage:(NSInteger)page{
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",[NSString stringWithFormat:@"%ld",_page],uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataShareLogPostPage:[NSString stringWithFormat:@"%ld",_page] uid:uid token:token versionCode:versionCode devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
     
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40004"]){
            [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
            return ;
        }
        
        if([errorCode isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return;
            }
            
            self.dataList = [MyShareModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSError *error) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
    }];
    
}

#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *shareIdentifer = @"shareIdentifer";
    MyShareCell *cell = [tableView dequeueReusableCellWithIdentifier:shareIdentifer];
    if(!cell){
        cell = [[MyShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareIdentifer];
    }
    
    cell.model = self.dataList[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以显示7组数据,最后70显示更多按钮
    return 60.0f;
}


@end
