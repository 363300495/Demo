//
//  CustomDownloadCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"

@interface DownloadManagerCell : UITableViewCell

@property (nonatomic,strong) NSString *downloadUrl;

@property (nonatomic,strong) TaskEntity *taskEntity;

- (void)showData:(TaskEntity *)taskEntity;

@end
