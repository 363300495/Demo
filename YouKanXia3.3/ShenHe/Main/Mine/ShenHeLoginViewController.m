//
//  ShenHeLoginViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeLoginViewController.h"
#import "YKXCustomPhoneView.h"
#import "YKXCustomCodeView.h"

@interface ShenHeLoginViewController () <UITextFieldDelegate>

@property (nonatomic,strong) YKXCustomPhoneView *rootPhoneView;

@property (nonatomic,strong) YKXCustomCodeView *rootCodeView;

//倒计时秒数
@property (nonatomic,assign) NSInteger runLoopTimes;
//倒计时计时器
@property (nonatomic,strong) NSTimer *unregisteredTimer;

@end

@implementation ShenHeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"手机登录";
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"输入手机号码";
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    if(IPHONE5){
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(@(40));
            make.height.mas_equalTo(30);
        }];
    }else{
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(@(70));
            make.height.mas_equalTo(30);
        }];
    }
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"我们不会公开显示您的号码";
    detailLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
    }];
    
    //手机号码根视图
    YKXCustomPhoneView *rootPhoneView = [[YKXCustomPhoneView alloc] init];
    [self.view addSubview:rootPhoneView];
    [rootPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(detailLabel.mas_bottom).offset(30);
        make.size.mas_offset(CGSizeMake(220, 50));
    }];
    rootPhoneView.phoneTextFeild.delegate = self;
    self.rootPhoneView = rootPhoneView;
    
    //验证码根视图
    YKXCustomCodeView *rootCodeView = [[YKXCustomCodeView alloc] init];
    [self.view addSubview:rootCodeView];
    [rootCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(rootPhoneView.mas_bottom).offset(0);
        make.size.mas_offset(CGSizeMake(220, 50));
    }];
    rootCodeView.codeTextFeild.delegate = self;
    self.rootCodeView = rootCodeView;
    
    
    
    //点击发送按钮,获取验证码
    rootCodeView.sendMessageBlock = ^{
        
        //获取当前输入的电话号码
        NSString *phoneNumber = rootPhoneView.phoneTextFeild.text;
        if(phoneNumber.length == 0){
            [YKXCommonUtil showToastWithTitle:@"请输入手机号" view:self.view.window];
            return ;
        }
        
        if([YKXCommonUtil isMobileNumber:phoneNumber] == NO){
            [YKXCommonUtil showToastWithTitle:@"请输入正确的手机号码" view:self.view.window];
            return ;
        }
    };
    
    
    //验证按钮
    UIButton *identifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [identifyButton setTitle:@"立即验证" forState:UIControlStateNormal];
    identifyButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [identifyButton addTarget:self action:@selector(onClickIdentify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:identifyButton];
    [identifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(rootCodeView.mas_bottom).offset(20);
        make.size.mas_offset(CGSizeMake(80, 40));
    }];

}


#pragma mark 点击事件


- (void)showActivity{
    
    [YKXCommonUtil hiddenHud];
    [YKXCommonUtil showToastWithTitle:@"此用户不存在或验证码错误" view:self.view.window];
}

// 倒计时
- (void)runLoop{
    
    self.rootCodeView.sendButton.userInteractionEnabled = NO;
    _runLoopTimes++;
    
    [self.rootCodeView.sendButton setTitle:[NSString stringWithFormat:@"%ld秒", 60-_runLoopTimes] forState:UIControlStateNormal];
    
    if (_runLoopTimes == 60) {
        [_unregisteredTimer invalidate];
        _unregisteredTimer = nil;
        self.rootCodeView.sendButton.userInteractionEnabled = YES;
        _runLoopTimes = 0;
        [self.rootCodeView.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    }
}

//立即验证按钮
- (void)onClickIdentify{
    
    NSString *phoneNumber = self.rootPhoneView.phoneTextFeild.text;
    NSString *code = self.rootCodeView.codeTextFeild.text;
    if(phoneNumber.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入手机号" view:self.view.window];
        return ;
    }
    
    if([YKXCommonUtil isMobileNumber:phoneNumber] == NO){
        [YKXCommonUtil showToastWithTitle:@"请输入正确的手机号码" view:self.view.window];
        return ;
    }
    
    if(code.length == 0){
        [YKXCommonUtil showToastWithTitle:@"验证码为空" view:self.view.window];
        return ;
    }
    
    [YKXCommonUtil showHudWithTitle:@"登录中" view:self.view.window];
    
    if([phoneNumber isEqualToString:SPECIALPHONENUMBER]){
        
        if([code isEqualToString:@"8090"]){
            [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:1 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        }else{
            [self performSelector:@selector(showActivity) withObject:nil afterDelay:1 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
        }
    }else{
        
        [self performSelector:@selector(showActivity) withObject:nil afterDelay:1 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//特殊号码登录成功
- (void)loginSuccess{
    
    [YKXCommonUtil hiddenHud];
    [YKXCommonUtil showToastWithTitle:@"登录成功" view:self.view.window];
    
    [YKXDefaultsUtil setPhonenumberStatus:SPECIALPHONENUMBER];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_LOGIN_MESSAGE_FREQUENCY object:nil];
    [super onClickBack];
}

#pragma mark textField代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length == 1 && string.length == 0){
        return YES;
    }else if ([textField isEqual:self.rootPhoneView.phoneTextFeild]){//电话号码最多输入11位
        return  textField.text.length < 11;
    }else if ([textField isEqual:self.rootCodeView.codeTextFeild]){//验证码最多输入6位
        return textField.text.length < 6;
    }
    return YES;
}

@end
