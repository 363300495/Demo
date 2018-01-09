//
//  BaseNavcWkwebviewViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/22.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface BaseNavcWkwebviewViewController : UIViewController <WKNavigationDelegate,WKUIDelegate>

//webView的请求链接
@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,strong) WKWebView *webView;

//加载时中间的提示框
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//wkwebView顶部刷新控件
@property (nonatomic,strong) MJRefreshNormalHeader *refreshHeader;


@property (nonatomic,strong) UILabel *currentNetworkReachabilityStatusLabel;

//加载时上面的进度条
@property (nonatomic,strong) UIProgressView *progressView;

//没网时显示的提示界面
@property (nonatomic,strong) UIView *rootView;

//导航栏左侧的关闭按钮
@property (nonatomic,strong) UIButton *closeButton;

//导航栏标题控件
@property (nonatomic,strong) UIView *titleView;
//头部标题控件
@property (nonatomic,strong) UILabel *titleLabel;

//创建导航栏
- (void)createNavc;

//创建视图
- (void)createView;

//关闭
- (void)onClickClose;

@end
