//
//  YKXUserProtocolController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/21.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXUserProtocolController.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface YKXUserProtocolController ()

@end

@implementation YKXUserProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"用户使用协议";
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
    
    UIView *rootContainerView = [[UIView alloc] init];
    [rootScrollView addSubview:rootContainerView];
    [rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootScrollView);
        make.width.equalTo(rootScrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT*3);
    }];
    
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    content = [content stringByReplacingOccurrencesOfString:@"优看侠" withString:DISPLAYNAME];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    [rootContainerView addSubview:contentLabel];
    
    CGRect frame = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(@(20));
        make.top.equalTo(rootContainerView).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH-40);
        make.height.mas_equalTo(frame.size.height+20);
    }];
    
}

@end
