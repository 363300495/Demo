//
//  ShenHeTabBarController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShenHeTabBarController : UITabBarController

#pragma mark 添加子导航控制器
- (void)addChildNavigationController:(Class)navigationControllerClass
                  rootViewController:(Class)rootViewControllerClass
                     navigationTitle:(NSString *)navigationTitle
                     tabBarItemTitle:(NSString *)tabBarItemTitle
               tabBarNormalImageName:(NSString *)normalImageName
               tabBarSelectImageName:(NSString *)selectImageName;

@end
