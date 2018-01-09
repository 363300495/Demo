//
//  YKXLoginViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/7/1.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXLoginViewController.h"
#import "YKXCustomUsernameView.h"
#import "YKXCustomPasswordView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "YKXRegisterViewController.h"
#import "PhoneLoginViewController.h"
#import "YKXUserProtocolController.h"
@interface YKXLoginViewController () <YKXRegisterViewControllerDelegate>

@property (nonatomic,strong) YKXCustomUsernameView *rootUsernameView;

@property (nonatomic,strong) YKXCustomPasswordView *rootPasswordView;

@end

@implementation YKXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLoginView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"账号登录";
}

- (void)createLoginView{
    
    WEAKSELF(weakSelf);

    self.view.backgroundColor = [UIColor whiteColor];
    TPKeyboardAvoidingScrollView *rootScrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [rootScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:rootScrollView];
    [rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuide).with.offset(0.0);
        make.left.equalTo(weakSelf.view).with.offset(0.0);
        make.bottom.equalTo(weakSelf.view).with.offset(0.0);
        make.right.equalTo(weakSelf.view).with.offset(0.0);
    }];

    UIView *rootContainerView = [[UIView alloc] init];
    [rootScrollView addSubview:rootContainerView];
    [rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootScrollView);
        make.width.equalTo(rootScrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT-63);
    }];
    
    //用户名
    YKXCustomUsernameView *rootUsernameView = [[YKXCustomUsernameView alloc] init];
    rootUsernameView.usernamePlaceholder = @"请输入用户名";
    [rootContainerView addSubview:rootUsernameView];
    [rootUsernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootContainerView);
        make.top.equalTo(@(80));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootUsernameView = rootUsernameView;
    
    //密码
    YKXCustomPasswordView *rootPasswordView = [[YKXCustomPasswordView alloc] init];
    rootPasswordView.passwordPlaceHolder = @"请输入密码";
    [rootContainerView addSubview:rootPasswordView];
    [rootPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootContainerView);
        make.top.equalTo(rootUsernameView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootPasswordView = rootPasswordView;
    
    
    //用户名登录
    UIButton *userloginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    userloginButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [userloginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [userloginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userloginButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    userloginButton.layer.cornerRadius = 6.0f;
    userloginButton.layer.masksToBounds = YES;
    [userloginButton addTarget:self action:@selector(onClickUserLogin:) forControlEvents:UIControlEventTouchUpInside];
    [rootContainerView addSubview:userloginButton];
    [userloginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootContainerView);
        make.top.equalTo(rootPasswordView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 40));
    }];
    
    //游客登录
    UIButton *visitorLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [visitorLoginButton setTitle:@"一键登录" forState:UIControlStateNormal];
    [visitorLoginButton setTitleColor:[UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR] forState:UIControlStateNormal];
    visitorLoginButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [visitorLoginButton addTarget:self action:@selector(visitorLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [rootContainerView addSubview:visitorLoginButton];
    
    [visitorLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userloginButton.mas_bottom).offset(15);
        make.left.equalTo(rootContainerView).offset(35);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    
    //快速注册
    UIButton *userRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userRegisterButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [userRegisterButton setTitleColor:[UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR] forState:UIControlStateNormal];
    userRegisterButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [userRegisterButton addTarget:self action:@selector(onClickUserRegister:) forControlEvents:UIControlEventTouchUpInside];
    [rootContainerView addSubview:userRegisterButton];
    [userRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(visitorLoginButton.mas_top);
        make.right.equalTo(rootContainerView.mas_right).offset(-35);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    
    //第三方登录
    UIView *rootExpandView = [[UIView alloc] init];
    [rootContainerView addSubview:rootExpandView];
    [rootExpandView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(SCREEN_HEIGHT-200-SafeAreaTopHeight));
        make.left.equalTo(rootContainerView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"第三方登录";
    textLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    textLabel.font = [UIFont systemFontOfSize:16.0f];
    [rootExpandView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootExpandView);
        make.top.equalTo(@(0));
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.image = [UIImage imageNamed:@"icon_login_expand_title_left_line"];
    [rootExpandView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textLabel.mas_left).offset(-2);
        make.centerY.equalTo(textLabel);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.image = [UIImage imageNamed:@"icon_login_expand_title_right_line"];
    [rootExpandView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textLabel.mas_right).offset(2);
        make.centerY.equalTo(textLabel);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
    UIView *rootShareView = [[UIView alloc] init];
    [rootContainerView addSubview:rootShareView];
    [rootShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootContainerView);
        make.top.equalTo(textLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 70));
    }];

    
    NSArray *itemImageArray = @[@"weChat",@"qq",@"mobile"];
    CGFloat leftWidth = (SCREEN_WIDTH-180)/6;
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < 3; idx++) {
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setBackgroundImage:[UIImage imageNamed:itemImageArray[idx]] forState:UIControlStateNormal];
        
        [itemButton addTarget:self action:@selector(onClickThirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 1000+idx;
        [rootShareView addSubview:itemButton];
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(@(0));
                make.left.equalTo(@(leftWidth));
            }else{
                
                make.top.equalTo(lastButton.mas_top).offset(0.0);
                make.left.equalTo(lastButton.mas_right).offset(2*leftWidth);
            }
        }];
        lastButton = itemButton;
    }
    
    
    YLButton *promptButton = [YLButton buttonWithType:UIButtonTypeCustom];
    [promptButton setTitle:@"我同意《用户使用协议》" forState:UIControlStateNormal];
    promptButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [promptButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
    [promptButton setImage:[UIImage imageNamed:@"confirmSelect.jpg"] forState:UIControlStateNormal];
    [promptButton setImage:[UIImage imageNamed:@"confirmSelect.jpg"] forState:UIControlStateHighlighted];
    promptButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    promptButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    promptButton.imageRect = CGRectMake(0, 0, 20, 20);
    promptButton.titleRect = CGRectMake(20, 0, 164, 20);
    [promptButton addTarget:self action:@selector(userProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    [rootContainerView addSubview:promptButton];
    [promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootContainerView);
        make.top.equalTo(rootShareView.mas_bottom).offset(24);
        make.width.mas_equalTo(184);
        make.height.mas_equalTo(20);
    }];
    
}


#pragma mark 点击事件
#pragma mark 用户注册
- (void)onClickUserRegister:(UIButton *)sender{
    
    //关掉键盘
    [self.view endEditing:YES];
    
    YKXRegisterViewController *registerVC = [[YKXRegisterViewController alloc] init];
    registerVC.delegete = self;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark 用户名登录
- (void)onClickUserLogin:(UIButton *)sender{
    
    NSString *username = self.rootUsernameView.usernameTextFeild.text;
    NSString *password = self.rootPasswordView.passwordTextFeild.text;
    
    if(username.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入用户名" view:self.view.window];
        return ;
    }
    if(password.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入密码" view:self.view.window];
        return ;
    }
    if(username.length < 6 || username.length > 16){
        [YKXCommonUtil showToastWithTitle:@"用户名应为6-16位" view:self.view.window];
        return;
    }
    if([YKXCommonUtil containsNumberLetter:username] == NO){
        [YKXCommonUtil showToastWithTitle:@"用户名只能包含字母、数字或下划线" view:self.view.window];
        return;
    }
    if(password.length < 6 || password.length > 16){
        [YKXCommonUtil showToastWithTitle:@"密码应为6-16位" view:self.view.window];
        return;
    }
    if([YKXCommonUtil containsNumberLetter:password] == NO){
        [YKXCommonUtil showToastWithTitle:@"密码只能包含字母、数字或下划线" view:self.view.window];
        return;
    }
    
    
    [YKXCommonUtil showHudWithTitle:@"登录中" view:self.view.window];
    
    NSString *phoneModel = [YKXCommonUtil iphoneType];
    
    //手机唯一码
    NSString *openUDID = [OpenUDID value];
    
    //手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    NSString *channelId = @"0";
    NSString *mobile = @"0";
    NSString *devType = @"2";
    NSString *loginType = @"5";
    
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",channelId,mobile,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataUserLoginPostLoginType:loginType versionCode:versionCode username:username password:password channelId:channelId model:phoneModel imei:openUDID sysversion:phoneVersion devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40000"] || [errorCode isEqualToString:@"40001"] || [errorCode isEqualToString:@"40002"] || [errorCode isEqualToString:@"40003"]){
            
            [YKXCommonUtil showToastWithTitle:@"请求数据错误" view:self.view.window];
            
        } else if([errorCode isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"登录成功" view:self.view.window];
            
            //保存用户登录信息
            NSDictionary *loginUserInfo = responseObject[@"data"];
            if([loginUserInfo isKindOfClass:[NSNull class]]){
                return ;
            }
    
            [YKXDefaultsUtil setLoginUserInfo:loginUserInfo];
            
            
            //登录成功返回上一个界面，发出通知,修改登录页面、优看界面信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
            
            //修改消息界面信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
            
            //修改APP启动信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];
            
            [self.view endEditing:YES];
            [super onClickBack];
            
        }else{
           [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
        //登录成功后修改登录信息
    } failure:^(NSError *error) {
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
    
}

#pragma mark 游客登录
- (void)visitorLoginAction:(UIButton *)sender{
    
    [YKXCommonUtil showHudWithTitle:@"登录中" view:self.view.window];
    
    //手机型号
    NSString *phoneModel = [YKXCommonUtil iphoneType];
    
    //手机唯一码
    NSString *openUDID = [OpenUDID value];
    
    //手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *channelId = @"0";
    NSString *mobile = @"0";
    NSString *devType = @"2";
    NSString *loginType = @"4";
    
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",channelId,mobile,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataVisitorLoginPostLoginType:loginType versionCode:versionCode channel_id:channelId model:phoneModel imei:openUDID syversion:phoneVersion devtype:devType timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [YKXCommonUtil hiddenHud];
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40000"] || [errorCode isEqualToString:@"40001"] || [errorCode isEqualToString:@"40002"] || [errorCode isEqualToString:@"40003"]){
            
            [YKXCommonUtil showToastWithTitle:@"请求数据错误" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"登录成功" view:self.view.window];
            //保存用户登录信息
            NSDictionary *loginUserInfo = responseObject[@"data"];
            if([loginUserInfo isKindOfClass:[NSNull class]]){
                return ;
            }
            
            [YKXDefaultsUtil setLoginUserInfo:loginUserInfo];
            
            //登录成功返回上一个界面，发出通知,修改登录页面、优看界面信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
            
            //修改消息界面信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
            
            //修改APP启动信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];
            
            [super onClickBack];
        }else{
            
            [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        //设置超时时间6秒后会自动提示失败
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}

#pragma mark 微信、QQ、手机登录
- (void)onClickThirdLogin:(UIButton *)sender{
    
    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    if(!([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"])){
        
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"当前网络不可用" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            
        }];
        [alertView show];
        
        return;
    }
    
    UMSocialPlatformType platformType;
    NSString *platformStr;
    NSString *loginType;
    if(sender.tag == 1000){
        
        platformType = UMSocialPlatformType_WechatSession;
        platformStr = @"微信";
        loginType = @"2";
        
        
        [self loginPlatformType:platformType platformStr:platformStr loginType:loginType];
        
    }else if (sender.tag == 1001){
        
        platformType = UMSocialPlatformType_QQ;
        platformStr = @"QQ";
        loginType = @"3";
    
        [self loginPlatformType:platformType platformStr:platformStr loginType:loginType];
    
    }else{//手机登录
        
        PhoneLoginViewController *phoneLoginVC = [[PhoneLoginViewController alloc] init];
        [self.navigationController pushViewController:phoneLoginVC animated:YES];
    }

}


- (void)loginPlatformType:(UMSocialPlatformType)platformType platformStr:(NSString *)platformStr loginType:(NSString *)loginType{
    
    
    if(![[UMSocialManager defaultManager] isInstall:platformType]){
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:[NSString stringWithFormat:@"您还未安装%@客户端",platformStr] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            
        }];
        [alertView show];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        [YKXCommonUtil showHudWithTitle:@"登录中" view:self.view.window];
        
        if (!error) {
            
            UMSocialUserInfoResponse *resp = result;
            NSDictionary *respDict = resp.originalResponse;
            
            NSString *openId = resp.openid;
            NSString *nickname = resp.name;
            NSString *sex = resp.unionGender;
            if([sex isEqualToString:@"男"]){
                sex = @"1";
            }else{
                sex = @"2";
            }
            NSString *headImageUrl = resp.iconurl;
            NSString *province = respDict[@"province"];
            NSString *city = respDict[@"city"];
            
            if(openId == nil || openId.length == 0){
                openId = @"0";
            }
            if(nickname == nil || nickname.length == 0){
                nickname = @"0";
            }
            if(sex == nil || sex.length == 0){
                sex = @"0";
            }
            if(headImageUrl == nil || headImageUrl.length == 0){
                headImageUrl = @"0";
            }
            if(province == nil || province.length == 0){
                province = @"0";
            }
            if(city == nil || city.length == 0){
                city = @"0";
            }
            
            //手机型号
            NSString *phoneModel = [YKXCommonUtil iphoneType];
            
            //手机唯一码
            NSString *openUDID = [OpenUDID value];
            
            //手机系统版本
            NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            
            NSString *channelId = @"0";
            NSString *devtype = @"2";
            
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",channelId,openId,devtype,timeStamp,YOYO,randCode];
            
            //获取签名
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataqqOrWechatLoginPostLoginType:loginType versionCode:versionCode channel_id:channelId openId:openId nickName:nickname sex:sex headImageURL:headImageUrl province:province city:city model:phoneModel imei:openUDID syversion:phoneVersion devtype:devtype timestamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
                
                [YKXCommonUtil hiddenHud];
                
                NSString *errorCode = responseObject[@"error_code"];
                
                if([errorCode isEqualToString:@"40000"] || [errorCode isEqualToString:@"40001"] || [errorCode isEqualToString:@"40002"] || [errorCode isEqualToString:@"40003"]){
                    
                    [YKXCommonUtil showToastWithTitle:@"请求数据错误" view:self.view.window];
                    
                }else if([errorCode isEqualToString:@"0"]){
                    
                    [YKXCommonUtil showToastWithTitle:@"登录成功" view:self.view.window];
                    
                    //保存用户登录信息
                    NSDictionary *loginUserInfo = responseObject[@"data"];
                    if([loginUserInfo isKindOfClass:[NSNull class]]){
                        return ;
                    }

                    [YKXDefaultsUtil setLoginUserInfo:loginUserInfo];
                    
                    //登录成功返回上一个界面，发出通知,修改登录页面、优看界面信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
                    
                    //修改消息界面信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
                    
                    //修改APP启动信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];
                    
                    [super onClickBack];
                    
                }else{
                    
                    [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
                }
                
            } failure:^(NSError *error) {
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
        }else{
            [YKXCommonUtil hiddenHud];
            [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
        }
    }];
}

#pragma mark 用户协议
- (void)userProtocolAction:(UIButton *)sender{
    
    YKXUserProtocolController *userProtocolVC = [[YKXUserProtocolController alloc] init];
    [self.navigationController pushViewController:userProtocolVC animated:YES];
}


- (void)loginUsername:(NSString *)username password:(NSString *)password{
    
    self.rootUsernameView.usernameTextFeild.text = username;
    self.rootPasswordView.passwordTextFeild.text = password;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
