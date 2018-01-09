//
//  ShenHeTabBarController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeTabBarController.h"

@interface ShenHeTabBarController () <UITabBarControllerDelegate>

@end

@implementation ShenHeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark 添加导航控制器
- (void)addChildNavigationController:(Class)navigationControllerClass
                  rootViewController:(Class)rootViewControllerClass
                     navigationTitle:(NSString *)navigationTitle
                     tabBarItemTitle:(NSString *)tabBarItemTitle
               tabBarNormalImageName:(NSString *)normalImageName
               tabBarSelectImageName:(NSString *)selectImageName
{
    // 创建视图控制器
    
    UIViewController *rootViewController = [[rootViewControllerClass alloc] init];
    rootViewController.navigationItem.title = tabBarItemTitle; // 默认设置与tabBarItem一样
    if (navigationTitle && navigationTitle.length > 0) {
        rootViewController.navigationItem.title = navigationTitle;
    }
    
    
    // 创建导航控制器
    UINavigationController *naviViewController = [[navigationControllerClass alloc] initWithRootViewController:rootViewController];
    naviViewController.automaticallyAdjustsScrollViewInsets = NO;
    naviViewController.tabBarItem.title = tabBarItemTitle;
    
    
    naviViewController.navigationBar.barTintColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    
    naviViewController.navigationBar.translucent = NO;
    //设置导航栏的文字颜色
    naviViewController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0f]};
    
    
    
    //设置标签的文字
    [naviViewController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} forState:UIControlStateNormal];
    [naviViewController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR]} forState:UIControlStateSelected];
    
    // 标签栏图片
    CGSize imageSize = CGSizeMake(49*0.50, 49*0.50);
    naviViewController.tabBarItem.image = [[[UIImage imageNamed:normalImageName]
                                            imageByScalingProportionallyToSize:imageSize]
                                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naviViewController.tabBarItem.selectedImage = [[[UIImage imageNamed:selectImageName]
                                                    imageByScalingProportionallyToSize:imageSize]
                                                   imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 主标签控制器中添加子导航控制器
    [self addChildViewController:naviViewController];
    
    //设置tabBar不透明
    self.tabBar.translucent = NO;
    
    // 设置底部UITabBarControllerDelegate代理
    rootViewController.tabBarController.delegate = self;
}



#pragma mark 设置子控制器，子类继承并重写
- (void)addChildControllers
{
    // add view controllers in subviews
    
}
@end
