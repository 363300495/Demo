//
//  CollectionListCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/10/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionListModel.h"
@interface CollectionListCell : UITableViewCell

/** 视频图标 */
@property (nonatomic,strong) UIImageView *videoImageView;

/** 背景图片上的标题 */
@property (nonatomic,strong) UILabel *titleLabel;


/** 播放按钮 */
@property (nonatomic,strong) UIButton *playButton;

/** 播放按钮block */
@property (nonatomic,copy) void(^playBlock)(UIButton *);


@property (nonatomic,strong) CollectionListModel *model;

@end
