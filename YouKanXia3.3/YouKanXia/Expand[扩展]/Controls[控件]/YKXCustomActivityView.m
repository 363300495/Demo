//
//  YKXCustomActivityView.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCustomActivityView.h"

@interface YKXCustomActivityView ()

@property (nonatomic,strong) UIView *alertView;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation YKXCustomActivityView

- (instancetype)initWithTitleImage:(NSString *)titleImage title:(NSString *)title content:(NSString *)content buttonTitle:(NSString *)buttonTitle{
    
    if(self = [super initWithFrame:SCREEN_BOUNDS]){
        
        WEAKSELF(weakSelf);
        
        UIView *alertView = [[UIView alloc] init];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 6.0f;
        [self addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(300*kWJWidthCoefficient, 260));
        }];
        self.alertView = alertView;
    
        
        UIImageView *titleImageView = [[UIImageView alloc] init];
        if([titleImage containsString:@"http"]){//如果是网络图片
            [titleImageView sd_setImageWithURL:[NSURL URLWithString:titleImage] placeholderImage:[UIImage imageNamed:@"startup_news_o"]];
        }else{
            titleImageView.image = [UIImage imageNamed:@"startup_news_o"];
        }
        [alertView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(@(-80));
            make.size.mas_equalTo(CGSizeMake(120, 120));
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        titleLabel.font = [UIFont systemFontOfSize:20.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(titleImageView.mas_bottom).offset(20);
            make.height.mas_equalTo(@(25));
        }];
        
        
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        contentLabel.text = content;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:16.0f];
        contentLabel.numberOfLines = 0;
        [alertView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(20));
            make.right.equalTo(@(-20));
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(100);
        }];
        
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        confirmButton.layer.borderColor = [UIColor orangeColor].CGColor;
        confirmButton.layer.borderWidth = 0.6;
        confirmButton.layer.cornerRadius = 10;
        confirmButton.layer.masksToBounds = YES;
        [confirmButton addTarget:self action:@selector(onClickGoActivity) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.bottom.equalTo(alertView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(100, 36));
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(alertView).offset(6);
            make.right.equalTo(alertView).offset(-6);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    }
    return self;
}

- (void)onClickGoActivity{
    [self dismiss];
    if(self.activityBlock){
        self.activityBlock();
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
    
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
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


@end
