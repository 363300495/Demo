//
//  ShenHeFindViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeFindViewController.h"

@interface ShenHeFindViewController ()

@end

@implementation ShenHeFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createIpv6View];
}

- (void)createIpv6View{
    
    NSArray *itemTitleArray = @[@"优网",@"优享",@"专业",@"专注"];
    NSArray *itemImageArray = @[@"youwang",@"youxiang",@"zhuanye",@"zhuanzhu"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    UIView *rootHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableView.frame.size.height)];
    tableView.tableHeaderView = rootHeadView;
    
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*kWJHeightCoefficient)];
    topImageView.image = [UIImage imageNamed:@"distop1"];
    [rootHeadView addSubview:topImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), SCREEN_WIDTH, 40)];
    titleLabel.backgroundColor = [UIColor colorWithHexString:@"#EEEEF0"];
    titleLabel.text = @"产品特色";
    titleLabel.textColor = [UIColor colorWithHexString:@"#858587"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [rootHeadView addSubview:titleLabel];
    
    UIView *rootButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, SCREEN_HEIGHT-40-200*kWJHeightCoefficient)];
    [rootHeadView addSubview:rootButtonView];
    rootButtonView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    
    //单个宽度
    NSInteger itemColumn = 2;
    CGFloat itemViewW = SCREEN_WIDTH/itemColumn;
    CGFloat itemViewH = 110;
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < 4; idx++) {
        
        YLButton *itemButton = [YLButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:itemTitleArray[idx] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:itemImageArray[idx]] forState:UIControlStateNormal];
        itemButton.imageRect = CGRectMake((itemViewW-60)/2, 10, 60, 60);
        itemButton.titleRect = CGRectMake((itemViewW-38)/2, 70, 38, 30);
        [itemButton addTarget:self action:@selector(onClickShowMessage:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 100+idx;
        [rootButtonView addSubview:itemButton];
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(itemViewW);
            make.height.mas_equalTo(itemViewH);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(rootButtonView);
                make.left.equalTo(rootButtonView);
            }else{
                if (idx % itemColumn == 0) { // 每行第一个控件
                    make.top.equalTo(lastButton.mas_bottom).offset(0.0);
                    make.left.equalTo(rootButtonView).offset(0);
                } else {
                    make.top.equalTo(lastButton.mas_top).offset(0.0);
                    make.left.equalTo(lastButton.mas_right).offset(0.0);
                }
            }
        }];
        lastButton = itemButton;
        
        
        // 右边边框
        if((idx%itemColumn) != (itemColumn-1)){//如果不是最右边的按钮
            UILabel *rightLineLabel = [[UILabel alloc] init];
            [itemButton addSubview:rightLineLabel];
            [rightLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
            
            [rightLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemButton.mas_top).offset(0.4);
                make.left.equalTo(itemButton.mas_right).offset(-0.2);
                make.right.equalTo(itemButton.mas_right).offset(0.2);
                make.bottom.equalTo(itemButton.mas_bottom).offset(-0.4);
            }];
        }
        
        
        // 底部边框
        UILabel *bottomLineLabel = [[UILabel alloc] init];
        [itemButton addSubview:bottomLineLabel];
        [bottomLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
        [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemButton.mas_left).offset(0.0);
            make.right.equalTo(itemButton.mas_right).offset(0.0);
            make.bottom.equalTo(itemButton.mas_bottom).offset(0.0);
            make.height.equalTo(@(0.4));
        }];
    }
}

- (void)onClickShowMessage:(UIButton *)button{
    
    switch (button.tag) {
        case 100:
        {
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:nil icon:nil message:[NSString stringWithFormat:@"%@用户专业网络,高速接入的安全网络，如影相随",PREVIOUSNAME] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
            
            break;
        }
        case 101:
        {
            
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:nil icon:nil message:[NSString stringWithFormat:@"%@用户专享服务,特权无须多言，优越体验，畅享快感",PREVIOUSNAME] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
            break;
        }
        case 102:
        {
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:nil icon:nil message:[NSString stringWithFormat:@"%@团队专业专网建设，优化，服务一流",PREVIOUSNAME] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
            
            break;
        }
        case 103:
        {
            SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:nil icon:nil message:@"十年技术沉淀，专注网络服务，所以专业" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            }];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
    
}

@end
