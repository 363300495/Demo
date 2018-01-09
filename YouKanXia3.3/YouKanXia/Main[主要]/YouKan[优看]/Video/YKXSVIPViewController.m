//
//  YKXSVIPViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXSVIPViewController.h"
#import "AppDelegate.h"
#import "YKXCustomSVIPFeedBackView.h"

@interface YKXSVIPViewController () <WKUIDelegate,WKNavigationDelegate,SRAlertViewDelegate,YKXCustomSVIPFeedBackViewDelegate>
{
    NSInteger line;
}

@property (nonatomic,strong) WKWebView *webView;

//UIWebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//中间转到指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;


@property (nonatomic,strong) YKXCustomSVIPFeedBackView *ykxExitView;

//标记当前点击的选集的链接
@property (nonatomic,copy) NSString *xuanjiURL;
//标记当前点击的选集的标题
@property (nonatomic,copy) NSString *xuanjiTitle;


/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView        *playerView;

@property (nonatomic,strong) ZFPlayerModel *playerModel;

@property (nonatomic,strong) UIView *playerFatherView;

@end

@implementation YKXSVIPViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    
    //键盘将要弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackAlertViewUp) name:UIKeyboardDidShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackAlertViewDown) name:UIKeyboardDidHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    line = 1;

    //设置手机UA
    if(self.userAgent != nil && self.userAgent.length >0){
        
        [YKXCommonUtil setDeviceUserAgent:self.userAgent];
    }

    
    [self createNavc];
    [self createView];
    
    
    if([self.svipAdOpen isEqualToString:@"1"]){
        
        //设置原生广告
        SRAlertView *alertView = [SRAlertView sr_alertViewVideoPlaysuperVC:self animationStyle:SRAlertViewAnimationTopToCenterSpring];
        [alertView showVideoPlayNative];
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
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavcButton];

    
    
    UIButton *leftCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftCloseButton.frame = CGRectMake(0, 0, 36, 44);
    [leftCloseButton setTitle:@"帮助" forState:UIControlStateNormal];
    [leftCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftCloseButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateHighlighted];
    leftCloseButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [leftCloseButton addTarget:self action:@selector(onClickHelp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCloseButton];
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem,helpBarButtonItem];
    
    
    //右侧下载按钮
    UIButton *downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadButton.frame = CGRectMake(0, 0, 22, 22);
    [downLoadButton setBackgroundImage:[UIImage imageNamed:@"downloadVideo"] forState:UIControlStateNormal];
    [downLoadButton addTarget:self action:@selector(downLoadVideoAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downLoadBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:downLoadButton];
    
    //右侧的切换VIP按钮
    UIButton *rightShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightShareButton.frame = CGRectMake(0, 0, 76, 22);
    rightShareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightShareButton setTitle:@"刷新播放" forState:UIControlStateNormal];
    [rightShareButton addTarget:self action:@selector(onClickChangeLine) forControlEvents:UIControlEventTouchUpInside];
    rightShareButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightShareButton];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,downLoadBarButtonItem];
    
    
    if(self.downloadURL.length == 0){
        downLoadButton.hidden = YES;
    }

    
    //设置导航栏的标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140*kWJWidthCoefficient, 44)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140*kWJWidthCoefficient, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.text = self.name;
    
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
}

- (void)createView{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if([self.playType isEqualToString:@"1"]){
        //创建网页播放
        [self createWebview];
        
    }else{
        //创建原生播放
        [self createPlayView];
        
    }

    //设置选集按钮
    UIButton *AnthologyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AnthologyButton setTitle:@"选集" forState:UIControlStateNormal];
    [AnthologyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AnthologyButton addTarget:self action:@selector(selectAnthologyAction) forControlEvents:UIControlEventTouchUpInside];
    AnthologyButton.layer.masksToBounds = YES;
    AnthologyButton.layer.cornerRadius = 23;
    AnthologyButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [self.view addSubview:AnthologyButton];
    [AnthologyButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];

    
    //设置选集按钮
    UIButton *FeedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [FeedBackButton setTitle:@"报错" forState:UIControlStateNormal];
    [FeedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [FeedBackButton addTarget:self action:@selector(feedBackAction) forControlEvents:UIControlEventTouchUpInside];
    FeedBackButton.layer.masksToBounds = YES;
    FeedBackButton.layer.cornerRadius = 23;
    FeedBackButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [self.view addSubview:FeedBackButton];
    [FeedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(AnthologyButton.mas_bottom).offset(20);
        make.right.equalTo(@(-20));
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    

    if(self.xuanjiArray.count == 0){
        AnthologyButton.hidden = YES;
    }
}


//创建网页播放器
- (void)createWebview {
    
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
    [webView setAllowsBackForwardNavigationGestures:YES];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    if (@available(iOS 11, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    
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
        make.center.equalTo(self.view);
    }];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
    activityIndicatorView.transform = transform;
    self.activityIndicatorView = activityIndicatorView;
    
    //增加进度条属性的监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}


//创建原生播放器
- (void)createPlayView {

    WEAKSELF(weakSelf);
    
    UIImageView *picImageView = [[UIImageView alloc] init];
    picImageView.userInteractionEnabled = YES;
    //设置图片大小比例填充
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.image = ZFPlayerImage(@"ZFPlayer_loading_bgView");
    [self.view addSubview:picImageView];
    
    [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_WIDTH*9/16);
        make.centerY.equalTo(weakSelf.view);
    }];
    
    self.playerFatherView = picImageView;
    
    
    // 代码添加playerBtn到imageView上
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [picImageView addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(picImageView);
        make.width.height.mas_equalTo(50);
    }];
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
- (void)onClickHelp {
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    NSString *escapedPath = [self.currentTitle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",PUBLIC,[NSString stringWithFormat:SVIPHELP_UEL,self.type,versionCode,escapedPath,self.currentUrl]];

    YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
    activityVC.urlStr = urlStr;
    [self.navigationController pushViewController:activityVC animated:YES];
}


#pragma mark 选集弹框
- (void)selectAnthologyAction {
    
    SRAlertView *alertView = [SRAlertView sr_alertViewSelectAnthologyWithXuanjiArray:self.xuanjiArray superVC:self animationStyle:SRAlertViewAnimationTopToCenterSpring];
    alertView.delegate = self;
    [alertView showNative];
}


//点击所选集数进行SVIP播放
- (void)alertViewXuanJiAction:(NSString *)urlStr title:(NSString *)title{

    line = 1;
    
    //保存当前的选集的URL
    self.xuanjiURL = urlStr;
    self.xuanjiTitle = title;
    
    [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];

    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",title,urlStr,[NSString stringWithFormat:@"%ld",line],uid,token,self.type,@"2",timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataSVIPChannelTitle:title URL:urlStr versionCode:versionCode line:[NSString stringWithFormat:@"%ld",line] uid:uid token:token vweb:self.type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];
        
        NSString *errroCode = responseObject[@"error_code"];
        
        if([errroCode isEqualToString:@"0"]){
            
            NSDictionary *dataDic = responseObject[@"data"];
            if([dataDic isKindOfClass:[NSNull class]]){
                return ;
            }
            NSString *reviseJS = dataDic[@"js_1"];
            NSString *adJS = dataDic[@"js_2"];
            
            NSString *playType = dataDic[@"play_type"];
            
            //网页播放链接
            NSString *sVIPurl = dataDic[@"url"];
            
            //原生播放链接
            NSString *playUrl = dataDic[@"play_url"];

            
            //刷新播放时给JS重新赋值
            self.reviseJS = reviseJS;
            self.adJS = adJS;
            
            //给playType赋值
            self.playType = playType;
            
            if([playType isEqualToString:@"1"]){
                
                if(self.playerView){
                    
                    [self pausePlayer];
                    
                    [self.playerView resetPlayer];
                }
                
                if(self.webView){
                    
                    //切换线路重新加载连接
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sVIPurl]];
                    [self.webView loadRequest:request];
                    
                }else{
                    
                    self.urlStr = sVIPurl;
                    
                    [self createWebview];
                }
                
            }else{//跳到原生的播放器
                
                self.playURL = playUrl;
                
                if(self.playerView){
                    
                    [self pausePlayer];
                    
                    [self.playerView resetPlayer];
                    
                    [self createPlayView];
                    
                }else{
                    
                    [self createPlayView];
                }
            }
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errroCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}




#pragma mark 意见反馈
- (void)feedBackAction {
    
    YKXCustomSVIPFeedBackView *ykxExitView = [[YKXCustomSVIPFeedBackView alloc] initWithPromptNote:@"是否有以下问题" loginContent:@"此影片无法播放" whiteContent:@"播放太卡" sleepContent:@"广告太多" otherContent:@"其它："];
    ykxExitView.delegete = self;
    [ykxExitView show];
    self.ykxExitView = ykxExitView;
    
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
    
    [HttpService loadDataFeedbackPostUid:uid token:token versionCode:versionCode vweb:self.type label:description content:content currentUrl:self.currentUrl devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
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
                self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, 50, 275, 320);
            }];
        }else{
            
            [UIView animateWithDuration:0.4 animations:^{
                self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, 100, 275, 320);
            }];
        }
    }
}


- (void)feedBackAlertViewDown{
    
    if(self.ykxExitView){
        [UIView animateWithDuration:0.4 animations:^{
            self.ykxExitView.alertView.frame = CGRectMake((SCREEN_WIDTH-275)/2.0, (SCREEN_HEIGHT-280)/2, 275, 320);
        }];
    }
}



#pragma mark 下载
- (void)downLoadVideoAction {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *downLoadUrl = [NSString stringWithFormat:@"%@",self.downloadURL];
    
    if(downLoadUrl.length > 0){
        
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
        
        MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:downLoadUrl];
        
        switch (taskState) {
            case MPTaskCompleted:
                
                [YKXCommonUtil showToastWithTitle:@"下载完成，请到[下载管理]中查看" view:self.view.window];
                
                break;
            case MPTaskExistTask:
                
                
                [YKXCommonUtil showToastWithTitle:@"正在下载，请到[下载管理]中查看进度" view:self.view.window];
                
                break;
            case MPTaskNoExistTask:
            {
                //这里给taskEntity赋值
                MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                downLoadEntity.downLoadUrlString = downLoadUrl;
                downLoadEntity.extra = @{@"name":self.currentTitle};
                [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                
                [YKXCommonUtil showToastWithTitle:@"添加成功，正在下载" view:self.view.window];
                
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark 刷新播放
- (void)onClickChangeLine{
    
    //每次点击线路增大
    line++;
    
    NSString *title;
    NSString *url;
    
    //如果点了选集，当前切换线路就问选集的时候切换的线路
    if(self.xuanjiURL.length > 0) {
        
        title = self.xuanjiTitle;
        url = self.xuanjiURL;
    }else{
        title = self.currentTitle;
        url = self.currentUrl;
    }

    
    [YKXCommonUtil showHudWithTitle:@"请稍等..." view:self.view.window];

    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",title,url,[NSString stringWithFormat:@"%ld",line],uid,token,self.type,@"2",timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataSVIPChannelTitle:title URL:url versionCode:versionCode line:[NSString stringWithFormat:@"%ld",line] uid:uid token:token vweb:self.type devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];

        NSString *errroCode = responseObject[@"error_code"];
        
        if([errroCode isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"刷新播放成功，如果仍无法播放，请尝试再次切换" view:self.view.window time:2];
            
            NSDictionary *dataDic = responseObject[@"data"];
            if([dataDic isKindOfClass:[NSNull class]]){
                return ;
            }
            
            NSString *reviseJS = dataDic[@"js_1"];
            NSString *adJS = dataDic[@"js_2"];
            
            NSString *sVIPurl = dataDic[@"url"];
            
            NSString *playType = dataDic[@"play_type"];
            NSString *playUrl = dataDic[@"play_url"];
            
            //刷新播放时给JS重新赋值
            self.reviseJS = reviseJS;
            self.adJS = adJS;
            
            //给playType赋值
            self.playType = playType;
            
   
            if([playType isEqualToString:@"1"]){
                
                if(self.playerView){
                 
                    [self pausePlayer];
                    
                    [self.playerView resetPlayer];
                }
                
                if(self.webView){//如果webview已经创建直接刷新，没有创建就创建webview
                    
                    //切换线路重新加载连接
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:sVIPurl]];
                    [self.webView loadRequest:request];
                    
                }else{
                    
                    //给当前的播放链接重新赋值
                    self.urlStr = sVIPurl;
                    
                    [self createWebview];
                }
                
            }else{//跳到原生的播放器

                self.playURL = playUrl;
                
                if(self.playerView){
                    
                    [self pausePlayer];
                    
                    [self.playerView resetPlayer];
                    
                    [self createPlayView];
                    
                }else{
                    
                    [self createPlayView];
                }
            }
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errroCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


- (BOOL)shouldAutorotate {
    
    if([self.playType isEqualToString:@"1"]){//网页播放要设置为可旋转
        return YES;
    }else{
        return NO;//原生播放必须设为NO
    }
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        // 可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    }
    return _playerView;
}


- (void)play:(UIButton *)sender {
    
    _playerModel = [[ZFPlayerModel alloc] init];
    
    NSString *title;
    if(self.xuanjiTitle.length > 0){
        title = self.xuanjiTitle;
    }else{
        title = self.currentTitle;
    }
    
    _playerModel.title            = title;
    
    _playerModel.videoURL         = [NSURL URLWithString:self.playURL];
    
    _playerModel.fatherView = self.playerFatherView;
    
    _playerModel.displayType = @"2";

    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:_playerModel];
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
}


- (void)pausePlayer {
    
    //销毁页面和播放器
    [self.playerFatherView removeFromSuperview];
    self.playerFatherView = nil;
    
    [self.playerView removeFromSuperview]; 
    self.playerView = nil;
    
}


- (void)refreshData{
    [self.webView reload];
}


- (void)onClickBack{
    
    if(self.playerView){
        
        [self pausePlayer];
        
        [self.playerView resetPlayer];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
            
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_topLayoutGuide);
                make.left.equalTo(weakSelf.view);
                make.right.equalTo(weakSelf.view);
                make.height.equalTo(weakSelf.view.mas_height).multipliedBy(1);
            }];
            break;
        }
        default:
            break;
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
    
    if(self.reviseJS.length > 0){
        //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
        [self.webView evaluateJavaScript:self.reviseJS completionHandler:^(id Result, NSError * error) {
        }];
    }
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
    if(self.adJS.length > 0){
       
        //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
        [self.webView evaluateJavaScript:self.adJS completionHandler:^(id Result, NSError * error) {
        }];
    }
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

@end
