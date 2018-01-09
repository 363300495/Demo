//
//  CustomNativeAdViewCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

/**
tableView 原生广告cell
 */

#import <UIKit/UIKit.h>
#import "YKXVideoModel.h"

@interface CustomNativeAdViewCell : UITableViewCell

/** model */
@property (nonatomic,strong) YKXVideoModel *model;

@end
