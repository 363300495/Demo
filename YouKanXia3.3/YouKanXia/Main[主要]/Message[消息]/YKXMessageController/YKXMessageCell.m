//
//  YKXMessageCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/4.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXMessageCell.h"
#import "YKXMessageModel.h"
@interface YKXMessageCell ()

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@end

@implementation YKXMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createViewLayout];
    }
    return self;
}

- (void)createViewLayout{
    
    WEAKSELF(weakSelf);
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 25;
    iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    
    if(IPHONE5){
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView);
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(26);
        }];
    }else if (IPHONE6){
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView);
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.width.mas_equalTo(220);
            make.height.mas_equalTo(26);
        }];
    }else{
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView);
            make.left.equalTo(iconImageView.mas_right).offset(10);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(26);
        }];
    }
    
    
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    
    if(IPHONE5){
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(4);
            make.left.equalTo(titleLabel);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(20);
        }];
    }else if (IPHONE6){
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(4);
            make.left.equalTo(titleLabel);
            make.width.mas_equalTo(220);
            make.height.mas_equalTo(20);
        }];
    }else{
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(4);
            make.left.equalTo(titleLabel);
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(20);
        }];
    }

    self.contentLabel = contentLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.top.equalTo(titleLabel);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel = timeLabel;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor redColor];
    messageLabel.layer.cornerRadius = 10;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel.mas_right);
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    self.messageLabel = messageLabel;
}

- (void)setModel:(YKXMessageModel *)model{
    
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl]];
    self.titleLabel.text = model.name;
    self.titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    self.contentLabel.text = model.title;
    self.contentLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    
    //时间戳转换为时间
    NSString *timeStr = [YKXCommonUtil detailDayStr:[model.time integerValue]];
    self.timeLabel.text = timeStr;
    
    
    NSInteger badge = [model.count integerValue];
    
    if(badge <= 0){
        
        self.messageLabel.hidden = YES;
        
    }else{
       
        self.messageLabel.hidden = NO;
        if(badge > 0 && badge <= 9){
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(20);
            }];
        }else if(badge >9 && badge <=19){
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(25);
            }];
        }else{
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(30);
            }];
        }
        
        self.messageLabel.text = model.count;
        
        if(badge >99){
            self.messageLabel.text = @"99+";
        }
    }
}

@end
