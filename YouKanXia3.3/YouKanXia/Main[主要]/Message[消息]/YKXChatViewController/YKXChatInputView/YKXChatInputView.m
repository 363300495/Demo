//
//  YKXChatInputView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXChatInputView.h"

static CGFloat inputViewDefaultHeight = 49; //输入框默认高度
static CGFloat chatTextInputHeight  = 35; //默认输入框的高度

NSString *const InputViewTextContentSize = @"contentSize";

@interface YKXChatInputView () <UITextViewDelegate>

/**
 输入框容器,(存放输入框,添加表情按钮和添加表情按钮)
 */
@property (nonatomic,strong) UIView *inputViewContainer;

@end


@implementation YKXChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setUI];
    }
    return self;
}


- (void)setUI{
    
    //输入框
    [self addSubview:self.inputViewContainer];
}

/**
 输入框容器
 */
- (UIView *)inputViewContainer{
    
    if (!_inputViewContainer){
        _inputViewContainer = [[UIView alloc] init];
        _inputViewContainer.frame = CGRectMake(0,0,SCREEN_WIDTH, inputViewDefaultHeight);
        
        [_inputViewContainer addSubview:self.chatText];
        [_inputViewContainer addSubview:self.sendButton];
    }
    return _inputViewContainer;
}

//聊天输入框
- (UITextView *)chatText{
    if (!_chatText) {
        _chatText = [[UITextView alloc] init];
        _chatText.frame = CGRectMake(10,(inputViewDefaultHeight-chatTextInputHeight)/2, SCREEN_WIDTH-100,chatTextInputHeight);
        _chatText.delegate = self;
        _chatText.backgroundColor = [UIColor whiteColor];
        _chatText.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        _chatText.returnKeyType = UIReturnKeySend;
        _chatText.enablesReturnKeyAutomatically = YES;
        _chatText.textAlignment = NSTextAlignmentLeft;
        _chatText.font = [UIFont systemFontOfSize:16.0f];
        _chatText.layer.cornerRadius = 4.0f;
        _chatText.layer.borderColor = [UIColor colorWithHexString:LIGHT_COLOR].CGColor;
        _chatText.layer.borderWidth = 0.6f;
        _chatText.layer.masksToBounds = YES;
        //观察输入框的高度变化(contentSize)
        [_chatText addObserver:self forKeyPath:InputViewTextContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _chatText;
}

//发送消息按钮
- (UIButton *)sendButton{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(CGRectGetMaxX(_chatText.frame)+10, (inputViewDefaultHeight-chatTextInputHeight)/2, 70, chatTextInputHeight);
        _sendButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
        _sendButton.layer.cornerRadius = 6.0f;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendChatMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


/**
 观察输入框的高度变化
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGFloat oldHeight = [change[@"old"] CGSizeValue].height;
    CGFloat newheight = [change[@"new"] CGSizeValue].height;
    
    if (oldHeight <= 0 || newheight <= 0) return;
    
    if (newheight != oldHeight) {
        
        if (newheight > 70){
            newheight = 70;
        }
        
        CGFloat inputHeight = newheight>chatTextInputHeight ? newheight:chatTextInputHeight;
        
        [self chatTextViewHeightFit:inputHeight];
    }
}

- (void)chatTextViewHeightFit:(CGFloat)height{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat inputH = height+inputViewDefaultHeight-chatTextInputHeight;
        
        if(_delegate && [_delegate respondsToSelector:@selector(YKXChatInputView:chatHeight:)]){
            
            [_delegate YKXChatInputView:self chatHeight:inputH];
        }
    }];
}


- (void)sendChatMessage{
    
    if(self.chatText.text.length > 0){
        
        if(_delegate && [_delegate respondsToSelector:@selector(YKXChatInputView:sendTextMessage:)]){
            
            [_delegate YKXChatInputView:self sendTextMessage:self.chatText.text];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    //限制在500字以内
    if(textView.text.length >500){
        
        textView.text = [textView.text substringToIndex:500];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        if(self.chatText.text.length > 0){
        
            if(_delegate && [_delegate respondsToSelector:@selector(YKXChatInputView:sendTextMessage:)]){
                
                [_delegate YKXChatInputView:self sendTextMessage:self.chatText.text];
            }
        }
        [self.chatText setText:@""];
        return NO;
    }
    return YES;
}


- (void)dealloc{
    
    [self.chatText removeObserver:self forKeyPath:InputViewTextContentSize];
}

@end
