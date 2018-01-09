//
//  BaseNavcViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/18.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcViewController.h"

@interface BaseNavcViewController ()

@end

@implementation BaseNavcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    [self createNavc];
}

- (void)createNavc{
    
    YLButton *leftNavcButton = [YLButton buttonWithType:UIButtonTypeCustom];
    [leftNavcButton setTitle:@"返回" forState:UIControlStateNormal];
    leftNavcButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [leftNavcButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftNavcButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateHighlighted];
    [leftNavcButton setImage:[UIImage imageNamed:@"leftNavc_button"] forState:UIControlStateNormal];
    [leftNavcButton setImage:[UIImage imageNamed:@"leftNavc_buttonSelect"] forState:UIControlStateHighlighted];
    leftNavcButton.titleRect = CGRectMake(16, 0, 36, 44);
    leftNavcButton.imageRect = CGRectMake(0, 10, 14, 24);
    [self.view addSubview:leftNavcButton];
    leftNavcButton.frame = CGRectMake(0, 0, 52, 44);
    [leftNavcButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavcButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    

}

- (void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
