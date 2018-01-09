//
//  YKXPayViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXPayViewController.h"

@interface YKXPayViewController ()

@end

@implementation YKXPayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)createNavc{
    [super createNavc];
}

- (void)createView{
    
    [super createView];

    NSString *payURL = [YKXDefaultsUtil getAPPRechargeURL];
    
    //用户中心替换URL
    NSString *urlStr = [self replaceUrlString:payURL];
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

- (NSString *)replaceUrlString:(NSString *)urlStr{
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{uid}" withString:[NSString stringWithFormat:@"%@",uid]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"{token}" withString:[NSString stringWithFormat:@"%@",token]];
    
    return urlStr;
}

#pragma mark 点击事件
- (void)onClickClose{
    
    //修改充值信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark WKNavigation代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *urlString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    
    UIApplication *app = [UIApplication sharedApplication];
    if([scheme isEqualToString:@"weixin"]){//打开微信支付
        if([app canOpenURL:URL]){
            
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }
    }
    
    if ([urlString containsString:@"alipay://"]) {//打开支付宝支付
        NSInteger subIndex = 23;
        NSString *dataStr=[urlString substringFromIndex:subIndex];
        //编码
        NSString *encodeString = [YKXCommonUtil encodeString:dataStr];
        NSMutableString *mString = [[NSMutableString alloc] init];
        [mString appendString:[urlString substringToIndex:subIndex]];
        [mString appendString:encodeString];
     
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mString] options:@{} completionHandler:nil];
    }
    
    if ([urlString containsString:@"alipays://"]) {
        
        NSRange range = [urlString rangeOfString:@"alipays://"]; //截取的字符串起始位置
        NSString * resultStr = [urlString substringFromIndex:range.location]; //截取字符串
        
        NSURL *alipayURL = [NSURL URLWithString:resultStr];
        
        [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
            
        }];
    }
    
    NSString *subStr = [urlString substringToIndex:4];
    
    if(![subStr isEqualToString:@"http"]){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
    
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
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
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //停止下拉刷新
    [self.refreshHeader endRefreshing];
    
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView setHidesWhenStopped:YES];
}


@end
