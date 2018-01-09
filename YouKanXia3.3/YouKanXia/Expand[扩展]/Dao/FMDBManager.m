//
//  FMDBManager.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface FMDBManager ()
{
    FMDatabase *dataBase;
}
@end

static FMDBManager *dbManager = nil;
@implementation FMDBManager

+ (instancetype)sharedFMDBManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if(!dbManager){
            
            dbManager = [[FMDBManager alloc] init];
        }
    });
    return dbManager;
}

- (instancetype)init{
    
    if(self = [super init]){
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/communicates.db"];
        
        dataBase = [[FMDatabase alloc] initWithPath:path];
        
        BOOL success = [dataBase open];
        if (success)
        {
            NSString *sql = @"create table if not exists friendList(friends_id varchar(32),headimgurl varchar(128),name varchar(32),title varchar(128),time varchar(32),count varchar(32),url varchar(128))";
            
            BOOL friendTableIsCreate = [dataBase executeUpdate:sql];
            
            if(friendTableIsCreate)
            {
//                YKXDEBUGLog(@"好友列表创建成功");
            }else
            {
//                YKXDEBUGLog(@"好友列表创建失败");
            }
            
            
            NSString *chatSql = @"create table if not exists chatList(friends_id varchar(32),addtime varchar(32),content varchar(256),fnid varchar(32),img_url varchar(128),title varchar(128),type varchar(32),url varchar(128),newstype varchar(32),isTimeShow varchar(32),js_1 varchar(2048),js_2 varchar(2048),user_agent varchar(256))";
            
            BOOL chatTableIsCreate = [dataBase executeUpdate:chatSql];
            
            if(chatTableIsCreate)
            {
//                YKXDEBUGLog(@"聊天列表创建成功");
            }else
            {
//                YKXDEBUGLog(@"好友列表创建失败");
            }
            
            
            NSString *phoneInfoSql = @"create table if not exists phoneInfoList(channel_id varchar(32),headimgurl varchar(128),logintype varchar(32),mobile varchar(32),nickname varchar(32),token varchar(128),uid varchar(32))";
            
            BOOL phoneInfoTableIsCreate = [dataBase executeUpdate:phoneInfoSql];
            
            if(phoneInfoTableIsCreate)
            {
//                YKXDEBUGLog(@"登录列表创建成功");
            }else
            {
//                YKXDEBUGLog(@"登录列表创建失败");
            }
            
            
            
            NSString *bindInfoSql = @"create table if not exists bindInfoList(qq_nickname varchar(32),wx_nickname varchar(32),mobile varchar(32))";
            
            BOOL bindInfoTableIsCreate = [dataBase executeUpdate:bindInfoSql];
            
            if(bindInfoTableIsCreate){
//                YKXDEBUGLog(@"绑定账号列表创建成功");
            }else{
//                YKXDEBUGLog(@"绑定账号列表创建失败");
            }
            
            NSString *remindInfoSql = @"create table if not exists remindInfoList(img_url varchar(128),name varchar(128),remind_id varchar(32),time varchar(32),title varchar(128),type varchar(32),url varchar(128))";
            
            BOOL remindInfoTableIsCreate = [dataBase executeUpdate:remindInfoSql];
            
            if(remindInfoTableIsCreate){
//                YKXDEBUGLog(@"小红点列表创建成功");
            }else{
//                YKXDEBUGLog(@"小红点列表创建失败");
            }
            
            
            NSString *watchListInfoSql = @"create table if not exists watchInfoList(title varchar(64),url varchar(128),time varchar(32),type varchar(32))";
            
            BOOL watchInfoTableIsCreate = [dataBase executeUpdate:watchListInfoSql];
            
            if(watchInfoTableIsCreate){
//                YKXDEBUGLog(@"观看记录列表创建成功");
            }else{
//                YKXDEBUGLog(@"观看记录列表创建失败");
            }
        }
        else
        {
//            YKXDEBUGLog(@"数据库打开失败");
        }
    }
    return self;
}


#pragma mark 好友信息
//插入好友信息
- (BOOL)insertFriendList:(NSDictionary *)friendList{
    
    NSString *sql = @"insert into friendList(friends_id,headimgurl,name,title,time,count,url) values (?,?,?,?,?,?,?)";
    
    BOOL success = [dataBase executeUpdate:sql,friendList[@"friends_id"],friendList[@"headimgurl"],friendList[@"name"],friendList[@"title"],friendList[@"time"],friendList[@"count"],friendList[@"url"]];
    
    if(success){
//        YKXDEBUGLog(@"好友信息插入成功");
    }else{
//        YKXDEBUGLog(@"好友信息插入失败");
    }
    
    return success;
}

//删除好友信息
- (BOOL)deleteFriendListByFriendId:(NSString *)friendId{
    
    NSString *sql = @"delete from friendList where friends_id = ?";
    
    BOOL success = [dataBase executeUpdate:sql,friendId];
    if(success){
//        YKXDEBUGLog(@"好友信息删除成功");
    }else{
//        YKXDEBUGLog(@"好友信息删除失败");
    }
    return success;
}

//修改好友信息
- (BOOL)updateFriendList:(NSDictionary *)friendList ByFriendId:(NSString *)friendId{
    
    NSString *sql = @"update friendList set headimgurl = ?,name = ?,title = ?,time = ?,count = ?,url = ? where friends_id = ?";
    BOOL success = [dataBase executeUpdate:sql,friendList[@"headimgurl"],friendList[@"name"],friendList[@"title"],friendList[@"time"],friendList[@"count"],friendList[@"url"],friendId];
    if(success){
//        YKXDEBUGLog(@"修改好友信息成功");
    }else{
//        YKXDEBUGLog(@"修改好友信息失败");
    }
    return success;
}


//修改好友信息角标
- (BOOL)updateFriendListInCount:(NSString *)count ByFriendId:(NSString *)friendId{
    
    NSString *sql = @"update friendList set count = ? where friends_id = ?";
    BOOL success = [dataBase executeUpdate:sql,count,friendId];
    if(success){
//        YKXDEBUGLog(@"修改好友信息角标成功");
    }else{
//        YKXDEBUGLog(@"修改好友信息角标失败");
    }
    return success;
    
    
}

//修改好友内容
- (BOOL)updateFriendListContent:(NSString *)content time:(NSString *)time ByFriendId:(NSString *)friendId{
    
    NSString *sql = @"update friendList set title = ?, time = ? where friends_id = ?";
    BOOL success = [dataBase executeUpdate:sql,content,time,friendId];
    if(success){
//        YKXDEBUGLog(@"修改好友信息内容成功");
    }else{
//        YKXDEBUGLog(@"修改好友信息内容失败");
    }
    return success;
    
}


//查询Id对应的好友信息
- (NSMutableArray *)receiveFriendListByFriendId:(NSString *)friendId{
    
    NSString *sql = @"select * from friendList where friends_id = ?";
    
    FMResultSet *results = [dataBase executeQuery:sql,friendId];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
}


//查询好友信息
- (NSMutableArray *)receiveFriendList{
    
    NSString *sql = @"select * from friendList";
    
    FMResultSet *results = [dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
    
}

//查询好友信息通过时间排序
- (NSMutableArray *)receiveFriendListByTime{
    
    NSString *sql = @"select * from friendList order by time desc";
    
    FMResultSet *results = [dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
    
}

//删除好友
- (BOOL)deleteFriendList{
    
    NSString *sql = @"delete from friendList";
    
    BOOL success = [dataBase executeUpdate:sql];
    if(success){
//        YKXDEBUGLog(@"聊天记录删除成功");
    }else{
//        YKXDEBUGLog(@"聊天记录删除失败");
    }
    return success;
}

#pragma mark 聊天信息
//插入聊天信息
- (BOOL)insertChatList:(NSDictionary *)chatList{
    
    NSString *sql = @"insert into chatList(friends_id,addtime,content,fnid,img_url,title,type,url,newstype,isTimeShow,js_1,js_2,user_agent) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL success = [dataBase executeUpdate:sql,chatList[@"friends_id"],chatList[@"addtime"],chatList[@"content"],chatList[@"fnid"],chatList[@"img_url"],chatList[@"title"],chatList[@"type"],chatList[@"url"],chatList[@"newstype"],chatList[@"isTimeShow"],chatList[@"js_1"],chatList[@"js_2"],chatList[@"user_agent"]];
    
    if(success){
//        YKXDEBUGLog(@"聊天信息插入成功");
    }else{
//        YKXDEBUGLog(@"聊天信息插入失败");
    }
    
    return success;
}

//通过好友Id查询聊天信息
- (NSMutableArray *)receiveChatListByFriendId:(NSString *)friendId{
    
    NSString *sql = @"select * from chatList where friends_id = ?";
    
    FMResultSet *results = [dataBase executeQuery:sql,friendId];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
}

//逆序查询n条好友信息
- (NSMutableArray *)receiveChatListByFriendId:(NSString *)friendId numStart:(NSString *)numStart numEnd:(NSString *)numEnd{
    
    NSString *sql = @"select * from chatList where friends_id = ? order by addtime desc limit ?,?";
    
    FMResultSet *results = [dataBase executeQuery:sql,friendId,numStart,numEnd];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
    
}

- (BOOL)deleteChatList{
    
    NSString *sql = @"delete from chatList";
    
    BOOL success = [dataBase executeUpdate:sql];
    if(success){
//        YKXDEBUGLog(@"消息删除成功");
    }else{
//        YKXDEBUGLog(@"消息删除失败");
    }
    return success;
}


#pragma mark 登录信息
//插入电话号码登录个人信息
- (BOOL)insertPhoneInfoList:(NSDictionary *)phoneInfoList{
    
    NSString *sql = @"insert into phoneInfoList(channel_id,headimgurl,logintype,mobile,nickname,token,uid) values (?,?,?,?,?,?,?)";
    
    BOOL success = [dataBase executeUpdate:sql,phoneInfoList[@"channel_id"],phoneInfoList[@"headimgurl"],phoneInfoList[@"logintype"],phoneInfoList[@"mobile"],phoneInfoList[@"nickname"],phoneInfoList[@"token"],phoneInfoList[@"uid"]];
    
    if(success){
//        YKXDEBUGLog(@"登录信息插入成功");
    }else{
//        YKXDEBUGLog(@"登录信息插入失败");
    }
    return success;
}


//获取电话号码登录信息
- (NSMutableArray *)receivePhoneInfoList{
    
    NSString *sql = @"select * from phoneInfoList";
    
    FMResultSet *results = [dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
}

//获取电话号码对应的个人信息
- (NSMutableArray *)receivePhoneInfoListByPhoneNumber:(NSString *)phoneNumber{
    
    NSString *sql = @"select * from phoneInfoList where mobile = ?";
    
    FMResultSet *results = [dataBase executeQuery:sql,phoneNumber];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
    
}


#pragma mark 动态小红点信息列表
- (BOOL)insertRemindInfoList:(NSDictionary *)remindInfoList{
    
    NSString *sql = @"insert into remindInfoList(img_url,name,remind_id,time,title,type,url) values (?,?,?,?,?,?,?)";
    
    BOOL success = [dataBase executeUpdate:sql,remindInfoList[@"img_url"],remindInfoList[@"name"],remindInfoList[@"remind_id"],remindInfoList[@"time"],remindInfoList[@"title"],remindInfoList[@"type"],remindInfoList[@"url"]];
    
    if(success){
//        YKXDEBUGLog(@"动态小红点信息插入成功");
    }else{
//        YKXDEBUGLog(@"动态小红点信息插入失败");
    }
    return success;
}


- (BOOL)updateRemindList:(NSDictionary *)remindDic remindId:(NSString *)remindId{
    
    NSString *sql = @"update remindInfoList set img_url = ?, name = ?, time = ?, title = ?, type = ?, url = ? where remind_id = ?";
    BOOL success = [dataBase executeUpdate:sql,remindDic[@"img_url"],remindDic[@"name"],remindDic[@"time"],remindDic[@"title"],remindDic[@"type"],remindDic[@"url"],remindId];
    if(success){
//        YKXDEBUGLog(@"修改小红点信息内容成功");
    }else{
//        YKXDEBUGLog(@"修改小红点信息内容失败");
    }
    return success;
}

//获取动态小红点信息列表
- (NSMutableArray *)receiveRemindInfoList{
    
    NSString *sql = @"select * from remindInfoList";
    
    FMResultSet *results = [dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
}

- (NSMutableArray *)receiveRemindInfoListremindId:(NSString *)remindId{
    
    NSString *sql = @"select * from remindInfoList where remind_id = ?";
    
    FMResultSet *results = [dataBase executeQuery:sql,remindId];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
}



#pragma mark 观看视频历史列表
- (BOOL)insertWatchInfoList:(NSDictionary *)watchInfoList {
    
    NSString *sql = @"insert into watchInfoList(title,url,time,type) values (?,?,?,?)";
    
    BOOL success = [dataBase executeUpdate:sql,watchInfoList[@"title"],watchInfoList[@"url"],watchInfoList[@"time"],watchInfoList[@"type"]];
    
    if(success){
//        YKXDEBUGLog(@"观看信息插入成功");
    }else{
//        YKXDEBUGLog(@"观看信息插入失败");
    }
    return success;
}


//删除观看记录
- (BOOL)deleteWatchListByWatchingTime:(NSString *)watchingTime {
    
    NSString *sql = @"delete from watchInfoList where time = ?";
    
    BOOL success = [dataBase executeUpdate:sql,watchingTime];
    if(success){
//          YKXDEBUGLog(@"观看记录删除成功");
    }else{
//          YKXDEBUGLog(@"观看记录删除失败");
    }
    return success;
    
}

//删除所有观看记录
- (BOOL)deleteAllWatchList {
    
    NSString *sql = @"delete from watchInfoList";
    
    BOOL success = [dataBase executeUpdate:sql];
    if(success){
//                  YKXDEBUGLog(@"观看记录删除成功");
    }else{
//                  YKXDEBUGLog(@"观看记录删除失败");
    }
    return success;
}

//获取所有的观看记录
- (NSMutableArray *)receiveWatchList {
    
    NSString *sql = @"select * from watchInfoList order by time desc";
    
    FMResultSet *results = [dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([results next]) {
        NSDictionary *dict = [results resultDictionary];
        [dataArray addObject:dict];
    }
    return dataArray;
    
}

@end
