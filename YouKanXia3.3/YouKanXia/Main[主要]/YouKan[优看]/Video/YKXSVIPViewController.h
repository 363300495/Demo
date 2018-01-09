//
//  YKXSVIPViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/6/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKXSVIPViewController : UIViewController

//修改界面注入的JS
@property (nonatomic,copy) NSString *reviseJS;
//加载广告注入的JS
@property (nonatomic,copy) NSString *adJS;

@property (nonatomic,copy) NSString *resDomain;

@property (nonatomic,copy) NSString *relDomain;

@property (nonatomic,copy) NSString *userAgent;


//未处理前的播放连接
@property (nonatomic,copy) NSString *currentUrl;
//未处理前的播放标题
@property (nonatomic,copy) NSString *currentTitle;
//导航栏名称
@property (nonatomic,copy) NSString *name;
//网站类型
@property (nonatomic,copy) NSString *type;

//导航栏右上角下载链接地址
@property (nonatomic,copy) NSString *downloadURL;

//设置VIP界面是否加入广告
@property (nonatomic,copy) NSString *svipAdOpen;

@property (nonatomic,strong) NSArray *xuanjiArray;


//判断是原生播放还是网页播放
@property (nonatomic,copy) NSString *playType;

//后台处理过的连接，第一次进入页面如果是网页时的播放链接
@property (nonatomic,copy) NSString *urlStr;

//第一次进入页面如果是原生的播放链接
@property (nonatomic,copy) NSString *playURL;


@end
