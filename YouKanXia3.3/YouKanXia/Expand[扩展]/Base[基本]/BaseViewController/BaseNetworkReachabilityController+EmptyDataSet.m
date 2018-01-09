//
//  BaseNetworkReachabilityController+EmptyDataSet.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNetworkReachabilityController+EmptyDataSet.h"

@implementation BaseNetworkReachabilityController (EmptyDataSet) 

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"没有查询到数据哦";
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16*kWJFontCoefficient],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_search_result"];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -100*kWJHeightCoefficient;
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithHexString:BACKGROUND_COLOR];
}

#pragma mark 是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.isEmptyDataSetShouldDisplay;
}


#pragma mark 是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark 图片是否要动画效果，默认NO
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return NO;
}

@end
