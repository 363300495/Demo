//
//  ShareRewardCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/2.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShareRewardCell.h"
#import "ShareRewardModel.h"

@interface ShareRewardCell ()

//左侧的图标
@property (nonatomic,strong) UIImageView *shareImageView;

//电话号码
@property (nonatomic,strong) UILabel *phoneLabel;

//描述
@property (nonatomic,strong) UILabel *descriptionLabel;

//右侧时间按钮
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation ShareRewardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout{
    
    UIView *rootView = [[UIView alloc] init];
    [self.contentView addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIImageView *shareImageView = [[UIImageView alloc] init];
    [rootView addSubview:shareImageView];
    
    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@(20));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.shareImageView = shareImageView;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    [rootView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareImageView.mas_right).offset(20);
        make.top.equalTo(shareImageView);
        make.height.mas_equalTo(20);
    }];
    
    self.phoneLabel = phoneLabel;
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [rootView addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel);
        make.top.equalTo(phoneLabel.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    self.descriptionLabel = descriptionLabel;
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [rootView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.top.equalTo(@(20));
        make.height.mas_equalTo(20);
    }];
    self.timeLabel = timeLabel;
    
    
}

- (void)setModel:(ShareRewardModel *)model{
    
    _model = model;
    
    self.shareImageView.image = [UIImage imageNamed:@"shareReward"];
    
    self.phoneLabel.text = model.mobile;
    self.phoneLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    self.phoneLabel.font = [UIFont systemFontOfSize:15.0f];
    
    
    self.descriptionLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    
    self.timeLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    
    NSString *description;
    NSString *time;
    
    NSString *type;
    if([model.type integerValue] == 1){
        type = @"天";
    }else if ([model.type integerValue] == 2){
        type = @"月";
    }else if ([model.type integerValue] == 3){
        type = @"年";
    }
        
    
    if([model.usecardtime integerValue] == 0){
       
        description = @"已领取未使用卡券";
        time = @"未使用";
        self.timeLabel.text = time;
    }else{
        description = @"已领取并使用卡券";
        time = [NSString stringWithFormat:@"各奖励%@%@",model.val,type];
        
        NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:time];
        NSRange range = [time rangeOfString:@"各奖励"];
        
        [mAttStri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.length, time.length-range.length)];
        
        self.timeLabel.attributedText = mAttStri;
    }
    
    self.descriptionLabel.text = description;
    
}

@end
