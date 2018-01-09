//
//  PhoneBindViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/22.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcViewController.h"

@protocol PhoneBindViewControllerDelegate <NSObject>

- (void)phoneBindNickname:(NSString *)nickName index:(NSInteger)index;

@end


@interface PhoneBindViewController : BaseNavcViewController

@property (nonatomic,copy) NSString *bindType;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) id<PhoneBindViewControllerDelegate> delegete;

@end
