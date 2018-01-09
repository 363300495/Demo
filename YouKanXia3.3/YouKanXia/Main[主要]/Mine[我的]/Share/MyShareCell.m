//
//  MyShareCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/2.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "MyShareCell.h"
#import "MyShareModel.h"

@interface MyShareCell ()

//图标
@property (nonatomic,strong) UIImageView *iconImageView;

//内容
@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation MyShareCell

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
    
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [rootView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(20));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.iconImageView = iconImageView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [rootView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.top.equalTo(rootView).offset(20);
        make.height.mas_equalTo(20);
    }];
    self.contentLabel = contentLabel;

}

- (void)setModel:(MyShareModel *)model{
    
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:@"shareVIP"];
    
    self.contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
    
    NSString *type;
    if([model.type integerValue] == 1){
        
        type = @"微信好友";
    }else if ([model.type integerValue] == 2){
        
        type = @"微信朋友圈";
    }else if ([model.type integerValue] == 3){
        
        type = @"QQ好友";
    }else if ([model.type integerValue] == 4){
       
        type = @"QQ空间";
    }
    
    NSString *time = [YKXCommonUtil timeStamp:[model.addtime integerValue]];
    
    NSString *timeStr = [time substringFromIndex:5];
    
    
    NSString *contentStr = [NSString stringWithFormat:@"%@发起“%@”分享奖励%@天",timeStr,type,model.reward];
    
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSRange range = [contentStr rangeOfString:[NSString stringWithFormat:@"%@发起“%@”分享奖励",timeStr,type]];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.length, contentStr.length-range.length)];
    
    self.contentLabel.attributedText = mAttStri;
}

@end
