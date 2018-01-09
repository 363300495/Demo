//
//  CustomHotServiceCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CustomHotServiceCell.h"

@implementation CustomHotServiceCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        WEAKSELF(weakSelf);
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:titleLabel];
        
        if(IPHONE6P){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(@(10));
                make.size.mas_equalTo(CGSizeMake(80, 25));
            }];
        }else{
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(@(10));
                make.size.mas_equalTo(CGSizeMake(80, 25));
            }];
        }
        
        self.titleLabel = titleLabel;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
        detailLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:detailLabel];
        
        if(IPHONE6P){
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(titleLabel.mas_bottom).offset(8);
                make.size.mas_equalTo(CGSizeMake(90, 20));
            }];
        }else{
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(titleLabel.mas_bottom).offset(2);
                make.size.mas_equalTo(CGSizeMake(90, 20));
            }];
        }
        
        self.detailLabel = detailLabel;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        
        if(IPHONE6P){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(detailLabel.mas_bottom).offset(16);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.contentView);
                make.top.equalTo(detailLabel.mas_bottom).offset(8);
                make.size.mas_equalTo(CGSizeMake(44, 44));
            }];
        }
        self.imageView = imageView;
    }
    return self;
}
@end
