//
//  MoreTableViewCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/10/12.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownRecommendModel.h"

@protocol DownRecommendCellDelegate <NSObject>

- (void)addDownRecommendTaskAction:(NSIndexPath *)indexPath;

@end

@interface DownRecommendCell : UITableViewCell

@property (nonatomic,strong) DownRecommendModel *model;

@property (strong,nonatomic) NSIndexPath *index;

@property (nonatomic,assign) id<DownRecommendCellDelegate> delegate;

@end
