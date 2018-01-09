//
//  YKXVideoPlayViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/10/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXVideoPlayViewController.h"

@interface YKXVideoPlayViewController ()

/**
 播放器
 */
@property (nonatomic,strong) ZFPlayerView        *playerView;


@property (nonatomic,strong) ZFPlayerModel *playerModel;

@property (nonatomic,strong) UIView *playerFatherView;

@end

@implementation YKXVideoPlayViewController

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    [self.playerView resetPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc {
    [super createNavc];
    
    //设置导航栏的标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160*kWJWidthCoefficient, 44)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160*kWJWidthCoefficient, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.text = self.playTitle;
    
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    
    
    //右侧下载按钮
    UIButton *downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadButton.frame = CGRectMake(0, 0, 22, 22);
    [downLoadButton setBackgroundImage:[UIImage imageNamed:@"downloadVideo"] forState:UIControlStateNormal];
    [downLoadButton addTarget:self action:@selector(downLoadVideoAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downLoadBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:downLoadButton];
    
    self.navigationItem.rightBarButtonItem = downLoadBarButtonItem;
    
    if(self.downloadURL.length == 0){
        downLoadButton.hidden = YES;
    }
}


- (void)createView {
    
    UIView *bgVideoView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgVideoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgVideoView];

    
    UIImageView *picImageView = [[UIImageView alloc] init];
    picImageView.userInteractionEnabled = YES;
    //设置图片大小比例填充
    picImageView.contentMode = UIViewContentModeScaleAspectFit;
    picImageView.image = ZFPlayerImage(@"ZFPlayer_loading_bgView");
    [bgVideoView addSubview:picImageView];
    
    [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgVideoView);
        make.height.mas_equalTo(SCREEN_WIDTH*9/16);
        make.centerY.equalTo(bgVideoView);
    }];
    
    self.playerFatherView = picImageView;
    
    
    // 代码添加playerBtn到imageView上
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [picImageView addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(picImageView);
        make.width.height.mas_equalTo(50);
    }];
    
    
   
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        SRAlertView *alertView = [SRAlertView sr_alertViewVideoPlaysuperVC:self animationStyle:SRAlertViewAnimationTopToCenterSpring];
        [alertView showVideoPlayNative];
        
    }
}


- (BOOL)shouldAutorotate {
    
    return NO;
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        // 可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    }
    return _playerView;
}



- (void)play:(UIButton *)sender {
    
    _playerModel = [[ZFPlayerModel alloc] init];
    _playerModel.title            = self.playTitle;

    _playerModel.videoURL = [NSURL fileURLWithPath:MPFileFullpath(self.playURL)];
    
    _playerModel.fatherView = self.playerFatherView;
    
    _playerModel.displayType = @"2";

    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:_playerModel];
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
}

#pragma mark 下载
- (void)downLoadVideoAction {
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *downLoadUrl = [NSString stringWithFormat:@"%@",self.downloadURL];
    
    if(downLoadUrl.length > 0){
        
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
        
        MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:downLoadUrl];
        
        switch (taskState) {
            case MPTaskCompleted:
                
                [YKXCommonUtil showToastWithTitle:@"下载完成，请到[下载管理]中查看" view:self.view.window];
                
                break;
            case MPTaskExistTask:
                
                [YKXCommonUtil showToastWithTitle:@"正在下载，请到[下载管理]中查看进度" view:self.view.window];
                
                break;
            case MPTaskNoExistTask:
            {
                //这里给taskEntity赋值
                MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                downLoadEntity.downLoadUrlString = downLoadUrl;
                downLoadEntity.extra = @{@"name":self.playTitle};
                [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                
                [YKXCommonUtil showToastWithTitle:@"添加成功，正在下载" view:self.view.window];
                
            }
                break;
            default:
                break;
        }
    }
}


@end
