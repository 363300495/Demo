//
//  MineTableViewCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/26.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "completeCell.h"

@interface completeCell ()


/** 视频信息 */
@property (nonatomic,strong) UILabel *informationLabel;

@end


@implementation completeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        WEAKSELF(weakSelf);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *videoImageView = [[UIImageView alloc] init];
        videoImageView.tag = 1001;
        videoImageView.layer.masksToBounds = YES;
        videoImageView.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:videoImageView];
        [videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10*kWJWidthCoefficient));
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(50*kWJWidthCoefficient, 50*kWJHeightCoefficient));
        }];
        
        self.videoImageView = videoImageView;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        titleLabel.font = [UIFont systemFontOfSize:14*kWJFontCoefficient];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(videoImageView.mas_right).offset(10*kWJWidthCoefficient);
            make.top.equalTo(videoImageView).offset(5*kWJHeightCoefficient);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-(80*kWJWidthCoefficient));
        }];
        self.titleLabel = titleLabel;
        
        UILabel *informationLabel = [[UILabel alloc] init];
        informationLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
        informationLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
        [self.contentView addSubview:informationLabel];
        [informationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
        }];
        self.informationLabel = informationLabel;
        
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[UIImage SDImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        playButton.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
        playButton.layer.borderWidth = 0.6f;
        playButton.layer.masksToBounds = YES;
        playButton.layer.cornerRadius = 4.0f;
        playButton.titleLabel.font = [UIFont systemFontOfSize:14*kWJFontCoefficient];
        [self.contentView addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-(10*kWJWidthCoefficient));
            make.size.mas_equalTo(CGSizeMake(60*kWJWidthCoefficient, 32*kWJHeightCoefficient));
        }];
        self.playButton = playButton;

    }
    
    return self;
}

- (void)playVideoAction:(UIButton *)sender {
    
    if(self.playBlock){
        self.playBlock(sender);
    }
}


- (void)showData:(TaskEntity *)taskEntity {
    
    self.taskEntity = taskEntity;
    
    //获取文件的总大小
    NSMutableDictionary *fileContentDic = [NSMutableDictionary dictionaryWithContentsOfFile:MPTotalLengthFullpath];
    
    NSString *totalMBExpectedRead = fileContentDic[MPFileName(taskEntity.downLoadUrl)];
    
    self.videoImageView.image = [UIImage imageNamed:@"video"];
    
    self.downloadUrl = taskEntity.downLoadUrl;
    self.titleLabel.text = taskEntity.name;
    
    
    self.informationLabel.text = [NSString stringWithFormat:@"%.1fMB | %@",[totalMBExpectedRead integerValue]/(1024*1024.0),taskEntity.completeTime];
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
}

@end
