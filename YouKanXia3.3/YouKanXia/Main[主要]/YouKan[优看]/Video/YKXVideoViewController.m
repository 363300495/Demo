//
//  YKXVideoViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXVideoViewController.h"
#import "YKXSVIPViewController.h"
#import <UMMobClick/MobClick.h>
#import "YKXCustomExitView.h"
#import "AppDelegate.h"

@interface YKXVideoViewController () <WKUIDelegate,WKNavigationDelegate,YKXCustomExitViewDelegate>

@property (nonatomic,strong) WKWebView *webView;

//UIWebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//中间转动指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;

//判断是不是第一次进入加载页面
@property (nonatomic,assign) BOOL isFirstLoading;

////心跳定时器
//@property (nonatomic,strong) NSTimer *doPingTimer;

//左侧的关闭按钮
@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,assign) BOOL processDidTerminated;

@property (nonatomic,strong) YKXCustomExitView *ykxExitView;

@property (nonatomic,assign) BOOL isSelected;

@end

@implementation YKXVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    //强制转换竖屏
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    
    [MobClick beginLogPageView:self.name];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.allowRotation = YES;
    //进入播放页面暂停好友消息列表定时器
    [appDelegate.friendListTimer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [MobClick endLogPageView:self.name];
    
    //开启好友信息定时器
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.allowRotation = NO;
    //退出播放页面开启好友消息列表定时器
    [appDelegate.friendListTimer setFireDate:[NSDate distantPast]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirstLoading = YES;
    
    // 禁止全屏右滑返回
    self.fd_interactivePopDisabled = YES;
    
    //键盘将要弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackAlertViewUp) name:UIKeyboardDidShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackAlertViewDown) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //设置手机ua
    if(self.userAgent != nil && self.userAgent.length >0){
        
        [YKXCommonUtil setDeviceUserAgent:self.userAgent];
    }
    
    //移除wkwebview的所有cookie
    [YKXCommonUtil removeAllCookies];
    
    [self createNavc];
    [self createView];
    
    //如果是小说，则不发送心跳包(根据返回的类型判断，如果为0则不发送心跳包)
//    if([self.pingType isEqualToString:@"0"]){
//        return;
//    }
    
//    NSString *pingtime = [YKXDefaultsUtil getPingtime];
//    //添加定时器心跳包
//    self.doPingTimer = [NSTimer timerWithTimeInterval:[pingtime integerValue] target:self selector:@selector(doPing) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.doPingTimer forMode:NSRunLoopCommonModes];
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
    
    
    
    //收藏按钮
    UIButton *collectionVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionVideoButton.frame = CGRectMake(0, 0, 22, 22);
    [collectionVideoButton setBackgroundImage:[UIImage imageNamed:@"colletionVideo"] forState:UIControlStateNormal];
    [collectionVideoButton addTarget:self action:@selector(collectionVideoAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectionVideoButton];
    
    
    //右侧的分享按钮
    UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightHelpButton.frame = CGRectMake(0, 0, 40, 30);
    [rightHelpButton setTitle:@"播放" forState:UIControlStateNormal];
    rightHelpButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightHelpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightHelpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightHelpButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    rightHelpButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [rightHelpButton addTarget:self action:@selector(videoChannelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,collectionBarButtonItem];

    

    UIView *titleView = [[UIView alloc] init];
    self.navigationItem.titleView = titleView;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = self.name;
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];

    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"viptitle"];
    [titleView addSubview:titleImageView];

    if(self.name.length == 2){
        titleView.frame = CGRectMake(0, 0, 94, 44);
        titleLabel.frame = CGRectMake(0, 0, 44, 44);
        titleImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+4, 14, 46, 16);
    }else if (self.name.length == 3){
        titleView.frame = CGRectMake(0, 0, 110, 44);
        titleLabel.frame = CGRectMake(0, 0, 60, 44);
        titleImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+4, 14, 46, 16);
    }else if (self.name.length >= 4){
        titleView.frame = CGRectMake(0, 0, 122, 44);
        titleLabel.frame = CGRectMake(0, 0, 72, 44);
        titleImageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+4, 14, 46, 16);
    }
    
    //小说隐藏右侧导航按钮
    if([self.pingType isEqualToString:@"0"]){
        collectionVideoButton.hidden = YES;
        rightHelpButton.hidden = YES;
    }
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //js注入cookie
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[self getcookieJsString] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    
    
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.allowsInlineMediaPlayback = YES;
    config.userContentController = userContentController;
    

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
    webView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    //这行代码可以是侧滑返回webView的上一级
    [webView setAllowsBackForwardNavigationGestures:YES];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuide);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view).multipliedBy(1);
    }];
    
    //加载网页
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.videoUrl]];
    [request setValue:[self getcookieString] forHTTPHeaderField:@"Cookie"];
    [webView loadRequest:request];
    self.webView = webView;
    
    if (@available(iOS 11, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.refreshHeader setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    //隐藏更新时间
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    webView.scrollView.mj_header = self.refreshHeader;
    
    
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
    
    
    //增加进度条属性的监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //添加标题的title
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //获取当前页面的URL (可以监听事件判断白屏)
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark 拼接cookie数据
- (NSString *)getcookieString{
    NSMutableString *cookieString = [NSMutableString string];
    for(NSDictionary *cookieDic in self.cookieArray){
        
        NSString *name = cookieDic[@"name"];
        NSString *value = cookieDic[@"content"];
        NSString *domain = cookieDic[@"domain"];
        NSString *path = cookieDic[@"path"];
        
        NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@;",name,value,domain,path];

        [cookieString appendString:string];
    }
    
    return cookieString;
}

- (NSString *)getcookieJsString{
    
    NSMutableString *cookieString = [NSMutableString string];
    for(NSDictionary *cookieDic in self.cookieArray){
        
        NSString *name = cookieDic[@"name"];
        NSString *value = cookieDic[@"content"];
        NSString *domain = cookieDic[@"domain"];
        NSString *path = cookieDic[@"path"];
        
        NSString *string = [NSString stringWithFormat:@"document.cookie='%@=%@;domain=%@;path=%@;';",name,value,domain,path];
        
        [cookieString appendString:string];
    }
    
    return cookieString;
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
    }else if ([keyPath isEqualToString:@"URL"]){
        //监听白屏事件处理
        if(object == self.webView){
            
            NSURL *newUrl = [change objectForKey:NSKeyValueChangeNewKey];
            NSURL *oldUrl = [change objectForKey:NSKeyValueChangeOldKey];
            if (newUrl == nil  && oldUrl != nil) {
                
                _processDidTerminated = YES;
                [self.webView reload];
            };
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
}

#pragma mark 点击事件
//强制旋转屏幕
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


- (void)handleDeviceOrientationDidChange:(NSNotification *)noti{
    
    WEAKSELF(weakSelf);
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
        {
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_topLayoutGuide);
                make.left.equalTo(weakSelf.view);
                make.right.equalTo(weakSelf.view);
                make.height.equalTo(weakSelf.view.mas_height).multipliedBy(1);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_topLayoutGuide);
                make.left.equalTo(weakSelf.view);
                make.right.equalTo(weakSelf.view);
                make.height.equalTo(weakSelf.view.mas_height).multipliedBy(1);
            }];
        }
            break;
        default:
            break;
    }
}


- (void)refreshData{
    
    [self.webView reload];
    
    //网速不好时，刷新状态会一直存在，要去掉
    [self performSelector:@selector(refreshHeaderHidden) withObject:nil afterDelay:5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
}

- (void)refreshHeaderHidden{
    
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
}


//返回按钮
- (void)onClickBack{
    
    if([self.webView canGoBack]){//网页内部跳转
        self.closeButton.hidden = NO;
        [self.webView goBack];
    }else{//网页外部跳转
        
        [self onClickClose];
    }
}

//关闭按钮
- (void)onClickClose{

    NSString *content = @"是否要反馈？";
    
    SRAlertView *alertView = [SRAlertView sr_alertViewWithMessage:content superVC:self leftActionTitle:@"是[反馈]" rightActionTitle:@"否[退出]" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {
        
        if(actionType == 0){
            
            YKXCustomExitView *ykxExitView = [[YKXCustomExitView alloc] initWithPromptNote:@"是否有以下问题" loginContent:@"有广告或VIP没有登录" whiteContent:@"无法播放视频" otherContent:@"其它："];
            ykxExitView.delegete = self;
            [ykxExitView show];
            self.ykxExitView = ykxExitView;
        }else{
            
            [self releaseRescources];
        }
    }];
    
    [alertView showNative];

}


//发送反馈内容
- (void)sendMessageDescription:(NSString *)description content:(NSString *)content{
    
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if(description.length == 0 && content.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请选择选项或输入反馈内容" view:self.view.window];
        return;
    }
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,content,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataFeedbackPostUid:uid token:token versionCode:versionCode vweb:self.type label:description content:content currentUrl:@"" devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"意见发送成功" view:self.view.window];
            
            [self.ykxExitView.alertView removeFromSuperview];
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.ykxExitView.coverView.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [self.ykxExitView removeFromSuperview];
                             }];
            
             [self releaseRescources];
            
        }else{
            [YKXCommonUtil showToastWithTitle:@"意见发送失败" view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


- (void)feedBackAlertViewUp{
    
    if(self.ykxExitView){
        
        if(IPHONE5){
            
            [UIView animateWithDuration:0.4 animations:^{
                self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, 50, 275, 280);
            }];
        }else{
            
            [UIView animateWithDuration:0.4 animations:^{
                self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, 100, 275, 280);
            }];
        }
    }
}

- (void)feedBackAlertViewDown{
    
    if(self.ykxExitView){
        [UIView animateWithDuration:0.4 animations:^{
            self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, (SCREEN_HEIGHT-280)/2, 275, 280);
        }];
    }
}

//释放资源
- (void)releaseRescources{
    
//    //销毁定时器
//    [self.doPingTimer invalidate];
//    self.doPingTimer = nil;
//    
//    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
//    NSString *uid = loginDic[@"uid"];
//    NSString *token = loginDic[@"token"];
//    
//    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
//    //时间戳
//    NSString *timeStamp = [YKXCommonUtil longLongTime];
//    //获取6位随机数
//    NSString *randCode = [YKXCommonUtil getRandomNumber];
//    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,self.type,@"2",timeStamp,YOYO,randCode];
//    //获取签名
//    NSString *sign = [MyMD5 md5:tempStr];
//    
//    //释放cookie资源
//    [HttpService loadDataReleaseCookiePostUid:uid token:token versionCode:versionCode vweb:self.type devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
//        
//        
//    } failure:^(NSError *error) {
//    }];
    
    [YKXCommonUtil hiddenHud];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//发送心跳包
//- (void)doPing{
//    
//    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
//    NSString *uid = loginDic[@"uid"];
//    NSString *token = loginDic[@"token"];
//    
//    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
//    //时间戳
//    NSString *timeStamp = [YKXCommonUtil longLongTime];
//    //获取6位随机数
//    NSString *randCode = [YKXCommonUtil getRandomNumber];
//    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,self.type,@"2",timeStamp,YOYO,randCode];
//    //获取签名
//    NSString *sign = [MyMD5 md5:tempStr];
//    
//    [HttpService loadDataDoPingPostUid:uid token:token versionCode:versionCode vweb:self.type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
//      
//        
//    } failure:^(NSError *error) {
//    }];
//}


#pragma mark 收藏
- (void)collectionVideoAction {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devType = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,self.type,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    
    NSString *currentTitle = self.webView.title;
    //当前点击的播放视频连接
    NSString *currentUrl = self.webView.URL.absoluteString;
    
    [HttpService loadDataAddColectionUid:uid token:token versionCode:versionCode vweb:self.type title:currentTitle url:currentUrl devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {

        NSString *errroCode = responseObject[@"error_code"];
        
        if([errroCode isEqualToString:@"0"]){

            NSString *message = responseObject[@"msg"];
            
            [YKXCommonUtil showToastWithTitle:message view:self.view.window];
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errroCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}

//VIP通道
- (void)videoChannelAction{
    
    [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];
    
    NSString *title = self.webView.title;
    //当前点击的播放视频连接
    NSString *currentUrl = self.webView.URL.absoluteString;
    
    if(title == nil || currentUrl == nil){
        
        title = @"";
        currentUrl = @"";
    }
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",title,currentUrl,@"1",uid,token,self.type,@"2",timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataSVIPChannelTitle:title URL:currentUrl versionCode:versionCode line:@"1" uid:uid token:token vweb:self.type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];
        
        NSString *errorcode = responseObject[@"error_code"];
        
        if([errorcode isEqualToString:@"0"]){
            
            NSDictionary *dataDic = responseObject[@"data"];
            if([dataDic isKindOfClass:[NSNull class]]){
                return ;
            }

            NSString *reviseJS = dataDic[@"js_1"];
            NSString *adJS = dataDic[@"js_2"];
            NSString *resDomain = dataDic[@"res_domain"];
            NSString *relDomain = dataDic[@"rel_domain"];
            NSString *userAgent = dataDic[@"user_agent"];
            NSString *sVIPurl = dataDic[@"url"];
            
            
            NSString *playType = dataDic[@"play_type"];
            NSString *playUrl = dataDic[@"play_url"];
            NSString *down_url = dataDic[@"down_url"];
            NSString *urlStatus = dataDic[@"url_status"];
            
            //设置VIP界面是否加入广告
            NSString *svipAdOpen = dataDic[@"svip_ad_open"];
            
            NSArray *xuanjiArray = responseObject[@"xuanji"];
            
            YKXSVIPViewController *ykxSVIPVC = [[YKXSVIPViewController alloc] init];
            ykxSVIPVC.reviseJS = reviseJS;
            ykxSVIPVC.adJS = adJS;
            ykxSVIPVC.resDomain = resDomain;
            ykxSVIPVC.relDomain = relDomain;
            ykxSVIPVC.userAgent = userAgent;
            
            ykxSVIPVC.name = self.name;
            ykxSVIPVC.type = self.type;
            //网页播放的链接
            ykxSVIPVC.currentUrl = currentUrl;
            ykxSVIPVC.currentTitle = title;
            ykxSVIPVC.downloadURL = down_url;
            ykxSVIPVC.svipAdOpen = svipAdOpen;
            ykxSVIPVC.xuanjiArray = xuanjiArray;
            
            //网页播放链接
            ykxSVIPVC.urlStr = sVIPurl;
            //原生播放的链接
            ykxSVIPVC.playURL = playUrl;
            //网页播放类型 1代表网页播放 2代表原生播放
            ykxSVIPVC.playType = playType;
            
            [self.navigationController pushViewController:ykxSVIPVC animated:YES];
   
            if(![urlStatus isEqualToString:@"0"]){
                
                //观看历史记录
                NSMutableDictionary *watchListDic = [NSMutableDictionary dictionary];
                [watchListDic setObject:title forKey:@"title"];
                [watchListDic setObject:currentUrl forKey:@"url"];
                [watchListDic setObject:self.type forKey:@"type"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
                NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
                
                [watchListDic setObject:dateString forKey:@"time"];

                FMDBManager *manager = [FMDBManager sharedFMDBManager];
                
                [manager insertWatchInfoList:watchListDic];
            }

        }else{
            
           [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


- (void)didSelectRow{
    _isSelected = NO;
}


#pragma mark wkwebview代理
//广告链接跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;

    if(_resDomain == nil || _resDomain.length == 0){
        
        policy = WKNavigationActionPolicyAllow;
    }else{
        
        if(![urlString containsString:_resDomain]){
            
            if(_relDomain != nil && _relDomain.length >0)
            {
                NSArray *relDomainArray = [_relDomain componentsSeparatedByString:@","];
                for(NSString *tempRelDomain in relDomainArray){
                    
                    if([urlString containsString:tempRelDomain]){
                        
                        policy = WKNavigationActionPolicyAllow;
                        
                    }else{
                        
                        policy = WKNavigationActionPolicyCancel;
                    }
                }
            }else{
                policy = WKNavigationActionPolicyCancel;
            }
        }
    }
    
    
    if([urlString containsString:@"uu-svip"] || [urlString containsString:@"UU-SVIP"]){
        
        //获取当前的链接并拦截掉，跳到自己的链接页面
        policy = WKNavigationActionPolicyCancel;
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
        
        [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
        
        NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
        NSString *uid = loginDic[@"uid"];
        NSString *token = loginDic[@"token"];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",self.webView.title,urlString,@"1",uid,token,self.type,@"2",timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataSVIPChannelTitle:self.webView.title URL:urlString versionCode:versionCode line:@"1" uid:uid token:token vweb:self.type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
            
            [YKXCommonUtil hiddenHud];
            
            NSString *errorcode = responseObject[@"error_code"];
            
            if([errorcode isEqualToString:@"0"]){
                
                NSDictionary *dataDic = responseObject[@"data"];
                if([dataDic isKindOfClass:[NSNull class]]){
                    return ;
                }
     
                NSString *reviseJS = dataDic[@"js_1"];
                NSString *adJS = dataDic[@"js_2"];
                NSString *resDomain = dataDic[@"res_domain"];
                NSString *relDomain = dataDic[@"rel_domain"];
                NSString *userAgent = dataDic[@"user_agent"];
                NSString *sVIPurl = dataDic[@"url"];
                
                
                NSString *playType = dataDic[@"play_type"];
                NSString *playUrl = dataDic[@"play_url"];
                NSString *down_url = dataDic[@"down_url"];
                NSString *urlStatus = dataDic[@"url_status"];
                
                NSString *svipAdOpen = dataDic[@"svip_ad_open"];
                NSArray *xuanjiArray = responseObject[@"xuanji"];
                
                if(!_isSelected){
                    
                    _isSelected = YES;
                    
                    [self performSelector:@selector(didSelectRow) withObject:nil afterDelay:2 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
                    
                    
                    YKXSVIPViewController *ykxSVIPVC = [[YKXSVIPViewController alloc] init];
                    ykxSVIPVC.reviseJS = reviseJS;
                    ykxSVIPVC.adJS = adJS;
                    ykxSVIPVC.resDomain = resDomain;
                    ykxSVIPVC.relDomain = relDomain;
                    ykxSVIPVC.userAgent = userAgent;
                    
                    ykxSVIPVC.name = self.name;
                    ykxSVIPVC.type = self.type;
                    //网页播放的链接
                    ykxSVIPVC.currentUrl = urlString;
                    ykxSVIPVC.currentTitle = self.webView.title;
                    ykxSVIPVC.downloadURL = down_url;
                    ykxSVIPVC.svipAdOpen = svipAdOpen;
                    ykxSVIPVC.xuanjiArray = xuanjiArray;
                    
                    //网页播放链接
                    ykxSVIPVC.urlStr = sVIPurl;
                    //原生播放的链接
                    ykxSVIPVC.playURL = playUrl;
                    //网页播放类型 1代表网页播放 2代表原生播放
                    ykxSVIPVC.playType = playType;
                    
                    [self.navigationController pushViewController:ykxSVIPVC animated:YES];
                    
                    if(![urlStatus isEqualToString:@"0"]){
                        
                        //观看历史记录
                        NSMutableDictionary *watchListDic = [NSMutableDictionary dictionary];
                        [watchListDic setObject:self.webView.title forKey:@"title"];
                        [watchListDic setObject:urlString forKey:@"url"];
                        [watchListDic setObject:self.type forKey:@"type"];
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
                        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
                        
                        [watchListDic setObject:dateString forKey:@"time"];
                        
                        FMDBManager *manager = [FMDBManager sharedFMDBManager];
                        
                        [manager insertWatchInfoList:watchListDic];
                    }
                    
                }
                
            }else{
                
                [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
            }
            
        } failure:^(NSError *error) {
            [YKXCommonUtil hiddenHud];
            [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
        }];
        
    }else if([urlString containsString:@"uu-ext"] || [urlString containsString:@"UU-EXT"]){
        
        policy = WKNavigationActionPolicyCancel;
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        
    }else if([urlString containsString:@"uu-new"] || [urlString containsString:@"UU-NEW"]){
        
        policy = WKNavigationActionPolicyCancel;
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-new" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-NEW" withString:@""];
        
        YKXActivityViewController *ykxActivityVC = [[YKXActivityViewController alloc] init];
        ykxActivityVC.urlStr = urlString;
        [self.navigationController pushViewController:ykxActivityVC animated:YES];
    }
    

    //爱奇艺界面再注入一次cookie否则登录不成功
    if([self.type isEqualToString:@"1"]){//爱奇艺
        
        //每次加载页面时手动添加cookie
        NSDictionary *headerFeilds = navigationAction.request.allHTTPHeaderFields;
        NSString *cookie = headerFeilds[@"Cookie"];
        if(cookie == nil){
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:navigationAction.request.URL];
            request.allHTTPHeaderFields = headerFeilds;
            [request setValue:[self getcookieString] forHTTPHeaderField:@"Cookie"];
            [webView loadRequest:request];
            policy = WKNavigationActionPolicyCancel;
        }
    
        
        //爱奇艺的头像按钮禁止跳转
        if([urlString isEqualToString:@"http://m.iqiyi.com/u/"]){
            policy = WKNavigationActionPolicyCancel;
        }
        
        //解决爱奇艺界面搜索界面不能跳转问题
        if([urlString isEqualToString:@"about:blank"]){
            
            policy = WKNavigationActionPolicyCancel;
        }
        
        //爱奇艺跳转到APP的问题
        if([urlString containsString:@"id393765873"]){
            policy = WKNavigationActionPolicyCancel;
        }
        
    }else if ([self.type isEqualToString:@"2"]){//优酷
        
        //优酷的头像按钮禁止跳转
        if([urlString isEqualToString:@"http://www.youku.com/#"]){
            policy = WKNavigationActionPolicyCancel;
        }
        
        //解决优酷跳到系统APP的问题
        if([urlString containsString:@"link-jump.youku.com"]){
            policy = WKNavigationActionPolicyCancel;
        }
        
        //解决优酷不能搜索的问题
        if([urlString containsString:@"soku.com"]){
            policy = WKNavigationActionPolicyAllow;
        }
    
    }else if([self.type isEqualToString:@"3"]){//乐视

        //乐视的头像按钮禁止跳转
        if([urlString isEqualToString:@"http://m.le.com/my/"]){
            policy = WKNavigationActionPolicyCancel;
        }
    }else if ([self.type isEqualToString:@"4"]){//芒果
        //点击芒果TV的头像按钮禁止跳转
        if([urlString isEqualToString:@"http://m.mgtv.com/#/i"]){
            policy = WKNavigationActionPolicyCancel;
        }
    }else if ([self.type isEqualToString:@"5"]){//小说
  
        //点击小说头像按钮禁止跳转
        if([urlString isEqualToString:@"http://m.cread.com/user/default.aspx"]){
            policy = WKNavigationActionPolicyCancel;
        }
    }
    decisionHandler(policy);
}


//加载开始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    if(_isFirstLoading){
        
        [YKXCommonUtil showHudWithTitle:@"VIP登录中..." view:self.view.window];
        [self performSelector:@selector(hiddenHud) withObject:nil afterDelay:5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        
    }else{
        [self.activityIndicatorView startAnimating];
        [self performSelector:@selector(activityDismiss) withObject:nil afterDelay:4 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }
}

- (void)hiddenHud{
    _isFirstLoading = NO;
    [YKXCommonUtil hiddenHud];
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

    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshing];
    }
    
    if(_isFirstLoading){
    
        _isFirstLoading = NO;
        
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"VIP登录成功" view:self.view.window];
        
    }else{
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
    }
    
    
    //加载完成时手动添加cookie
    [webView evaluateJavaScript:[self getcookieJsString] completionHandler:^(id result, NSError *  error) {
    }];


    //加载广告的JS
    if(self.adJS.length > 0){
        
        //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
        [self.webView evaluateJavaScript:self.adJS completionHandler:^(id Result, NSError * error) {
        }];
    }
    
    //将当前点击的链接的m3u8文件下载下来后上传到服务器
    if(self.svipJS.length > 0){
        
        NSString *URL = self.webView.URL.absoluteString;
        
        NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
        
        NSString *uid = loginUserInfo[@"uid"];
        NSString *token = loginUserInfo[@"token"];
        
        NSString *vweb = self.type;
        
        NSString *devType = @"2";
        
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",URL,uid,token,vweb,devType,timeStamp,YOYO,randCode];
        
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataPostCheckSvipURLCurrentURL:URL uid:uid token:token versionCode:versionCode vweb:vweb devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
            
            NSString *errorCode = responseObject[@"error_code"];

            //返回的是200就下载m3u8文件并上传
            if([errorCode isEqualToString:@"200"]){
                
                NSString *openDown = responseObject[@"open_down"];
                
                //opendown是1需要下载m3u8文件并上传
                if([openDown isEqualToString:@"1"]){
                    
                    [self downloadVideoDirectionJS];
                    
                }else{//opendown是0不需要下载直接上传当前的链接文件
                   
                    [self uploadVideoURLJS];
                }
                
            }
        } failure:^(NSError *error) {
        }];
    }
}


- (void)downloadVideoDirectionJS {

    [self.webView evaluateJavaScript:self.svipJS completionHandler:^(NSString *Result, NSError * error) {
        
        //result是当前返回的m3u8文件
        if(![Result isEqual:[NSNull null]] && Result != nil && Result.length > 0){
            
            //如果返回的m3u8文件有值，就停止加载该JS
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadVideoDirectionJS) object:nil];
            
            [self downloadUPloadvideoFilePath:Result];
        }
    }];
    
    //一直循环直到JS获取到数据
    [self performSelector:@selector(downloadVideoDirectionJS) withObject:nil afterDelay:0.05];
}



- (void)downloadUPloadvideoFilePath:(NSString *)result {
    
    //filePath下载的m3u8文件存储路径
    [HttpServiceManager downloadWithURL:result directionName:@"downloadCache" success:^(NSString *filePath) {

        NSString *URL = self.webView.URL.absoluteString;
        
        NSString *vweb = self.type;
        
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        
        NSString *video_id = @"0";
        
        NSString *title = self.webView.title;
        
        NSString *uploadTempStr = [NSString stringWithFormat:@"%@%@%@%@%@",vweb,video_id,timeStamp,YOYO,randCode];
        
        NSString *uploadSign = [MyMD5 md5:uploadTempStr];
        
        NSDictionary *parames = @{@"vweb":vweb,@"video_id":video_id,@"url":URL,@"title":title,@"vip":@"0",@"timestamp":timeStamp,@"randcode":randCode,@"sign":uploadSign};
        
        //上传下载的m3u8文件
        [HttpServiceManager uploadWithURL:self.svipLoadURL parameters:parames filePath:filePath success:^(id responseObject) {

            NSString *errorcode = responseObject[@"error_code"];
            
            if([errorcode isEqualToString:@"0"]){
                
                //上传完成清除刚才下载的缓存文件
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [YKXCacheUtil clearDownloadFile];
                    
                });
            }
        } failure:^(NSError *error) {
        }];
    } failure:^(NSError *error) {
    }];
}


- (void)uploadVideoURLJS {
    
    [self.webView evaluateJavaScript:self.svipJS completionHandler:^(NSString *Result, NSError * error) {
        
        //result是当前返回的m3u8文件
        if(![Result isEqual:[NSNull null]] && Result != nil && Result.length > 0){
            
            //如果返回的m3u8文件有值，就停止加载该JS
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadVideoURLJS) object:nil];
            
            [self uploadVideoURLString:Result];
        }
    }];
    
    //一直循环直到JS获取到数据
    [self performSelector:@selector(uploadVideoURLJS) withObject:nil afterDelay:0.05];
    
}

- (void)uploadVideoURLString:(NSString *)result {

    NSString *URL = self.webView.URL.absoluteString;
    
    NSString *vweb = self.type;
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *video_id = @"0";
    
    NSString *title = self.webView.title;
    
    NSString *uploadTempStr = [NSString stringWithFormat:@"%@%@%@%@%@",vweb,video_id,timeStamp,YOYO,randCode];
    
    NSString *uploadSign = [MyMD5 md5:uploadTempStr];
    
    NSDictionary *parames = @{@"vweb":vweb,@"video_id":video_id,@"url":URL,@"title":title,@"vip":@"0",@"timestamp":timeStamp,@"player_url":result,@"randcode":randCode,@"sign":uploadSign};
    
    [HttpServiceManager POST:self.svipLoadURL parameters:parames success:^(id responseObject) {
        
    } failure:^(NSError *error) {
    }];
}


//wkwebview进程终止时处理,解决wkwebview白屏问题
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    _processDidTerminated = YES;
    [webView reload];
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


- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end
