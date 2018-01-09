//
//  AppDelegate.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTSplashAd.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (strong,nonatomic) UIWindow *window;

@property (nonatomic,strong) MainViewController *mainVC;
//tabbar的角标
@property (nonatomic,assign) NSInteger badgeCount;

//好友消息定时器
@property (nonatomic,strong) NSTimer *friendListTimer;


/*** 是否允许横屏的标记 */
@property (nonatomic,assign) BOOL allowRotation;

@property (strong, nonatomic) GDTSplashAd *splash;

@property (retain, nonatomic) UIView *bottomView;

//跳过视图
@property (nonatomic ,strong) UIView *skipView;

@property (nonatomic ,strong) UILabel *textLabel;

@property (nonatomic,strong) NSTimer *skiptimer;
//倒计时秒数
@property (nonatomic,assign) NSInteger runLoopTimes;

@end

