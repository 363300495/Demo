//
//  BaseShareViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseShareViewController.h"

@interface BaseShareViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if(IPHONE5){
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH-32, 300);
    }else{
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH-32, 420);
    }
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    
    //加载更多按钮
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    moreButton.layer.cornerRadius = 6.0f;
    moreButton.layer.borderColor = [UIColor colorWithHexString:DEEP_COLOR].CGColor;
    moreButton.layer.borderWidth = 0.6f;
    [moreButton addTarget:self action:@selector(onClickMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButton];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(tableView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    moreButton.hidden = YES;
    self.moreButton = moreButton;
    
}

#pragma mark 点击事件
- (void)onClickMore{
    
   //子类继承实现
}

#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0.0f;
}



#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
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
    return -20*kWJHeightCoefficient;
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
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
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return NO;
}


@end
