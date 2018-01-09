//
//  YKXRevisePasswordController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXRevisePasswordController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "YKXCustomUsernameView.h"
#import "YKXCustomPasswordView.h"
#import "AppDelegate.h"
@interface YKXRevisePasswordController ()

@property (nonatomic,strong) YKXCustomPasswordView *rootNewPasswordView;

@property (nonatomic,strong) YKXCustomPasswordView *rootConfirmNewPasswordView;

@end

@implementation YKXRevisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"修改密码";
    
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
    
    
    //新密码
    YKXCustomPasswordView *rootNewPasswordView = [[YKXCustomPasswordView alloc] init];
    rootNewPasswordView.passwordPlaceHolder = @"请输入新密码";
    [rootScrollView addSubview:rootNewPasswordView];
    [rootNewPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(@(100));
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootNewPasswordView = rootNewPasswordView;
    
    //确认新密码
    YKXCustomPasswordView *rootConfirmNewPasswordView = [[YKXCustomPasswordView alloc] init];
    rootConfirmNewPasswordView.passwordPlaceHolder = @"请再次输入新密码";
    [rootScrollView addSubview:rootConfirmNewPasswordView];
    [rootConfirmNewPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootNewPasswordView.mas_bottom).offset(10);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    self.rootConfirmNewPasswordView = rootConfirmNewPasswordView;
    
    //确认更改
    UIButton *confirmReviseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmReviseButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    [confirmReviseButton setTitle:@"确认更改" forState:UIControlStateNormal];
    [confirmReviseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmReviseButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    confirmReviseButton.layer.cornerRadius = 6.0f;
    confirmReviseButton.layer.masksToBounds = YES;
    [confirmReviseButton addTarget:self action:@selector(confirmReviseAction:) forControlEvents:UIControlEventTouchUpInside];
    [rootScrollView addSubview:confirmReviseButton];
    [confirmReviseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootScrollView);
        make.top.equalTo(rootConfirmNewPasswordView.mas_bottom).offset(20);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH-60, 40));
    }];
}

#pragma mark 点击事件
- (void)confirmReviseAction:(UIButton *)sender{
    
    NSString *newPassword = self.rootNewPasswordView.passwordTextFeild.text;
    
    NSString *confirmNewPassword = self.rootConfirmNewPasswordView.passwordTextFeild.text;
    

    if(newPassword.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入新密码" view:self.view.window];
        return;
    }
    if(confirmNewPassword.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入确认新密码" view:self.view.window];
        return;
    }
    if(newPassword.length < 6 || newPassword.length > 16){
        [YKXCommonUtil showToastWithTitle:@"密码应为6-16位" view:self.view.window];
        return;
    }
    if(![newPassword isEqualToString:confirmNewPassword]){
        [YKXCommonUtil showToastWithTitle:@"新密码与确认密码不一致" view:self.view.window];
        return;
    }
    
    
    [YKXCommonUtil showToastWithTitle:@"请稍等..." view:self.view.window];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];

    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    NSString *chnanelId = @"0";
    NSString *action = @"updatepwd";
    NSString *devType = @"2";
    
    
    //手机唯一码
    NSString *openUDID = [OpenUDID value];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",uid,token,self.phoneNumber,chnanelId,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataUserRegisterPostUid:uid token:token versionCode:versionCode imei:openUDID username:self.phoneNumber phoneNumber:@"" oldPassword:@"" newPassword:newPassword action:action channelId:chnanelId devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"0"]){
            
            NSString *msg = @"密码修改成功";
            
            [YKXCommonUtil showToastWithTitle:msg view:self.view.window];
            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
        
    } failure:^(NSError *error) {
        [YKXCommonUtil hiddenHud];
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}


- (void)userExitSuccess{
    
    [YKXCommonUtil hiddenHud];
    [YKXCommonUtil showToastWithTitle:@"修改密码成功，请重新登录" view:self.view.window];
    
    //将各个模块的Id全部清空
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activityId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"discoveryId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"centerId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noticeId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carouselId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recserveId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vwebId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remindVersion"];
    
    //修改登录信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY object:nil];
    
    //修改消息界面信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];
    
    //清空数据库消息
    FMDBManager *manager = [FMDBManager sharedFMDBManager];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timeString"];
    
    NSArray *dbArray = [manager receiveFriendList];
    for (NSDictionary *dbDict in dbArray){
        
        NSString *dbFriendId = dbDict[@"friends_id"];
        //删除存储的消息时间
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:dbFriendId];
    }
    //避免数据丢失
    [[NSUserDefaults standardUserDefaults] synchronize];
    //删除好友信息列表
    [manager deleteFriendList];
    //删除消息列表
    [manager deleteChatList];
    
    //退出登录去掉角标
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainVC.tabBar hideMarkIndex:1];
    appDelegate.badgeCount = 0;
    
    
    //关闭键盘
    [self.view endEditing:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
