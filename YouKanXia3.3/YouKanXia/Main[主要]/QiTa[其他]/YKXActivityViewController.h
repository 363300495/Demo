//
//  ActivityViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

/**
 活动弹框、底部通知公告、优看顶部轮播图跳转页面、VIP和推荐服务头部组图等点击跳转页面
 */

#import "BaseNavcWkwebviewViewController.h"

@interface YKXActivityViewController : BaseNavcWkwebviewViewController

//修改网页注入的JS
@property (nonatomic,copy) NSString *reviseJS;
//注入广告的JS
@property (nonatomic,copy) NSString *adJS;
//注入当前页面的UA
@property (nonatomic,copy) NSString *userAgent;

@end
