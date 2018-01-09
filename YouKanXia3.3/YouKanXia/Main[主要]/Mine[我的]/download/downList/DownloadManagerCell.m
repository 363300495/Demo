//
//  CustomDownloadCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#define DownloadTool_Limit                           1024.0
#import "DownloadManagerCell.h"

@interface DownloadManagerCell ()

/** 视频图标 */
@property (nonatomic,strong) UIImageView *videoImageView;
/** 视频标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 视频进度条 */
@property (nonatomic,strong) UIProgressView *videoProgressView;
/** 下载的进度条数值 */
@property (nonatomic,strong) UILabel *progressLabel;
/** 下载的速度 */
@property (nonatomic,strong) UILabel *rateLabel;
/** 开始暂停按钮 */
@property (nonatomic,strong) UIButton *stopStartBtn;

@property (nonatomic,strong) NSDate *lastDate;

@property (nonatomic,assign) int64_t bytes;

@end

@implementation DownloadManagerCell

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
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-(80*kWJWidthCoefficient));
    }];
    self.titleLabel = titleLabel;
    
    
    UIButton *stopStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopStartBtn addTarget:self action:@selector(stopStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [stopStartBtn setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
    stopStartBtn.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
    stopStartBtn.layer.borderWidth = 0.6f;
    stopStartBtn.layer.masksToBounds = YES;
    stopStartBtn.layer.cornerRadius = 4.0f;
    stopStartBtn.titleLabel.font = [UIFont systemFontOfSize:14*kWJFontCoefficient];
    [stopStartBtn setBackgroundImage:[UIImage SDImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self.contentView addSubview:stopStartBtn];
    [stopStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-(10*kWJWidthCoefficient));
        make.size.mas_equalTo(CGSizeMake(60*kWJWidthCoefficient, 32*kWJHeightCoefficient));
    }];
    self.stopStartBtn = stopStartBtn;
    
    
    UIProgressView *videoProgressView = [[UIProgressView alloc] init];
    videoProgressView.trackTintColor = [UIColor colorWithHexString:LIGHT_COLOR];
    videoProgressView.progressTintColor = [UIColor colorWithHexString:@"#4EBAF6"];
    [self.contentView addSubview:videoProgressView];
    [videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(5*kWJHeightCoefficient);
        make.right.equalTo(stopStartBtn.mas_left).offset(-(10*kWJWidthCoefficient));
    }];
    self.videoProgressView = videoProgressView;
    
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
    progressLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [self.contentView addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(videoProgressView.mas_bottom).offset(5);
    }];
    self.progressLabel = progressLabel;
    
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
    rateLabel.font = [UIFont systemFontOfSize:12*kWJFontCoefficient];
    [self.contentView addSubview:rateLabel];
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(videoProgressView);
        make.top.equalTo(progressLabel);
    }];
    self.rateLabel = rateLabel;
}


- (void)showData:(TaskEntity *)taskEntity{
    
    _taskEntity = taskEntity;
    
     WEAKSELF(weakSelf);
    
    self.videoImageView.image = [UIImage imageNamed:@"video"];
    self.titleLabel.text = taskEntity.name;
    self.downloadUrl = taskEntity.downLoadUrl;
    
    self.videoProgressView.progress = taskEntity.progress;

    //获取当前的下载字节
    NSInteger totalMBRead = MPDownloadLength(taskEntity.downLoadUrl);
    
    //获取总的下载字节
    NSMutableDictionary *fileContentDic = [NSMutableDictionary dictionaryWithContentsOfFile:MPTotalLengthFullpath];

    NSString *totalMBExpectedRead = fileContentDic[MPFileName(taskEntity.downLoadUrl)];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",totalMBRead/(1024*1024.0),[totalMBExpectedRead integerValue]/(1024*1024.0)];

    
    if (taskEntity.taskDownloadState == TaskStateSuspended) {

        [self.stopStartBtn setTitle:@"开始" forState:UIControlStateNormal];
    }else if (taskEntity.taskDownloadState == TaskStateRunning){

        [self.stopStartBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{

        [self.stopStartBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    
   
    taskEntity.progressBlock = ^(CGFloat progress, int64_t bytes,CGFloat totalMBRead, CGFloat totalMBExpectedToRead) {
        
        weakSelf.videoProgressView.progress = progress;
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.1fMB/%.1fMB",totalMBRead/(1024*1024.0),totalMBExpectedToRead/(1024*1024.0)];
        
        //计算当前下载的速度
        NSDate *nowDate = [NSDate date];
        if(self.lastDate){
            
            NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:self.lastDate];
            
            self.bytes += bytes;
            
            if(timeInterval > 1){
                
                self.rateLabel.text = [NSString stringWithFormat:@"%@/S", [self calculationDataWithBytes:(self.bytes/timeInterval)]];
                
                self.lastDate = nowDate;
                self.bytes = 0;
            }
        }else{
            
            self.lastDate = [NSDate date];
        }
        
    };
    
    taskEntity.completeBlock = ^(TaskDownloadState mpDownloadState,NSString *downLoadUrlString) {
        if (mpDownloadState == TaskStateSuspended) {
            
            weakSelf.taskEntity.taskDownloadState = TaskStateSuspended;

            [self.stopStartBtn setTitle:@"开始" forState:UIControlStateNormal];
            
            self.rateLabel.text = nil;
            
        }else if (mpDownloadState == TaskStateRunning){
            weakSelf.taskEntity.taskDownloadState = TaskStateRunning;
            
            [self.stopStartBtn setTitle:@"暂停" forState:UIControlStateNormal];
            
            
        }
    };
}

- (void)stopStartAction:(UIButton *)sender {
    
    if (self.taskEntity.taskDownloadState == TaskStateRunning) {
        [[MusicPartnerDownloadManager sharedInstance] pause:self.downloadUrl];

        [self.stopStartBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else if (self.taskEntity.taskDownloadState == TaskStateSuspended){
        [[MusicPartnerDownloadManager sharedInstance] start:self.downloadUrl];

        [self.stopStartBtn setTitle:@"开始" forState:UIControlStateNormal];
    }else if(self.taskEntity.taskDownloadState == TaskStateFailed){
        [[MusicPartnerDownloadManager sharedInstance] start:self.downloadUrl];

        [self.stopStartBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
}



/**
 按字节计算文件大小
 
 @param tytes 字节数
 @return 文件大小字符串
 */
- (NSString *)calculationDataWithBytes:(int64_t)tytes
{
    NSString *result;
    double length;
    if (tytes > DownloadTool_Limit) {
        length = tytes/DownloadTool_Limit;
        if (length > DownloadTool_Limit) {
            length /= DownloadTool_Limit;
            if (length > DownloadTool_Limit) {
                length /= DownloadTool_Limit;
                if (length > DownloadTool_Limit) {
                    length /= DownloadTool_Limit;
                    result = [NSString stringWithFormat:@"%.1fTB", length];
                }
                else
                {
                    result = [NSString stringWithFormat:@"%.1fGB", length];
                }
            }
            else
            {
                result = [NSString stringWithFormat:@"%.1fMB", length];
            }
        }
        else
        {
            result = [NSString stringWithFormat:@"%.1fKB", length];
        }
    }
    else
    {
        result = [NSString stringWithFormat:@"%lliB", tytes];
    }
    
    return result;
}

@end
