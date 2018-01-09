//
//  CustomVideoListCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@protocol CustomVideoListCellDelegete <NSObject>

-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath;

@end


@interface CustomVideoListCell : UITableViewCell

@property (nonatomic,strong) VideoModel *model;

@property (strong,nonatomic) NSIndexPath *index;

@property (nonatomic,assign) id<CustomVideoListCellDelegete> delegete;

@end
