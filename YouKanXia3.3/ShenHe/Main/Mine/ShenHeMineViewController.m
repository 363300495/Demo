//
//  ShenHeMineViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeMineViewController.h"
#import "ShenHeAboutusViewController.h"
#import "ShenHeLoginViewController.h"

@interface ShenHeMineViewController () <UITableViewDelegate,UITableViewDataSource>

//图片数组
@property (nonatomic,strong) NSMutableArray *imageList;
//数据数组
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *headTitleLabel;

@property (nonatomic,strong) UILabel *headDetailLabel;

@property (nonatomic,strong) UIButton *headButton;

@property (nonatomic,strong) UIView *tableHeaderView;

@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UIView *bottomHeadView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ShenHeMineViewController

- (void)viewDidLoad {
    
    [self createView];
    
    [self initData];
    
    //修改特殊号码登录信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialLoginSuccess) name:NOTIFICATION_SPECIAL_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
    //修改特殊号码退出登录信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialExitSuccess) name:NOTIFICATION_SPECIAL_EXIT_STAUS_CHANGE_FREQUENCY object:nil];
    
}

- (void)initData {
    
    NSString *status = [YKXDefaultsUtil getPhonenumberStatus];
    
    if([status isEqualToString:SPECIALPHONENUMBER]){
        
        NSString *phoneNumber = status;
        NSString *numberString = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.headTitleLabel.text = @"欢迎您";
        self.headDetailLabel.text = numberString;
        self.headButton.enabled = NO;
        
    }else{
        
        self.headTitleLabel.text = @"点击登录";
        self.headDetailLabel.text = [NSString stringWithFormat:@"%@VIP专享",PREVIOUSNAME];
        self.headButton.enabled = YES;
    }
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
    
   UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20+120*kWJHeightCoefficient)];
    //创建头部视图
    tableHeaderView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableHeaderView = tableHeaderView;
    
    [self addRootView];
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
    
}


//修改特殊号码登录信息
- (void)specialLoginSuccess{
    
    NSString *phoneNumber = SPECIALPHONENUMBER;
    NSString *numberString = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.headTitleLabel.text = @"欢迎您";
    self.headDetailLabel.text = numberString;
    self.headButton.enabled = NO;
    
}

//修改特殊号码退出登录信息
- (void)specialExitSuccess{
    self.headTitleLabel.text = @"点击登录";
    self.headDetailLabel.text = [NSString stringWithFormat:@"%@VIP专享",PREVIOUSNAME];
    self.headButton.enabled = YES;
}


#pragma mark 登录界面
- (void)onClickLogin{
    
    ShenHeLoginViewController *phoneLoginVC = [[ShenHeLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
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
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置点击时的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0){
        
        ShenHeAboutusViewController *aboutUsVC = [[ShenHeAboutusViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        
        [self clearCache];
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

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPECIAL_LOGIN_STATUS_CHANGE_FREQUENCY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPECIAL_EXIT_STAUS_CHANGE_FREQUENCY object:nil];

}

@end
