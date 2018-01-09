//
//  YKXServiceViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/6/16.
//  Copyright © 2017年 youyou. All rights reserved.
// 推荐服务页面跳转

#import <UIKit/UIKit.h>

@interface YKXServiceViewController : UIViewController

//导航栏名称
@property (nonatomic,copy) NSString *serviceName;
@property (nonatomic,copy) NSString *serviceTitle;

//播放视频URL
@property (nonatomic,copy) NSString *serviceUrl;

//修改界面注入的JS
@property (nonatomic,copy) NSString *reviseJS;

//加载广告注入的JS
@property (nonatomic,copy) NSString *adJS;

//userAgent
@property (nonatomic,copy) NSString *userAgent;

@end
