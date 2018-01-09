//
//  SRAlertView.h
//  SRAlertView
//
//  Created by 郭伟林 on 16/7/8.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobBannerView.h"
#import "GDTNativeAd.h"

@class SRAlertView;

typedef NS_ENUM(NSInteger, SRAlertViewActionType) {
    SRAlertViewActionTypeLeft,
    SRAlertViewActionTypeRight,
};

typedef NS_ENUM(NSInteger, SRAlertViewAnimationStyle) {
    SRAlertViewAnimationNone,
    SRAlertViewAnimationZoomSpring,
    SRAlertViewAnimationTopToCenterSpring,
    SRAlertViewAnimationDownToCenterSpring,
    SRAlertViewAnimationLeftToCenterSpring,
    SRAlertViewAnimationRightToCenterSpring,
};

@protocol SRAlertViewDelegate <NSObject>

@optional

- (void)alertViewDidSelectAction:(SRAlertViewActionType)actionType;


- (void)alertViewXuanJiAction:(NSString *)urlStr title:(NSString *)title;

@end

typedef void(^SRAlertViewDidSelectActionBlock)(SRAlertViewActionType actionType);

@interface SRAlertView : UIView <GDTNativeAdDelegate,GDTMobBannerViewDelegate>
{
    GDTMobBannerView *bannerView;
    GDTNativeAd *_nativeAd;     //原生广告实例           
    GDTNativeAdData *_currentAd;//当前展示的原生广告数据对象
    UIView *_adView;
    UIImageView *_imgV;
    UIView *_titleView;
}

@property (nonatomic, weak) id<SRAlertViewDelegate> delegate;

/**
 Whether blur the current background view, default is YES.
 */
@property (nonatomic, assign) BOOL blurEffect;

/**
 The animation style of showing the alert view.
 */
@property (nonatomic, assign) SRAlertViewAnimationStyle animationStyle;

@property (nonatomic, strong) UIColor *actionTitleColorWhenHighlighted;

@property (nonatomic, strong) UIColor *actionBackgroundColorWhenHighlighted;

//设置普通弹框
+ (instancetype)sr_alertViewWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock;


//设置退出原生广告弹框
+ (instancetype)sr_alertViewWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock;


//设置领券广告弹框
+ (instancetype)sr_alertViewGetCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock;

//设置使用卡券广告弹窗
+ (instancetype)sr_alertViewUseCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock;

//设置签到原生广告弹框
+ (instancetype)sr_alertViewWithMessage:(NSString *)message superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle;

//设置播放器原生广告弹窗
+ (instancetype)sr_alertViewVideoPlaysuperVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle;


//设置选集弹框
+ (instancetype)sr_alertViewSelectAnthologyWithXuanjiArray:(NSArray *)xuanjiArray superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle;


+ (instancetype)sr_alertViewWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle delegate:(id<SRAlertViewDelegate>)delegate;

//加载优看和消息模块Banner广告
- (instancetype)initSR_BannerViewWithSuperVC:(UIViewController *)superVC bannerID:(NSString *)bannerId;

- (void)show;

- (void)showNative;

- (void)showSignNative;

- (void)showVideoPlayNative;

@end
