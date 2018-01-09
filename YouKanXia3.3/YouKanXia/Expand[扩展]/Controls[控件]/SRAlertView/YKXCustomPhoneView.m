//
//  YKXCustomPhoneView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomPhoneView.h"

@interface YKXCustomPhoneView ()

@end


@implementation YKXCustomPhoneView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        WEAKSELF(weakSelf);
        
        UILabel *areaLabel = [[UILabel alloc] init];
        areaLabel.text = @"+86";
        areaLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:areaLabel];
        [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.top.equalTo(@(15));
            make.height.mas_offset(20);
            make.width.mas_offset(40);
            
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(areaLabel.mas_right);
            make.top.equalTo(@(12));
            make.size.mas_offset(CGSizeMake(22, 26));
        }];
        
        UITextField *phoneTextFeild = [[UITextField alloc] init];
        phoneTextFeild.placeholder = @"输入手机号码";
        phoneTextFeild.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:phoneTextFeild];
        [phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(arrowImageView.mas_right).offset(15);
            make.top.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.height.mas_equalTo(30);
        }];
        self.phoneTextFeild = phoneTextFeild;
        
        UILabel *phoneLineLabel = [[UILabel alloc] init];
        phoneLineLabel.backgroundColor = [UIColor colorWithHexString:@"#E4E3E5"];
        [self addSubview:phoneLineLabel];
        [phoneLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf);
            make.height.mas_offset(1);
        }];
        
    }
    return self;
}

@end
