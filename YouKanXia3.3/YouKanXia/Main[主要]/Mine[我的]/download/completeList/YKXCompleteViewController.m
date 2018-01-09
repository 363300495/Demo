//
//  YKXCompleteViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCompleteViewController.h"
#import "DownLoadCompleteDataSource.h"
#import "completeCell.h"

@interface YKXCompleteViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;

//tableView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;


@property (nonatomic , strong) DownLoadCompleteDataSource *downLoadCompleteDataSource;

@end

@implementation YKXCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self initData];
}

- (void)createNavc {
    
    [super createNavc];
    self.navigationItem.title = @"已下载";
}


- (void)createView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
    
    self.downLoadCompleteDataSource = [[DownLoadCompleteDataSource alloc] init];
    [self mpDownLoadCompleteTask];
    
    //任务完成时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpDownLoadCompleteTask) name:MpDownLoadCompleteTask object:nil];
    
}

//刷新重新加载数据
- (void)refreshData{
    [self initData];
}



- (void)mpDownLoadCompleteTask{
    [self.downLoadCompleteDataSource loadFinishedTasks];

    //刷新加载空白页
    [self.tableView reloadEmptyDataSet];
    [self.tableView reloadData];
    
    [self.refreshHeader endRefreshing];
}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.downLoadCompleteDataSource.finishedTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *completeIdentifier = @"completeIdentifier";
    
    completeCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentifier];
    if(!cell) {
        
        cell = [[completeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentifier];
    }
    
    
    TaskEntity *taskEntity = [self.downLoadCompleteDataSource.finishedTasks objectAtIndex:indexPath.row];
    [cell showData:taskEntity];
    
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        
        YKXVideoPlayViewController *videoPlayVC = [[YKXVideoPlayViewController alloc] init];
        videoPlayVC.playTitle = taskEntity.name;
        videoPlayVC.playURL = taskEntity.downLoadUrl;
        [self.navigationController pushViewController:videoPlayVC animated:YES];
        
    };
    
    return cell;
}

- (BOOL)shouldAutorotate {
    return NO;
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
        
        TaskEntity *taskEntity = [self.downLoadCompleteDataSource.finishedTasks objectAtIndex:indexPath.row];
        
        //删除缓存的本地文件
        [[MusicPartnerDownloadManager sharedInstance] deleteFile:taskEntity.downLoadUrl];
        [self.downLoadCompleteDataSource.finishedTasks removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
        //修改
        [[NSNotificationCenter defaultCenter] postNotificationName:MpDownLoadCompleteDeleteCount object:nil];
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
