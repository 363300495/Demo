//
//  CardInvalidViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/7.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CardInvalidViewController.h"
#import "CardListCell.h"
#import "CardListModel.h"
@interface CardInvalidViewController ()

//中间的旋转指示器
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,strong) NSArray *dataList;

@end

@implementation CardInvalidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)createView{
    
    WEAKSELF(weakSelf);
    [super createView];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    
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

- (void)refreshData{
    [self initData];
}

- (void)initData{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,@"3",@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    
    //卡券类型使用记录
    [HttpService loadDataPostUid:uid token:token versionCode:versionCode type:@"3" devType:@"2" timeStamp:timeStamp randcode:randCode sign:sign sucess:^(id responseObject) {
        
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView setHidesWhenStopped:YES];
        [self.refreshHeader endRefreshing];
        
        NSString *errorcode = responseObject[@"error_code"];
        
        if([errorcode isEqualToString:@"0"]){
            
            NSArray *dataArray = responseObject[@"data"];
            if([dataArray isKindOfClass:[NSNull class]]){
                return ;
            }
            self.dataList = [CardListModel mj_objectArrayWithKeyValuesArray:dataArray];
            
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
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cardListIdentifer = @"cardListIdentifer";
    CardListCell *cell = [tableView dequeueReusableCellWithIdentifier:cardListIdentifer];
    if(!cell){
        cell = [[CardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardListIdentifer];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}





@end
