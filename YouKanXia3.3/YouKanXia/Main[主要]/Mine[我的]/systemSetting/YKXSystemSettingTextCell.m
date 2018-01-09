//
//  YKXSystemSettingTextCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/17.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXSystemSettingTextCell.h"

@implementation YKXSystemSettingTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createViewAutoLayout];
        
    }
    return self;
}

- (void)createViewAutoLayout{
    
    WEAKSELF(weakSelf);
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(24);
    }];
    
    self.titleLabel = titleLabel;
    
    UIImageView *rightAccesroyView = [[UIImageView alloc] init];
    rightAccesroyView.image = [UIImage imageNamed:@"rightAccessory"];
    [self.contentView addSubview:rightAccesroyView];
    [rightAccesroyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(@(-18));
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    self.rightAccesroyView = rightAccesroyView;
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.textColor = [UIColor colorWithHexString:@"#FC767E"];
    descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(rightAccesroyView.mas_left).offset(-10);
        make.height.mas_equalTo(24);
    }];
    
    self.descriptionLabel = descriptionLabel;
    
}


@end
