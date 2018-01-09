//
//  ShareActivityController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/5/31.
//  Copyright © 2017年 youyou. All rights reserved.
//  tableView设置的是大小，headView的大小类似与contentSize

#define titleWidth (SCREEN_WIDTH-32-20)/_titleArray.count
#define titleHeight 40

#import "ShareActivityController.h"
#import "ShareRewardViewController.h"
#import "MyShareViewController.h"
#import "ActivityRulesViewController.h"

@interface ShareActivityController ()

{
    //选中状态下的按钮
    UIButton *selectButton;
}

//tableview列表
@property (nonatomic,strong) UITableView *tableView;
//头部视图
@property (nonatomic,strong) UIView *rootHeadView;
//分享视图
@property (nonatomic,strong) UIView *rootShareView;

//标题数组
@property (nonatomic, strong) NSArray *titleArray;
//控制器数组
@property (nonatomic, strong) NSArray *controllerArray;
//当前选中的视图控制器
@property (nonatomic, weak) UIViewController *currentVC;
//按钮数组
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation ShareActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self createView];
}

- (void)initData{
    
    _buttonArray = [NSMutableArray array];
    self.titleArray = @[@"分享奖励",@"我的分享",@"活动规则"];
    
    ShareRewardViewController *shareRewardVC = [[ShareRewardViewController alloc] init];
    MyShareViewController *myShareVC = [[MyShareViewController alloc] init];
    ActivityRulesViewController *activityRulesVC = [[ActivityRulesViewController alloc] init];
    self.controllerArray = @[shareRewardVC,myShareVC,activityRulesVC];
}

- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"分享有奖";
}

- (void)createView{
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建头部视图
    [self obtainHeaderView];
}

//创建头部视图
- (void)obtainHeaderView{
    
    UIView *rootHeadView = [[UIView alloc] init];
    if(IPHONE5){
        rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+180);
    }else if (IPHONE6){
        rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+240);
    }else{
        rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+200);
    }
    
    rootHeadView.backgroundColor = [UIColor colorWithHexString:@"#FF003C"];
    self.rootHeadView = rootHeadView;
    self.tableView.tableHeaderView = rootHeadView;
    
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"shareHeader"];
    [rootHeadView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootHeadView);
        make.left.equalTo(rootHeadView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*253/414));
    }];
    
    //微信、QQ分享按钮
    UIView *rootShareView = [[UIView alloc] init];
    [rootHeadView addSubview:rootShareView];
    [rootShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootHeadView);
        make.top.equalTo(headImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 130));
    }];
    self.rootShareView = rootShareView;
    
    NSArray *itemTitleArray = @[@"微信好友",@"QQ好友",@"微信朋友圈"];
    NSArray *itemImageArray = @[@"weChat",@"qq",@"WeTimeLine"];
    CGFloat leftWidth = (SCREEN_WIDTH-210)/6;
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < 3; idx++) {
        
        YLButton *itemButton = [YLButton buttonWithType:UIButtonTypeCustom];        
        [itemButton setTitle:itemTitleArray[idx] forState:UIControlStateNormal];
        //设置按钮文字的大小
        itemButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        //设置按钮文字居中
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:itemImageArray[idx]] forState:UIControlStateNormal];
        itemButton.imageRect = CGRectMake(0, 0, 70, 70);
        itemButton.titleRect = CGRectMake(0, 70, 70, 20);
        [itemButton addTarget:self action:@selector(onClickShare:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = 100+idx;
        [rootShareView addSubview:itemButton];
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(90);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(@(20));
                make.left.equalTo(@(leftWidth));
            }else{
                
                make.top.equalTo(lastButton.mas_top).offset(0.0);
                make.left.equalTo(lastButton.mas_right).offset(2*leftWidth);
            }
        }];
        lastButton = itemButton;
    }
    
    //点击切换视图
    [self initWithTitleButton];
    [self initWithController];
 
}

- (void)initWithTitleButton{
    
    WEAKSELF(weakSelf);
    //头部的标题
    UIView *titleView = [[UIView alloc] init];
    [self.rootHeadView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.right.equalTo(@(-16));
        make.top.equalTo(weakSelf.rootShareView.mas_bottom);
        make.height.mas_equalTo(titleHeight);
    }];

    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < _titleArray.count; idx++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:_titleArray[idx] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[UIImage imageNamed:@"shareToff"] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleButton.tag = 200+idx;
        [titleButton addTarget:self action:@selector(onClickSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (idx == 0) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor colorWithHexString:@"#FA0000"] forState:UIControlStateNormal];
            [titleButton setBackgroundImage:[UIImage imageNamed:@"shareTon"] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
        
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(titleWidth);
            make.height.mas_equalTo(titleHeight);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(titleView);
                make.left.equalTo(titleView);
            }else{
                make.top.equalTo(lastButton);
                make.left.equalTo(lastButton.mas_right).offset(10);
            }
        }];
        lastButton = titleButton;
    }
}


- (void)initWithController{
    
    for (int i = 0; i < _controllerArray.count; i++) {
        
        [self addChildViewController:_controllerArray[i]];
        
        if(i==0){
            
            UIViewController *firstVC = _controllerArray[i];
            
            if(IPHONE5){
                // 设置尺寸位置 第一个视图控制器的高度比其他2个高
                firstVC.view.frame = CGRectMake(16, SCREEN_WIDTH*253/414+130+titleHeight, SCREEN_WIDTH-32, 370);
            }else{
                // 设置尺寸位置 第一个视图控制器的高度比其他2个高
                firstVC.view.frame = CGRectMake(16, SCREEN_WIDTH*253/414+130+titleHeight, SCREEN_WIDTH-32, 490);
            }
            
            
            // 加载第一次初始时的视图控制器
            [_rootHeadView addSubview:firstVC.view];
            //保存当前的控制器
            self.currentVC = firstVC;
        }
    }
}

#pragma mark 点击事件
#pragma mark 分享
- (void)onClickShare:(UIButton *)button{
    
    WEAKSELF(weakSelf);
    UMSocialPlatformType platformType;
    NSString *type;
    NSString *platformStr;
    
    if(button.tag == 100){//微信分享
        platformType = UMSocialPlatformType_WechatSession;
        type = @"1";
        platformStr = @"微信";
    }else if (button.tag == 101){//QQ分享
        platformType = UMSocialPlatformType_QQ;
        type = @"3";
        platformStr = @"QQ";
    }else{//微信朋友圈分享
        platformType = UMSocialPlatformType_WechatTimeLine;
        type = @"2";
        platformStr = @"微信";
    }
    
    if(![[UMSocialManager defaultManager] isInstall:platformType]){
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:[NSString stringWithFormat:@"您还未安装%@客户端",platformStr] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            
        }];
        [alertView show];
        return;
    }
    
    
    
    NSDictionary *loginDic = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginDic[@"uid"];
    NSString *token = loginDic[@"token"];
    
    NSString *shareType = @"1";
    NSString *shareId = @"0";
    
    NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
    //时间戳
    NSString *timeStamp = [YKXCommonUtil longLongTime];
    //获取6位随机数
    NSString *randCode = [YKXCommonUtil getRandomNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",type,uid,token,@"2",timeStamp,YOYO,randCode];
    //获取签名
    NSString *sign = [MyMD5 md5:tempStr];
    
    [HttpService loadDataSharePostType:type uid:uid token:token shareType:shareType shareId:shareId versionCode:versionCode devType:@"2" timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
        
        NSString *errorcode = responseObject[@"error_code"];
        
        if([errorcode isEqualToString:@"40000"] || [errorcode isEqualToString:@"40001"] || [errorcode isEqualToString:@"40002"] || [errorcode isEqualToString:@"40003"] || [errorcode isEqualToString:@"40004"]){
            
            [YKXCommonUtil showToastWithTitle:@"状态错误，请重新登录" view:self.view.window];
            return ;
        }
        
        if([errorcode isEqualToString:@"0"]){
            
            NSDictionary *dict = responseObject[@"data"];
            if([dict isKindOfClass:[NSNull class]]){
                return;
            }
            
            NSString *title = dict[@"title"];
            NSString *content = dict[@"content"];
            NSString *urlStr = dict[@"url"];
            NSString *iconURLStr = dict[@"icon_url"];
            
            NSURL *iconURL = [NSURL URLWithString:iconURLStr];
            NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
            
            urlStr = [YKXCommonUtil replaceDeviceSystemUrl:urlStr];
            
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *webPageObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:[UIImage imageWithData:iconData]];
            webPageObject.webpageUrl = urlStr;
            
            messageObject.shareObject = webPageObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:weakSelf completion:^(id result, NSError *error) {
            }];
            
        }
    } failure:^(NSError *error) {
        [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
    }];
}

#pragma mark 点击按钮切换视图控制器
- (void)onClickSelectToIndex:(UIButton *)btn{
    
    //获取当前点击按钮的下标
    NSInteger index = btn.tag-200;
    
    //改变之前的button
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"shareToff"] forState:UIControlStateNormal];
    //点击之后的button
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor colorWithHexString:@"#FA0000"] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"shareTon"] forState:UIControlStateNormal];
    // 取出选中的这个控制器
    UIViewController *vc = self.childViewControllers[btn.tag-200];
    
    // 设置尺寸位置
    if(index == 0 || index == 1){
    
        if(IPHONE5){
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+180);
        }else if (IPHONE6){
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+240);
        }else{
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+200);
        }
        
        if(IPHONE5){
            vc.view.frame = CGRectMake(16, SCREEN_WIDTH*253/414+130+titleHeight, SCREEN_WIDTH-32, 370);
        }else{
           vc.view.frame = CGRectMake(16, SCREEN_WIDTH*253/414+130+titleHeight, SCREEN_WIDTH-32, 490);
        }
        
        //重新赋值
        self.tableView.tableHeaderView = self.rootHeadView;
    }else{
        
        if(IPHONE5){
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+130);
        }else if (IPHONE6){
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+70);
        }else{
            self.rootHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+30);
        }
        
        vc.view.frame = CGRectMake(16, SCREEN_WIDTH*253/414+130+titleHeight, SCREEN_WIDTH-32, 320);
        //重新赋值
        self.tableView.tableHeaderView = self.rootHeadView;

    }
    
    // 移除掉当前显示的控制器的view（移除的是view，而不是控制器）
    [self.currentVC.view removeFromSuperview];
    // 把选中的控制器view显示到界面上
    [_rootHeadView addSubview:vc.view];
    self.currentVC = vc;
    
}

@end
