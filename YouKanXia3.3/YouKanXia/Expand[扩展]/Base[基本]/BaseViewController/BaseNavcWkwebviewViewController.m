//
//  BaseNavcWkwebviewViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/22.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcWkwebviewViewController.h"

@implementation BaseNavcWkwebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavc];
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        [self viewDidLoadWithNetworkingStatus];
    }else{
        
        [self viewDidLoadWithNoNetworkingStatus];
    }
}

- (void)createNavc{    
    
    YLButton *leftNavcButton = [YLButton buttonWithType:UIButtonTypeCustom];
    [leftNavcButton setTitle:@"返回" forState:UIControlStateNormal];
    leftNavcButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [leftNavcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftNavcButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateHighlighted];
    [leftNavcButton setImage:[UIImage imageNamed:@"leftNavc_button"] forState:UIControlStateNormal];
    [leftNavcButton setImage:[UIImage imageNamed:@"leftNavc_buttonSelect"] forState:UIControlStateHighlighted];
    leftNavcButton.titleRect = CGRectMake(16, 0, 36, 44);
    leftNavcButton.imageRect = CGRectMake(0, 10, 14, 24);
    [self.view addSubview:leftNavcButton];
    leftNavcButton.frame = CGRectMake(0, 0, 52, 44);
    [leftNavcButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *leftCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftCloseButton.frame = CGRectMake(0, 0, 36, 44);
    [leftCloseButton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftCloseButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateHighlighted];
    leftCloseButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [leftCloseButton addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    leftCloseButton.hidden = YES;
    self.closeButton = leftCloseButton;
    
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavcButton];
    UIBarButtonItem *closeBarBurronItem = [[UIBarButtonItem alloc] initWithCustomView:leftCloseButton];
    self.navigationItem.leftBarButtonItems =  @[backBarButtonItem,closeBarBurronItem];
    

    
    //设置导航栏的标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160*kWJWidthCoefficient, 44)];
    self.titleView = titleView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160*kWJWidthCoefficient, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel = titleLabel;
    
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
}


// 根据网络状态进行加载处理(有网)
- (void)viewDidLoadWithNetworkingStatus{
    
    WEAKSELF(weakSelf);
    //有网时创建WkWebView，先调用子类的方法
    [self createView];
    
    //加载进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    progressView.tintColor = [UIColor colorWithHexString:PROGRESS_COLOR];
    progressView.trackTintColor = [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
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
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
        webView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        //这行代码可以是侧滑返回webView的上一级
//        [webView setAllowsBackForwardNavigationGestures:YES];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [self.view addSubview:webView];
        self.webView = webView;
    
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
            currentNetworkReachabilityStatusLabel.hidden = YES;
            self.currentNetworkReachabilityStatusLabel = currentNetworkReachabilityStatusLabel;
        }
        
        //增加进度条属性的监听
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        //添加标题的title
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if(object == self.webView){
            self.progressView.progress = self.webView.estimatedProgress;
            if (self.progressView.progress == 1) {

                WEAKSELF(weakSelf);
                [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    weakSelf.progressView.hidden = YES;
                    
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if([keyPath isEqualToString:@"title"]){
        if (object == self.webView){
            self.titleLabel.text = self.webView.title;
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [self.webView loadRequest:request];
        //开始刷新
        [self.refreshHeader beginRefreshing];
    }
}

//下拉刷新
- (void)refreshData{
    
    WEAKSELF(weakSelf);
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        //有数据重新加载此页面
        [self.webView reload];
        
        //网速不好时，刷新状态会一直存在，要去掉
        [self performSelector:@selector(refreshHeaderHidden) withObject:nil afterDelay:5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }else{
        
        //停止刷新
        if([self.refreshHeader isRefreshing]){
            [self.refreshHeader endRefreshing];
        }
        
        self.currentNetworkReachabilityStatusLabel.hidden = NO;
        
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
   } completion:^(BOOL finished) {
       self.currentNetworkReachabilityStatusLabel.hidden = YES;
   }];
    
}

- (void)refreshHeaderHidden{
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
}


- (void)onClickBack{
    
    if ([self.webView canGoBack]){//在网页内部跳转

        self.closeButton.hidden = NO;
        [self.webView goBack];
    }else{//在网页外部跳转
        [self onClickClose];
    }
}


- (void)onClickClose{
    //子类继承实现
}


#pragma mark 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 提示框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
