//
//  YKXCustomExitView.h
//  YouKanXia
//
//  Created by 汪立 on 2017/7/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKXCustomExitViewDelegate <NSObject>

- (void)sendMessageDescription:(NSString *)description content:(NSString *)content;

@end

@interface YKXCustomExitView : UIView

- (instancetype)initWithPromptNote:(NSString *)promptNote loginContent:(NSString *)loginContent whiteContent:(NSString *)whiteContent otherContent:(NSString *)otherContent;

- (void)show;

@property (nonatomic,strong) UIView *alertView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,assign) id<YKXCustomExitViewDelegate> delegete;

@end
