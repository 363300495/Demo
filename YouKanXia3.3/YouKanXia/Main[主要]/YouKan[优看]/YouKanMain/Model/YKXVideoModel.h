//
//  YKXVideoModel.h
//  YouKanXia
//
//  Created by 汪立 on 2017/9/12.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKXVideoModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 名称 */
@property (nonatomic, copy) NSString *nickname;
/** 视频地址 */
@property (nonatomic, copy) NSString *videourl;
/** 封面图 */
@property (nonatomic, copy) NSString *coverimgurl;
/** 头像 */
@property (nonatomic, copy) NSString *headimgurl;
/** 播放次数 */
@property (nonatomic, copy) NSString *playcount_str;
/** 视频时长 */
@property (nonatomic, copy) NSString *timelong_str;
/** 类型 */
@property (nonatomic, copy) NSString *type;
/** 视频 */
@property (nonatomic,copy) NSString *displaytype;
/** 视频ID */
@property (nonatomic,copy) NSString *vid;
@end
