//
//  CustomRecommendCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CustomRecommendCell.h"

@implementation CustomRecommendCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        WEAKSELF(weakSelf);
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        if(IPHONE6P){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(@(14));
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(@(12));
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }
        
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:titleLabel];
        
        if(IPHONE6P){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(imageView.mas_bottom).offset(6);
                make.size.mas_equalTo(CGSizeMake(80, 20));
            }];
        }else{
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(imageView.mas_bottom).offset(6);
                make.size.mas_equalTo(CGSizeMake(80, 20));
            }];
        }
        
        self.titleLabel = titleLabel;
    }
    return self;
}

@end
