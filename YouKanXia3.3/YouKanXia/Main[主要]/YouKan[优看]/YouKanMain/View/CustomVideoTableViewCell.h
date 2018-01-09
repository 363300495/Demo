//
//  CustomVideoTableViewCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/11.
//  Copyright © 2017年 youyou. All rights reserved.
//


/**
 tableView 小视频播放cell
 */

#import <UIKit/UIKit.h>
#import "YKXVideoModel.h"

@interface CustomVideoTableViewCell : UITableViewCell

/** 背景图片 */
@property (nonatomic,strong) UIImageView *picImageView;

/** 背景图片上的标题 */
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *playButton;
/** model */
@property (nonatomic,strong) YKXVideoModel *model;
/** 播放按钮block */
@property (nonatomic,copy) void(^playBlock)(UIButton *);


/**
 分享的block
 */
@property (nonatomic,copy) void(^shareVideoBlock)(NSString *);
@end
