//
//  YKXChatInputView.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKXChatInputView;
@protocol YKXChatInputViewDelegate <NSObject>

/**  
 发送消息
 @param chatInputView 输入框
 @param textMessage 消息
 */
- (void)YKXChatInputView:(YKXChatInputView *)chatInputView sendTextMessage:(NSString *)textMessage;


/**
 输入框高度变化

 @param chatInputView 输入框
 @param height 输入文字时输入框高度的变化
 */
- (void)YKXChatInputView:(YKXChatInputView *)chatInputView chatHeight:(CGFloat)height;

@end

@interface YKXChatInputView : UIView

@property (nonatomic,strong) UITextView *chatText;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,weak) id<YKXChatInputViewDelegate> delegate;

@end
