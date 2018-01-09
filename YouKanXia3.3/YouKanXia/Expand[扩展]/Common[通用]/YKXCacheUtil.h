//
//  YKXCacheUtil.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/30.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKXCacheUtil : NSObject

//获取缓存文件的大小
+ (float)readCacheSize;

//清除缓存
+ (void)clearFile;

//清除m3u8文件
+ (void)clearDownloadFile;

@end
