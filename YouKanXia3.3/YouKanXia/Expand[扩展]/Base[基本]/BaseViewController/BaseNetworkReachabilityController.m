//
//  BaseNetworkReachabilityController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/12.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNetworkReachabilityController.h"
#import "BaseNetworkReachabilityController+EmptyDataSet.h"
@interface BaseNetworkReachabilityController ()

@end

@implementation BaseNetworkReachabilityController

- (instancetype)init{
    if(self = [super init]){
        _isEmptyDataSetShouldDisplay = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
         [self viewDidLoadWithNetworkingStatus];
        
    }else{
        [self viewDidLoadWithNoNetworkingStatus];
    }
    
}

#pragma mark 没网时
- (void)viewDidLoadWithNoNetworkingStatus{
    
    //这里会先进入子类
    [self createView];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.rootView = rootView;
    
    //网络图片
    UIImageView *networkImageView = [[UIImageView alloc] init];
    networkImageView.image = [UIImage imageNamed:@"feed_error"];
    [rootView addSubview:networkImageView];
    [networkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(@(160*kWJHeightCoefficient));
        make.size.mas_equalTo(CGSizeMake(120*kWJHeightCoefficient, 120*kWJHeightCoefficient));
    }];
    
    //网络文字
    UILabel *networkLabel = [[UILabel alloc] init];
    networkLabel.text = @"抱歉，网络出现了错误";
    networkLabel.font = [UIFont systemFontOfSize:14.0f];
    networkLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    networkLabel.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:networkLabel];
    [networkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(networkImageView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    //网络按钮
    UIButton *networkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [networkButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [networkButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateNormal];
    networkButton.layer.cornerRadius = 15;
    networkButton.layer.masksToBounds = YES;
    networkButton.layer.borderWidth = 0.6;
    networkButton.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
    networkButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [networkButton addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:networkButton];
    [networkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(networkLabel.mas_bottom).offset(30*kWJHeightCoefficient);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
}


#pragma mark 有网时
- (void)viewDidLoadWithNetworkingStatus{
    
    //子类有方法时会先调用子类的方法（这里会先进入子类）
    [self createView];
    
    //创建头部刷新控件
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //隐藏更新时间
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    self.refreshHeader = refreshHeader;
    
    
}

- (void)refreshData{
    //子类继承实现
}

- (void)loadData{
    //子类继承实现
}

- (void)createView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    //这里使用平板样式
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
