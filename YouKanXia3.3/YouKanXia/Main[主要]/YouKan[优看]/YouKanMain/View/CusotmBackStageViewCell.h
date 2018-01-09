//
//  CusotmBackStageViewCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

/**
 tableView 跳转链接cell
 */

#import <UIKit/UIKit.h>
#import "YKXVideoModel.h"

@protocol CusotmBackStageViewCellDelegate <NSObject>

- (void)backStageURLClick:(NSString *)urlStr;

@end


@interface CusotmBackStageViewCell : UITableViewCell

/** model */
@property (nonatomic,strong) YKXVideoModel *model;

@property (nonatomic,assign) id<CusotmBackStageViewCellDelegate> delegete;

@end
