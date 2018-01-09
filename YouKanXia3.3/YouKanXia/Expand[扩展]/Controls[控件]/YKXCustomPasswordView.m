//
//  YKXCustomCodeView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomPasswordView.h"

@implementation YKXCustomPasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        WEAKSELF(weakSelf);
        
        UIView *rootContainerView = [[UIView alloc] init];
        [self addSubview:rootContainerView];
        [rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIImageView *passwordImageView = [[UIImageView alloc] init];
        passwordImageView.image = [UIImage imageNamed:@"password"];
        [rootContainerView addSubview:passwordImageView];
        [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(12));
            make.size.mas_offset(CGSizeMake(26, 26));
        }];
        
        UITextField *passwordTextFeild = [[UITextField alloc] init];
        passwordTextFeild.secureTextEntry = YES;
        passwordTextFeild.font = [UIFont systemFontOfSize:14.0f];
        passwordTextFeild.keyboardType = UIKeyboardTypeASCIICapable;
        [self addSubview:passwordTextFeild];
        [passwordTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordImageView.mas_right).offset(15);
            make.top.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.height.mas_equalTo(30);
        }];
        self.passwordTextFeild = passwordTextFeild;
        
        UIView *separatorLineView = [[UIView alloc] init];
        [self addSubview:separatorLineView];
        separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E4E3E5"];
        [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordImageView.mas_bottom).offset(5);
            make.left.equalTo(passwordImageView.mas_right).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(0.0);
            make.height.equalTo(@(1.0));
        }];
        
    }
    return self;
}

- (void)setPasswordPlaceHolder:(NSString *)passwordPlaceHolder{
    
    _passwordPlaceHolder = passwordPlaceHolder;
    
    self.passwordTextFeild.placeholder = passwordPlaceHolder;
}
@end
