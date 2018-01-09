//
//  YKXCustomActivityView.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKXCustomActivityView : UIView

- (instancetype)initWithTitleImage:(NSString *)titleImage title:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle;

- (void)show;

//按钮回调
@property (nonatomic,copy) void(^activityBlock)();

@end
