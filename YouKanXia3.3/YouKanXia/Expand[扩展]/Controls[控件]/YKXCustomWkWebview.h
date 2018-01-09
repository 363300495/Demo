//
//  YKXCustomWkWebview.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKXCustomWkWebviewDelegate <NSObject>

- (void)goToNextViewControllerWithURLStr:(NSString *)urlStr reviseJS:(NSString *)reviseJS adJS:(NSString *)adJS;

@end

@interface YKXCustomWkWebview : UIView <WKNavigationDelegate,WKUIDelegate>

- (instancetype)initWithUrlstr:(NSString *)urlStr;

@property (nonatomic,strong) WKWebView *webView;

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//wkwebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;

//没网时显示的提示界面
@property (nonatomic,strong) UIView *rootView;

//没网时头部的提示框
@property (nonatomic,strong) UILabel *currentNetworkReachabilityStatusLabel;

//当前网页的URL
@property (nonatomic,copy) NSString *urlStr;

//当前注入的js字符串(修改页面)
@property (nonatomic,copy) NSString *reviseJS;
//加载广告的JS
@property (nonatomic,copy) NSString *adJS;


@property (nonatomic,assign) BOOL processDidTerminated;

@property (nonatomic,assign) id<YKXCustomWkWebviewDelegate> delegate;

@end
