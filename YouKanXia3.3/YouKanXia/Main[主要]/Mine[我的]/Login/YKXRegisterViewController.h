//
//  YKXRegisterViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/18.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcViewController.h"

@protocol YKXRegisterViewControllerDelegate <NSObject>

- (void)loginUsername:(NSString *)username password:(NSString *)password;

@end


@interface YKXRegisterViewController : BaseNavcViewController

@property (nonatomic,assign) id<YKXRegisterViewControllerDelegate> delegete;

@end
