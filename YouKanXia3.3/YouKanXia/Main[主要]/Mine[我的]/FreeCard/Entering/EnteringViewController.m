//
//  EnteringViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/2.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "EnteringViewController.h"

@interface EnteringViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *enterTextFeild;

@end

@implementation EnteringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"录入激活码";
    
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"激活码";
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@(80*kWJHeightCoefficient));
        make.height.mas_equalTo(26);
    }];
    
    UITextField *enterTextFeild = [[UITextField alloc] init];
    enterTextFeild.placeholder = @"请输入激活码";
    //设置字体居中
    enterTextFeild.textAlignment = NSTextAlignmentCenter;
    enterTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    enterTextFeild.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [self.view addSubview:enterTextFeild];
    [enterTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-120, 30));
    }];
    enterTextFeild.delegate = self;
    self.enterTextFeild = enterTextFeild;
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithHexString:LIGHT_COLOR];
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(enterTextFeild.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-120, 0.4));
    }];
    
    //激活按钮
    UIButton *activationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activationButton setTitle:@"激活" forState:UIControlStateNormal];
    [activationButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
    activationButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    activationButton.layer.cornerRadius = 6.0f;
    activationButton.layer.masksToBounds = YES;
    activationButton.layer.borderWidth = 0.6f;
    activationButton.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
    [activationButton addTarget:self action:@selector(onClickactivation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activationButton];
    [activationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(lineLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 34));
    }];
    
    UIView *rootActivationView = [[UIView alloc] init];
    [self.view addSubview:rootActivationView];
    [rootActivationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(activationButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
    }];
    
    UILabel *descriptionLabel1 = [[UILabel alloc] init];
    descriptionLabel1.text = @"激活码是VIP的唯一充值密码。";
    descriptionLabel1.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    descriptionLabel1.font = [UIFont systemFontOfSize:15.0f];
    [rootActivationView addSubview:descriptionLabel1];
    [descriptionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootActivationView).offset(54);
        make.top.equalTo(rootActivationView);
        make.height.mas_equalTo(@(25));
    }];
    
    UILabel *descriptionLabel2 = [[UILabel alloc] init];
    descriptionLabel2.text = @"激活码是通过线上渠道获取的电子码，";
    descriptionLabel2.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    descriptionLabel2.font = [UIFont systemFontOfSize:15.0f];
    [rootActivationView addSubview:descriptionLabel2];
    [descriptionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descriptionLabel1);
        make.top.equalTo(descriptionLabel1.mas_bottom).offset(5);
        make.height.mas_equalTo(@(25));
    }];
    
    UILabel *descriptionLabel3 = [[UILabel alloc] init];
    descriptionLabel3.text = @"或通过线下渠道发行的实物卡片。";
    descriptionLabel3.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    descriptionLabel3.font = [UIFont systemFontOfSize:15.0f];
    [rootActivationView addSubview:descriptionLabel3];
    [descriptionLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descriptionLabel2);
        make.top.equalTo(descriptionLabel2.mas_bottom).offset(5);
        make.height.mas_equalTo(@(25));
    }];
}

#pragma mark 点击事件
- (void)onClickactivation:(UIButton *)button{
    
    NSString *code = self.enterTextFeild.text;
    if(code.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入激活码" view:self.view.window];
        return;
    }
    
    if(code.length >0 && code.length != 12){
        [YKXCommonUtil showToastWithTitle:@"激活码为12位" view:self.view.window];
        return;
    }
    
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,code,@"2",timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataEnteryActivationCodePostUid:uid token:token versionCode:versionCode code:code devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40004"]){
            [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
        } else if([errorCode isEqualToString:@"40006"]){
            [YKXCommonUtil showToastWithTitle:@"非法激活码" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"40007"]){
            [YKXCommonUtil showToastWithTitle:@"激活码错误" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"40008"]){
            [YKXCommonUtil showToastWithTitle:@"激活码已过期" view:self.view.window];
            
        }else if([errorCode isEqualToString:@"0"]){
            
            NSString *value = responseObject[@"val"];;
            NSString *type = responseObject[@"type"];
            
            NSString *text;
            if([type isEqualToString:@"1"]){
                text = @"天";
            }else if ([type isEqualToString:@"2"]){
                text = @"月";
            }else if ([type isEqualToString:@"3"]){
                text = @"年";
            }
            
            SRAlertView *alertView = [SRAlertView sr_alertViewUseCardWithMessage:[NSString stringWithFormat:@"激活码兑换成功,vip有效期延长%@%@",value,text] superVC:self leftActionTitle:@"确定" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView showNative];
            
            //发送通知，修改VIP时间信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
            
            //发送通知，修改APP启动信息
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APPINFO_STATUS_FREQUENCY object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];

            
        }else{
            
            [YKXCommonUtil showToastWithTitle:errorCode view:self.view.window];
        }
        
    } failure:^(NSError *error) {
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
    }else if ([textField isEqual:self.enterTextFeild]){//激活码最多输入14位
        return  textField.text.length < 14;
    }
    return YES;
}

@end
