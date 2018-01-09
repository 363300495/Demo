//
//  YKXChatReceiveModel.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKXChatReceiveModel : NSObject

@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *fnid;
@property (nonatomic,copy) NSString *friends_id;
@property (nonatomic,copy) NSString *img_url;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *user_agent;

@property (nonatomic,copy) NSString *js_1;
@property (nonatomic,copy) NSString *js_2;

//是否显示时间
@property (nonatomic,copy) NSString *isTimeShow;

//消息类型
@property (nonatomic,copy) NSString *newstype;

@property (nonatomic, assign) CGFloat height;

@end
