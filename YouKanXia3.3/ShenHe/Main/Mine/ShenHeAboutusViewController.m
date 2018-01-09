//
//  ShenHeAboutusViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeAboutusViewController.h"

@interface ShenHeAboutusViewController ()

@end

@implementation ShenHeAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"关于我们";
    
}

- (void)createView {
    
    WEAKSELF(weakSelf);
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.text = [NSString stringWithFormat:@"       “%@”是一款%@专用网络连接工具，可以“搜索”周边的%@网络(专属WiFi网络)，并查看网络强度。",DISPLAYNAME,PREVIOUSNAME,PREVIOUSNAME];
    titleLabel1.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel1.numberOfLines = 0;
    titleLabel1.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(weakSelf.view).offset(80*kWJHeightCoefficient);
        make.height.mas_equalTo(40);
    }];
    
    if(IPHONE5 || IPHONE6){
        [titleLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
    }
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.text = [NSString stringWithFormat:@"       可以一键连接%@网络，畅享专网体验。",PREVIOUSNAME];
    titleLabel2.numberOfLines = 0;
    titleLabel2.font = [UIFont systemFontOfSize:15.0f];
    titleLabel2.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [self.view addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel1);
        make.right.equalTo(titleLabel1);
        make.top.equalTo(titleLabel1.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    if(IPHONE5){
        [titleLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    }
    
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.text = @"       产品反馈：support@ykxia.com";
    titleLabel3.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel3.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:titleLabel3];
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(titleLabel2.mas_bottom).offset(30);
    }];
    
    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.text = @"       商务合作：bussness@ykxia.com";
    titleLabel4.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel4.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:titleLabel4];
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(titleLabel3.mas_bottom);
    }];
    
    UILabel *titleLabel5 = [[UILabel alloc] init];
    titleLabel5.text = @"       官方网站：http://www.ykxia.com";
    titleLabel5.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel5.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:titleLabel5];
    [titleLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(titleLabel4.mas_bottom);
    }];
    
    
    //退出登录
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    //普通状态
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [exitButton addTarget:self action:@selector(onClickExitLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-80);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    if(IPHONE5){
        [exitButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(-50);
        }];
    }
    
    NSString *status = [YKXDefaultsUtil getPhonenumberStatus];
    if([status isEqualToString:SPECIALPHONENUMBER]){
        
        exitButton.hidden = NO;
    }else{
        
        exitButton.hidden = YES;
    }
}


- (void)onClickExitLogin{
    
    [YKXCommonUtil showHudWithTitle:@"退出登录中" view:self.view.window];
    
    [self performSelector:@selector(exitSuccess) withObject:nil afterDelay:0.5 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    
}


- (void)exitSuccess{
    
    [YKXCommonUtil hiddenHud];
    [YKXCommonUtil showToastWithTitle:@"退出登录成功" view:self.view.window];
    
    //清空特殊号码登录信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phonenumber"];
    
    //发送通知修改登录信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_EXIT_STAUS_CHANGE_FREQUENCY object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_EXIT_MESSAGE_FREQUENCY object:nil];
    
    [super onClickBack];
}

@end
