//
//  YKXCustomWkWebview.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomWkWebview.h"
@implementation YKXCustomWkWebview

- (instancetype)initWithUrlstr:(NSString *)urlStr{
    
    if(self = [super init]){
        
        WEAKSELF(weakSelf);
        
        self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.allowsInlineMediaPlayback = YES;
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) configuration:config];
        webView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        //允许侧滑返回
        webView.allowsBackForwardNavigationGestures = YES;
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [self addSubview:webView];
        self.webView = webView;
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:urlStr]];
        [self.webView loadRequest:request];
        
        //ios8监听事件判断白屏
        [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
        

        //刷新控件
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        [refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        //隐藏更新时间
        refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        webView.scrollView.mj_header = refreshHeader;
        self.refreshHeader = refreshHeader;
        
        
        if(self.currentNetworkReachabilityStatusLabel == nil){
            
            UILabel *currentNetworkReachabilityStatusLabel = [[UILabel alloc] init];
            [self.webView addSubview:currentNetworkReachabilityStatusLabel];
            currentNetworkReachabilityStatusLabel.font = [UIFont systemFontOfSize:15.0f];
            [currentNetworkReachabilityStatusLabel setTextColor:[UIColor whiteColor]];
            [currentNetworkReachabilityStatusLabel setTextAlignment:NSTextAlignmentCenter];
            [currentNetworkReachabilityStatusLabel setBackgroundColor:[UIColor colorWithHexString:NONETWORKING_COLOR alpha:0.8]];
            currentNetworkReachabilityStatusLabel.text = @"网络异常，请检查网络设置";
            [currentNetworkReachabilityStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.mas_top);
                make.left.equalTo(@(0));
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
            }];
            self.currentNetworkReachabilityStatusLabel = currentNetworkReachabilityStatusLabel;
        }
        
        
        NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
        
        if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
            
            //创建指示器
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.webView addSubview:activityIndicatorView];
            [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.webView);
            }];
            CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
            activityIndicatorView.transform = transform;
            self.activityIndicatorView = activityIndicatorView;

        }else{
            
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
    }
    return self;
}

//点击重新加载按钮刷新
- (void)loadData{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        //移除网络提示界面
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        //重新加载数据
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:self.urlStr]];
        [self.webView loadRequest:request];
        //开始刷新
        [self.refreshHeader beginRefreshing];
    }
}

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
        [self.refreshHeader endRefreshing];
        
        [self.currentNetworkReachabilityStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(0));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        }];
        
        [UIView animateWithDuration:1.5 animations:^{
            
            [weakSelf layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self performSelector:@selector(removeNetworkLabel) withObject:nil afterDelay:1.5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        }];
    }
}


- (void)removeNetworkLabel{
    
    WEAKSELF(weakSelf);
    
    [self.currentNetworkReachabilityStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_top);
        make.left.equalTo(@(0));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    
    [UIView animateWithDuration:1.5 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:nil];
    
}

- (void)refreshHeaderHidden{
    
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
}

#pragma mark WKNavigation代理
//广告链接跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


//在发送请求之前决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    //点击的链接的URL，主页面为nil(二手界面手机数码不支持WKNavigationTypeLinkActivated，用WKNavigationTypeOther和这个条件判断是否跳转)
    NSURL *targetUrl = navigationAction.targetFrame.request.URL;
    
    //当链接被点击时
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated || (navigationAction.navigationType == WKNavigationTypeOther && targetUrl)){
        
        //当前点击的链接的URL
        NSString *urlStr = navigationAction.request.URL.absoluteString;
        
        
        if([self.delegate respondsToSelector:@selector(goToNextViewControllerWithURLStr:reviseJS:adJS:)]){
            [self.delegate goToNextViewControllerWithURLStr:urlStr reviseJS:self.reviseJS adJS:self.adJS];
        }
        
        policy = WKNavigationActionPolicyCancel;
        
    }
    
    decisionHandler(policy);
}

//导航开始请求时
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self.activityIndicatorView startAnimating];
    
    [self performSelector:@selector(activityDismiss) withObject:nil afterDelay:4 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    
}

- (void)activityDismiss{
    if([self.activityIndicatorView isAnimating]){
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
    }
}



//wkwebview进程终止时处理,解决wkwebview白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    _processDidTerminated = YES;
    [webView reload];
}

//ios8监听处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"URL"])
    {
        
        NSURL *newUrl = [change objectForKey:NSKeyValueChangeNewKey];
        NSURL *oldUrl = [change objectForKey:NSKeyValueChangeOldKey];
        if (newUrl == nil  && oldUrl != nil) {
            _processDidTerminated = YES;
            [self.webView reload];
        };
    }
}

//已经开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    if(self.reviseJS == nil || self.reviseJS == 0 || self.reviseJS.length == 0){
        return;
    }
    //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
    [self.webView evaluateJavaScript:self.reviseJS completionHandler:^(id Result, NSError * error) {
    }];
}


//导航完成时
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    //停止下拉刷新
    [self.refreshHeader endRefreshing];
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    //加载广告的JS
    if(self.adJS == nil || self.adJS == 0 || self.adJS.length == 0){
        return;
    }
    //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
    [self.webView evaluateJavaScript:self.adJS completionHandler:^(id Result, NSError * error) {
    }];
}


//当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    //停止下拉刷新
    [self.refreshHeader endRefreshing];
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"URL"];
}

@end
