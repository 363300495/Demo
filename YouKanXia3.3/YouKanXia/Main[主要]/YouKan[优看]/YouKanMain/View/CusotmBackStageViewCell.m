//
//  CusotmBackStageViewCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CusotmBackStageViewCell.h"

@interface CusotmBackStageViewCell ()

/** 背景图片 */
@property (nonatomic,strong) UIImageView *picImageView;

/** 背景图片上的标题 */
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *iconLabel;


@end


@implementation CusotmBackStageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        WEAKSELF(weakSelf);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"];
        
        
        UIImageView *picImageView = [[UIImageView alloc] init];
        picImageView.backgroundColor = [UIColor blackColor];
        picImageView.userInteractionEnabled = YES;
        //设置图片大小比例填充
        picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:picImageView];

        [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(SCREEN_WIDTH*9/16);
        }];
        self.picImageView = picImageView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picImageViewTapped:)];
        [picImageView addGestureRecognizer:tap];
        
        
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.image = [UIImage imageNamed:@"video_list_cell_big_icon"];
        [picImageView addSubview:playImageView];
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(picImageView);
            make.width.height.mas_equalTo(50);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [picImageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.left.equalTo(@(16));
            make.height.equalTo(@(20));
        }];
        self.titleLabel = titleLabel;

        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(picImageView.mas_bottom);
            make.left.right.equalTo(weakSelf.contentView);
            make.height.equalTo(@(40));
        }];
        
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.layer.cornerRadius = 12;
        iconImageView.layer.masksToBounds = YES;
        [bottomView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.top.equalTo(@(8));
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        self.iconImageView = iconImageView;
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.font = [UIFont systemFontOfSize:12.0f];
        iconLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        [bottomView addSubview:iconLabel];
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(6);
            make.centerY.equalTo(iconImageView);
        }];
        self.iconLabel = iconLabel;

    }
    
    return self;
}

- (void)setModel:(YKXVideoModel *)model{
    
    _model = model;
    
    NSString *coverimgurl = model.coverimgurl;
    
    if([coverimgurl hasSuffix:@"webp"]){
        
        coverimgurl = [coverimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
    }
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:coverimgurl] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = model.title;

    
    NSString *headimgurl = model.headimgurl;
    
    if([headimgurl hasSuffix:@"webp"]){
        
        headimgurl = [headimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl]];
    
    self.iconLabel.text = model.nickname;
}

- (void)picImageViewTapped:(UITapGestureRecognizer *)gr{
    
    NSString *urlStr = self.model.videourl;
    
    if(_delegete || [_delegete respondsToSelector:@selector(backStageURLClick:)]) {
        
        [_delegete backStageURLClick:urlStr];
    }
}

@end
