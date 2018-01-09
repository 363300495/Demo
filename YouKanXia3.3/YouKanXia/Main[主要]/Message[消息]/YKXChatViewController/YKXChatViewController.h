//
//  YKXChatViewController.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "BaseNavcViewController.h"

@protocol YKXChatViewControllerDelegate <NSObject>

- (void)chatListTextMessage:(NSString *)messageText time:(NSString *)messageTime friendId:(NSString *)friendId;

@end

@interface YKXChatViewController : BaseNavcViewController

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *friendId;

@property (nonatomic,copy) NSString *headimgurl;

@property (nonatomic,assign) id<YKXChatViewControllerDelegate> delegete;

@end
