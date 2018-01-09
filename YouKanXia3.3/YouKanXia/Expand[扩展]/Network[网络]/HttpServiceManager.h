//
//  HttpServiceManager.h
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);
/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);


@interface HttpServiceManager : NSObject

// 网络请求Session
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/**
 *  网络状态管理单例
 */
+ (instancetype)sharedManager;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 */
+ (void)GET:(NSString *)URL
 parameters:(NSDictionary *)parameters
    success:(HttpRequestSuccess)success
    failure:(HttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 */
+ (void)POST:(NSString *)URL
  parameters:(NSDictionary *)parameters
     success:(HttpRequestSuccess)success
     failure:(HttpRequestFailed)failure;



/**
 下载文件
 
 @param URL     请求地址
 @param name    文件存储目录
 @param success 请求成功回调（filePath文件路径）
 @param failure 请求失败的回调
 */
+ (void)downloadWithURL:(NSString *)URL
          directionName:(NSString *)name
                success:(void(^)(NSString *filePath))success
                failure:(HttpRequestFailed)failure;




/**
 上传文件
 
 @param URL         请求地址
 @param parameters  请求参数
 @param filePath    本地文件路径
 @param success     请求成功回调
 @param failure     请求失败回调
 */
+ (void)uploadWithURL:(NSString *)URL
           parameters:(NSDictionary *)parameters
             filePath:(NSString *)filePath
              success:(HttpRequestSuccess)success
              failure:(HttpRequestFailed)failure;


@end
