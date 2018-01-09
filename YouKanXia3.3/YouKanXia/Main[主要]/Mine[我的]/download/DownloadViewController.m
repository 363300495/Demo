//
//  DownloadViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "DownloadViewController.h"
#import "MLMSegmentManager.h"
#import "YKXDownloadManagerController.h"
#import "YKXVideoListViewController.h"

@interface DownloadViewController ()

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}


- (void)createView {

    NSArray *titleList = @[@"下载管理",@"下载热榜"];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:titleList headStyle:SegmentHeadStyleDefault layoutStyle:MLMSegmentLayoutCenter];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontSize = 16.0f;
    _segHead.equalSize = YES;
    //设置选择状态的颜色
    _segHead.selectColor = [UIColor whiteColor];
    //设置未选中状态的颜色
    _segHead.deSelectColor = [UIColor colorWithHexString:SEGTITLE_SELECTED_COLOR];

    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) vcOrViews:[self viewArr:titleList.count]];
    _segScroll.loadAll = YES;
    _segScroll.enableScroll = @"2";
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
    }];
}

- (NSArray *)viewArr:(NSInteger)count {
   
    NSMutableArray *arr = [NSMutableArray array];
    
    YKXDownloadManagerController *downloadVC = [[YKXDownloadManagerController alloc] init];
    [arr addObject:downloadVC];
    
    YKXVideoListViewController *videoListVC = [[YKXVideoListViewController alloc] init];
    [arr addObject:videoListVC];
    
    
    return arr;
}

@end
