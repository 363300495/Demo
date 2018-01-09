//
//  YKXSystemSettingController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/17.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXSystemSettingController.h"
#import "YKXRevisePasswordController.h"
#import "PhoneBindViewController.h"
#import "YKXSystemSettingHeadCell.h"
#import "YKXSystemSettingTextCell.h"
#import "AppDelegate.h"

@interface YKXSystemSettingController () <UITableViewDelegate,UITableViewDataSource,PhoneBindViewControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) NSMutableArray *detailList;

@property (nonatomic,strong) FMDBManager *manager;



@end

@implementation YKXSystemSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createView];
    [self initData];
}

#pragma mark 创建UI
- (void)createNavc{
    
    [super createNavc];
    self.navigationItem.title = @"设置";
}

- (void)createView{
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //创建头部视图
    UIView *rootHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    rootHeadView.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    tableView.tableHeaderView = rootHeadView;
    
    //创建尾部视图
    [self obtainFooterView];
}

- (void)obtainFooterView{
    
    UIView *rootFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-16, 50)];
    textLabel.numberOfLines = 0;
    textLabel.text = @"提示：一键登录/QQ/微信/手机号绑定后，将共享最长的VIP有效期。";
    textLabel.textColor = [UIColor colorWithHexString:@"#A6A6A6"];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    [rootFooterView addSubview:textLabel];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame)+30, SCREEN_WIDTH, 50);
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor colorWithHexString:@"#FC767E"] forState:UIControlStateNormal];
    exitButton.backgroundColor = [UIColor whiteColor];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [exitButton addTarget:self action:@selector(onClickExitLogin) forControlEvents:UIControlEventTouchUpInside];
    [rootFooterView addSubview:exitButton];
    
    self.tableView.tableFooterView = rootFooterView;
}

#pragma mark 初始化数据
- (void)initData{
    
    _manager = [FMDBManager sharedFMDBManager];
    
    //获取用户个人信息中的昵称和头像
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    
    NSString *loginType = loginUserInfo[@"logintype"];
    NSString *nickname = loginUserInfo[@"nickname"];
    NSString *loginNickname = [NSString stringWithFormat:@"昵称（%@）",nickname];
    NSInteger type = [loginType integerValue];


    NSString *QQNickname;
    NSString *weChatNickname;
    NSString *mobileNickname;
    NSString *QQbind;
    NSString *weChatBind;
    NSString *mobileBind;
    
    if(self.qq_nickname.length == 0){
        QQNickname = @"QQ账号";
        QQbind = @"马上绑定";
    }else{
        QQNickname = [NSString stringWithFormat:@"QQ账号（%@）",self.qq_nickname];
        QQbind = @"";
    }
    
    if(self.wx_nickname.length == 0){
        weChatNickname = @"微信账号";
        weChatBind = @"马上绑定";
    }else{
        weChatNickname = [NSString stringWithFormat:@"微信账号（%@）",self.wx_nickname];
        weChatBind = @"";
    }
    
    if(self.mobile.length == 0){
        mobileNickname = @"手机号";
        mobileBind = @"马上绑定";
    }else{
        mobileNickname = [NSString stringWithFormat:@"手机号 (%@)",self.mobile];
        mobileBind = @"";
    }

    
    switch (type) {
        case userInfoLoginTypePhone:
        {
            _dataList = [NSMutableArray arrayWithArray:@[@"头像",loginNickname,QQNickname,weChatNickname,mobileNickname]];
            _detailList = [NSMutableArray arrayWithArray:@[@"",@"",QQbind,weChatBind,@""]];
            break;
        }
        case userInfoLoginTypeWechat:
        {
            _dataList = [NSMutableArray arrayWithArray:@[@"头像",loginNickname,QQNickname,weChatNickname,mobileNickname]];
            _detailList = [NSMutableArray arrayWithArray:@[@"",@"",QQbind,@"",mobileBind]];

            break;
        }
        case userInfoLoginTypeQQ:
        {
            _dataList = [NSMutableArray arrayWithArray:@[@"头像",loginNickname,QQNickname,weChatNickname,mobileNickname]];
            _detailList = [NSMutableArray arrayWithArray:@[@"",@"",@"",weChatBind,mobileBind]];
            
            break;
        }
        case userInfoLoginTypeVisitor:
        {
            _dataList = [NSMutableArray arrayWithArray:@[@"头像",loginNickname,QQNickname,weChatNickname,mobileNickname]];
            _detailList = [NSMutableArray arrayWithArray:@[@"",@"",QQbind,weChatBind,mobileBind]];
            
            break;
        }
        case userInfoLoginTypeUsername:
        {
            NSString *username = [NSString stringWithFormat:@"用户名 (%@)",nickname];
            _dataList = [NSMutableArray arrayWithArray:@[@"头像",loginNickname,username,QQNickname,weChatNickname,mobileNickname]];
            _detailList = [NSMutableArray arrayWithArray:@[@"",@"",@"修改密码",QQbind,weChatBind,mobileBind]];
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark 点击事件
- (void)onClickExitLogin{
    
    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:@"退出登录" leftActionTitle:@"取消" rightActionTitle:@"确定" animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
        
        if(actionType == 1){
            
            [YKXCommonUtil showHudWithTitle:@"退出登录中" view:self.view.window];
            
            //清空登录信息
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginUserInfo"];
            //避免数据丢失
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(userExitSuccess) withObject:nil afterDelay:1 inModes:@[NSDefaultRunLoopMode, UITrackingRunLoopMode]];
            
        }
    }];
    [alertView show];
}


- (void)userExitSuccess{
    
    [YKXCommonUtil hiddenHud];
    [YKXCommonUtil showToastWithTitle:@"退出登录成功" view:self.view.window];


    //修改登录信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EXIT_STATUS_CHANGE_FREQUENCY object:nil];
    
    //修改消息界面信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MESSAGEINFO_STATUS_FREQUENCY object:nil];

    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timeString"];
    
    NSArray *dbArray = [_manager receiveFriendList];
    for (NSDictionary *dbDict in dbArray){
        
        NSString *dbFriendId = dbDict[@"friends_id"];
        
        //删除存储的消息时间
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"friend%@",dbFriendId]];
    }
    //避免数据丢失
    [[NSUserDefaults standardUserDefaults] synchronize];
    //删除好友信息列表
    [_manager deleteFriendList];
    //删除消息列表
    [_manager deleteChatList];
    
    //退出登录去掉角标
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mainVC.tabBar hideMarkIndex:1];
    appDelegate.badgeCount = 0;
    
    [super onClickBack];
}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        static NSString *headIdentifier = @"headIdentifier";
        YKXSystemSettingHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
        if(!headCell){
            
            headCell = [[YKXSystemSettingHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headIdentifier];
        }
        
        //设置头像
        [headCell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headimgurl] placeholderImage:[UIImage imageNamed:@"setting_logo"]];
        
        return headCell;
    }else{
        static NSString *textIdentifier = @"textIdentifier";
        YKXSystemSettingTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:textIdentifier];
        
        if(!textCell){
            
            textCell = [[YKXSystemSettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textIdentifier];
        }
        
        if(indexPath.row == 1){
            textCell.rightAccesroyView.hidden = YES;
        }
        textCell.titleLabel.text = self.dataList[indexPath.row];
        textCell.descriptionLabel.text = self.detailList[indexPath.row];
        
        return textCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置点击时的状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *loginUserInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *uid = loginUserInfo[@"uid"];
    NSString *token = loginUserInfo[@"token"];
    NSString *loginType = loginUserInfo[@"logintype"];
    //当前用户的登录方式 （有5种方式）
    NSInteger type = [loginType integerValue];
    
    
    UMSocialPlatformType platformType;
    NSString *platformStr;
    //当前用户的绑定方式（有3种方式）
    NSString *bindType;
    
    
//    if(indexPath.row == 0){
//        
//        WEAKSELF(weakSelf);
//        self.imagePickerController = [[YKXImagePickerController alloc] init];
//        self.imagePickerController.allowsEditing = YES;
//        
//        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if (![weakSelf.imagePickerController isCameraAvailable]) {
//                [YKXCommonUtil showToastWithTitle:@"照相机不可用！" view:self.view.window];
//                return;
//            }
//            
//            [weakSelf.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera superVC:weakSelf completion:^(UIImage *image, CTImagePickerStatus status) {
//                //                [weakSelf updateUserHeaderImage:image];
//            }];
//            
//        }];
//        
//        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            if (![weakSelf.imagePickerController isPhotoLibraryAvailable]) {
//                [YKXCommonUtil showToastWithTitle:@"相册不可用！" view:self.view.window];
//                
//            }
//            [weakSelf.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary superVC:weakSelf completion:^(UIImage *image, CTImagePickerStatus status) {
//                //                [weakSelf updateUserHeaderImage:image];
//            }];
//        }];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        
//        [alertVc addAction:cameraAction];
//        [alertVc addAction:photoAction];
//        [alertVc addAction:cancelAction];
//        [self presentViewController:alertVc animated:YES completion:nil];
//        
//    }
    
    
    switch (type) {
        case userInfoLoginTypePhone:
        {
            if(indexPath.row == 2){//QQ账号绑定
                
                platformType = UMSocialPlatformType_QQ;
                platformStr = @"QQ";
                bindType = @"3";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if (indexPath.row == 3){//微信账号绑定
                
                platformType = UMSocialPlatformType_WechatSession;
                platformStr = @"微信";
                bindType = @"2";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }
            break;
        }
        case userInfoLoginTypeWechat:
        {
            if(indexPath.row == 2){//QQ账号绑定
                platformType = UMSocialPlatformType_QQ;
                platformStr = @"QQ";
                bindType = @"3";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if (indexPath.row == 4){//手机号绑定
                PhoneBindViewController *phoneVC = [[PhoneBindViewController alloc] init];
                phoneVC.bindType = @"1";
                phoneVC.delegete = self;
                phoneVC.index = indexPath.row;
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
            break;
        }
        case userInfoLoginTypeQQ:
        {
            if(indexPath.row == 3){//微信账号绑定
                
                platformType = UMSocialPlatformType_WechatSession;
                platformStr = @"微信";
                bindType = @"2";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if (indexPath.row == 4){//手机号绑定
                PhoneBindViewController *phoneVC = [[PhoneBindViewController alloc] init];
                phoneVC.bindType = @"1";
                phoneVC.delegete = self;
                phoneVC.index = indexPath.row;
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
            break;
        }
        case userInfoLoginTypeVisitor:
        {
            if(indexPath.row == 2){//QQ账号绑定
                
                platformType = UMSocialPlatformType_QQ;
                platformStr = @"QQ";
                bindType = @"3";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if (indexPath.row == 3){//微信账号绑定
                
                platformType = UMSocialPlatformType_WechatSession;
                platformStr = @"微信";
                bindType = @"2";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if (indexPath.row == 4){//手机号绑定
                PhoneBindViewController *phoneVC = [[PhoneBindViewController alloc] init];
                phoneVC.bindType = @"1";
                phoneVC.delegete = self;
                phoneVC.index = indexPath.row;
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
            break;
        }
        case userInfoLoginTypeUsername:
        {
            if(indexPath.row == 2){//修改密码
                
                NSString *nickname = self.dataList[indexPath.row];
                
                NSString *reviseNickname = [nickname substringWithRange:NSMakeRange(5, nickname.length - 6)];
                
                YKXRevisePasswordController *revisePasswordVC = [[YKXRevisePasswordController alloc] init];
                revisePasswordVC.phoneNumber = reviseNickname;
                [self.navigationController pushViewController:revisePasswordVC animated:YES];
                
            }else if(indexPath.row == 3){//QQ账号绑定
                
                platformType = UMSocialPlatformType_QQ;
                platformStr = @"QQ";
                bindType = @"3";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if(indexPath.row == 4){//微信账号绑定
                
                platformType = UMSocialPlatformType_WechatSession;
                platformStr = @"微信";
                bindType = @"2";
                
                [self bindAccountPlatformType:platformType platformStr:platformStr bindType:bindType uid:uid token:token indexPath:indexPath];
            }else if(indexPath.row == 5){//手机号绑定
                
                PhoneBindViewController *phoneVC = [[PhoneBindViewController alloc] init];
                phoneVC.bindType = @"1";
                phoneVC.delegete = self;
                phoneVC.index = indexPath.row;
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark  QQ、微信绑定
- (void)bindAccountPlatformType:(UMSocialPlatformType)platformType platformStr:(NSString *)platformStr bindType:(NSString *)bindType uid:(NSString *)uid token:(NSString *)token indexPath:(NSIndexPath *)indexPath{
    
    if(![[UMSocialManager defaultManager] isInstall:platformType]){
        SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"提示" icon:nil message:[NSString stringWithFormat:@"您还未安装%@客户端",platformStr] leftActionTitle:@"确定" rightActionTitle:nil animationStyle:SRAlertViewAnimationNone selectActionBlock:^(SRAlertViewActionType actionType) {
            
        }];
        [alertView show];
        return;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        [YKXCommonUtil showHudWithTitle:[NSString stringWithFormat:@"%@绑定中",platformStr] view:self.view.window];
        
        if (!error) {
            
            UMSocialUserInfoResponse *resp = result;
            
            NSString *openId = resp.openid;
            NSString *nickname = resp.name;
            NSString *headImageUrl = resp.iconurl;
            
            NSString *channelId = @"0";
            NSString *versionCode = [YKXCommonUtil getCurrentSystemVersion];
            
            NSString *devType = @"2";
            //时间戳
            NSString *timeStamp = [YKXCommonUtil longLongTime];
            //获取6位随机数
            NSString *randCode = [YKXCommonUtil getRandomNumber];
            
            NSString *tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",uid,token,channelId,devType,timeStamp,YOYO,randCode];
            
            NSString *sign = [MyMD5 md5:tempStr];
            
            [HttpService loadDataBindUserInfoUid:uid token:token channel_id:channelId versionCode:versionCode type:bindType mobile:openId smsCode:nickname headImgurl:headImageUrl devType:devType timeStamp:timeStamp randCode:randCode sign:sign sucess:^(id responseObject) {
                
                [YKXCommonUtil hiddenHud];
            
                
                NSString *qqnickname = responseObject[@"qq_nickname"];
                NSString *wxnickname = responseObject[@"wx_nickname"];
      
                NSString *QQNickname = [NSString stringWithFormat:@"QQ账号（%@）",qqnickname];
                NSString *weChatNickname = [NSString stringWithFormat:@"微信账号（%@）",wxnickname];


                if(platformType == UMSocialPlatformType_QQ){
                    
                    [_dataList replaceObjectAtIndex:indexPath.row withObject:QQNickname];
                    
                }else if(platformType == UMSocialPlatformType_WechatSession){
                    
                    [_dataList replaceObjectAtIndex:indexPath.row withObject:weChatNickname];
 
                }
                [_detailList replaceObjectAtIndex:indexPath.row withObject:@""];
            
                [self.tableView reloadData];

            } failure:^(NSError *error) {
                [YKXCommonUtil hiddenHud];
                [YKXCommonUtil showToastWithTitle:@"请检查网络设置" view:self.view.window];
            }];
        }else{
            
            [YKXCommonUtil hiddenHud];
        }
    }];
}

- (void)phoneBindNickname:(NSString *)nickName index:(NSInteger)index{
    
    [_dataList replaceObjectAtIndex:index withObject:nickName];
    [_detailList replaceObjectAtIndex:index withObject:@""];
    
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return 80;
    }else{
        return 44;
    }
}

@end
