//
//  DownLoadCompleteDataSource.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/28.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "DownLoadCompleteDataSource.h"

@implementation DownLoadCompleteDataSource

-(id)init{
    self.finishedTasks = [[NSMutableArray alloc ] init];
    return [super init];
}

/**
 *  读取下载完成的任务
 */
-(void)loadFinishedTasks{
    
    [self.finishedTasks removeAllObjects];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSArray *unFinishedTasks = [[MusicPartnerDownloadManager sharedInstance] loadFinishedTask];
    for (NSDictionary *taskDic in unFinishedTasks) {
        
        TaskEntity *taskEntity = [[TaskEntity alloc] init];
        
        taskEntity.completeTime = [taskDic objectForKey:@"completeTime"];
        
        [tempArray addObject:taskEntity.completeTime];
        
    }
    
    NSArray *completeTimeArray = [NSArray arrayWithArray:tempArray];
    
    //对任务完成的时间进行排序
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    
    completeTimeArray = [completeTimeArray sortedArrayUsingDescriptors:@[descriptor]];
    
    for(int i = 0 ; i<completeTimeArray.count ; i++){
        
        NSString *completeTime = completeTimeArray[i];
        
        for (NSDictionary *taskDic in unFinishedTasks) {
            
            TaskEntity *taskEntity = [[TaskEntity alloc ] init];
            
            NSString *downLoadString = [taskDic objectForKey:@"mpDownloadUrlString"];
            NSDictionary *exra       = [taskDic objectForKey:@"mpDownloadExtra"];
            NSString *downLoadPath   = [taskDic objectForKey:@"mpDownLoadPath"];
            
            taskEntity.downLoadUrl = downLoadString;
            
            taskEntity.completeTime = [taskDic objectForKey:@"completeTime"];
            
            taskEntity.name     = [exra objectForKey:@"name"];
            
            taskEntity.mpDownLoadPath = downLoadPath;
            
            if([completeTime isEqualToString:taskEntity.completeTime]){
                
                [self.finishedTasks addObject:taskEntity];
            }
        }
    }
    
    
    /*
    [self.finishedTasks removeAllObjects];
    
    NSArray *unFinishedTasks = [[MusicPartnerDownloadManager sharedInstance] loadFinishedTask];
    for (NSDictionary *taskDic in unFinishedTasks) {
        
        NSString *downLoadString = [taskDic objectForKey:@"mpDownloadUrlString"];
        NSDictionary *exra       = [taskDic objectForKey:@"mpDownloadExtra"];
        NSString *downLoadPath   = [taskDic objectForKey:@"mpDownLoadPath"];
        
        TaskEntity *taskEntity = [[TaskEntity alloc ] init];
        taskEntity.downLoadUrl = downLoadString;
        
        taskEntity.completeTime = [taskDic objectForKey:@"completeTime"];
        
//        taskEntity.imgName  = [exra objectForKey:@"imgName"];
        taskEntity.name     = [exra objectForKey:@"name"];
//        taskEntity.desc     = [exra objectForKey:@"desc"];
        taskEntity.mpDownLoadPath = downLoadPath;
        //将下载的任务逆序插入
        [self.finishedTasks insertObject:taskEntity atIndex:0];
    }
     */
}

@end
