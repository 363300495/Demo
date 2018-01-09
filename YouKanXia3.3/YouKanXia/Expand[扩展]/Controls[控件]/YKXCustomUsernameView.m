//
//  YKXCustomPhoneView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomUsernameView.h"

@implementation YKXCustomUsernameView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        WEAKSELF(weakSelf);
        
        UIView *rootContainerView = [[UIView alloc] init];
        [self addSubview:rootContainerView];
        [rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIImageView *usernameImageView = [[UIImageView alloc] init];
        usernameImageView.image = [UIImage imageNamed:@"username"];
        [rootContainerView addSubview:usernameImageView];
        [usernameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(12));
            make.size.mas_offset(CGSizeMake(26, 26));
        }];
        
        UITextField *usernameTextFeild = [[UITextField alloc] init];
        usernameTextFeild.font = [UIFont systemFontOfSize:14.0f];
        usernameTextFeild.keyboardType = UIKeyboardTypeASCIICapable;
        [self addSubview:usernameTextFeild];
        [usernameTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(usernameImageView.mas_right).offset(15);
            make.top.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.height.mas_equalTo(30);
        }];
        self.usernameTextFeild = usernameTextFeild;
        
        UIView *separatorLineView = [[UIView alloc] init];
        [self addSubview:separatorLineView];
        separatorLineView.backgroundColor = [UIColor colorWithHexString:@"#E4E3E5"];
        [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(usernameImageView.mas_bottom).offset(5);
            make.left.equalTo(usernameImageView.mas_right).offset(5);
            make.right.equalTo(weakSelf.mas_right).offset(0.0);
            make.height.equalTo(@(1.0));
        }];
    }
    return self;
}

- (void)setUsernamePlaceholder:(NSString *)usernamePlaceholder{
    
    _usernamePlaceholder = usernamePlaceholder;
    
    self.usernameTextFeild.placeholder = usernamePlaceholder;
}

@end
