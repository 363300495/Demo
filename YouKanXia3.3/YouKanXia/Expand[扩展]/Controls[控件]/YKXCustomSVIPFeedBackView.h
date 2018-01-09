//
//  YKXCustomSVIPFeedBackView.h
//  YouKanXia
//
//  Created by 汪立 on 2017/12/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKXCustomSVIPFeedBackViewDelegate <NSObject>

- (void)sendMessageDescription:(NSString *)description content:(NSString *)content;

@end

@interface YKXCustomSVIPFeedBackView : UIView

- (instancetype)initWithPromptNote:(NSString *)promptNote loginContent:(NSString *)loginContent whiteContent:(NSString *)whiteContent sleepContent:(NSString *)sleepContent otherContent:(NSString *)otherContent;

- (void)show;

@property (nonatomic,strong) UIView *alertView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,assign) id<YKXCustomSVIPFeedBackViewDelegate> delegete;

@end
