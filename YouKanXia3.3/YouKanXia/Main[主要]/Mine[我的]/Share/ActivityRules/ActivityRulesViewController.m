//
//  ActivityRulesViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/1.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ActivityRulesViewController.h"

@interface ActivityRulesViewController ()

@end

@implementation ActivityRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"activityRules" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    content = [content stringByReplacingOccurrencesOfString:@"优看侠" withString:DISPLAYNAME];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:contentLabel];
    
    CGRect frame = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(weakSelf.view).offset(20);
        make.height.mas_equalTo(frame.size.height+20);
    }];
    
}

@end
