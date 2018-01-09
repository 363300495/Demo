//
//  FMDBManager.h
//  YouKanXia
//
//  Created by 汪立 on 2017/8/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBManager : NSObject

+ (instancetype)sharedFMDBManager;


#pragma mark 好友信息
//插入好友信息
- (BOOL)insertFriendList:(NSDictionary *)friendList;

//删除好友信息
- (BOOL)deleteFriendListByFriendId:(NSString *)friendId;

//修改好友信息
- (BOOL)updateFriendList:(NSDictionary *)friendList ByFriendId:(NSString *)friendId;

//修改好友信息角标
- (BOOL)updateFriendListInCount:(NSString *)count ByFriendId:(NSString *)friendId;

//修改好友内容
- (BOOL)updateFriendListContent:(NSString *)content time:(NSString *)time ByFriendId:(NSString *)friendId;

//查询好友信息
- (NSMutableArray *)receiveFriendList;

//查询好友信息通过时间排序
- (NSMutableArray *)receiveFriendListByTime;

//查询Id对应的好友信息
- (NSMutableArray *)receiveFriendListByFriendId:(NSString *)friendId;

//删除好友
- (BOOL)deleteFriendList;


#pragma mark 聊天信息
//插入聊天信息
- (BOOL)insertChatList:(NSDictionary *)chatList;

//通过好友Id查询聊天信息
- (NSMutableArray *)receiveChatListByFriendId:(NSString *)friendId;

//逆序查询n条好友信息
- (NSMutableArray *)receiveChatListByFriendId:(NSString *)friendId numStart:(NSString *)numStart numEnd:(NSString *)numEnd;

//删除聊天信息
- (BOOL)deleteChatList;


#pragma mark 登录信息
//插入电话号码登录个人信息
- (BOOL)insertPhoneInfoList:(NSDictionary *)phoneInfoList;

//获取电话号码登录信息
- (NSMutableArray *)receivePhoneInfoList;

//获取电话号码对应的个人信息
- (NSMutableArray *)receivePhoneInfoListByPhoneNumber:(NSString *)phoneNumber;


#pragma mark 动态小红点信息列表
- (BOOL)insertRemindInfoList:(NSDictionary *)remindInfoList;


- (BOOL)updateRemindList:(NSDictionary *)remindDic remindId:(NSString *)remindId;

//获取动态小红点信息列表
- (NSMutableArray *)receiveRemindInfoList;

- (NSMutableArray *)receiveRemindInfoListremindId:(NSString *)remindId;

#pragma mark 观看视频历史列表
- (BOOL)insertWatchInfoList:(NSDictionary *)watchInfoList;

//删除观看记录
- (BOOL)deleteWatchListByWatchingTime:(NSString *)watchingTime;

//删除所有观看记录
- (BOOL)deleteAllWatchList;

//获取所有的观看记录
- (NSMutableArray *)receiveWatchList;

@end
