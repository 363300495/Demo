//
//  YKXCustomExitView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/7/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomExitView.h"
#import "YKXTextView.h"

#define AlertViewWidth 275

@interface YKXCustomExitView () <UITextViewDelegate>

@property (nonatomic,strong) UIButton *questionButotn1;

@property (nonatomic,strong) UIButton *questionButotn2;

@property (nonatomic,strong) UITextView *contentTextView;

@end

@implementation YKXCustomExitView

- (instancetype)initWithPromptNote:(NSString *)promptNote loginContent:(NSString *)loginContent whiteContent:(NSString *)whiteContent otherContent:(NSString *)otherContent{
    
    if(self = [super initWithFrame:SCREEN_BOUNDS]){
        
        
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-AlertViewWidth)/2.0, (SCREEN_HEIGHT-280)/2.0, AlertViewWidth, 280)];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 6.0f;
        [self addSubview:alertView];
        self.alertView = alertView;
        
        
        UILabel *promptNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake((AlertViewWidth-200)/2, 30, 200, 20)];
        promptNoteLabel.text = promptNote;
        promptNoteLabel.textAlignment = NSTextAlignmentCenter;
        promptNoteLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        promptNoteLabel.font = [UIFont systemFontOfSize:14.0f];
        [alertView addSubview:promptNoteLabel];
        

        UIButton *questionButotn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        questionButotn1.frame = CGRectMake((AlertViewWidth-200)/2, CGRectGetMaxY(promptNoteLabel.frame)+10, 200, 30);
        questionButotn1.layer.masksToBounds = YES;
        questionButotn1.layer.cornerRadius = 15;
        questionButotn1.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
        questionButotn1.layer.borderWidth = 0.6f;
        [questionButotn1 setTitle:loginContent forState:UIControlStateNormal];
        [questionButotn1 setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        questionButotn1.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [questionButotn1 addTarget:self action:@selector(onClickButtonContent:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:questionButotn1];
        self.questionButotn1 = questionButotn1;
        
        UIButton *questionButotn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        questionButotn2.frame = CGRectMake((AlertViewWidth-200)/2, CGRectGetMaxY(questionButotn1.frame)+10, 200, 30);
        questionButotn2.layer.masksToBounds = YES;
        questionButotn2.layer.cornerRadius = 15;
        questionButotn2.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
        questionButotn2.layer.borderWidth = 0.6f;
        [questionButotn2 setTitle:whiteContent forState:UIControlStateNormal];
        [questionButotn2 setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        questionButotn2.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [questionButotn2 addTarget:self action:@selector(onClickButtonContent:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:questionButotn2];
        self.questionButotn2 = questionButotn2;
        

        
        
        UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(questionButotn2.frame)+10, 200, 20)];
        otherLabel.text = otherContent;
        otherLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        otherLabel.font = [UIFont systemFontOfSize:14.0f];
        [alertView addSubview:otherLabel];
        
        
        YKXTextView *contentTextView = [[YKXTextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(otherLabel.frame)+10, AlertViewWidth-40, 50)];
        contentTextView.delegate = self;
        contentTextView.layer.cornerRadius = 6.0f;
        contentTextView.layer.masksToBounds = YES;
        contentTextView.layer.borderWidth = 0.6f;
        contentTextView.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
        contentTextView.font = [UIFont systemFontOfSize:12.0f];
        
        //设置提醒文字
        contentTextView.myPlaceholder = @"我们会尽快处理并在消息“客服”中回复您！";
        //设置提醒文字颜色
        contentTextView.myPlaceholderColor= [UIColor lightGrayColor];
        
        [alertView addSubview:contentTextView];
        self.contentTextView = contentTextView;
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(244, 5, 24, 24);
        [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:cancelButton];
        
        
        CGFloat btnY = alertView.frame.size.height - 50;
        

        UIButton *feedBackAction = [UIButton buttonWithType:UIButtonTypeCustom];
        feedBackAction.frame = CGRectMake(0, btnY, AlertViewWidth, 50);
        feedBackAction.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [feedBackAction setTitle:@"反馈修复" forState:UIControlStateNormal];
        [feedBackAction setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        [feedBackAction addTarget:self action:@selector(onClickSendMessage) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:feedBackAction];
        

        
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, btnY, AlertViewWidth, 0.5);
        line1.backgroundColor = [UIColor lightGrayColor];
        [alertView addSubview:line1];
        
    }
    
    return self;
}

- (void)onClickButtonContent:(UIButton *)sender{
    
    if(!sender.selected){
        
        [sender setTitleColor:[UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR] forState:UIControlStateSelected];
        sender.layer.borderColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR].CGColor;
        
    }else{
        
        [sender setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        sender.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;

    }
    
    sender.selected = !sender.selected;
}


- (void)onClickSendMessage {
    
    NSString *description;
    
    if(!self.questionButotn1.selected && !self.questionButotn2.selected){
        
        description = @"";
    }else if (self.questionButotn1.selected && !self.questionButotn2.selected){
        
        description = @"1";
    }else if (!self.questionButotn1.selected && self.questionButotn2.selected){
        
        description = @"2";
    }else{
        description = @"1,2";
    }

    if([self.delegete respondsToSelector:@selector(sendMessageDescription:content:)]){
        [self.delegete sendMessageDescription:description content:self.contentTextView.text];
    }
}

- (void)onClickDismiss{
    
    [self dismiss];
}

- (void)dismiss{
    
    [self.alertView removeFromSuperview];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _coverView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}


- (void)show{
    
    [self coverView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
    self.alertView.layer.position = startPoint;
    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alertView.layer.position = self.center;
                         self.coverView.alpha = 1.0;
                     } completion:nil];
}


- (UIView *)coverView {
    
    if (!_coverView) {
        [self insertSubview:({
            _coverView = [[UIView alloc] initWithFrame:self.bounds];
            _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
            _coverView.alpha = 0;
            _coverView;
        }) atIndex:0];
    }
    return _coverView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(string.length > 50){
        return NO;
    }
    return YES;
}

@end
