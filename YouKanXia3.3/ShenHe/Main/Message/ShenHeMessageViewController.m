//
//  ShenHeMessageViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeMessageViewController.h"
#import "ShenHeTableViewCell.h"
#import "ShenHeModel.h"

@interface ShenHeMessageViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *tempArray;


@property (nonatomic,assign) BOOL isEmptyDataSetShouldDisplay;

//顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//中间转动指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ShenHeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    [self initData];
    
    //特殊登录消息改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginMessageSuccess:) name:NOTIFICATION_SPECIAL_LOGIN_MESSAGE_FREQUENCY object:nil];
    //特殊消息退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitMessageSuccess:) name:NOTIFICATION_SPECIAL_EXIT_MESSAGE_FREQUENCY object:nil];
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
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
}

- (void)initData {
    
    NSString *status = [YKXDefaultsUtil getPhonenumberStatus];
    
    if([status isEqualToString:SPECIALPHONENUMBER]){
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        [self setIPV6MessageData];
        
    }else{
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        [self.dataList removeAllObjects];
        
        self.isEmptyDataSetShouldDisplay = YES;
        //刷新加载空白页
        [self.tableView reloadEmptyDataSet];
        
        [self.tableView reloadData];
        
    }
    
}


- (void)setIPV6MessageData{
    
    NSMutableArray *messageArray = [NSMutableArray array];
    
    ShenHeModel *model1 = [[ShenHeModel alloc] init];
    model1.addtime = [YKXCommonUtil longLongTime];
    model1.content = [NSString stringWithFormat:@"欢迎登录%@",DISPLAYNAME];
    model1.status = @"1";
    [messageArray addObject:model1];
    
    ShenHeModel *model2 = [[ShenHeModel alloc] init];
    model2.addtime = [YKXCommonUtil longLongTime];
    model2.content = @"新版本消息让你了解最新最快资讯";
    model2.status = @"1";
    [messageArray addObject:model2];
    
    ShenHeModel *model3 = [[ShenHeModel alloc] init];
    model3.addtime = [YKXCommonUtil longLongTime];
    model3.content = [NSString stringWithFormat:@"又到开学季，%@网络陪你更好看",DISPLAYNAME];
    model3.status = @"1";
    [messageArray addObject:model3];
    
    
    self.dataList = [ShenHeModel mj_objectArrayWithKeyValuesArray:messageArray];
    
    //刷新加载空白页
    [self.tableView reloadEmptyDataSet];
    
    self.isEmptyDataSetShouldDisplay = YES;
    
    [self.tableView reloadData];
}

- (void)loginMessageSuccess:(NSNotification *)noti{
    
    [self setIPV6MessageData];
}

- (void)exitMessageSuccess:(NSNotification *)noti{
    
    [self.dataList removeAllObjects];
    
    //刷新加载空白页
    [self.tableView reloadEmptyDataSet];
    
    [self.tableView reloadData];
}


#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    ShenHeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[ShenHeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataList[indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return 80;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPECIAL_LOGIN_MESSAGE_FREQUENCY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPECIAL_EXIT_MESSAGE_FREQUENCY object:nil];
}

@end
