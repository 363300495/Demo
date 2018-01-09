//
//  YKXSystemSettingHeadCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/17.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXSystemSettingHeadCell.h"

@implementation YKXSystemSettingHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createViewAutoLayout];
        
    }
    
    return self;
}

- (void)createViewAutoLayout{
    
    WEAKSELF(weakSelf);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"头像";
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(24);
    }];

    
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 30;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-42);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.headImageView = headImageView;
    
}

@end
