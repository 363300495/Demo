//
//  YKXCustomCodeView.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKXCustomCodeView : UIView
//验证码
@property (nonatomic,strong) UITextField *codeTextFeild;
//发送按钮
@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,copy) void(^sendMessageBlock)();

@end
