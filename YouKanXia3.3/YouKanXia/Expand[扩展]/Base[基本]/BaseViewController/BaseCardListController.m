//
//  BaseCardListController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/7.
//  Copyright © 2017年 youyou. All rights reserved.
//


#define titleWidth 260/_titleArray.count
#define titleHeight 34

#import "BaseCardListController.h"

@interface BaseCardListController () <UIScrollViewDelegate>

{
    //选中状态下的按钮
    UIButton *selectButton;

}

@property (nonatomic, weak) UIViewController *currentVC;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation BaseCardListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _buttonArray = [NSMutableArray array];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self initWithTitleButton];
}

- (void)setControllerArray:(NSArray *)controllerArray {
    _controllerArray = controllerArray;
    [self initWithController];
}

- (void)initWithTitleButton{
    //头部的标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2, 5, 260, titleHeight)];
    [self.view addSubview:titleView];
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < _titleArray.count; idx++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:_titleArray[idx] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleButton.tag = 100+idx;
        [titleButton addTarget:self action:@selector(onClickSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (idx == 0) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
        
        
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(titleWidth);
            make.height.mas_equalTo(titleHeight);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(titleView);
                make.left.equalTo(titleView);
            }else{
                make.top.equalTo(lastButton);
                make.left.equalTo(lastButton.mas_right);
            }
        }];
        lastButton = titleButton;
        
        
        //顶部边框
        UILabel *topLineLabel = [[UILabel alloc] init];
        [titleButton addSubview:topLineLabel];
        [topLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
        [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleButton.mas_left).offset(0.0);
            make.right.equalTo(titleButton.mas_right).offset(0.0);
            make.top.equalTo(titleButton.mas_top).offset(0.0);
            make.height.equalTo(@(0.5));
        }];
        
        //左侧边框
        if(idx == 0){
            UILabel *leftLineLabel = [[UILabel alloc] init];
            [titleButton addSubview:leftLineLabel];
            [leftLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
            [leftLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleButton.mas_top).offset(0.5);
                make.left.equalTo(titleButton.mas_left).offset(-0.25);
                make.right.equalTo(titleButton.mas_left).offset(0.25);
                make.bottom.equalTo(titleButton.mas_bottom).offset(-0.5);
            }];
        }
        
        
        //右边边框
        UILabel *rightLineLabel = [[UILabel alloc] init];
        [titleButton addSubview:rightLineLabel];
        [rightLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
        [rightLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleButton.mas_top).offset(0.5);
            make.left.equalTo(titleButton.mas_right).offset(-0.25);
            make.right.equalTo(titleButton.mas_right).offset(0.25);
            make.bottom.equalTo(titleButton.mas_bottom).offset(-0.5);
        }];
        
        

        // 底部边框
        UILabel *bottomLineLabel = [[UILabel alloc] init];
        [titleButton addSubview:bottomLineLabel];
        [bottomLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
        [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleButton.mas_left).offset(0.0);
            make.right.equalTo(titleButton.mas_right).offset(0.0);
            make.bottom.equalTo(titleButton.mas_bottom).offset(0.0);
            make.height.equalTo(@(0.5));
        }];
    }
}

- (void)onClickSelectToIndex:(UIButton *)btn{
    
    //获取当前点击按钮的下标
    NSInteger index = btn.tag-100;
    
    [selectButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateNormal];
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
    
    
    // 取出选中的这个控制器
    UIViewController *vc = self.childViewControllers[btn.tag-100];
    // 设置尺寸位置
    vc.view.frame = CGRectMake(0, titleHeight + 10, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight - 10);
    // 移除掉当前显示的控制器的view（移除的是view，而不是控制器）
    [self.currentVC.view removeFromSuperview];
    // 把选中的控制器view显示到界面上
    [self.view addSubview:vc.view];
    self.currentVC = vc;
    
}

- (void)initWithController{
    
    for (int i = 0; i < _controllerArray.count; i++) {
        
        [self addChildViewController:_controllerArray[i]];
        
        if(i==0){
            
            UIViewController *firstVC = _controllerArray[i];
            // 设置尺寸位置
            firstVC.view.frame = CGRectMake(0, titleHeight + 10, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight-10);
            
            // 把选中的控制器view显示到界面上
            [self.view addSubview:firstVC.view];
            //保存当前的控制器
            self.currentVC = firstVC;
        }
    }
}
@end
