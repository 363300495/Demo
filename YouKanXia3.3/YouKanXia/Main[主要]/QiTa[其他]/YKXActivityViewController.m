//
//  ActivityViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXActivityViewController.h"
#import "YKXSVIPViewController.h"
#import "AppDelegate.h"
@implementation YKXActivityViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置网页的UA
    if(self.userAgent != nil && self.userAgent.length >0){
        [YKXCommonUtil setDeviceUserAgent:self.userAgent];
    }
}


- (void)createView{
    
    [super createView];

    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
}


#pragma mark 点击事件
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
    
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *urlString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    

    if([urlString containsString:@"uu-svip"] || [urlString containsString:@"UU-SVIP"]){
        
        policy = WKNavigationActionPolicyCancel;
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-svip" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-SVIP" withString:@""];
        
        
        NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
        
        if(loginDic.count == 0){
            
            [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
            
            NSString *uid = loginDic[@"uid"];
            NSString *token = loginDic[@"token"];
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"",urlString,@"1",uid,token,@"0",@"2",timeStamp,YOYO,randCode];
            
            //获取签名
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataSVIPChannelTitle:@"" URL:urlString versionCode:versionCode line:@"1" uid:uid token:token vweb:@"0" devtype:@"2" timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
                
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
                    
                    NSString *svipAdOpen = dataDic[@"svip_ad_open"];
                    NSArray *xuanjiArray = responseObject[@"xuanji"];
                    
                    
                    YKXSVIPViewController *ykxSVIPVC = [[YKXSVIPViewController alloc] init];
                    ykxSVIPVC.reviseJS = reviseJS;
                    ykxSVIPVC.adJS = adJS;
                    ykxSVIPVC.resDomain = resDomain;
                    ykxSVIPVC.relDomain = relDomain;
                    ykxSVIPVC.userAgent = userAgent;
                    
                    ykxSVIPVC.name = @"";
                    ykxSVIPVC.type = @"";
                    ykxSVIPVC.currentUrl = urlString;
                    ykxSVIPVC.currentTitle = @"";
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
                    

                }else{
                    
                    [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
                }
                
            } failure:^(NSError *error) {
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
            
        }
    }else if([urlString containsString:@"uu-ext"] || [urlString containsString:@"UU-EXT"]){
        
        policy = WKNavigationActionPolicyCancel;
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        
    }else if([urlString containsString:@"uu-down"] || [urlString containsString:@"UU-DOWN"]){
        
        policy = WKNavigationActionPolicyCancel;
        
        NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
        NSString *uid = loginUserInfo[@"uid"];
        NSString *token = loginUserInfo[@"token"];
        
        if([[NSString stringWithFormat:@"%@",urlString] length] > 0){
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
            
            MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:urlString];
            
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
                    downLoadEntity.downLoadUrlString = urlString;
                    downLoadEntity.extra = @{@"name":@""};
                    [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                    
                    [YKXCommonUtil showToastWithTitle:@"添加成功，正在下载" view:self.view.window];
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    
    
    UIApplication *app = [UIApplication sharedApplication];
    if([scheme isEqualToString:@"weixin"]){//打开微信支付
        if([app canOpenURL:URL]){
            
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }
    }
    
    // 打开appstore
    if([URL.absoluteString containsString:@"itunes.apple.com"]) {
        
        if ([app canOpenURL:URL]) {
            
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }
    }else if ([urlString containsString:@"alipay://"]) {//打开支付宝支付
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


@end
