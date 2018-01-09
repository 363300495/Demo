//
//  CustomVideoListCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CustomVideoListCell.h"

@interface CustomVideoListCell ()

@property (nonatomic,strong) UIImageView *videoImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *informationLabel;

@property (nonatomic,strong) UILabel *totalSizeLabel;

@property (nonatomic,strong) UIButton *downloadButton;



@end

@implementation CustomVideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createViewAutoLayout];
        
    }
    return self;
}

- (void)createViewAutoLayout {
    
    WEAKSELF(weakSelf);
    
    UIImageView *videoImageView = [[UIImageView alloc] init];
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
    }];
    self.titleLabel = titleLabel;
    
    
    UILabel *totalSizeLabel = [[UILabel alloc] init];
    totalSizeLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
    totalSizeLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [self.contentView addSubview:totalSizeLabel];
    [totalSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.centerY.equalTo(titleLabel);
    }];
    self.totalSizeLabel = totalSizeLabel;
    
    
    
    UILabel *informationLabel = [[UILabel alloc] init];
    informationLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
    informationLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [self.contentView addSubview:informationLabel];
    [informationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-(80*kWJWidthCoefficient));
    }];
    self.informationLabel = informationLabel;
    
    
    
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downloadButton.layer.masksToBounds = YES;
    downloadButton.layer.cornerRadius = 4.0f;
    downloadButton.titleLabel.font = [UIFont systemFontOfSize:14*kWJFontCoefficient];
    [self.contentView addSubview:downloadButton];
    [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-(10*kWJWidthCoefficient));
        make.size.mas_equalTo(CGSizeMake(60*kWJWidthCoefficient, 32*kWJHeightCoefficient));
    }];
    self.downloadButton = downloadButton;
}


- (void)setModel:(VideoModel *)model {
    
    _model = model;
    
    if(model.img_url.length > 0){
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"video"]];
    }else{
        self.videoImageView.image = [UIImage imageNamed:@"video"];
    }
    
    
    self.titleLabel.text = model.name;

    self.informationLabel.text = model.content;
    
    self.totalSizeLabel.text = [NSString stringWithFormat:@"%@MB",model.size];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *downLoadUrl = [NSString stringWithFormat:@"%@",model.down_url];
    
    if(downLoadUrl.length >0){
        
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
        
        MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:downLoadUrl];
        
        switch (taskState) {
            case MPTaskCompleted:
                
                [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
                self.downloadButton.backgroundColor = [UIColor lightGrayColor];
                
                break;
            case MPTaskExistTask:
                
                [self.downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
                self.downloadButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
                
                break;
            case MPTaskNoExistTask:
                
                [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
                self.downloadButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
                break;
            default:
                break;
        }
    }
}

- (void)downloadAction:(UIButton *)sender {
    
    if(_delegete && [_delegete respondsToSelector:@selector(addDownLoadTaskAction:)])
    
    [_delegete addDownLoadTaskAction:self.index];
}

@end
