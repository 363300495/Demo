//
//  CardNotUseViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/7.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CardNotUseViewController.h"
#import "EnteringViewController.h"
#import "FreeCardViewController.h"
#import "CardNotUseCell.h"
#import "CardListModel.h"
@interface CardNotUseViewController ()

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong) NSArray *cardList;

@property (nonatomic,strong) NSArray *imageList;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) UIView *tableFooterView;
//没有卡券时提示背景
@property (nonatomic,strong) UIView *alertCardView;
//有卡券时的描述背景
@property (nonatomic,strong) UIView *descriptionView;

@end

@implementation CardNotUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.cardList = @[@"激活码通道",@"免费领取更多VIP时长券"];
    self.imageList = @[@"bind_m",@"juan_m"];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardUseList) name:NOTIFICATION_CARDUSER_STATUS_FREQUENCY object:nil];
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    [super createView];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    //cell底部分割线颜色
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //设置头部标题的高度为10，头部标题可以跟着cell以前滑动，分组样式的组头不能更正cell一起滑动
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
    
    //创建底部描述视图
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    self.tableView.tableFooterView = self.tableFooterView;

 
    //创建指示器
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@((SCREEN_HEIGHT-140)/2));
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


- (void)initData{
    
    WEAKSELF(weakSelf);
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,@"4",@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    //卡券类型未使用
    [HttpService loadDataPostUid:uid token:token versionCode:versionCode type:@"4" devType:@"2" timeStamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
    
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];

        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"0"]){
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            
            self.dataList = [CardListModel mj_objectArrayWithKeyValuesArray:dataArray];
            
            if(self.dataList.count == 0){
                
                if(self.descriptionView){
                    [self.descriptionView removeFromSuperview];
                    self.descriptionView = nil;
                }
                
                UIView *alertCardView = [[UIView alloc] init];
                [weakSelf.tableFooterView addSubview:alertCardView];
                [alertCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                weakSelf.alertCardView = alertCardView;
                
                
                UIImageView *alertImageView = [[UIImageView alloc] init];
                alertImageView.image = [UIImage imageNamed:@"empty_search_result"];
                [alertCardView addSubview:alertImageView];
                [alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(alertCardView);
                    make.top.equalTo(@(80*kWJHeightCoefficient));
                    make.size.mas_equalTo(CGSizeMake(310, 238));
                }];
                
                if(IPHONE5){
                    [alertImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(@(30));
                    }];
                }
                
                UILabel *alertLabel = [[UILabel alloc] init];
                alertLabel.textAlignment = NSTextAlignmentCenter;
                alertLabel.text = @"无可用卡券，请及时领取";
                alertLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
                [alertCardView addSubview:alertLabel];
                [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(alertCardView);
                    make.top.equalTo(alertImageView.mas_bottom);
                    make.height.mas_equalTo(@(30));
                }];
            }else{
                
                if(self.alertCardView){
                    [self.alertCardView removeFromSuperview];
                    self.alertCardView = nil;
                }
                
                UIView *descriptionView = [[UIView alloc] init];
                [weakSelf.tableFooterView addSubview:descriptionView];
                [descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(weakSelf.tableFooterView);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 100));
                }];
                self.descriptionView = descriptionView;
                
                UILabel *descriptionLabel1 = [[UILabel alloc] init];
                descriptionLabel1.text = @"点击“使用”，即可延长账户的VIP期限";
                descriptionLabel1.font = [UIFont systemFontOfSize:13.0f];
                descriptionLabel1.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
                descriptionLabel1.textAlignment = NSTextAlignmentLeft;
                [descriptionView addSubview:descriptionLabel1];
                [descriptionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(descriptionView);
                    make.top.equalTo(@(10));
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 20));
                }];
                
                UILabel *descriptionLabel2 = [[UILabel alloc] init];
                descriptionLabel2.text = @"点击“转赠”，把卡券赠送给您的好友";
                descriptionLabel2.font = [UIFont systemFontOfSize:13.0f];
                descriptionLabel2.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
                descriptionLabel2.textAlignment = NSTextAlignmentLeft;
                [descriptionView addSubview:descriptionLabel2];
                [descriptionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(descriptionView);
                    make.top.equalTo(descriptionLabel1.mas_bottom).offset(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40, 20));
                }];
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
        [self.refreshHeader endRefreshing];
    }];
}

//刷新重新加载数据
- (void)refreshData{
    [self initData];
}

//免费领券成功后刷新列表
- (void)cardUseList{
    [self initData];
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
        static NSString *cardListIdentifer = @"cardListIdentifer";
        CardNotUseCell *cell = [tableView dequeueReusableCellWithIdentifier:cardListIdentifer];
        if(!cell){
            cell = [[CardNotUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardListIdentifer];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.model = self.dataList[indexPath.row-self.cardList.count];
       
        cell.cardUseButton.tag = 1000+indexPath.row;
        cell.donationButton.tag = 2000+indexPath.row;

        if(!cell.useBlock){
            
            cell.useBlock = ^(UIButton *button){
                
                //获取当前点击的cell的行
                NSInteger index = button.tag - 1000;
                
                //获取当前的cid
                CardListModel *cardModel = weakSelf.dataList[index-weakSelf.cardList.count];
                NSString *cid = cardModel.cid;
                NSString *value = cardModel.val;
                
                NSString *text;
                if([cardModel.type integerValue] == 1){
                    text = @"天";
                }else if([cardModel.type integerValue] == 2){
                    text = @"月";
                }else if([cardModel.type integerValue] == 3){
                    text = @"年";
                }
                
                
                NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
                NSString *uid = loginUserInfo[@"uid"];
                NSString *token = loginUserInfo[@"token"];
                
                NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
                
                //时间戳
                NSString *timeStamp = [YKXCommonUtil longLongTime];
                //获取6位随机数
                NSString *randCode = [YKXCommonUtil getRandomNumber];
                
                NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,cid,@"2",timeStamp,YOYO,randCode];
                //获取签名
                NSString *sign = [MyMD5 md5:tempStr];
                
                [HttpService loadDataUseCardPostUid:uid token:token versionCode:versionCode cid:cid devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                    
                    
                    NSString *errorcode = responseObject[@"error_code"];
                    
                    if([errorcode isEqualToString:@"40000"]){
                        
                        [YKXCommonUtil showToastWithTitle:@"查询出错" view:self.view.window];
                        
                    }else if ([errorcode isEqualToString:@"40001"] || [errorcode isEqualToString:@"40002"] || [errorcode isEqualToString:@"40003"] || [errorcode isEqualToString:@"40004"]){     
                        
                        [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
                        
                        
                    }else if ([errorcode isEqualToString:@"40006"]){
                        
                        [YKXCommonUtil showToastWithTitle:@"同一个活动只能使用一张卡券" view:self.view.window];
                    }else if([errorcode isEqualToString:@"0"]){
                        
                    
                        SRAlertView *alertView = [SRAlertView sr_alertViewUseCardWithMessage:[NSString stringWithFormat:@"卡券使用成功，vip有效期延长%@%@",value,text] superVC:self leftActionTitle:@"确定" animationStyle:SRAlertViewAnimationTopToCenterSpring selectActionBlock:^(SRAlertViewActionType actionType) {
                            
                            
                        }];
                        [alertView showNative];
                        
                        
                        //修改当前的卡券使用日期
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
                        
                        
                        [button setTitle:@"已使用" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor colorWithHexString:@"#A3A3A3"] forState:UIControlStateNormal];
                        button.enabled = NO;
                        button.layer.borderColor = [UIColor colorWithHexString:@"#A3A3A3"].CGColor;
                        
                        
                        //当前点击的cell的转赠按钮
                        NSInteger tag = index+2000;
                        UIButton *donationButton = (UIButton *)[weakSelf.view viewWithTag:tag];
                        donationButton.hidden = YES;
                    
                    }else{
                        
                        [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
                    }
                    
                } failure:^(NSError *error) {
                    [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:weakSelf.view.window];
                }];
            };
        }
        
        
        //赠送
        if(!cell.donationBlock){
            
            cell.donationBlock = ^(UIButton *button) {
                
                //获取当前点击的cell的行
                NSInteger index = button.tag-2000;
                
                //获取当前的cid
                CardListModel *cardModel = weakSelf.dataList[index-weakSelf.cardList.count];
                NSString *cid = cardModel.cid;
                
                
                NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
                NSString *uid = loginUserInfo[@"uid"];
                NSString *token = loginUserInfo[@"token"];
                
                
                NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
                //时间戳
                NSString *timeStamp = [YKXCommonUtil longLongTime];
                //获取6位随机数
                NSString *randCode = [YKXCommonUtil getRandomNumber];
                
                
                
                NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,cid,@"2",timeStamp,YOYO,randCode];
                //获取签名
                NSString *sign = [MyMD5 md5:tempStr];
                
                [HttpService loadDataGiveCardPostUid:uid token:token versionCode:versionCode cid:cid devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                    
                    NSString *errorcode = responseObject[@"error_code"];
                    if([errorcode isEqualToString:@"0"]){
                        
                        NSDictionary *dict = responseObject[@"data"];
                        if([dict isKindOfClass:[NSNull class]]){
                            return ;
                        }
                        
                        NSString *content = dict[@"content"];
                        NSString *title = dict[@"title"];
                        NSString *url = dict[@"url"];
                        NSString *iconURLStr = dict[@"icon_url"];
                        
                        NSURL *iconURL = [NSURL URLWithString:iconURLStr];
                        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
                        
                    
                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                        
                        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
                        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                            
                            
                            UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageWithData:iconData]];
                            webPageObject.webpageUrl = url;
                            
                            messageObject.shareObject = webPageObject;
                            
                            
                            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:weakSelf completion:^(id result, NSError *error) {
                            }];
                        }];
                        
                    }else if ([errorcode isEqualToString:@"40000"]){
                        
                        [YKXCommonUtil showToastWithTitle:@"查询出错" view:self.view.window];
                    }else{
                        
                        [YKXCommonUtil showToastWithTitle:errorcode view:self.view.window];
                    }
                    
                } failure:^(NSError *error) {
                }];
            };
        }
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
        
        EnteringViewController *enterVC = [[EnteringViewController alloc] init];
        [self.navigationController pushViewController:enterVC animated:YES];
    }else if(indexPath.row == 1){
        //设置点击时的状态
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FreeCardViewController *freeCardVC = [[FreeCardViewController alloc] init];
        [self.navigationController pushViewController:freeCardVC animated:YES];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CARDUSER_STATUS_FREQUENCY object:nil];
}

@end
