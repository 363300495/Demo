//
//  UITabBar+badge.h
//  YouKanXia
//
//  Created by 汪立 on 2017/11/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

/**
 *  数字角标
 *
 *  @param badge   所要显示数字
 *  @param index 位置
 */
- (void)showBadgeMark:(NSInteger)badge index:(NSInteger)index;

/**
 *  小红点
 *
 *  @param index 位置
 */
- (void)showPointMarkIndex:(NSInteger)index;



/**
 *  影藏指定位置角标
 *
 *  @param index 位置
 */
- (void)hideMarkIndex:(NSInteger)index;


@end
