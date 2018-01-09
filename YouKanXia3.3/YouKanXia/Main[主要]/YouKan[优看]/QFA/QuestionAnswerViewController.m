//
//  QuestionAnswerViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "QuestionAnswerViewController.h"
#import "FeedbackViewController.h"

@interface QuestionAnswerViewController () <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

//加载时中间的提示框
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//wkwebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;


//没网时显示的提示界面
@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UILabel *currentNetworkReachabilityStatusLabel;

@end

@implementation QuestionAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        [self viewDidLoadWithNetworkingStatus];
        
    }else{
        [self viewDidLoadWithNoNetworkingStatus];
    }
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"常见问题";
    
    //右侧的分享按钮
    UIButton *rightShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightShareButton.frame = CGRectMake(0, 0, 80, 24);
    [rightShareButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    [rightShareButton addTarget:self action:@selector(onClickFeedback) forControlEvents:UIControlEventTouchUpInside];
    rightShareButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightShareButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

// 根据网络状态进行加载处理(有网)
- (void)viewDidLoadWithNetworkingStatus{
    
    WEAKSELF(weakSelf);
    //有网时创建WkWebView
    [self createView];
    
    //创建指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
    activityIndicatorView.transform = transform;
    self.activityIndicatorView = activityIndicatorView;
    
}

// 根据网络状态进行加载处理(没网)
- (void)viewDidLoadWithNoNetworkingStatus{
    //没网时提示没网的界面
    [self createView];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.webView addSubview:rootView];
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

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    if(self.webView == nil){
        
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.allowsInlineMediaPlayback = YES;
        
        
        
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
        //这行代码可以是侧滑返回webView的上一级
        [webView setAllowsBackForwardNavigationGestures:YES];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [self.view addSubview:webView];
        
        self.webView = webView;
        
        if (@available(iOS 11, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        NSString *problemURL = [YKXDefaultsUtil getQuestionAndAnswerString];
        
        //加载网页
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:problemURL]];
        [webView loadRequest:request];
        
        
        self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [self.refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        //隐藏更新时间
        self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        webView.scrollView.mj_header = self.refreshHeader;
        
        
        if(self.currentNetworkReachabilityStatusLabel == nil){
            
            UILabel *currentNetworkReachabilityStatusLabel = [[UILabel alloc] init];
            [webView addSubview:currentNetworkReachabilityStatusLabel];
            currentNetworkReachabilityStatusLabel.font = [UIFont systemFontOfSize:15.0f];
            [currentNetworkReachabilityStatusLabel setTextColor:[UIColor whiteColor]];
            [currentNetworkReachabilityStatusLabel setTextAlignment:NSTextAlignmentCenter];
            [currentNetworkReachabilityStatusLabel setBackgroundColor:[UIColor colorWithHexString:NONETWORKING_COLOR alpha:0.8]];
            currentNetworkReachabilityStatusLabel.text = @"网络异常，请检查网络设置";
            [currentNetworkReachabilityStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view.mas_top);
                make.left.equalTo(@(0));
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
            }];
            self.currentNetworkReachabilityStatusLabel = currentNetworkReachabilityStatusLabel;
        }
        
        
        
    }
}

#pragma mark 点击事件
//点击重新加载按钮刷新
- (void)loadData{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        //移除网络提示界面
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        //重新加载数据
        
        NSString *problemURL = [YKXDefaultsUtil getQuestionAndAnswerString];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:problemURL]];
        [self.webView loadRequest:request];
        //开始刷新
        [self.refreshHeader beginRefreshing];
    }    
}


//下拉刷新
- (void)refreshData{
    
    WEAKSELF(weakSelf);
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] ||[networkStatus isEqualToString:@"wifi"]){
        
        //有数据重新加载此页面
        [self.webView reload];
        
        //网速不好时，刷新状态会一直存在，要去掉
        [self performSelector:@selector(refreshHeaderHidden) withObject:nil afterDelay:5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    
    }else{
        
        //停止刷新
        [self.refreshHeader endRefreshing];
        
        [self.currentNetworkReachabilityStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(0));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        }];
        
        [UIView animateWithDuration:1.5 animations:^{
            
            [weakSelf.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self performSelector:@selector(removeNetworkLabel) withObject:nil afterDelay:1.5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        }];
    }
    
}

- (void)removeNetworkLabel{
    
    WEAKSELF(weakSelf);
    
    [self.currentNetworkReachabilityStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(@(0));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    
    [UIView animateWithDuration:1.5 animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
    
}

- (void)refreshHeaderHidden{
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
}

- (void)onClickFeedback{
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}


#pragma mark WKNavigation代理
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    
    [self.activityIndicatorView startAnimating];
    
    [self performSelector:@selector(activityDismiss) withObject:nil afterDelay:4 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
}

- (void)activityDismiss{
    if([self.activityIndicatorView isAnimating]){
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
    }
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //停止下拉刷新
    [self.refreshHeader endRefreshing];
    
    
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
}

@end
