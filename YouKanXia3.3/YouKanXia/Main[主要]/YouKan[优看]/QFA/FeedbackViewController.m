//
//  FeedbackViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/19.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "FeedbackViewController.h"
#import "YKXTextView.h"
@interface FeedbackViewController () <UITextViewDelegate>

@property (nonatomic,strong) YKXTextView *textView;

@property (nonatomic,strong) UIButton *sendMessageButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createView];
    
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"意见反馈";
}

- (void)createView{
    
    YKXTextView *textView = [[YKXTextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 200)];
    textView.delegate = self;
    textView.layer.borderWidth = 0.6f;
    textView.layer.cornerRadius = 6.0f;
    textView.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
    textView.font = [UIFont systemFontOfSize:15.0f];
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    //设置提醒文字
    textView.myPlaceholder = @"请在这里输入您的宝贵意见...";
    //设置提醒文字颜色
    textView.myPlaceholderColor= [UIColor lightGrayColor];
    
    
    UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessageButton.frame = CGRectMake(40, CGRectGetMaxY(textView.frame)+40, SCREEN_WIDTH-80, 40);
    [self.view addSubview:sendMessageButton];
    sendMessageButton.enabled = NO;
    sendMessageButton.backgroundColor = [UIColor lightGrayColor];
    [sendMessageButton setTitle:@"提交" forState:UIControlStateNormal];
    [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMessageButton.layer.cornerRadius = 6;
    sendMessageButton.layer.masksToBounds = YES;
    [sendMessageButton addTarget:self action:@selector(onClickSendMessage) forControlEvents:UIControlEventTouchUpInside];
    self.sendMessageButton = sendMessageButton;
}

//发送
- (void)onClickSendMessage{
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    if(loginDic.count == 0){
        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
        return;
    }
    
    NSString *content = self.textView.text;
    
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"-" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if(content.length == 0){
        [YKXCommonUtil showToastWithTitle:@"请输入反馈内容" view:self.view.window];
        return;
    }
    [self.view endEditing:YES];
    

    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,content,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataFeedbackPostUid:uid token:token versionCode:versionCode vweb:@"" label:@"" content:content currentUrl:@"" devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        if([responseObject[@"error_code"] isEqualToString:@"0"]){
            [YKXCommonUtil showToastWithTitle:@"意见发送成功" view:self.view.window];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [YKXCommonUtil showToastWithTitle:@"意见发送失败" view:self.view.window];
        }
        
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}

#pragma mark textView代理
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.sendMessageButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
    self.sendMessageButton.enabled = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(string.length > 200){
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
