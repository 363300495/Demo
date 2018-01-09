//
//  AboutUsViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"关于我们";

}

- (void)createView{
    
    WEAKSELF(weakSelf);
    
    NSString *aboutusInfoString = [YKXDefaultsUtil getAboutusAppInfoString];
    
    aboutusInfoString = [aboutusInfoString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    aboutusInfoString = [aboutusInfoString stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = aboutusInfoString;
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.right.equalTo(@(-20));
        make.top.equalTo(weakSelf.view).offset(40*kWJHeightCoefficient);
        make.height.mas_equalTo(300);
    }];
    
    NSString *infoCodeURL = [YKXDefaultsUtil getAboutusCodeURL];
    
    if(infoCodeURL.length > 0){
        
        UIImageView *QRCodeImageView = [[UIImageView alloc] init];
        [QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:infoCodeURL]];
        [self.view addSubview:QRCodeImageView];
        [QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(120, 120));
        }];
    }
}


@end
