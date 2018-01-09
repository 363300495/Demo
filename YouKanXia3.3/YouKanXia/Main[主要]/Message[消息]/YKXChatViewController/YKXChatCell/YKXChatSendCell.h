//
//  YKXChatSendCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YKXChatReceiveModel.h"

@interface YKXChatSendCell : UITableViewCell

@property (nonatomic,strong) YKXChatReceiveModel *model;

+ (CGFloat)heightTableCellWithModel:(YKXChatReceiveModel *)model;

@end
