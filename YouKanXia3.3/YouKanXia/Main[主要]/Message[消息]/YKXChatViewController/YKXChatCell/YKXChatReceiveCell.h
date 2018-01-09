//
//  YKXChatReceiveCell.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKXChatReceiveModel.h"

@protocol YKXChatReceiveCellDelegete <NSObject>

/**
 当前点击的cell的链接
 
 @param contentUrl 链接
 */
- (void)currentCellUserAgent:(NSString *)userAgent contentUrl:(NSString *)contentUrl js_1:(NSString *)js1 js_2:(NSString *)js2;

@end


@interface YKXChatReceiveCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,copy) YKXChatReceiveModel *model;

@property (nonatomic,assign) id<YKXChatReceiveCellDelegete> delegate;

+ (CGFloat)heightTableCellWithModel:(YKXChatReceiveModel *)model;

@end
