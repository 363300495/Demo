//
//  MainViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "MainViewController.h"
#import "YouKanViewController.h"
#import "YKXMessageController.h"
#import "DiscoveryViewController.h"
#import "MineMainViewController.h"
#import "YKXLoginViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildControllers];
}

#pragma mark 添加子控制器
- (void)addChildControllers
{
    // 优看
    [self addChildNavigationController:[BaseNavigationController class]
                    rootViewController:[YouKanViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:PREVIOUSNAME
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_YOUKAN_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_YOUKAN_SELECT];
    
    
    [self addChildNavigationController:[BaseNavigationController class]
                    rootViewController:[YKXMessageController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"消息"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_MESSAGE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_MESSAGE_SELECT];
    
    
    // 发现
    [self addChildNavigationController:[BaseNavigationController class]
                    rootViewController:[DiscoveryViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"发现"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_DISCOVERY_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_DISCOVERY_SELECT];
    
    // 我的
    [self addChildNavigationController:[BaseNavigationController class]
                    rootViewController:[MineMainViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"我的"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_MINE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_MINE_SELECT];
}



@end
