//
//  MineMainViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/24.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "MineMainViewController.h"
#import "YKXLoginViewController.h"
#import "ShareActivityController.h"
#import "CardListViewController.h"
#import "AboutUsViewController.h"
#import "QuestionAnswerViewController.h"
#import "YKXSystemSettingController.h"
#import "PhoneLoginViewController.h"
#import "YKXCollectionListController.h"
#import "YKXWatchingViewController.h"
#import "DownloadViewController.h"
#import "YkXUserSignViewController.h"
#import "UIView+DKSBadge.h"


@interface MineMainViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) FMDBManager *manager;

//图片数组
@property (nonatomic,strong) NSMutableArray *imageList;
//数据数组
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UIImageView *vipImageView;

@property (nonatomic,strong) UILabel *headTitleLabel;

@property (nonatomic,strong) UILabel *headDetailLabel;

@property (nonatomic,strong) UIButton *headButton;

@property (nonatomic,strong) UIView *tableHeaderView;

@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UIView *bottomHeadView;

@property (nonatomic,strong) UITableView *tableView;

//右侧自定义的文字
@property (nonatomic,strong) UILabel *accessoryShareLabel;

@property (nonatomic,strong) UILabel *accessoryCardLabel;

@property (nonatomic,strong) UILabel *accessoryQustionLabel;

@property (nonatomic,strong) UILabel *accessoryMineLabel;

@property (nonatomic,strong) UILabel *accessoryCacheLabel;

@property (nonatomic,strong) UIButton *rightNavcButton;

//头像
@property (nonatomic,copy) NSString *headimgurl;
//QQ昵称
@property (nonatomic,copy) NSString *qq_nickname;
//微信昵称
@property (nonatomic,copy) NSString *wx_nickname;
//电话号码
@property (nonatomic,copy) NSString *mobile;

//用户连续签到天数
@property (nonatomic,copy) NSString *signcount;
//用户积分数
@property (nonatomic,copy) NSString *integral;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation MineMainViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    //每次进来重新请求个人信息
    [self setLoginInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFirst = NO;
    _manager = [FMDBManager sharedFMDBManager];
    

    //修改登录信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginInfo) name:NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
    //退出登录时修改优看信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLoginState) name:NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY object:nil];
    
    //修改VIP时间信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeExpireTime) name:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
    
    [self createNavc];
    [self createView];
    [self initData];
}

- (void)initData{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];

    if(loginUserInfo.count == 0){//如果是未登录状态(包括特殊号码的登录)
        
        _imageList = [NSMutableArray array];
        NSArray *imageArray1 = @[@"aboutus"];
        NSArray *imageArray2 = @[@"cache"];
        [_imageList addObject:imageArray1];
        [_imageList addObject:imageArray2];
        
        
        _dataList = [NSMutableArray array];
        NSArray *nameArray1 = @[@"关于我们"];
        NSArray *nameArray2 = @[@"清空缓存"];
        [_dataList addObject:nameArray1];
        [_dataList addObject:nameArray2];
        
    }else{//登录状态
        
        _imageList = [NSMutableArray array];
        NSArray *imageArray1 = @[@"discount",@"gifts"];
        NSArray *imageArray2 = @[@"FAQ",@"aboutus"];
        NSArray *imageArray3 = @[@"cache"];

        [_imageList addObject:imageArray1];
        [_imageList addObject:imageArray2];
        [_imageList addObject:imageArray3];
        
        _dataList = [NSMutableArray array];
        NSArray *nameArray1 = @[@"领VIP",@"分享有奖"];
        NSArray *nameArray2 = @[@"常见问题",@"关于我们"];
        NSArray *nameArray3 = @[@"清空缓存"];
        
        [_dataList addObject:nameArray1];
        [_dataList addObject:nameArray2];
        [_dataList addObject:nameArray3];
    }
    [self.tableView reloadData];
}


//设置头部视图信息
- (void)setLoginInfo{
    
    NSDictionary *loginInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginInfo.count == 0){//未登录状态包括特殊号码
        
        self.headTitleLabel.text = @"点击登录";
        self.headDetailLabel.text = [NSString stringWithFormat:@"%@VIP专享",PREVIOUSNAME];
        self.headButton.enabled = YES;
        self.vipImageView.hidden = YES;
        self.iconImageView.image = [UIImage imageNamed:@"setting_logo"];
    }else{//已登录状态
        
        self.headButton.enabled = YES;
        self.vipImageView.hidden = NO;
        
        //设置头部信息
        [self changeExpireTime];
    }
}

//设置头部个人信息
- (void)changeExpireTime{
    
    NSDictionary *loginInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(!_isFirst){
        _isFirst = YES;
        
        NSString *headimgurl = loginInfo[@"headimgurl"];
        NSString *nickname = loginInfo[@"nickname"];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl] placeholderImage:[UIImage imageNamed:@"setting_logo"]];
        self.headTitleLabel.text = nickname;
        
        NSString *imageStr = [YKXDefaultsUtil getMineExpireImage];
        self.vipImageView.image = [UIImage imageNamed:imageStr];
        
        self.headDetailLabel.text = [YKXDefaultsUtil getExpiretime];
    }
    
    NSString *uid = loginInfo[@"uid"];
    NSString *token = loginInfo[@"token"];
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    //获取当前时间
    NSString *currentTime = [YKXCommonUtil longLongTime];
    
    [HttpService loadDataUserinfoPostUid:uid token:token versionCode:versionCode  devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorCode = responseObject[@"error_code"];
        
        if([errorCode isEqualToString:@"0"]){
            
            //删掉VIP时间重新存
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"expireTime"];
            //删掉VIP图标重新存
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mineExpireImage"];
            
            
            NSDictionary *dataDic = responseObject[@"data"];
            if([dataDic isKindOfClass:[NSNull class]]){
                return ;
            }
            
            //头像
            self.headimgurl = dataDic[@"headimgurl"];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.headimgurl] placeholderImage:[UIImage imageNamed:@"setting_logo"]];
            
            //昵称
            NSString *nickname = dataDic[@"nickname"];
            self.headTitleLabel.text = nickname;
            
            //VIP过期时间
            NSString *expiretime = dataDic[@"expiretime"];
            NSString *dataStr = [YKXCommonUtil timeStamp:[expiretime integerValue]];
            
            
            self.qq_nickname = dataDic[@"qq_nickname"];
            self.wx_nickname = dataDic[@"wx_nickname"];
            self.mobile = dataDic[@"mobile"];
            
            NSString *timeStr;
            NSString *imageStr;
            if([expiretime integerValue] <= [currentTime integerValue]){
                
                timeStr = @"VIP:已过期";
                imageStr = @"VIPout";
                
            }else{
                
                timeStr = [NSString stringWithFormat:@"VIP:%@到期",dataStr];
                imageStr = @"VIP";
            }
            
            //VIP头像
            self.vipImageView.image = [UIImage imageNamed:imageStr];
            //VIP详细时间
            self.headDetailLabel.text = timeStr;
    
            //存入过期时间
            [YKXDefaultsUtil setExpiretime:timeStr];
            //存入图标
            [YKXDefaultsUtil setMineExpireImage:imageStr];
            
            self.signcount = dataDic[@"signcount"];
            self.integral = dataDic[@"integral"];
        }
    } failure:^(NSError *error) {
        
        //请求失败直接加载默认数据
        NSString *headimgurl = loginInfo[@"headimgurl"];
        NSString *nickname = loginInfo[@"nickname"];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl] placeholderImage:[UIImage imageNamed:@"setting_logo"]];
        self.headTitleLabel.text = nickname;
        
        NSString *imageStr = [YKXDefaultsUtil getMineExpireImage];
        self.vipImageView.image = [UIImage imageNamed:imageStr];
        
        self.headDetailLabel.text = [YKXDefaultsUtil getExpiretime];
    }];
}


#pragma mark 创建UI
- (void)createNavc{
    
    UIButton *rightNavcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavcButton.frame = CGRectMake(0, 0, 20, 20);
    [rightNavcButton setBackgroundImage:[UIImage imageNamed:@"ic_fan_setting"] forState:UIControlStateNormal];
    [rightNavcButton addTarget:self action:@selector(onClickSystemSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavcButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.rightNavcButton = rightNavcButton;
    
    
    NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"7"];
    
    if(dbmineRemindList.count >0){
        
        NSDictionary *dbRemindDic = dbmineRemindList[0];
        
        NSString *type = dbRemindDic[@"type"];
        if([type isEqualToString:@"0"]){
            [rightNavcButton hidenBadge];
        }else{
            [rightNavcButton showBadge];
        }
    }
}

- (void)createView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    //cell底部分割线颜色
    tableView.separatorColor = [UIColor colorWithHexString:@"#EAEAEA"];
    //cell底部的分割线靠左
    tableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //iOS11必须设置的三个属性
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建头部视图
    [self obtainHeaderView];
    //创建尾部视图
    [self obtainFooterView];
}


//创建头部视图
- (void)obtainHeaderView{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    UIView *tableHeaderView;
    if(loginUserInfo.count == 0){
        
        tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+120*kWJHeightCoefficient)];
        //创建头部视图
        tableHeaderView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableHeaderView = tableHeaderView;
        
        [self addRootView];
        
    }else{
        
        tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+120*kWJHeightCoefficient+100)];
        
        //创建头部视图
        tableHeaderView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableHeaderView = tableHeaderView;
        
        [self addRootView];
        
        [self createBottomHeadView];
    }
}


- (void)addRootView {
    
    WEAKSELF(weakSelf);
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.tableHeaderView).offset(0);
        make.top.equalTo(weakSelf.tableHeaderView).offset(19.5);
        make.height.mas_equalTo(120*kWJHeightCoefficient);
    }];
    self.rootView = rootView;
    
    
    CGFloat imageWidth = 80*kWJWidthCoefficient;
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = imageWidth/2;
    [rootView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20*kWJHeightCoefficient));
        make.left.equalTo(@(40*kWJWidthCoefficient));
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
    }];
    self.iconImageView = iconImageView;
    
    
    UILabel *headTitleLabel = [[UILabel alloc] init];
    headTitleLabel.textAlignment = NSTextAlignmentLeft;
    headTitleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [rootView addSubview:headTitleLabel];
    [headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(20*kWJWidthCoefficient);
        make.top.equalTo(@(35*kWJHeightCoefficient));
        make.height.mas_equalTo(25*kWJHeightCoefficient);
    }];
    self.headTitleLabel = headTitleLabel;
    
    
    UIImageView *vipImageView = [[UIImageView alloc] init];
    [rootView addSubview:vipImageView];
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTitleLabel.mas_right).offset(4);
        make.top.equalTo(headTitleLabel);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    vipImageView.hidden = YES;
    self.vipImageView = vipImageView;
    
    UILabel *headDetailLabel = [[UILabel alloc] init];
    headDetailLabel.textAlignment = NSTextAlignmentLeft;
    headDetailLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    headDetailLabel.font = [UIFont systemFontOfSize:15.0f];
    [rootView addSubview:headDetailLabel];
    [headDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headTitleLabel);
        make.top.equalTo(headTitleLabel.mas_bottom).offset(5*kWJHeightCoefficient);
        make.height.mas_equalTo(25*kWJHeightCoefficient);
    }];
    self.headDetailLabel = headDetailLabel;
    
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.backgroundColor = [UIColor clearColor];
    [headButton addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:headButton];
    [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.headButton = headButton;
}

- (void)createBottomHeadView{
    
    WEAKSELF(weakSelf);
    UIView *bottomHeadView = [[UIView alloc] init];
    bottomHeadView.backgroundColor = [UIColor whiteColor];
    [self.tableHeaderView addSubview:bottomHeadView];
    [bottomHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.tableHeaderView);
        make.top.equalTo(weakSelf.rootView.mas_bottom).offset(10);
        make.height.mas_equalTo(90);
    }];
    self.bottomHeadView = bottomHeadView;
    
    
    NSArray *itemTitleArray = @[@"我的收藏",@"观看历史",@"下载中心",@"签到积分"];
    NSArray *itemImageArray = @[@"colletion",@"wacthing",@"download",@"userSign"];
    //单个宽度
    NSInteger itemColumn = 4;
    CGFloat itemViewW = SCREEN_WIDTH/4.0;
    CGFloat itemViewH = 90;
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < 4; idx++) {
        
        YLButton *itemButton = [YLButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:itemTitleArray[idx] forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor colorWithHexString:LIGHT_COLOR] forState:UIControlStateNormal];
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [itemButton setImage:[UIImage imageNamed:itemImageArray[idx]] forState:UIControlStateNormal];
        itemButton.imageRect = CGRectMake((itemViewW-30)/2, 15, 30, 30);
        itemButton.titleRect = CGRectMake((itemViewW-60)/2, 54, 60, 30);
        [itemButton addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 100+idx;
        [bottomHeadView addSubview:itemButton];
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(itemViewW);
            make.height.mas_equalTo(itemViewH);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(bottomHeadView);
                make.left.equalTo(bottomHeadView);
            }else{
                if (idx % itemColumn == 0) { // 每行第一个控件
                    make.top.equalTo(lastButton.mas_bottom).offset(0.0);
                    make.left.equalTo(bottomHeadView).offset(0);
                } else {
                    make.top.equalTo(lastButton.mas_top).offset(0.0);
                    make.left.equalTo(lastButton.mas_right).offset(0.0);
                }
            }
        }];
        lastButton = itemButton;
        
        
        // 右边边框
        if((idx%itemColumn) != (itemColumn-1)){//如果不是最右边的按钮
            UILabel *rightLineLabel = [[UILabel alloc] init];
            [bottomHeadView addSubview:rightLineLabel];
            [rightLineLabel setBackgroundColor:[UIColor colorWithHexString:LIGHT_COLOR]];
            
            [rightLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemButton.mas_top).offset(0.4);
                make.left.equalTo(itemButton.mas_right).offset(-0.3);
                make.bottom.equalTo(itemButton.mas_bottom).offset(-0.4);
                make.width.mas_equalTo(0.3);
            }];
        }
    }
}

//添加尾部视图
- (void)obtainFooterView{
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,140*kWJHeightCoefficient)];
    self.tableView.tableFooterView = tableFooterView;
    
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = [NSString stringWithFormat:@"%@©2017·优享品质",DISPLAYNAME];
    copyrightLabel.font = [UIFont systemFontOfSize:13.0f];
    copyrightLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:copyrightLabel];
    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableFooterView);
        make.top.equalTo(tableFooterView.mas_top).offset(10*kWJHeightCoefficient);
        make.height.mas_equalTo(20);
    }];
    
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid;
    if(loginUserInfo.count > 0) {
        uid = loginUserInfo[@"uid"];
    }else {
        uid = @"";
    }
   
    
    //获取当前所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app版本号
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *systemLabel = [[UILabel alloc] init];
    systemLabel.text = [NSString stringWithFormat:@"版本:%@%@",appVersion,uid];
    systemLabel.font = [UIFont systemFontOfSize:13.0f];
    systemLabel.textAlignment = NSTextAlignmentCenter;
    systemLabel.textColor = [UIColor colorWithHexString:LIGHT_COLOR];
    [tableFooterView addSubview:systemLabel];
    [systemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableFooterView);
        make.top.equalTo(copyrightLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark 点击事件
- (void)functionAction:(UIButton *)sender{
    
    switch (sender.tag) {
        case 100:{
            
            YKXCollectionListController *collectionListVC = [[YKXCollectionListController alloc] init];
            [self.navigationController pushViewController:collectionListVC animated:YES];
            break;
        }
        case 101:{
            
            YKXWatchingViewController *watchingListVC = [[YKXWatchingViewController alloc] init];
            [self.navigationController pushViewController:watchingListVC animated:YES];
            
            break;
        }
        case 102:{
            
            DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
            [self.navigationController pushViewController:downloadVC animated:YES];
            
            break;
        }
        case 103:{
            
            YkXUserSignViewController *signVC = [[YkXUserSignViewController alloc] init];
            signVC.headimgurl = self.headimgurl;
            signVC.signCount = self.signcount;
            signVC.integral = self.integral;
            [self.navigationController pushViewController:signVC animated:YES];
            break;
        }
        default:
            break;
    }
}

//进入系统设置界面
- (void)onClickSystemSetting{
    
    NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"7"];
    
    if(dbmineRemindList.count >0){
        
        NSDictionary *dbRemindDic = dbmineRemindList[0];
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
        
        //将该条数据的time设为0
        [tempDic setObject:@"0" forKey:@"type"];
        
        [_manager updateRemindList:tempDic remindId:@"7"];
        
        [self.rightNavcButton hidenBadge];
    }
    
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    if(loginUserInfo.count == 0){
        [YKXCommonUtil showToastWithTitle:@"您还未登录" view:self.view.window];
        return;
    }
    
    YKXSystemSettingController *systemSettingVC = [[YKXSystemSettingController alloc] init];
    systemSettingVC.qq_nickname = self.qq_nickname;
    systemSettingVC.wx_nickname = self.wx_nickname;
    systemSettingVC.mobile = self.mobile;
    systemSettingVC.headimgurl = self.headimgurl;
    [self.navigationController pushViewController:systemSettingVC animated:YES];

}

//进入登录页面
- (void)onClickLogin{
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    if(loginUserInfo.count == 0){
        
        YKXLoginViewController *loginVC = [[YKXLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        
        [self onClickSystemSetting];
    }
}



//修改登录信息
- (void)changeLoginInfo{
    
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+120*kWJHeightCoefficient+100);
    
    [self createBottomHeadView];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.headButton.enabled = YES;
    self.vipImageView.hidden = NO;
   
    //VIP时间赋值
    [self changeExpireTime];

    _imageList = [NSMutableArray array];
    NSArray *imageArray1 = @[@"discount",@"gifts"];
    NSArray *imageArray2 = @[@"FAQ",@"aboutus"];
    NSArray *imageArray3 = @[@"cache"];
   
    [_imageList addObject:imageArray1];
    [_imageList addObject:imageArray2];
    [_imageList addObject:imageArray3];
    
    _dataList = [NSMutableArray array];
    NSArray *nameArray1 = @[@"领VIP",@"分享有奖"];
    NSArray *nameArray2 = @[@"常见问题",@"关于我们"];
    NSArray *nameArray3 = @[@"清空缓存"];

    [_dataList addObject:nameArray1];
    [_dataList addObject:nameArray2];
    [_dataList addObject:nameArray3];
    
    [self.tableView reloadData];
}

//退出登录时修改优看信息
- (void)exitLoginState{
    
    [self.bottomHeadView removeFromSuperview];
    self.bottomHeadView = nil;
    
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20+120*kWJHeightCoefficient);
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.headTitleLabel.text = @"点击登录";
    self.headDetailLabel.text = [NSString stringWithFormat:@"%@VIP专享",PREVIOUSNAME];
    self.headButton.enabled = YES;
    self.vipImageView.hidden = YES;
    self.iconImageView.image = [UIImage imageNamed:@"setting_logo"];

    _imageList = [NSMutableArray array];
    NSArray *imageArray1 = @[@"aboutus"];
    NSArray *imageArray2 = @[@"cache"];
    [_imageList addObject:imageArray1];
    [_imageList addObject:imageArray2];
    
    
    _dataList = [NSMutableArray array];
    NSArray *nameArray1 = @[@"关于我们"];
    NSArray *nameArray2 = @[@"清空缓存"];
    [_dataList addObject:nameArray1];
    [_dataList addObject:nameArray2];
    
    [self.tableView reloadData];
}


#pragma mark tableView代理事件
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return 20.0;
    }else{
        return 10.0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

//返回头部标题的颜色
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = (UITableViewHeaderFooterView *)view;
    headView.backgroundView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"DT_ DynamicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }

    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    //左边的图片
    UIImage *icon = [UIImage imageNamed:self.imageList[indexPath.section][indexPath.row]];
    CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    cell.imageView.layer.masksToBounds = YES;
    UIGraphicsEndImageContext();
    
    NSDictionary *loginInfo = [YKXDefaultsUtil getLoginUserInfo];
    if(loginInfo.count == 0){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.accessoryCardLabel.text = @"";
        self.accessoryShareLabel.text = @"";
        self.accessoryCardLabel.hidden = YES;
        self.accessoryShareLabel.hidden = YES;
    }else{
        
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        
        //红色文字
        UILabel *accessoryLabel1 = [[UILabel alloc] init];
        accessoryLabel1.backgroundColor = [UIColor redColor];
        accessoryLabel1.layer.cornerRadius = 9.0f;
        accessoryLabel1.layer.masksToBounds = YES;
        accessoryLabel1.textColor = [UIColor whiteColor];
        accessoryLabel1.font = [UIFont systemFontOfSize:12.0f];
        accessoryLabel1.textAlignment = NSTextAlignmentCenter;
        [accessoryView addSubview:accessoryLabel1];
        
        //红点小图标
        UILabel *accessoryLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 18, 8, 8)];
        accessoryLabel2.layer.cornerRadius = 4;
        accessoryLabel2.layer.masksToBounds = YES;
        accessoryLabel2.backgroundColor = [UIColor redColor];
        [accessoryView addSubview:accessoryLabel2];
        

        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 13, 14, 14)];
        accessoryImageView.image = [UIImage imageNamed:@"rightAccessory"];
        [accessoryView addSubview:accessoryImageView];
        
        cell.accessoryView = accessoryView;
        
    
        NSArray *remindDataArray = [_manager receiveRemindInfoList];
        
        for(NSDictionary *remindDic in remindDataArray){
            
            NSString *remind_id = remindDic[@"remind_id"];
            NSString *type = remindDic[@"type"];
            NSString *title = remindDic[@"title"];
            
            if(indexPath.section == 0){
                if(indexPath.row == 0){
                    
                    if([remind_id isEqualToString:@"8"]){
                        
                        if([type isEqualToString:@"0"]){//隐藏
                            accessoryLabel1.hidden = YES;
                            accessoryLabel2.hidden = YES;
                        }else if([type isEqualToString:@"1"]){//红点
                            accessoryLabel1.hidden = YES;
                            self.accessoryCardLabel = accessoryLabel2;
                        }else if ([type isEqualToString:@"2"]){//文字
                            accessoryLabel2.hidden = YES;
                            accessoryLabel1.text = title;
                            //根据文字来确定控件的宽度
                            CGSize contentStrSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
                            accessoryLabel1.frame = CGRectMake(120-contentStrSize.width-10-24, 11, contentStrSize.width+10, 18);
                            
                            self.accessoryCardLabel = accessoryLabel1;
                        }
                    }
                    
                }else if (indexPath.row == 1){
                    
                    
                    if([remind_id isEqualToString:@"9"]){
                        
                        if([type isEqualToString:@"0"]){//隐藏
                            accessoryLabel1.hidden = YES;
                            accessoryLabel2.hidden = YES;
                        }else if([type isEqualToString:@"1"]){//红点
                            accessoryLabel1.hidden = YES;
                            self.accessoryShareLabel = accessoryLabel2;
                        }else if ([type isEqualToString:@"2"]){//文字
                            accessoryLabel2.hidden = YES;
                            accessoryLabel1.text = title;
                            
                            CGSize contentStrSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
                            accessoryLabel1.frame = CGRectMake(120-contentStrSize.width-10-24, 11, contentStrSize.width+10, 18);
                            self.accessoryShareLabel = accessoryLabel1;
                        }
                    }

                }
            }else if(indexPath.section == 1){
                
                if(indexPath.row == 0){
                    
                    if([remind_id isEqualToString:@"10"]){
                        
                        if([type isEqualToString:@"0"]){//隐藏
                            accessoryLabel1.hidden = YES;
                            accessoryLabel2.hidden = YES;
                        }else if([type isEqualToString:@"1"]){//红点
                            accessoryLabel1.hidden = YES;
                            self.accessoryQustionLabel = accessoryLabel2;
                        }else if ([type isEqualToString:@"2"]){//文字
                            accessoryLabel2.hidden = YES;
                            accessoryLabel1.text = title;
                            
                            CGSize contentStrSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
                            accessoryLabel1.frame = CGRectMake(120-contentStrSize.width-10-24, 11, contentStrSize.width+10, 18);
                            self.accessoryQustionLabel = accessoryLabel1;
                        }
                    }

                }else if (indexPath.row == 1){
                    
                    if([remind_id isEqualToString:@"11"]){
                        
                        if([type isEqualToString:@"0"]){//隐藏
                            accessoryLabel1.hidden = YES;
                            accessoryLabel2.hidden = YES;
                        }else if([type isEqualToString:@"1"]){//红点
                            accessoryLabel1.hidden = YES;
                            self.accessoryMineLabel = accessoryLabel2;
                        }else if ([type isEqualToString:@"2"]){//文字
                            accessoryLabel2.hidden = YES;
                            accessoryLabel1.text = title;
                            
                            CGSize contentStrSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
                            accessoryLabel1.frame = CGRectMake(120-contentStrSize.width-10-24, 11, contentStrSize.width+10, 18);
                            self.accessoryMineLabel = accessoryLabel1;
                        }
                    }
     
                }
            }else{
                
                if([remind_id isEqualToString:@"12"]){
                    
                    if([type isEqualToString:@"0"]){//隐藏
                        accessoryLabel1.hidden = YES;
                        accessoryLabel2.hidden = YES;
                    }else if([type isEqualToString:@"1"]){//红点
                        accessoryLabel1.hidden = YES;
                        self.accessoryCacheLabel = accessoryLabel2;
                    }else if ([type isEqualToString:@"2"]){//文字
                        accessoryLabel2.hidden = YES;
                        accessoryLabel1.text = title;
                        
                        CGSize contentStrSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
                        accessoryLabel1.frame = CGRectMake(120-contentStrSize.width-10-24, 11, contentStrSize.width+10, 18);
                        self.accessoryCacheLabel = accessoryLabel1;
                    }
                }
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置点击时的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    if(loginUserInfo.count == 0){//如果是未登录状态
        
         if (indexPath.section == 0 && indexPath.row == 0){
            
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
            
        }else if(indexPath.section == 1 && indexPath.row == 0){
            
            [self clearCache];
        }
    }else{//登录状态
        
        if(indexPath.section == 0 && indexPath.row == 0){
            
            NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"8"];
            
            if(dbmineRemindList.count >0){
                
                NSDictionary *dbRemindDic = dbmineRemindList[0];
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
                
                //将该条数据的time设为0
                [tempDic setObject:@"0" forKey:@"type"];
                
                [_manager updateRemindList:tempDic remindId:@"8"];
                
                self.accessoryCardLabel.text = @"";
                self.accessoryCardLabel.hidden = YES;
            }
            
            
            CardListViewController *cardListVC = [[CardListViewController alloc] init];
            [self.navigationController pushViewController:cardListVC animated:YES];
            
            
        }else if(indexPath.section == 0 && indexPath.row == 1){
            
            
            NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"9"];
            
            if(dbmineRemindList.count >0){
                
                NSDictionary *dbRemindDic = dbmineRemindList[0];
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
                
                //将该条数据的time设为0
                [tempDic setObject:@"0" forKey:@"type"];
                
                [_manager updateRemindList:tempDic remindId:@"9"];
                
                self.accessoryShareLabel.text = @"";
                self.accessoryShareLabel.hidden = YES;
            }
            
            ShareActivityController *shareActivityVC = [[ShareActivityController alloc] init];
            [self.navigationController pushViewController:shareActivityVC animated:YES];
            
        }else if(indexPath.section == 1 && indexPath.row == 0){
            
            
            NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"10"];
            
            if(dbmineRemindList.count >0){
                
                NSDictionary *dbRemindDic = dbmineRemindList[0];
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
                
                //将该条数据的time设为0
                [tempDic setObject:@"0" forKey:@"type"];
                
                [_manager updateRemindList:tempDic remindId:@"10"];
                
                self.accessoryQustionLabel.text = @"";
                self.accessoryQustionLabel.hidden = YES;
            }
            
            QuestionAnswerViewController *QAFVC = [[QuestionAnswerViewController alloc] init];
            [self.navigationController pushViewController:QAFVC animated:YES];
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            
            NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"11"];
            
            if(dbmineRemindList.count >0){
                
                NSDictionary *dbRemindDic = dbmineRemindList[0];
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
                
                //将该条数据的time设为0
                [tempDic setObject:@"0" forKey:@"type"];
                
                [_manager updateRemindList:tempDic remindId:@"11"];
                
                self.accessoryMineLabel.text = @"";
                self.accessoryMineLabel.hidden = YES;
            }
            
            
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
            
            
        }else if(indexPath.section == 2 && indexPath.row == 0){
            
            NSArray *dbmineRemindList = [_manager receiveRemindInfoListremindId:@"12"];
            
            if(dbmineRemindList.count >0){
                
                NSDictionary *dbRemindDic = dbmineRemindList[0];
                
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dbRemindDic];
                
                //将该条数据的time设为0
                [tempDic setObject:@"0" forKey:@"type"];
                
                [_manager updateRemindList:tempDic remindId:@"12"];
                
                self.accessoryCacheLabel.text = @"";
                self.accessoryCacheLabel.hidden = YES;
            }
            [self clearCache];
        }
    }
}


- (void)clearCache{
    
    [YKXCommonUtil showHudWithTitle:@"请稍等" view:self.view.window];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //获取缓存大小
        float cacheSize = [YKXCacheUtil readCacheSize];
        int size = (int)(cacheSize*100);
        
        //清除缓存
        [YKXCacheUtil clearFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(size == 0){
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:@"暂无缓存" view:self.view.window];
            }else{
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:[NSString stringWithFormat:@"已清除缓存%.2fM",cacheSize] view:self.view.window];
            }
        });
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_USERINFO_STATUS_FREQUENCY object:nil];
}

@end
