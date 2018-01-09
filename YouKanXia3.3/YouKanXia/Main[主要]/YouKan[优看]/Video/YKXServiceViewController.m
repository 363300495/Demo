//
//  YKXServiceViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXServiceViewController.h"
#import <UMMobClick/MobClick.h>
@interface YKXServiceViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

//UIWebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//中间转到指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong) UILabel *currentNetworkReachabilityStatusLabel;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;

//导航栏左侧的关闭按钮
@property (nonatomic,strong) UIButton *closeButton;

//没网时显示的提示界面
@property (nonatomic,strong) UIView *rootView;

//是否在拨打电话或发送短信
@property (nonatomic,assign) BOOL isPhoneCallOrSendMessage;

@end

@implementation YKXServiceViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:@"recommendService"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [MobClick endLogPageView:@"recommendService"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self createNavc];
    
    if(self.userAgent != nil && self.userAgent.length >0){
        
        [YKXCommonUtil setDeviceUserAgent:self.userAgent];
    }
    
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
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem,closeBarBurronItem];
    
    
    
    //右侧的分享按钮
    UIButton *rightShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightShareButton.frame = CGRectMake(0, 0, 22, 22);
    [rightShareButton setBackgroundImage:[UIImage imageNamed:@"ykShare"] forState:UIControlStateNormal];
    [rightShareButton addTarget:self action:@selector(onClickShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightShareButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@|%@",self.serviceName,self.serviceTitle];

}

// 根据网络状态进行加载处理(有网)
- (void)viewDidLoadWithNetworkingStatus{
    
    WEAKSELF(weakSelf);
    //有网时创建WkWebView
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
        
        
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
        webView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        //这行代码可以是侧滑返回webView的上一级
        [webView setAllowsBackForwardNavigationGestures:YES];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [self.view addSubview:webView];
        self.webView = webView;
        
        //加载网页
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.serviceUrl]];
        [self.webView loadRequest:request];
        
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
        
        
        self.webView = webView;
        
        //增加进度条属性的监听
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
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
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.serviceUrl]];
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


#pragma mark 点击事件
- (void)onClickBack{
    
    if ([self.webView canGoBack]){
        self.closeButton.hidden = NO;
        [self.webView goBack];
    }else{//在网页外部跳转，backForwardList没值
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)onClickClose{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)onClickShare{
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    if(loginDic.count == 0){
        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
        return;
    }else{
        
        NSString *uid = loginDic[@"uid"];
        NSString *token = loginDic[@"token"];
        
        
        WEAKSELF(weakSelf);
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
        
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            NSString *type;
            if(platformType == UMSocialPlatformType_WechatSession){
                type = @"1";
                
            }else if(platformType == UMSocialPlatformType_WechatTimeLine){
                type = @"2";
                
            }else if (platformType == UMSocialPlatformType_QQ){
                type = @"3";
                
            }else if(platformType == UMSocialPlatformType_Qzone){
                type = @"4";
                
            }
            
            NSString *shareType = @"1";
            NSString *shareId = @"0";
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",type,uid,token,@"2",timeStamp,YOYO,randCode];
            //获取签名
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataSharePostType:type uid:uid token:token shareType:shareType shareId:shareId versionCode:versionCode devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                
                NSString *errorCode = responseObject[@"error_code"];
                
                if([errorCode isEqualToString:@"0"]){
                    
                    NSDictionary *dict = responseObject[@"data"];
                    if([dict isKindOfClass:[NSNull class]]){
                        return ;
                    }
                    
                    NSString *title = dict[@"title"];
                    NSString *content = dict[@"content"];
                    NSString *urlStr = dict[@"url"];
                    NSString *iconURLStr = dict[@"icon_url"];
                    
                    NSURL *iconURL = [NSURL URLWithString:iconURLStr];
                    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
                    
                    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
                    

                    UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageWithData:iconData]];
                    webPageObject.webpageUrl = urlStr;
                    
                    messageObject.shareObject = webPageObject;
                    
                    
                    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:weakSelf completion:^(id result, NSError *error) {
                        
                        
                    }];
                }
                
                
            } failure:^(NSError *error) {
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
            
        }];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *urlString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([scheme isEqualToString:@"tel"]) {//打电话
        
        _isPhoneCallOrSendMessage = YES;
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        // 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        });
    }else if([scheme isEqualToString:@"sms"]){//发短信
        
        _isPhoneCallOrSendMessage = YES;
        
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *phoneNumber = [resourceSpecifier substringToIndex:11];
        
        NSString *message = [NSString stringWithFormat:@"sms://%@", phoneNumber];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message] options:@{} completionHandler:nil];
        });
    }else if([scheme isEqualToString:@"weixin"]){//打开微信支付
        if([app canOpenURL:URL]){
            
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }
    }
    
    // 打开appstore
    if([urlString containsString:@"itunes.apple.com"]) {
        
        if ([app canOpenURL:URL]) {
            
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }
    }else if([urlString containsString:@"alipay://"]) {//打开支付宝支付
        
        NSInteger subIndex = 23;
        NSString *dataStr = [urlString substringFromIndex:subIndex];
        //编码
        NSString *encodeString = [YKXCommonUtil encodeString:dataStr];
        NSMutableString *mString = [[NSMutableString alloc] init];
        [mString appendString:[urlString substringToIndex:subIndex]];
        [mString appendString:encodeString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString] options:@{} completionHandler:nil];
    }
    
    decisionHandler(policy);
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    [self.activityIndicatorView startAnimating];
    
    [self performSelector:@selector(activityDismiss) withObject:nil afterDelay:4 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    
}

- (void)activityDismiss{
    if([self.activityIndicatorView isAnimating]){
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
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



//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //停止下拉刷新
    [self.refreshHeader endRefreshing];
    
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
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
}

@end
