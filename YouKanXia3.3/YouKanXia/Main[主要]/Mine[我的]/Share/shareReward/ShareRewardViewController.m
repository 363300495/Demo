//
//  ShareRewardViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/6/2.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShareRewardViewController.h"
#import "ShareRewardRecordController.h"
#import "ShareRewardCell.h"
#import "ShareRewardModel.h"
@interface ShareRewardViewController ()

@property (nonatomic,strong) NSArray *dataList;

@end

@implementation ShareRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)initData{
    
    NSString *page = @"1";
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",page,uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataShareReceiveLogPostPage:page uid:uid token:token versionCode:versionCode devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"40004"]){
            [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
            return ;
        }
        
        if([errorCode isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return;
            }
            
            self.dataList = [ShareRewardModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            if(IPHONE5){
                if(self.dataList.count <= 5){
                    self.moreButton.hidden = YES;
                }else{
                    self.moreButton.hidden = NO;
                }
                
            }else{
                if(self.dataList.count <= 7){
                    self.moreButton.hidden = YES;
                }else{
                    self.moreButton.hidden = NO;
                }
            }
            
            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
    }];
}



#pragma mark 点击事件
- (void)onClickMore{
    
    ShareRewardRecordController *shareRewardRecordVC = [[ShareRewardRecordController alloc] init];
    [self.navigationController pushViewController:shareRewardRecordVC animated:YES];
}

#pragma mark tableView代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *shareIdentifer = @"shareIdentifer";
    ShareRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:shareIdentifer];
    if(!cell){
        cell = [[ShareRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareIdentifer];
    }
    
    cell.model = self.dataList[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以显示7组数据,最后80显示更多按钮
    return 60.0f;
}


@end
