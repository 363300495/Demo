//
//  UITabBar+badge.m
//  YouKanXia
//
//  Created by 汪立 on 2017/11/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

//数字角标直径
#define NumMark_W_H 20
//小红点直径
#define PointMark_W_H 8

#import "UITabBar+badge.h"

@implementation UITabBar (badge)

/**
 *  数字角标
 *  @param badge   所要显示数字
 *  @param index 位置
 */
- (void)showBadgeMark:(NSInteger)badge index:(NSInteger)index{
    
    [self removeBadgeOnItemIndex:index];
    //label为小红点，并设置label属性
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.tag = 1000+index;
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.clipsToBounds = YES;
    numLabel.backgroundColor = [UIColor redColor];
    numLabel.font = [UIFont systemFontOfSize:13.0f];
    CGRect tabFrame = self.frame;
    
    //计算小红点的X值，根据第index控制器，小红点在每个tabbar按钮的中部偏移0.1，即是每个按钮宽度的0.6倍
    CGFloat percentX = (index+0.56);
    CGFloat tabBarButtonW = CGRectGetWidth(tabFrame)/4;
    CGFloat x = percentX*tabBarButtonW;
    CGFloat y = 0.1*49;
    //10为小红点的高度和宽度
    numLabel.frame = CGRectMake(x, y, 0, 0);

    CGRect nFrame = numLabel.frame;
    if(badge <= 0){
        //隐藏角标
        [self hideMarkIndex:index];
    }else{
        if(badge >0 && badge <=9){
            
            nFrame.size.width = NumMark_W_H;
        }else if (badge >9 && badge <= 19){
            
            nFrame.size.width = NumMark_W_H + 5;
        }else{
            
            nFrame.size.width = NumMark_W_H + 10;
        }
        
        nFrame.size.height = NumMark_W_H;
        numLabel.frame = nFrame;
        numLabel.layer.cornerRadius = NumMark_W_H/2.0;
        numLabel.text = [NSString stringWithFormat:@"%ld",badge];
        
        if(badge > 99){
            numLabel.text = @"99+";
        }
    }
    
    [self addSubview:numLabel];
    //把小红点移到最顶层
    [self bringSubviewToFront:numLabel];
}



/**
 tabbar显示小红点
 @param index 第几个控制器显示，从0开始算起
 */
- (void)showPointMarkIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
    //label为小红点，并设置label属性
    UILabel *label = [[UILabel alloc]init];
    label.tag = 1000+index;
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    
    //计算小红点的X值，根据第index控制器，小红点在每个tabbar按钮的中部偏移0.1，即是每个按钮宽度的0.6倍
    CGFloat percentX = (index+0.6);
    CGFloat tabBarButtonW = CGRectGetWidth(tabFrame)/4;
    CGFloat x = percentX*tabBarButtonW;
    CGFloat y = 0.1*CGRectGetHeight(tabFrame);
    //10为小红点的高度和宽度
    label.frame = CGRectMake(x, y, 10, 10);
    
    
    [self addSubview:label];
    //把小红点移到最顶层
    [self bringSubviewToFront:label];
}

/**
 隐藏红点
 @param index 第几个控制器隐藏，从0开始算起
 */
- (void)hideMarkIndex:(NSInteger)index{
    [self removeBadgeOnItemIndex:index];
}

/**
 移除控件
 @param index 第几个控制器要移除控件，从0开始算起
 */
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 1000+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
