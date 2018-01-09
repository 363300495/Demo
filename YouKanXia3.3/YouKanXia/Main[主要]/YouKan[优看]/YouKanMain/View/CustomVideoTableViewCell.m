//
//  CustomVideoTableViewCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CustomVideoTableViewCell.h"

@interface CustomVideoTableViewCell ()

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *iconLabel;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UIButton *shareButton;

@end


@implementation CustomVideoTableViewCell

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
        //必须设置tag值
        picImageView.tag = 1001;
        [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(SCREEN_WIDTH*9/16);
        }];
        self.picImageView = picImageView;
        
        
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
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.textColor = [UIColor whiteColor];
        [picImageView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(picImageView).offset(-14);
            make.bottom.equalTo(picImageView).offset(-10);
        }];
        self.timeLabel = timeLabel;
        
        // 代码添加playerBtn到imageView上
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [picImageView addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(picImageView);
            make.width.height.mas_equalTo(50);
        }];
        self.playButton = playBtn;
        
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
        
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton addTarget:self action:@selector(shareVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.right.equalTo(bottomView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        self.shareButton = shareButton;
        
        UILabel *verticalLabel = [[UILabel alloc] init];
        verticalLabel.backgroundColor = [UIColor colorWithHexString:LIGHT_COLOR];
        [bottomView addSubview:verticalLabel];
        [verticalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.right.equalTo(shareButton.mas_left).offset(-14);
            make.size.mas_equalTo(CGSizeMake(0.6, 16));
        }];
        
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        numberLabel.font = [UIFont systemFontOfSize:12.0f];
        [bottomView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(verticalLabel.mas_left).offset(-10);
            make.centerY.equalTo(bottomView);
        }];
        self.numberLabel = numberLabel;
    }
    
    return self;
}


- (void)setModel:(YKXVideoModel *)model {
    
    _model = model;
    
    NSString *coverimgurl = model.coverimgurl;
    
    if([coverimgurl hasSuffix:@"webp"]){
        
        coverimgurl = [coverimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
    }
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:coverimgurl] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%.1fs",[model.timelong_str floatValue]];
    
    NSString *headimgurl = model.headimgurl;
    
    if([headimgurl hasSuffix:@"webp"]){
        
        headimgurl = [headimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl]];
    
    self.iconLabel.text = model.nickname;
    
    
    CGFloat playFloat = [model.playcount_str integerValue]/10000.0;
    if(playFloat >= 1.0){
        
        self.numberLabel.text = [NSString stringWithFormat:@"%.1f万次",playFloat];
    }else{
        self.numberLabel.text = [NSString stringWithFormat:@"%@次",model.playcount_str];
    }
    
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"videoShare"] forState:UIControlStateNormal];
}


- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (void)shareVideoAction:(UIButton *)sender{
    
    if(self.shareVideoBlock){
        self.shareVideoBlock(self.model.vid);
    }
}

@end
