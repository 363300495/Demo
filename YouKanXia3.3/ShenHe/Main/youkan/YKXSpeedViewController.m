//
//  YKXSpeedViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/7/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXSpeedViewController.h"

@interface YKXSpeedViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation YKXSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
}

- (void)createView{
    
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
    
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.speedtest.cn"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    //加载进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    progressView.tintColor = [UIColor colorWithHexString:PROGRESS_COLOR];
    progressView.trackTintColor = [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    //增加进度条属性的监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
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


//已经开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"speed" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    
    //在开始加载时，注入JS,修改页面,删掉页面上多余的按钮和界面
    [self.webView evaluateJavaScript:content completionHandler:^(id Result, NSError * error) {
    }];
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
