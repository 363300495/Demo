//
//  YKXVideoViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/13.
//  Copyright © 2017年 youyou. All rights reserved.
//  VIP视频界面跳转

#import <UIKit/UIKit.h>

@interface YKXVideoViewController : UIViewController

//导航栏名称
@property (nonatomic,copy) NSString *name;

//网站类型
@property (nonatomic,copy) NSString *type;

//当前的groupid
@property (nonatomic,copy) NSString *groupid;

//播放视频URL
@property (nonatomic,copy) NSString *videoUrl;

//当前注入的cookie
@property (nonatomic,strong) NSArray *cookieArray;

//当前加载的pingType
@property (nonatomic,strong) NSString *pingType;
//当前注入的UA
@property (nonatomic,copy) NSString *userAgent;

//修改界面注入的JS
@property (nonatomic,copy) NSString *reviseJS;
//加载广告注入的JS
@property (nonatomic,copy) NSString *adJS;

//当前的拦截域名字符串
@property (nonatomic,copy) NSString *resDomain;
//当前未拦截域名字符串
@property (nonatomic,copy) NSString *relDomain;

//加载完成时执行JS，当为空时不执行
@property (nonatomic,copy) NSString *svipJS;

//m3u8上传URL
@property (nonatomic,copy) NSString *svipLoadURL;

@end
