//
//  YKXCustomCodeView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomCodeView.h"

@implementation YKXCustomCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        

        WEAKSELF(weakSelf);
        
        UITextField *codeTextFeild = [[UITextField alloc] init];
        codeTextFeild.placeholder = @"验证码";
        codeTextFeild.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:codeTextFeild];
        [codeTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(10));
            make.size.mas_offset(CGSizeMake(80, 30));
        }];
        self.codeTextFeild = codeTextFeild;
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:@"获取" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        sendButton.layer.cornerRadius = 5;
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.borderWidth = 1;
        sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [sendButton addTarget:self action:@selector(onClickSendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.left.equalTo(codeTextFeild.mas_right).offset(30);
            make.right.equalTo(weakSelf);
            make.height.mas_offset(35);
        }];
        self.sendButton = sendButton;
        
        UILabel *codeLineLabel = [[UILabel alloc] init];
        codeLineLabel.backgroundColor = [UIColor colorWithHexString:@"#E4E3E5"];
        [self addSubview:codeLineLabel];
        [codeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.mas_offset(1);
        }];
        
    }
    return self;
}

- (void)onClickSendMessage{
    if(self.sendMessageBlock){
        self.sendMessageBlock();
    }
}

@end
