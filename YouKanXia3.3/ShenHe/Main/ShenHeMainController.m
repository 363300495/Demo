//
//  ShenHeMainController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeMainController.h"
#import "ShenHeNavigationController.h"
#import "ShenHeYouKanViewController.h"
#import "ShenHeMessageViewController.h"
#import "ShenHeFindViewController.h"
#import "ShenHeMineViewController.h"

@implementation ShenHeMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildControllers];
}

#pragma mark 添加子控制器
- (void)addChildControllers
{
    // 优看
    [self addChildNavigationController:[ShenHeNavigationController class]
                    rootViewController:[ShenHeYouKanViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:PREVIOUSNAME
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_YOUKAN_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_YOUKAN_SELECT];
    
    
    [self addChildNavigationController:[ShenHeNavigationController class]
                    rootViewController:[ShenHeMessageViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"消息"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_MESSAGE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_MESSAGE_SELECT];
    
    
    // 发现
    [self addChildNavigationController:[ShenHeNavigationController class]
                    rootViewController:[ShenHeFindViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"发现"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_DISCOVERY_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_DISCOVERY_SELECT];
    
    // 我的
    [self addChildNavigationController:[ShenHeNavigationController class]
                    rootViewController:[ShenHeMineViewController class]
                       navigationTitle:nil
                       tabBarItemTitle:@"我的"
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_MINE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_MINE_SELECT];
}


@end
