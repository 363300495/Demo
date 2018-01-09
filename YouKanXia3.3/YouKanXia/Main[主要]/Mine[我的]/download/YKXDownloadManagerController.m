//
//  YKXDownloadManagerController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/27.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXDownloadManagerController.h"
#import "DownloadManagerCell.h"
#import "DownRecommendCell.h"
#import "MusicDownloadDataSource.h"
#import "DownLoadCompleteDataSource.h"
#import "YKXCompleteViewController.h"
#import <AdSupport/AdSupport.h>

@interface YKXDownloadManagerController () <UITableViewDelegate,UITableViewDataSource,DownRecommendCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic , strong) MusicDownloadDataSource *dataSource;

@property (nonatomic , strong) DownLoadCompleteDataSource *downLoadCompleteDataSource;

@property (nonatomic,strong) NSMutableArray *dataList;

@end

@implementation YKXDownloadManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    [self initData];
    
}

- (void)initData {
    
    self.dataList = [NSMutableArray array];
    self.dataSource = [[MusicDownloadDataSource alloc] init];
    self.downLoadCompleteDataSource = [[DownLoadCompleteDataSource alloc] init];
    
    [self loadNewAndmpDownloadCompleteTask];
    
    //每次新增任务时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskNotification) name:MpDownLoadingTask object:nil];
    
    //任务完成时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskNotification) name:MpDownLoadCompleteTask object:nil];
    
    //下载完成的任务和正在下载的任务删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskNotification) name:MpDownLoadCompleteDeleteCount object:nil];
}


- (void)loadNewAndmpDownloadCompleteTask {
    
    [self.dataList removeAllObjects];
    
    [self.dataSource loadUnFinishedTasks];
   
    [self.dataSource startDownLoadUnFinishedTasks];
    
    [self.downLoadCompleteDataSource loadFinishedTasks];
    
    
    //第一组数据
    [self.dataList addObject:self.dataSource.unFinishedTasks];
    

    //第二组数据要先加入DownRecommendModel对象的数组防止数据崩溃
    DownRecommendModel *tempModel = [[DownRecommendModel alloc] init];
    [self.dataList addObject:@[tempModel]];
    
    
    //第三组数据
    NSString *downLoadCompleteText;
    if(self.downLoadCompleteDataSource.finishedTasks.count == 0){
        
        downLoadCompleteText = @"查看更多(无已下载内容)";
    }else{
        downLoadCompleteText = [NSString stringWithFormat:@"查看更多(%ld项)",self.downLoadCompleteDataSource.finishedTasks.count];
    }
    
    [self.dataList addObject:@[downLoadCompleteText]];
    

    //请求到数据时替换第二组数据
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *devType = @"2";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",uid,token,devType,timeStamp,YOYO,randCode];
    
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataDownloadRecommendPostUid:uid token:token versionCode:versionCode devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {

        NSString *errorcode = responseObject[@"error_code"];
        
        if([errorcode isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            
            NSArray *tempArray = [DownRecommendModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            //将第二组数据内容替换
            [self.dataList replaceObjectAtIndex:1 withObject:tempArray];

            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)downloadTaskNotification {
    
    [self.dataSource loadUnFinishedTasks];
    
    [self.dataSource startDownLoadUnFinishedTasks];
    
    [self.downLoadCompleteDataSource loadFinishedTasks];
    
    
    //替换第一组数据
    [self.dataList replaceObjectAtIndex:0 withObject:self.dataSource.unFinishedTasks];
    
    
    //替换第三组数据
    NSString *downLoadCompleteText;
    if(self.downLoadCompleteDataSource.finishedTasks.count == 0){
        
        downLoadCompleteText = @"查看更多(无已下载内容)";
    }else{
        downLoadCompleteText = [NSString stringWithFormat:@"查看更多(%ld项)",self.downLoadCompleteDataSource.finishedTasks.count];
    }
    
    [self.dataList replaceObjectAtIndex:2 withObject:@[downLoadCompleteText]];
    
    [self.tableView reloadData];
}


- (void)createView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    //cell底部分割线颜色
    tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}


#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataList.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        static NSString *downloadIdentifier = @"downIdentifier";
        
        DownloadManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadIdentifier];
        if(!cell) {
            
            cell = [[DownloadManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadIdentifier];
        }
        
        TaskEntity *taskEntity    = self.dataList[indexPath.section][indexPath.row];
        
        [cell showData:taskEntity];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexPath.section == 1){
    
        static NSString *moreIdentifier = @"recommendIdentifier";
        
        DownRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
        
        if(!cell){
        
            cell = [[DownRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataList[indexPath.section][indexPath.row];
        
        cell.index = indexPath;
        cell.delegate = self;
        return cell;
        
    }else{
        
        static NSString *completeIdentifier = @"completeIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:completeIdentifier];
        if(!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completeIdentifier];
            
        }
        
        UIImage *downloadImage = [UIImage imageNamed:@"duigou"];
        CGSize itemSize = CGSizeMake(44*kWJWidthCoefficient, 44*kWJWidthCoefficient);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [downloadImage drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        cell.imageView.layer.masksToBounds = YES;
        UIGraphicsEndImageContext();
        
        
        cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70*kWJHeightCoefficient;
}

//返回分组头部标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    if(section == 0) {
        
        if([self.dataList[section] count] == 0){
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithHexString:DEEP_COLOR];
            label.font = [UIFont systemFontOfSize:16.0f];
            label.text = @"下载中";
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(16));
                make.top.equalTo(@(14));
                make.height.equalTo(@(20));
            }];
            
            UILabel *bottomLabel = [[UILabel alloc] init];
            bottomLabel.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
            [headerView addSubview:bottomLabel];
            [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(headerView);
                make.top.equalTo(label.mas_bottom).offset(20);
                make.height.mas_equalTo(0.4);
            }];
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.text = @"无下载内容";
            contentLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
            contentLabel.font = [UIFont systemFontOfSize:14.0f];
            [headerView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(headerView);
                make.top.equalTo(bottomLabel.mas_bottom).offset(30);
                make.height.equalTo(@(20));
            }];
            
            
        }else{
          
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithHexString:DEEP_COLOR];
            label.font = [UIFont systemFontOfSize:16.0f];
            label.text = @"下载中";
            [headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(16));
                make.centerY.equalTo(headerView);
            }];
            
        }
        
    }else{
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        label.font = [UIFont systemFontOfSize:16.0f];
        
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(16));
            make.centerY.equalTo(headerView);
        }];
        
        if(section == 1){
            label.text = @"大家都在下";
        }else{
            label.text = @"已下载";
        }
        
    }

    return headerView;
}

// 返回组头部view的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        
        if([self.dataList[section] count] == 0){
            return 128;
        }else{
           return 48;
        }
    }else{
        return 48;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 2){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        YKXCompleteViewController *completeVC = [[YKXCompleteViewController alloc] init];
        [self.navigationController pushViewController:completeVC animated:YES];
    }
}

//设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if(editingStyle == UITableViewCellEditingStyleDelete){
            
            TaskEntity *taskEntity = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
            
            //删除缓存的本地文件
            [[MusicPartnerDownloadManager sharedInstance] deleteFile:taskEntity.downLoadUrl];
            [self.dataSource.unFinishedTasks removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            
            //修改
            [[NSNotificationCenter defaultCenter] postNotificationName:MpDownLoadCompleteDeleteCount object:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}


- (void)addDownRecommendTaskAction:(NSIndexPath *)indexPath {
    
    DownRecommendModel *model = self.dataList[indexPath.section][indexPath.row];
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    //下载的链接
    NSString *downLoadUrl = [NSString stringWithFormat:@"%@",model.down_url];
    
    if(downLoadUrl.length > 0){
        
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{UID}" withString:[NSString stringWithFormat:@"%@",uid]];
        downLoadUrl = [downLoadUrl stringByReplacingOccurrencesOfString:@"{TOKEN}" withString:[NSString stringWithFormat:@"%@",token]];
        
        MPTaskState taskState = [[MusicPartnerDownloadManager sharedInstance] getTaskState:downLoadUrl];
        
        switch (taskState) {
            case MPTaskCompleted:
                
                [YKXCommonUtil showToastWithTitle:@"下载完成，请到[下载管理]中查看" view:self.view.window];
                
                break;
            case MPTaskExistTask:
                
                [YKXCommonUtil showToastWithTitle:@"正在下载，请到[下载管理]中查看进度" view:self.view.window];
                
                break;
            case MPTaskNoExistTask:
            {
                //这里给taskEntity赋值
                MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                downLoadEntity.downLoadUrlString = downLoadUrl;
                downLoadEntity.extra = model.mj_keyValues;
                [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                
                [YKXCommonUtil showToastWithTitle:@"添加成功，正在下载" view:self.view.window];
            }
                break;
            default:
                break;
        }
    }else{
        
        //跳转的链接
        [self headViewActionURL:model.url];
    }
}



- (void)headViewActionURL:(NSString *)urlStr{
    
    if(urlStr == nil || urlStr.length == 0){
        return;
    }
    
    urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
    
    if([urlStr containsString:@"uu-ext"] || [urlStr containsString:@"UU-EXT"]){//跳到外部链接
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"uu-ext" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"UU-EXT" withString:@""];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        
    }else{
        
        YKXActivityViewController *activityVC = [[YKXActivityViewController alloc] init];
        activityVC.urlStr = urlStr;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
}

@end
