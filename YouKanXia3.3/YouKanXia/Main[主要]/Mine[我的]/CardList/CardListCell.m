//
//  CardListCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CardListCell.h"
#import "CardListModel.h"
@interface CardListCell ()

//左边背景
@property (nonatomic,strong) UIView *leftRootView;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UILabel *dateLabel;

//分割图片
@property (nonatomic,strong) UIImageView *lineImageView;

//右边背景
@property (nonatomic,strong) UIView *rightRootView;

@property (nonatomic,strong) UIImageView *getCardImageView;

@property (nonatomic,strong) UILabel *cardTitleLabel;

@property (nonatomic,strong) UILabel *cardDetailLabel;

//时间
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIButton *cardInvalidButton;

@end


@implementation CardListCell

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
    
    UIView *topRootView = [[UIView alloc] init];
    topRootView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    [rootView addSubview:topRootView];
    [topRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(rootView);
        make.height.mas_equalTo(10);
    }];
    
    
    UIView *leftRootView = [[UIView alloc] init];
    [rootView addSubview:leftRootView];
    [leftRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topRootView.mas_bottom);
        make.left.bottom.equalTo(rootView);
        make.width.mas_equalTo(80);
    }];
    self.leftRootView = leftRootView;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    [leftRootView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(leftRootView);
        make.height.mas_equalTo(40);
    }];
    self.numberLabel = numberLabel;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [leftRootView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right);
        make.bottom.equalTo(numberLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    self.dateLabel = dateLabel;
    
    UIImageView *lineImageView = [[UIImageView alloc] init];
    [rootView addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftRootView.mas_right);
        make.top.equalTo(leftRootView);
        make.bottom.equalTo(rootView);
        make.width.mas_equalTo(15);
    }];
    self.lineImageView = lineImageView;
    
    UIView *rightRootView = [[UIView alloc] init];
    [rootView addSubview:rightRootView];
    [rightRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right);
        make.top.equalTo(leftRootView);
        make.right.bottom.equalTo(rootView);
    }];
    
    UIImageView *getCardImageView = [[UIImageView alloc] init];
    [rightRootView addSubview:getCardImageView];
    [getCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(5));
        make.top.equalTo(@(10));
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    self.getCardImageView = getCardImageView;
    
    UILabel *cardTitleLabel = [[UILabel alloc] init];
    [rightRootView addSubview:cardTitleLabel];
    [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(getCardImageView.mas_right).offset(5);
        make.top.equalTo(getCardImageView.mas_top);
        make.height.mas_equalTo(20);
        
    }];
    if(IPHONE5){
        [cardTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(170);
        }];
    }
    self.cardTitleLabel = cardTitleLabel;
    
    UILabel *cardDetailLabel = [[UILabel alloc] init];
    [rightRootView addSubview:cardDetailLabel];
    [cardDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right).offset(10);
        make.top.equalTo(getCardImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    if(IPHONE5){
        [cardDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140, 30));
        }];
    }
    self.cardDetailLabel = cardDetailLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [rightRootView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardDetailLabel);
        make.top.equalTo(cardDetailLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel = timeLabel;
    
    UIButton *cardInvalidButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightRootView addSubview:cardInvalidButton];
    [cardInvalidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightRootView);
        make.right.equalTo(rightRootView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50,20));
    }];
    self.cardInvalidButton = cardInvalidButton;
    
}

- (void)setModel:(CardListModel *)model{
    
    self.leftRootView.backgroundColor = [UIColor colorWithHexString:@"#51C8CB"];
    
    self.numberLabel.text = model.val;
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont systemFontOfSize:40.0f];
    
    NSString *text;
    if([model.type integerValue] == 1){
        text = @"天";
    }else if([model.type integerValue] == 2){
        text = @"月";
    }else if([model.type integerValue] == 3){
        text = @"年";
    }
    self.dateLabel.text = text;
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.lineImageView.image = [UIImage imageNamed:@"juan_line"];
    
    self.getCardImageView.image = [UIImage imageNamed:@"juan_tag"];
    
    self.cardTitleLabel.text = model.title;
    self.cardTitleLabel.textColor = [UIColor colorWithHexString:@"#545252"];
    self.cardTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    self.cardDetailLabel.text = model.info;
    self.cardDetailLabel.textColor = [UIColor colorWithHexString:@"#A3A3A3"];
    self.cardDetailLabel.font = [UIFont systemFontOfSize:12.0f];
    self.cardDetailLabel.numberOfLines = 0;
    
    NSString *expirationtime = [YKXCommonUtil timeStamp:[model.expirationtime integerValue]];
    self.timeLabel.text = [NSString stringWithFormat:@"过期时间：%@",expirationtime];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#A3A3A3"];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.cardInvalidButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.cardInvalidButton.layer.masksToBounds = YES;
    self.cardInvalidButton.layer.cornerRadius = 10;
    self.cardInvalidButton.layer.borderWidth = 0.6;
    [self.cardInvalidButton setTitle:@"已过期" forState:UIControlStateNormal];
    [self.cardInvalidButton setTitleColor:[UIColor colorWithHexString:@"#A3A3A3"] forState:UIControlStateNormal];
    self.cardInvalidButton.enabled = NO;
    self.cardInvalidButton.layer.borderColor = [UIColor colorWithHexString:@"#A3A3A3"].CGColor;
}

@end
