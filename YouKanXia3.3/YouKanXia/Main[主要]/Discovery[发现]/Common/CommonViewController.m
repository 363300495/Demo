//
//  CommonViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/28.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CommonViewController.h"
#import <UMMobClick/MobClick.h>
#import <AdSupport/AdSupport.h>
@interface CommonViewController () <WKNavigationDelegate,WKUIDelegate>

//是否在拨打电话或发送短信
@property (nonatomic,assign) BOOL isPhoneCallOrSendMessage;

@property (nonatomic,strong) FMDBManager *manager;

@end

@implementation CommonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [MobClick beginLogPageView:@"newsContent"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [MobClick endLogPageView:@"newsContent"];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSArray *userAgentArray = [YKXDefaultsUtil getDiscoveryUserAgent];
    if(userAgentArray.count >0){
        
        [YKXCommonUtil setDeviceUserAgent:userAgentArray[0]];
    }
}

- (void)createNavc{
    
    [super createNavc];

    //右侧的分享按钮
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 22, 22);

    [rightNavcButton addTarget:self action:@selector(rightNavcAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    _manager = [FMDBManager sharedFMDBManager];
    //设置左边导航栏的图片
    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *img_url = remindDic[@"img_url"];
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *type = remindDic[@"type"];
        
        //优看左上角图标
        if([remind_id isEqualToString:@"3"]){
            
            if([type isEqualToString:@"0"]){
                rightNavcButton.hidden = YES;
            }else{
                rightNavcButton.hidden = NO;
                [rightNavcButton sd_setImageWithURL:[NSURL URLWithString:img_url] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)createView{
    
    [super createView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    
    if (@available(iOS 11, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark 点击事件
- (void)rightNavcAction{
    
    //设置左边导航栏的图片
    NSArray *remindDataArray = [_manager receiveRemindInfoList];
    
    for(NSDictionary *remindDic in remindDataArray){
        
        NSString *remind_id = remindDic[@"remind_id"];
        NSString *urlStr = remindDic[@"url"];
        
        
        if([remind_id isEqualToString:@"3"]){
            
            [self headViewActionURL:urlStr];
        }
    }
}

- (void)headViewActionURL:(NSString *)urlStr{
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){//跳到外部链接
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else{
        
        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
        activityVC.urlStr = urlStr;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
}

//直接销毁当前视图
- (void)onClickClose{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WKNavigation代理
//广告链接跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *urlString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
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
    
    decisionHandler(WKNavigationActionPolicyAllow);
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

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if(_isPhoneCallOrSendMessage){//当点击界面上的打电话或发短信时不显示提示信息
        _isPhoneCallOrSendMessage = NO;
        return;
    }
    
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


@end
