//
//  FreeCardCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/5/6.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FreeCardModel;
@interface FreeCardCell : UITableViewCell

//领取按钮
@property (nonatomic,strong) UIButton *getCardButton;

@property (nonatomic,copy) void(^clickButtonAction)(UIButton *button);

@property (nonatomic,strong) FreeCardModel *model;
@end
