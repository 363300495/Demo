//
//  PhoneBindViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/22.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "PhoneBindViewController.h"
#import "YKXCustomPhoneView.h"
#import "YKXCustomCodeView.h"

@interface PhoneBindViewController () <UITextFieldDelegate>

@property (nonatomic,strong) YKXCustomPhoneView *rootPhoneView;

@property (nonatomic,strong) YKXCustomCodeView *rootCodeView;

//倒计时秒数
@property (nonatomic,assign) NSInteger runLoopTimes;
//倒计时计时器
@property (nonatomic,strong) NSTimer *unregisteredTimer;

@end

@implementation PhoneBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"手机绑定";
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
        
        //手机唯一码
        NSString *openUDID = [OpenUDID value];
        
        NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
        //时间戳
        NSString *timeStamp = [YKXCommonUtil longLongTime];
        //获取6位随机数
        NSString *randCode = [YKXCommonUtil getRandomNumber];
        NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",phoneNumber,@"1",@"2",timeStamp,YOYO,randCode];
        //获取签名
        NSString *sign = [MyMD5 md5:tempStr];
        
        [HttpService loadDataPostMobile:phoneNumber imei:openUDID versionCode:versionCode type:@"1" devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
            
            
            NSString *errorCode = responseObject[@"error_code"];
            
            if([errorCode isEqualToString:@"40004"]){
                [YKXCommonUtil showToastWithTitle:@"手机号码不合法" view:self.view.window];
                
            }else if([errorCode isEqualToString:@"40005"]){
                [YKXCommonUtil showToastWithTitle:@"验证码类型不合法" view:self.view.window];
                
            }else if([errorCode isEqualToString:@"40006"]){
                [YKXCommonUtil showToastWithTitle:@"60秒内只能发送一次验证码" view:self.view.window];
                
            }else if([errorCode isEqualToString:@"40007"]){
                [YKXCommonUtil showToastWithTitle:@"验证码发送失败" view:self.view.window];
                
            }else if([errorCode isEqualToString:@"0"]){
                
                [YKXCommonUtil showToastWithTitle:@"验证码发送成功" view:self.view.window];
                
                _unregisteredTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runLoop) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_unregisteredTimer forMode:NSRunLoopCommonModes];
                
            }else{
                
                [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
            }
            
        } failure:^(NSError *error) {
            
            [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
        }];
    };
    
    //验证按钮
    UIButton *identifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [identifyButton setTitle:@"立即绑定" forState:UIControlStateNormal];
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
    
    [YKXCommonUtil showHudWithTitle:@"手机号绑定中" view:self.view.window];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *channelId = @"0";
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    NSString *devType = @"2";
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,channelId,devType,timeStamp,YOYO,randCode];
    
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataBindUserInfoUid:uid token:token channel_id:channelId versionCode:versionCode type:self.bindType mobile:phoneNumber smsCode:code headImgurl:@"" devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40000"]){
            
            [YKXCommonUtil showToastWithTitle:@"查询出错" view:self.view.window];
            
        }else if ([errorCode isEqualToString:@"40001"] || [errorCode isEqualToString:@"40002"] || [errorCode isEqualToString:@"40003"]){
            
            [YKXCommonUtil showToastWithTitle:@"请求数据错误" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"40004"]){
            
            [YKXCommonUtil showToastWithTitle:@"手机号码不合法" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"40005"]){
            
            [YKXCommonUtil showToastWithTitle:@"验证码错误" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"40006"]){
            
            [YKXCommonUtil showToastWithTitle:@"验证码已过期" view:self.view.window];
            
        }else if ([errorCode isEqualToString:@"0"]){
            
        
            NSString *mobile = responseObject[@"mobile"];
            NSString *mobileNickname = [NSString stringWithFormat:@"手机号 (%@)",mobile];
            
            if(_delegete && [_delegete respondsToSelector:@selector(phoneBindNickname:index:)]){
                
                [_delegete phoneBindNickname:mobileNickname index:self.index];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
 
        }else{
            [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
