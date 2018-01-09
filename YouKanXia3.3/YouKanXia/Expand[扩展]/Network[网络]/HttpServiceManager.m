//
//  HttpServiceManager.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "HttpServiceManager.h"

@implementation HttpServiceManager

+ (instancetype)sharedManager{
    static HttpServiceManager *_singetonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (nil == _singetonInstance) {
            
            //1.网络请求服务单例
            _singetonInstance = [[super allocWithZone:NULL] init];
            
            // 2、网络请求Session
            _singetonInstance.manager = [AFHTTPSessionManager manager];
            // 设置请求参数的类型:HTTP(AFJSONRequestSerializer, AFHTTPRequestSerializer)
            _singetonInstance.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            // 设置请求的超时时间
            [_singetonInstance.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            _singetonInstance.manager.requestSerializer.timeoutInterval = 30.0f;
            [_singetonInstance.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            // 设置服务器返回结果的类型:JSON(AFJSONResponseSerializer, AFHTTPResponseSerializer)
            _singetonInstance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
            _singetonInstance.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
            
        }
    });
    return _singetonInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedManager];
}

#pragma mark - GET请求
+ (void)GET:(NSString *)URL
 parameters:(NSDictionary *)parameters
    success:(HttpRequestSuccess)success
    failure:(HttpRequestFailed)failure{
    
    AFHTTPSessionManager *manager = [HttpServiceManager sharedManager].manager;
    
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - POST请求
+ (void)POST:(NSString *)URL
  parameters:(NSDictionary *)parameters
     success:(HttpRequestSuccess)success
     failure:(HttpRequestFailed)failure{
    
    AFHTTPSessionManager *manager = [HttpServiceManager sharedManager].manager;
    
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - 下载文件
+ (void)downloadWithURL:(NSString *)URL directionName:(NSString *)name
                success:(void(^)(NSString *filePath))success
                failure:(HttpRequestFailed)failure {
    
    // 1. 创建会话管理者
    AFHTTPSessionManager *manager = [HttpServiceManager sharedManager].manager;
    
    // 2. 创建下载路径和请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *path = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        success ? success(filePath.path) : nil;
        failure && error ? failure(error) : nil;
        
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
}


#pragma mark 上传文件
+ (void)uploadWithURL:(NSString *)URL
           parameters:(NSDictionary *)parameters
             filePath:(NSString *)filePath
              success:(HttpRequestSuccess)success
              failure:(HttpRequestFailed)failure {
    
    //上传当前的文件到服务器
    AFHTTPSessionManager *manager = [HttpServiceManager sharedManager].manager;
    
    //发送post请求上传路径
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
        
    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              success(responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              failure(error);
          }];
}


@end
