//
//  FreeCardViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/6.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "FreeCardViewController.h"
#import "FreeCardCell.h"
#import "FreeCardModel.h"
#import "EnteringViewController.h"
#import "ShareActivityController.h"
#import "YKXPayViewController.h"
@interface FreeCardViewController ()

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong) NSArray *cardList;

@property (nonatomic,strong) NSArray *imageList;

@property (nonatomic,strong) NSArray *dataList;

@end

@implementation FreeCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.cardList = @[@"任性充值，立享VIP",@"好友分享，各赠1-7天VIP时长"];
    self.imageList = @[@"pay_m",@"share_m"];
    [self initData];
    
}


- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"免费领券";
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    [super createView];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //cell底部分割线颜色
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //设置头部标题的高度为10，头部标题可以跟着cell以前滑动，分组样式的组头不能更正cell一起滑动
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    

    //创建底部描述视图
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    UILabel *descriptionLabel1 = [[UILabel alloc] init];
    descriptionLabel1.text = @"官方将不定期免费发放VIP时长券";
    descriptionLabel1.font = [UIFont systemFontOfSize:13.0f];
    descriptionLabel1.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    descriptionLabel1.textAlignment = NSTextAlignmentLeft;
    [self.tableView.tableFooterView addSubview:descriptionLabel1];
    [descriptionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tableView.tableFooterView);
        make.top.equalTo(@(10));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 20));
    }];
    
    UILabel *descriptionLabel2 = [[UILabel alloc] init];
    descriptionLabel2.text = @"领取时可“立即使用”或先存入“卡券包”";
    descriptionLabel2.font = [UIFont systemFontOfSize:13.0f];
    descriptionLabel2.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    descriptionLabel2.textAlignment = NSTextAlignmentLeft;
    [self.tableView.tableFooterView addSubview:descriptionLabel2];
    [descriptionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tableView.tableFooterView);
        make.top.equalTo(descriptionLabel1.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 20));
    }];
    
    //创建指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.4f, 1.4f);
    activityIndicatorView.transform = transform;
    self.activityIndicatorView = activityIndicatorView;
    [activityIndicatorView startAnimating];
}

- (void)loadData{

    NSString *networkStatus = [YKXCommonUtil getNetWorkStates];
    
    if([networkStatus isEqualToString:@"GPS"] || [networkStatus isEqualToString:@"wifi"]){
        
        [self.rootView removeFromSuperview];
        self.rootView = nil;
        [self initData];
    }
}


- (void)refreshData{
    [self initData];
}

- (void)initData{

    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataGetWiatCardPostUid:uid token:token versionCode:versionCode devtype:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        if([responseObject[@"error_code"] integerValue] == 0){
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            
            self.dataList = [FreeCardModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            //请求数据之后将空白页显示出来
            self.isEmptyDataSetShouldDisplay = YES;
            //刷新加载空白页
            [self.tableView reloadEmptyDataSet];
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
    }];
}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count + self.cardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row <= 1){
        
        static NSString *cellID = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = self.cardList[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        //左边的图片
        UIImage *icon = [UIImage imageNamed:self.imageList[indexPath.row]];
        CGSize itemSize = CGSizeMake(25, 18);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        cell.imageView.layer.masksToBounds = YES;
        UIGraphicsEndImageContext();
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        
        WEAKSELF(weakSelf);
        static NSString *freeCardIdentifer = @"freeCardIdentifer";
        FreeCardCell *cell = [tableView dequeueReusableCellWithIdentifier:freeCardIdentifer];
        if(!cell){
            cell = [[FreeCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freeCardIdentifer];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //indexPath第二行为数组的第一个元素，防止数组越界
        cell.model = self.dataList[indexPath.row-self.cardList.count];
        
        cell.getCardButton.tag = 1000+indexPath.row;
        cell.clickButtonAction = ^(UIButton *button) {
            
            //获取当前点击按你的下标
            NSInteger index = button.tag - 1000;
    
            FreeCardModel *model = weakSelf.dataList[index-weakSelf.cardList.count];
            NSString *activity_id = model.activity_id;
            
            NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
            NSString *uid = loginUserInfo[@"uid"];
            NSString *token = loginUserInfo[@"token"];
            
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,activity_id,@"2",timeStamp,YOYO,randCode];
            //获取签名
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataGetFreeCardPostUid:uid token:token versionCode:versionCode activity_id:activity_id devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                
                NSString *errorcode = responseObject[@"error_code"];
                
                if([errorcode isEqualToString:@"40000"]){
                    
                    [YKXCommonUtil showToastWithTitle:@"查询出错" view:self.view.window];
                    
                }else if ([errorcode isEqualToString:@"40001"] || [errorcode isEqualToString:@"40002"] || [errorcode isEqualToString:@"40003"] || [errorcode isEqualToString:@"40004"]){
                    
                    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"状态错误，请重新登录" leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
                        
                    }];
                    [alertView show];
                    
                }else if([errorcode isEqualToString:@"40006"]){
                    
                    [YKXCommonUtil showToastWithTitle:@"当前用户已经领取过" view:self.view.window];
                    
                }else if([errorcode isEqualToString:@"0"]){
                    NSDictionary *dataDic = responseObject[@"data"];
                    if([dataDic isKindOfClass:[NSNull class]]){
                        return;
                    }
                    
                    NSString *cid = dataDic[@"cid"];
                    NSString *value = dataDic[@"val"];
                    NSString *type = dataDic[@"type"];
                    
                    NSString *text;
                    if([type integerValue] == 1){
                        text = @"天";
                    }else if([type integerValue] == 2){
                        text = @"月";
                    }else if([type integerValue] == 3){
                        text = @"年";
                    }
                    
                    
                    SRAlertView *alertView = [SRAlertView sr_alertViewGetCardWithMessage:@"成功领取，已放入“卡券包”。" superVC:self leftActionTitle:@"暂不使用" rightActionTitle:@"立即使用" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {
                        
                        if(actionType == 0){
                            
                            SRAlertView *alertView = [SRAlertView sr_alertViewUseCardWithMessage:@"已放入卡券包" superVC:self leftActionTitle:@"确定" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {

                            }];
                            [alertView showNative];
                            
                            
                            //发送通知，卡券列表界面卡券增加
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CARDUSER_STATUS_FREQUENCY object:nil];
                            
                        }else if(actionType == 1){//使用卡券
                            
                            NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
                            NSString *uid = loginDic[@"uid"];
                            NSString *token = loginDic[@"token"];
                            
                            
                            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,cid,@"2",timeStamp,YOYO,randCode];
                            //获取签名
                            NSString *sign = [MyMD5 md5:tempStr];
                            
                            [HttpService loadDataUseCardPostUid:uid token:token versionCode:versionCode cid:cid  devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                                
                                NSString *errorcodeSucccess = responseObject[@"error_code"];
                                
                                if([errorcodeSucccess isEqualToString:@"40000"] || [errorcodeSucccess isEqualToString:@"40001"] || [errorcodeSucccess isEqualToString:@"40002"] || [errorcodeSucccess isEqualToString:@"40003"] || [errorcodeSucccess isEqualToString:@"40004"]){
                                    
                                    [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
                                    
                                    return ;
                                }
                                
                                
                                if([errorcodeSucccess isEqualToString:@"0"]){
                                    
                                    SRAlertView *alertView = [SRAlertView sr_alertViewUseCardWithMessage:[NSString stringWithFormat:@"卡券使用成功，vip有效期延长%@%@",value,text] superVC:self leftActionTitle:@"确定" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {
                                    }];
                                    [alertView showNative];
                                    
                                    
                                    //发送通知，卡券列表界面卡券增加
                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CARDUSER_STATUS_FREQUENCY object:nil];
                                    //修改当前的卡券使用日期
                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
                                    
                                }
                                
                            } failure:^(NSError *error) {
                                [YKXCommonUtil showToastWithTitle:@"卡券使用失败" view:self.view.window];
                            }];
                        }     
                    }];
                    [alertView showNative];
                    
                    [button setTitle:@"已领取" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"#A3A3A3"] forState:UIControlStateNormal];
                    button.enabled = NO;
                    button.layer.borderColor = [UIColor colorWithHexString:@"#A3A3A3"].CGColor;
                }else{
                    
                    [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
                }
                
            } failure:^(NSError *error) {
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row <= 1){
        return 44;
    }else{
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        YKXPayViewController *ykxPayVC = [[YKXPayViewController alloc] init];
        [self.navigationController pushViewController:ykxPayVC animated:YES];
       
    }else if(indexPath.row == 1){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ShareActivityController *shareActivityVC = [[ShareActivityController alloc] init];
        [self.navigationController pushViewController:shareActivityVC animated:YES];
        
    }
}


@end
