//
//  YKXRegisterViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/18.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXRegisterViewController.h"
#import "YKXCustomUsernameView.h"
#import "YKXCustomPasswordView.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface YKXRegisterViewController ()

@property (nonatomic,strong) YKXCustomUsernameView *rootUsernameView;

@property (nonatomic,strong) YKXCustomUsernameView *rootPhonenumberView;

@property (nonatomic,strong) YKXCustomPasswordView *rootPasswordView;

@property (nonatomic,strong) YKXCustomPasswordView *rootConfirmPasswordView;

@end

@implementation YKXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"快速注册";
    
    //右侧的分享按钮
    UIButton *rightShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightShareButton.frame = CGRectMake(0, 0, 76, 22);
    rightShareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightShareButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [rightShareButton addTarget:self action:@selector(onClickFindPassword:) forControlEvents:UIControlEventTouchUpInside];
    rightShareButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightShareButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    TPKeyboardAvoidingScrollView *rootScrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [rootScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:rootScrollView];
    [rootScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuide).with.offset(0.0);
        make.left.equalTo(weakSelf.view).with.offset(0.0);
        make.bottom.equalTo(weakSelf.view).with.offset(0.0);
        make.right.equalTo(weakSelf.view).with.offset(0.0);
    }];
    
    
    //用户名
    YKXCustomUsernameView *rootUsernameView = [[YKXCustomUsernameView alloc] init];
    rootUsernameView.usernamePlaceholder = @"请输入用户名(字母、数字或下划线)";
    [rootScrollView addSubview:rootUsernameView];
    [rootUsernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(@(80));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootUsernameView = rootUsernameView;
    
    //手机号或者QQ号
    YKXCustomUsernameView *rootPhonenumberView = [[YKXCustomUsernameView alloc] init];
    rootPhonenumberView.usernamePlaceholder = @"请输入手机号或QQ号(用户找回账号密码)";
    [rootScrollView addSubview:rootPhonenumberView];
    [rootPhonenumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootUsernameView.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootPhonenumberView = rootPhonenumberView;
    
    //密码
    YKXCustomPasswordView *rootPasswordView = [[YKXCustomPasswordView alloc] init];
    rootPasswordView.passwordPlaceHolder = @"请输入密码(长度6-16位)";
    [rootScrollView addSubview:rootPasswordView];
    [rootPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootPhonenumberView.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootPasswordView = rootPasswordView;
    
    //确认密码
    YKXCustomPasswordView *rootConfirmPasswordView = [[YKXCustomPasswordView alloc] init];
    rootConfirmPasswordView.passwordPlaceHolder = @"请输入确认密码(长度6-16位)";
    [rootScrollView addSubview:rootConfirmPasswordView];
    [rootConfirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootPasswordView.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootConfirmPasswordView = rootConfirmPasswordView;
    
    
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    registerButton.layer.cornerRadius = 6.0f;
    registerButton.layer.masksToBounds = YES;
    [registerButton addTarget:self action:@selector(onClickRegister:) forControlEvents:UIControlEventTouchUpInside];
    [rootScrollView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootConfirmPasswordView.mas_bottom).offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 40));
    }];
}


#pragma mark 点击事件
//找回密码
- (void)onClickFindPassword:(UIButton *)sender {
    
    NSString *findPasswordURL = [YKXDefaultsUtil getFindPasswordURLStr];
    
    YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
    activityVC.urlStr = findPasswordURL;
    [self.navigationController pushViewController:activityVC animated:YES];
}


- (void)onClickRegister:(UIButton *)sender{
    
    NSString *username = self.rootUsernameView.usernameTextFeild.text;
    
    NSString *phoneNumber = self.rootPhonenumberView.usernameTextFeild.text;
    
    NSString *password = self.rootPasswordView.passwordTextFeild.text;
    
    NSString *confirmPassword = self.rootConfirmPasswordView.passwordTextFeild.text;
    
    if(username.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入用户名" view:self.view.window];
        return;
    }
    if(password.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入密码" view:self.view.window];
        return;
    }
    if(confirmPassword.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入确认密码" view:self.view.window];
        return;
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
    if(![password isEqualToString:confirmPassword]){
        [YKXCommonUtil showToastWithTitle:@"新密码与确认密码不一致" view:self.view.window];
        return;
    }
    
    
    NSString *uid = @"0";
    NSString *token = @"0";
    NSString *chnanelId = @"0";
    NSString *action = @"reg";
    NSString *devType = @"2";
    
    
    //手机唯一码
    NSString *openUDID = [OpenUDID value];
    
    
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",uid,token,username,chnanelId,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    
    [HttpService loadDataUserRegisterPostUid:uid token:token versionCode:versionCode imei:openUDID username:username phoneNumber:phoneNumber oldPassword:@"" newPassword:password action:action channelId:chnanelId devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        //注册成功后返回上一个界面同时关掉键盘
        
        NSString *errorCode = responseObject[@"error_code"];
        if([errorCode isEqualToString:@"0"]){
            
            [YKXCommonUtil showToastWithTitle:@"注册成功" view:self.view.window];
            
            if(_delegete && [_delegete respondsToSelector:@selector(loginUsername:password:)]){
                
                [_delegete loginUsername:username password:password];
            }
            
            //关闭键盘
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
        
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}

@end
