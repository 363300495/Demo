//
//  BaseNetworkReachabilityController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/12.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNetworkReachabilityController : UIViewController <UITableViewDataSource,UITableViewDelegate>

//tableView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//是否显示空白页
@property (nonatomic,assign) BOOL isEmptyDataSetShouldDisplay;
//没网时的网络提示页面
@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UITableView *tableView;

//上拉刷新控件
- (void)refreshData;

//点击按钮重新加载
- (void)loadData;

- (void)createView;

@end
