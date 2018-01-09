//
//  BaseShareViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/6/10.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseShareViewController : UIViewController

//是否显示空白页
@property (nonatomic,assign) BOOL isEmptyDataSetShouldDisplay;

@property (nonatomic,strong) UITableView *tableView;

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

//更多按钮button
@property (nonatomic,strong) UIButton *moreButton;

//查看更多按钮
- (void)onClickMore;

@end
