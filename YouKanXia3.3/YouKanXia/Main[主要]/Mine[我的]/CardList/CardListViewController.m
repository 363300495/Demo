//
//  CardListViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/6.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CardListViewController.h"
#import "CardNotUseViewController.h"
#import "CardInvalidViewController.h"
@interface CardListViewController ()

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"VIP卡券列表";
}

- (void)createView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArray = @[@"可使用",@"已过期"];
    
    CardNotUseViewController *cardNotUseVC = [[CardNotUseViewController alloc] init];
    CardInvalidViewController *cardInvalidVC = [[CardInvalidViewController alloc] init];
    self.controllerArray = @[cardNotUseVC,cardInvalidVC];
}

@end
