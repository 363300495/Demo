//
//  YKXCacheUtil.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/30.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXCacheUtil.h"

@implementation YKXCacheUtil

//计算整个目录大小
+ (float)readCacheSize{
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        //计算除视频播放文件以外的文件的大小
        if(![fileName containsString:@"MPCache"]){
            
            NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
            folderSize += [self fileSizeAtPath :fileAbsolutePath];
        }
    }
    return folderSize/( 1024.0 * 1024.0 );
}

//计算单个文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
}

//清除缓存
+ (void)clearFile{
  
    //文件路径
    NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subpaths) {
        
        //清除视频播放文件以外文件的缓存
        if(![subPath isEqualToString:@"MPCache"]){
            
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
    
    [[SDImageCache sharedImageCache] cleanDisk];
}


+ (void)clearDownloadFile {
    
    //文件路径
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subpaths) {
        
        //清除视频播放文件以外文件的缓存
        if([subPath isEqualToString:@"downloadCache"]){
            
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}


@end
