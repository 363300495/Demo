//
//  YkXUserSignViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YkXUserSignViewController.h"

@interface YkXUserSignViewController () <WKNavigationDelegate,WKUIDelegate>

//左侧的关闭按钮
@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,strong) UIImageView *rootHeadView;

@property (nonatomic,strong) UILabel *integralLabel;

@property (nonatomic,strong) UILabel *dayTitleLabel;

@property (nonatomic,strong) WKWebView *webView;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation YkXUserSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavc];
    [self createView];
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
    
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 22, 22);
    [rightNavcButton setBackgroundImage:[UIImage imageNamed:@"signInfo"] forState:UIControlStateNormal];
    [rightNavcButton addTarget:self action:@selector(signDetailAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationItem.title = @"签到";
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    UIImageView *rootHeadView = [[UIImageView alloc] init];
    rootHeadView.image = [UIImage imageNamed:@"headbgView"];
    rootHeadView.userInteractionEnabled = YES;
    [self.view addSubview:rootHeadView];
    [rootHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80*kWJHeightCoefficient));
    }];
    self.rootHeadView = rootHeadView;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.headimgurl] placeholderImage:[UIImage imageNamed:@"setting_logo"]];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 27*kWJHeightCoefficient;
    [rootHeadView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10*kWJWidthCoefficient));
        make.centerY.equalTo(rootHeadView);
        make.size.mas_equalTo(CGSizeMake(54*kWJHeightCoefficient, 54*kWJHeightCoefficient));
    }];
    

    
    UILabel *integralLabel = [[UILabel alloc] init];
    integralLabel.textColor = [UIColor whiteColor];
    integralLabel.font = [UIFont systemFontOfSize:13*kWJFontCoefficient];
    [rootHeadView addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(iconImageView.mas_right).offset(20*kWJWidthCoefficient);
        make.top.equalTo(iconImageView).offset(4*kWJHeightCoefficient);
    }];
    self.integralLabel = integralLabel;
    
    
    NSString *text = [NSString stringWithFormat:@"我的积分：%@",self.integral];
    NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*kWJFontCoefficient] range:NSMakeRange(5, text.length-5)];
    integralLabel.attributedText = AttributeStr;
    
    
    UILabel *lineBackgroundLabel = [[UILabel alloc] init];
    lineBackgroundLabel.backgroundColor = [UIColor colorWithHexString:@"#B21D32"];
    [rootHeadView addSubview:lineBackgroundLabel];
    [lineBackgroundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(integralLabel).offset(9*kWJWidthCoefficient);
        make.bottom.equalTo(iconImageView.mas_bottom).offset(-10*kWJHeightCoefficient);
        make.size.mas_equalTo(CGSizeMake(168*kWJWidthCoefficient, 6));
    }];
    
    UIImageView *outGiftImageView = [[UIImageView alloc] init];
    outGiftImageView.image = [UIImage imageNamed:@"gift2"];
    [rootHeadView addSubview:outGiftImageView];
    [outGiftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineBackgroundLabel).offset(11*kWJWidthCoefficient);
        make.top.equalTo(integralLabel);
        make.size.mas_equalTo(CGSizeMake(22*kWJWidthCoefficient, 22*kWJHeightCoefficient));
    }];
    
    UIImageView *inGiftImageView = [[UIImageView alloc] init];
    inGiftImageView.image = [UIImage imageNamed:@"gift1"];
    [outGiftImageView addSubview:inGiftImageView];
    [inGiftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(outGiftImageView);
        make.centerY.equalTo(outGiftImageView).offset(-2*kWJHeightCoefficient);
        make.size.mas_equalTo(CGSizeMake(12*kWJWidthCoefficient, 12*kWJHeightCoefficient));
    }];
    
        
    UILabel *lastLabel = nil;
    for(NSInteger i = 0; i < 7 ;i++) {
        
        UILabel *dayLabel = [[UILabel alloc] init];
        dayLabel.layer.cornerRadius = 9*kWJWidthCoefficient;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.text = [NSString stringWithFormat:@"%ld",i+1];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.font = [UIFont systemFontOfSize:13*kWJFontCoefficient];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = [UIColor colorWithHexString:@"#B21D32"];
        [rootHeadView addSubview:dayLabel];
        
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(18*kWJWidthCoefficient, 18*kWJWidthCoefficient));
            make.centerY.equalTo(lineBackgroundLabel);
            if(!lastLabel){
                make.left.equalTo(lineBackgroundLabel.mas_left).offset(-9*kWJWidthCoefficient);
                
            }else{
                make.left.equalTo(lastLabel.mas_right).offset(10*kWJWidthCoefficient);
            }
        }];
        
        lastLabel = dayLabel;
        
        
        UIImageView *signokImageView = [[UIImageView alloc] init];
        signokImageView.image = [UIImage imageNamed:@"sign_ok"];
        signokImageView.tag = 100+i;
        if(i < [self.signCount integerValue]){
            signokImageView.hidden = NO;
        }else{
            signokImageView.hidden = YES;
        }
        
        
        [self.rootHeadView addSubview:signokImageView];
        [signokImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(dayLabel);
            make.size.mas_equalTo(CGSizeMake(24*kWJWidthCoefficient, 24*kWJWidthCoefficient));
        }];
    }
    
    
    UIImageView *signImageView = [[UIImageView alloc] init];
    signImageView.backgroundColor = [UIColor whiteColor];
    signImageView.layer.masksToBounds = YES;
    signImageView.userInteractionEnabled = YES;
    signImageView.layer.cornerRadius = 5;
    [rootHeadView addSubview:signImageView];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineBackgroundLabel.mas_right).offset(30*kWJWidthCoefficient);
        make.centerY.equalTo(iconImageView);
        make.size.mas_equalTo(CGSizeMake(70*kWJWidthCoefficient, 40*kWJHeightCoefficient));
    }];
    
    UITapGestureRecognizer *tapGseture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [signImageView addGestureRecognizer:tapGseture];
    
    UILabel *signTitleLabel = [[UILabel alloc] init];
    signTitleLabel.text = @"已连续签到";
    signTitleLabel.textAlignment = NSTextAlignmentCenter;
    signTitleLabel.textColor = [UIColor redColor];
    signTitleLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [signImageView addSubview:signTitleLabel];
    [signTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(signImageView);
        make.top.equalTo(@(2));
    }];
    
    
    
    UILabel *dayTitleLabel = [[UILabel alloc] init];
    dayTitleLabel.textColor = [UIColor redColor];
    dayTitleLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [signImageView addSubview:dayTitleLabel];
    [dayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(signImageView);
        make.top.equalTo(signTitleLabel.mas_bottom);
    }];
    self.dayTitleLabel = dayTitleLabel;
    
    
    NSString *dayText = [NSString stringWithFormat:@"%@天",self.signCount];
    NSMutableAttributedString *dayAttributeStr = [[NSMutableAttributedString alloc] initWithString:dayText];
    [dayAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*kWJFontCoefficient] range:NSMakeRange(0, dayText.length-1)];
    dayTitleLabel.attributedText = dayAttributeStr;
    
    
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.allowsInlineMediaPlayback = YES;
    
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    self.webView = webView;
    
    
    NSString *signURLString = [YKXDefaultsUtil getSignURLString];
    
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:signURLString]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(rootHeadView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-80*kWJHeightCoefficient-64));
    }];
    
    
    //加载进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 100*kWJHeightCoefficient, [[UIScreen mainScreen] bounds].size.width,2)];
    progressView.tintColor = [UIColor colorWithHexString:PROGRESS_COLOR];
    progressView.trackTintColor = [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    //增加进度条属性的监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

}


#pragma mark 点击事件
- (void)onClickBack {
    
    if([self.webView canGoBack]){//网页内部跳转
        self.closeButton.hidden = NO;
        [self.webView goBack];
    }else{//网页外部跳转
        
        [self onClickClose];
    }
}

- (void)onClickClose {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)signDetailAction {
    
    NSString *urlStr = [YKXDefaultsUtil getSignInformationUrl];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];

    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-uid" withString:[NSString stringWithFormat:@"%@",uid]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-token" withString:[NSString stringWithFormat:@"%@",token]];
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
    activityVC.urlStr = urlStr;
    [self.navigationController pushViewController:activityVC animated:YES];
}


- (void)tapGesture:(UITapGestureRecognizer *)tap{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devtype = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataSignIntegerUid:uid token:token versionCode:versionCode devType:devtype timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorcode = responseObject[@"error_code"];
        NSString *msg = responseObject[@"msg"];
        
        if([errorcode isEqualToString:@"0"]){
            
            //连续签到的天数
            NSString *count = responseObject[@"count"];
            //当前的积分
            NSString *currentIntegral = responseObject[@"integral"];
            
            
            //修改连续签到天数
            NSString *dayText = [NSString stringWithFormat:@"%@天",count];
            NSMutableAttributedString *dayAttributeStr = [[NSMutableAttributedString alloc] initWithString:dayText];
            [dayAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*kWJFontCoefficient] range:NSMakeRange(0, dayText.length-1)];
            self.dayTitleLabel.attributedText = dayAttributeStr;
            
            //修改总积分数
            NSString *text = [NSString stringWithFormat:@"我的积分：%ld",[self.integral integerValue] + [currentIntegral integerValue]];
            NSMutableAttributedString *AttributeStr = [[NSMutableAttributedString alloc] initWithString:text];
            [AttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*kWJFontCoefficient] range:NSMakeRange(5, text.length-5)];
            self.integralLabel.attributedText = AttributeStr;
            
            //修改签到的图片
            for(NSInteger i=0 ; i<7 ; i++){
                
                UIImageView *signokImageView = (id)[self.view viewWithTag:100+i];
                if(i < [count integerValue]){
                    signokImageView.hidden = NO;
                }else{
                    signokImageView.hidden = YES;
                }
            }
            
            
            if(msg.length == 0){
                
                msg = [NSString stringWithFormat:@"签到奖励%@积分，7天大礼等你拿",currentIntegral];
            }
            
            //广告弹窗
            SRAlertView *alertView = [SRAlertView sr_alertViewWithMessage:msg superVC:self animationStyle:SRAlertViewAnimationTopToCenterSpring];
            [alertView showSignNative];
            
        }else{
            
            if(msg.length >0){
                [YKXCommonUtil showToastWithTitle:msg view:self.view.window time:2];
            }else{
               [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window time:2];
            }
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
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


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *urlString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    UIApplication *app = [UIApplication sharedApplication];
    if([scheme isEqualToString:@"weixin"]){//打开微信支付
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


- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
