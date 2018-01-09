//
//  YKXVideoPlayViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/10/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcViewController.h"

@interface YKXVideoPlayViewController : BaseNavcViewController

@property (nonatomic,copy) NSString *playTitle;

@property (nonatomic,copy) NSString *playURL;

//导航栏右上角下载链接地址
@property (nonatomic,copy) NSString *downloadURL;

@end
