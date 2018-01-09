//
//  ShenHeYouKanViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeYouKanViewController.h"
#import "YKXSpeedViewController.h"

@interface ShenHeYouKanViewController ()


//导航栏底部的横线
@property (nonatomic,strong) UIImageView *navBarHairlineImageView;

//添加的WiFi视图界面
@property (nonatomic,strong) UIView *rootWiFiView;
@property (nonatomic,strong) UILabel *resultLabel;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UIButton *wifiButton;
//@property (nonatomic,strong) UIButton *speedButton;

@end

@implementation ShenHeYouKanViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    self.navBarHairlineImageView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //再定义一个imageview来等同于这个黑线
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self createWiFiView];
}

//通过一个方法来找到这个黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark 创建WiFi界面
- (void)createWiFiView{
    
    WEAKSELF(weakSelf);
    UIView *rootWiFiView = [[UIView alloc] init];
    rootWiFiView.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [self.view addSubview:rootWiFiView];
    [rootWiFiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.mas_topLayoutGuide);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-49-64));
    }];
    self.rootWiFiView = rootWiFiView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"一键连接 - 优享品质";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:24.0f];
    [rootWiFiView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootWiFiView);
        make.top.equalTo(rootWiFiView).offset(20*kWJHeightCoefficient);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *wifiImageView = [[UIImageView alloc] init];
    wifiImageView.image = [UIImage imageNamed:@"ykwifibg"];
    [rootWiFiView addSubview:wifiImageView];
    [wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootWiFiView);
        make.top.equalTo(titleLabel.mas_bottom).offset(30*kWJHeightCoefficient);
        make.size.mas_equalTo(CGSizeMake(200*kWJWidthCoefficient, 200*kWJHeightCoefficient));
    }];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.font = [UIFont systemFontOfSize:20.0f];
    [rootWiFiView addSubview:resultLabel];
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootWiFiView);
        make.top.equalTo(wifiImageView.mas_bottom).offset(50*kWJHeightCoefficient);
        make.height.mas_equalTo(26);
    }];
    self.resultLabel = resultLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = [UIFont systemFontOfSize:14.0f];
    [rootWiFiView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootWiFiView);
        make.top.equalTo(resultLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(20);
    }];
    self.desLabel = desLabel;
    
    
    UIButton *wifiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wifiButton.backgroundColor = [UIColor whiteColor];
    [wifiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wifiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    wifiButton.layer.cornerRadius = 10;
    wifiButton.layer.masksToBounds = YES;
    [wifiButton addTarget:self action:@selector(onClickWiFiConnect) forControlEvents:UIControlEventTouchUpInside];
    [rootWiFiView addSubview:wifiButton];
    [wifiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootWiFiView);
        make.top.equalTo(desLabel.mas_bottom).offset(30*kWJHeightCoefficient);
        make.size.mas_equalTo(CGSizeMake(140*kWJWidthCoefficient, 36*kWJHeightCoefficient));
    }];
    self.wifiButton = wifiButton;
    
    //网络测速
    //    UIButton *speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    speedButton.backgroundColor = [UIColor whiteColor];
    //    [speedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [speedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //    [speedButton setTitle:@"网络测速" forState:UIControlStateNormal];
    //    speedButton.layer.cornerRadius = 10;
    //    speedButton.layer.masksToBounds = YES;
    //    [speedButton addTarget:self action:@selector(onClickSpeed) forControlEvents:UIControlEventTouchUpInside];
    //    [rootWiFiView addSubview:speedButton];
    //    [speedButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(rootWiFiView);
    //        make.top.equalTo(wifiButton.mas_bottom).offset([YKXAutoSizeUtil getAutosizeViewHeight:30]);
    //        make.size.mas_equalTo(CGSizeMake([YKXAutoSizeUtil getAutosizeViewWidth:140], [YKXAutoSizeUtil getAutosizeViewHeight:36]));
    //    }];
    //    speedButton.hidden = YES;
    //    self.speedButton = speedButton;
    
    NSTimer *wifiTime = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(setWiFiInfo) userInfo:nil repeats:YES];
    [wifiTime fire];
    [[NSRunLoop mainRunLoop] addTimer:wifiTime forMode:NSRunLoopCommonModes];
}

- (void)setWiFiInfo{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    if([networkStatus isEqualToString:@"GPS"]){
        
        self.resultLabel.text = @"正在使用[移动网络]";
        [self.wifiButton setTitle:@"连接WiFi" forState:UIControlStateNormal];
        
    }else if([networkStatus isEqualToString:@"wifi"]){
        
        NSString *network = [YKXCommonUtil currentWifiSSID];
        
        if(network == nil){
            self.resultLabel.text = @"成功连接";
        }else{
            self.resultLabel.text = [NSString stringWithFormat:@"成功连接%@",[YKXCommonUtil currentWifiSSID]];
        }
        
        [self.wifiButton setTitle:@"切换WiFi" forState:UIControlStateNormal];
    }else{
        self.resultLabel.text = @"请检查网络设置";
        
        [self.wifiButton setTitle:@"连接WiFi" forState:UIControlStateNormal];
    }
    
    self.desLabel.text = [NSString stringWithFormat:@"无法检测%@专网",PREVIOUSNAME];
    
    //    if([[YKXCommonUtil currentWifiSSID] isEqualToString:@"优看网络"]){
    //        self.desLabel.text = @"已连接优看专网";
    //        self.speedButton.hidden = NO;
    //    }else{
    //        self.desLabel.text = @"无法检测优看专网";
    //        self.speedButton.hidden = YES;
    //    }
}

//进入WiFi连接页面
- (void)onClickWiFiConnect{
    
    NSString *status = [YKXDefaultsUtil getPhonenumberStatus];
    if([status isEqualToString:SPECIALPHONENUMBER]){
        
        [self skipToSystemWiFi];
    }else{
        
        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
    }
}

//跳转到系统WiFi界面
- (void)skipToSystemWiFi{
    
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 10.0){
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

//- (void)onClickSpeed{
//
//    NSString *status = [YKXDefaultsUtil getPhonenumberStatus];
//    if([status isEqualToString:SPECIALPHONENUMBER]){
//
//        YKXSpeedViewController *ykxSpeedVC = [[YKXSpeedViewController alloc] init];
//        [self.navigationController pushViewController:ykxSpeedVC animated:YES];
//
//    }else{
//
//        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
//    }
//}

@end
