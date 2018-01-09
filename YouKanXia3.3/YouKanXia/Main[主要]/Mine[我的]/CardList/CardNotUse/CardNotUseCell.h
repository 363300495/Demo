//
//  CardNotUseCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardListModel;
@interface CardNotUseCell : UITableViewCell

@property (nonatomic,copy) void(^useBlock)(UIButton *button);

@property (nonatomic,copy) void(^donationBlock)(UIButton *button);

@property (nonatomic,strong) UIButton *cardUseButton;

@property (nonatomic,strong) UIButton *donationButton;

@property (nonatomic,strong) CardListModel *model;

@end
