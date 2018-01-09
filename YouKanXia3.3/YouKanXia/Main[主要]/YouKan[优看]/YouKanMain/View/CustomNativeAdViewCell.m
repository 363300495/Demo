//
//  CustomNativeAdViewCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/9/16.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "CustomNativeAdViewCell.h"

@interface CustomNativeAdViewCell () <GDTNativeAdDelegate>

{
    GDTNativeAd *_nativeAd;     //原生广告实例
    GDTNativeAdData *_currentAd;//当前展示的原生广告数据对象
    int adIndex;//拉取的广告条数
}

@property (nonatomic,strong) UIView *adView;
/** 背景图片 */
@property (nonatomic,strong) UIImageView *picImageView;

@property (nonatomic,strong) UIImageView *adImageView;

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *iconLabel;

@end

@implementation CustomNativeAdViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        WEAKSELF(weakSelf);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF3"];

        
        UIView *adView = [[UIView alloc] init];
        [self.contentView addSubview:adView];
        [adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.contentView);
            make.height.mas_equalTo(SCREEN_WIDTH*9/16);
        }];
        self.adView = adView;
        
        /*广告详情图*/
        UIImageView *picImageView = [[UIImageView alloc] init];
        picImageView.userInteractionEnabled = YES;
        [adView addSubview:picImageView];
        [picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(adView);
        }];
        self.picImageView = picImageView;
        
        
        //加载广告图标
        UIImageView *adImageView = [[UIImageView alloc] init];
        adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
        [picImageView addSubview:adImageView];
        [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(picImageView.mas_right);
            make.bottom.equalTo(picImageView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(53, 18));
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picImageViewTapped:)];
        [picImageView addGestureRecognizer:tap];
        
        
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.image = [UIImage imageNamed:@"video_list_cell_big_icon"];
        [picImageView addSubview:playImageView];
        [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(picImageView);
            make.width.height.mas_equalTo(50);
        }];
        
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(picImageView.mas_bottom);
            make.left.right.equalTo(weakSelf.contentView);
            make.height.equalTo(@(40));
        }];

        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.layer.cornerRadius = 12;
        iconImageView.layer.masksToBounds = YES;
        [bottomView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.top.equalTo(@(8));
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        self.iconImageView = iconImageView;
        
        
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.font = [UIFont systemFontOfSize:12.0f];
        iconLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        [bottomView addSubview:iconLabel];
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(6);
            make.centerY.equalTo(iconImageView);
        }];
        self.iconLabel = iconLabel;
        
        
        NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
        NSString *cellID = [YKXDefaultsUtil getGDTCellNativeID];
        
        if(GDTMainID.length == 0 || cellID.length == 0 || [GDTMainID isEqualToString:@"0"] || [cellID isEqualToString:@"0"]){
            
            GDTMainID = GDTID;
            cellID = GDTCellNativeID;
        }
        
        
        adIndex = 10;
        
        //拉取广告
        _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:cellID];
        
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        _nativeAd.controller = vc;
        _nativeAd.delegate = self;
        
    }
    return self;
}


- (void)setModel:(YKXVideoModel *)model{
    
    _model = model;

    NSString *headimgurl = model.headimgurl;
    
    if([headimgurl hasSuffix:@"webp"]){
        
        headimgurl = [headimgurl stringByReplacingOccurrencesOfString:@".webp" withString:@".png"];
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl]];
    
    self.iconLabel.text = model.nickname;
    
    //加载广告
    [_nativeAd loadAd:adIndex];
    
}

#pragma mark nativeAd代理
//数据拉取成功
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    
    //加载成功时
    if(nativeAdDataArray.count > 8){

        _currentAd = nativeAdDataArray[arc4random()%7];

        NSURL *imageURL = [NSURL URLWithString:[_currentAd.properties objectForKey:GDTNativeAdDataKeyImgUrl]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.picImageView.image = [UIImage imageWithData:imageData];

                [_nativeAd attachAd:_currentAd toView:_adView];
            });
        });
    }
}


- (void)nativeAdFailToLoad:(NSError *)error{
    
}

- (void)picImageViewTapped:(UITapGestureRecognizer *)gr{
    
    [_nativeAd clickAd:_currentAd];
}


- (void)nativeAdClosed{

}

@end
