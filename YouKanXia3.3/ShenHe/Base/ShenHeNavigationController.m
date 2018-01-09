//
//  ShenHeNavigationController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeNavigationController.h"

@interface ShenHeNavigationController ()

@end

@implementation ShenHeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        // push前设置隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    
    //解决iPhoneX push页面时tabbar上移问题
    if (IPHONEX) {
        
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = SCREEN_HEIGHT - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

@end