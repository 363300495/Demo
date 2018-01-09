//
//  SRAlertView.m
//  SRAlertView
//
//  Created by 郭伟林 on 16/7/8.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRAlertView.h"
#import "FXBlurView.h"

#pragma mark - Frames

#define SCREEN_BOUNDS         [UIScreen mainScreen].bounds
#define SCREEN_ADJUST(Value)  SCREEN_WIDTH * (Value) / 375.0f

#define kAlertViewW            275.0f
#define kAlertViewTitleH       20.0f
#define kAlertViewIconWH       50.0f
#define kAlertViewBtnH         50.0f
#define kAlertViewMessageMinH  70.0f
#define kVerticalMargin        20.0f

#define kTitleFont     [UIFont boldSystemFontOfSize:18];
#define kMessageFont   [UIFont systemFontOfSize:15];
#define kBtnTitleFont  [UIFont systemFontOfSize:16];


#define kAlertSignViewW        290.0f
#define kAlertVideoPlayViewW   300.0f

#pragma mark - Colors

#define COLOR_RGB(R, G, B)  [UIColor colorWithRed:(R/255.0f) green:(G/255.0f) blue:(B/255.0f) alpha:1.0f]

#define COLOR_RANDOM  COLOR_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define UICOLOR_FROM_HEX_ALPHA(RGBValue, Alpha) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:Alpha]

#define UICOLOR_FROM_HEX(RGBValue) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0]

#define kTitleLabelColor                UICOLOR_FROM_HEX_ALPHA(0x000000, 1.0)
#define kMessageLabelColor              UICOLOR_FROM_HEX_ALPHA(0x313131, 1.0)

#define kBtnNormalTitleColor            UICOLOR_FROM_HEX_ALPHA(0x4A4A4A, 1.0)
#define kBtnHighlightedTitleColor       UICOLOR_FROM_HEX_ALPHA(0x4A4A4A, 1.0)
#define kBtnHighlightedBackgroundColor  UICOLOR_FROM_HEX_ALPHA(0xF76B1E, 0.15)

#define kLineBackgroundColor  [UIColor colorWithRed:1.00 green:0.92 blue:0.91 alpha:1.00]


@interface SRAlertView ()


@property (nonatomic, copy) SRAlertViewDidSelectActionBlock selectActionBlock;

@property (nonatomic, strong) UIView     *alertView;
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIView     *coverView;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) NSTimer *skiptimer;
//倒计时秒数
@property (nonatomic,assign) NSInteger runLoopTimes;


@property (nonatomic, strong) UIImage     *icon;
@property (nonatomic, copy  ) UIImageView *iconImageView;
@property (nonatomic, strong) UIViewController *superVC;

@property (nonatomic, copy  ) NSString *message;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, copy  ) NSString *leftActionTitle;
@property (nonatomic, strong) UIButton *leftAction;

@property (nonatomic, copy  ) NSString *rightActionTitle;
@property (nonatomic, strong) UIButton *rightAction;

@property (nonatomic,strong) NSArray *xuanjiArray;

@property (nonatomic,strong) UIScrollView *contentScrollView;

@end

@implementation SRAlertView

#pragma mark - BLOCK
//弹框
+ (instancetype)sr_alertViewWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    return [[self alloc] initWithTitle:title icon:icon message:message leftActionTitle:leftActionTitle rightActionTitle:rightActionTitle animationStyle:animationStyle selectActionBlock:selectActionBlock];
}


//设置退出原生广告弹框
+ (instancetype)sr_alertViewWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock{
    
    return [[self alloc] initWithMessage:message superVC:superVC leftActionTitle:leftActionTitle rightActionTitle:rightActionTitle animationStyle:animationStyle selectActionBlock:selectActionBlock];
}

//设置领券广告弹框
+ (instancetype)sr_alertViewGetCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    return [[self alloc] initGetCardWithMessage:message superVC:superVC leftActionTitle:leftActionTitle rightActionTitle:rightActionTitle animationStyle:animationStyle selectActionBlock:selectActionBlock];
    
}

//设置使用卡券广告弹窗
+ (instancetype)sr_alertViewUseCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC leftActionTitle:(NSString *)leftActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    return [[self alloc] initUseCardWithMessage:message superVC:superVC leftActionTitle:leftActionTitle animationStyle:animationStyle selectActionBlock:selectActionBlock];
}


//设置签到原生广告弹框
+ (instancetype)sr_alertViewWithMessage:(NSString *)message superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle{
    
    return [[self alloc] initWithMessage:message superVC:superVC animationStyle:animationStyle];
}

//设置播放器原生广告弹窗
+ (instancetype)sr_alertViewVideoPlaysuperVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    return [[self alloc] initVideoPlaysuperVC:superVC animationStyle:animationStyle];
}


//设置选集弹框
+ (instancetype)sr_alertViewSelectAnthologyWithXuanjiArray:(NSArray *)xuanjiArray superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    return [[self alloc] initSelectAnthologyWithXuanjiArray:xuanjiArray superVC:superVC animationStyle:animationStyle];
}


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
//        _blurEffect        = YES;
        _title             = title;
        _icon              = icon;
        _message           = message;
        _leftActionTitle   = leftActionTitle;
        _rightActionTitle  = rightActionTitle;
        _animationStyle    = animationStyle;
        _selectActionBlock = selectActionBlock;
        [self setupAlertView];
    }
    return self;
}



- (instancetype)initWithMessage:(NSString *)message superVC:(UIViewController *)superVC  leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //        _blurEffect        = YES;
        _message           = message;
        _superVC           = superVC;
        _leftActionTitle   = leftActionTitle;
        _rightActionTitle  = rightActionTitle;
        _animationStyle    = animationStyle;
        _selectActionBlock = selectActionBlock;
        [self setupAlertExitNativeView];
    }
    return self;
}


- (instancetype)initGetCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC  leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //        _blurEffect        = YES;
        _message           = message;
        _superVC           = superVC;
        _leftActionTitle   = leftActionTitle;
        _rightActionTitle  = rightActionTitle;
        _animationStyle    = animationStyle;
        _selectActionBlock = selectActionBlock;
        [self setupAlertGetCardExitNativeView];
    }
    return self;
}

- (instancetype)initUseCardWithMessage:(NSString *)message superVC:(UIViewController *)superVC  leftActionTitle:(NSString *)leftActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle selectActionBlock:(SRAlertViewDidSelectActionBlock)selectActionBlock {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //        _blurEffect        = YES;
        _message           = message;
        _superVC           = superVC;
        _leftActionTitle   = leftActionTitle;
        _animationStyle    = animationStyle;
        _selectActionBlock = selectActionBlock;
        [self setupAlertUseCardExitNativeView];
    }
    return self;
}


- (instancetype)initWithMessage:(NSString *)message superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //        _blurEffect        = YES;
        _message           = message;
        _superVC           = superVC;
        _animationStyle    = animationStyle;
        [self setupAlertSignNativeView];
    }
    return self;
}



- (instancetype)initVideoPlaysuperVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        //        _blurEffect        = YES;
//        _message           = message;
        _superVC           = superVC;
        _animationStyle    = animationStyle;
        [self setupAlertVideoPlayNativeView];
    }
    return self;
}



- (instancetype)initSelectAnthologyWithXuanjiArray:(NSArray *)xuanjiArray superVC:(UIViewController *)superVC animationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {

        _xuanjiArray       = xuanjiArray;
        _superVC           = superVC;
        _animationStyle    = animationStyle;
        [self setupSelectAnthology];
    }
    return self;
}

#pragma mark - DELEGATE

+ (instancetype)sr_alertViewWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle delegate:(id<SRAlertViewDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title icon:icon message:message leftActionTitle:leftActionTitle rightActionTitle:rightActionTitle animationStyle:animationStyle delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message leftActionTitle:(NSString *)leftActionTitle rightActionTitle:(NSString *)rightActionTitle animationStyle:(SRAlertViewAnimationStyle)animationStyle delegate:(id<SRAlertViewDelegate>)delegate {
    
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        _blurEffect       = YES;
        _title            = title;
        _icon             = icon;
        _message          = message;
        _leftActionTitle  = leftActionTitle;
        _rightActionTitle = rightActionTitle;
        _animationStyle   = animationStyle;
        _delegate         = delegate;
        [self setupAlertView];
    }
    return self;
}

#pragma mark - Setup UI

- (FXBlurView *)blurView {
    
    if (!_blurView) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
        _blurView = [[FXBlurView alloc] initWithFrame:SCREEN_BOUNDS];
        _blurView.tintColor = [UIColor clearColor];
        _blurView.dynamic = NO;
        _blurView.blurRadius = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:_blurView];
    }
    return _blurView;
}

- (UIView *)coverView {
    
    if (!_coverView) {
        [self insertSubview:({
            _coverView = [[UIView alloc] initWithFrame:self.bounds];
            _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
            _coverView.alpha = 0;
            _coverView;
        }) atIndex:0];
    }
    return _coverView;
}


#pragma mark 设置普通弹框
- (void)setupAlertView {
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupTitleView];
    
    [self setupIconImageView];
    
    [self setupMessageLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertViewW, CGRectGetMaxY(_messageLabel.frame) + kAlertViewBtnH + kVerticalMargin);
    _alertView.center = self.center;
    
    [self setupActions];
}

- (void)setupTitleView {
    
    if (!_title || _title.length == 0) {
        return;
    }
    [_alertView addSubview:({
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kVerticalMargin, kAlertViewW, kAlertViewTitleH)];
        _titleLabel.text          = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor     = kTitleLabelColor;
        _titleLabel.font          = kTitleFont;
        _titleLabel;
    })];
}

- (void)setupIconImageView {
    
    if (_title && _title.length > 0) { // the icon title will be ignored if there is text title already
        return;
    }
    if (!_icon) {
        return;
    }
    [_alertView addSubview:({
        _iconImageView = [[UIImageView alloc] initWithImage:_icon];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.frame = CGRectMake((kAlertViewW - kAlertViewIconWH) * 0.5, kVerticalMargin, kAlertViewIconWH, kAlertViewIconWH);
        _iconImageView;
    })];
}

- (void)setupMessageLabel {
    
    CGFloat messageLabelSpacing = 20;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.textColor       = kMessageLabelColor;
        _messageLabel.font            = kMessageFont;
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) { // if message label just has only one line
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        CGFloat messageLabH = expectSize.height < kAlertViewMessageMinH ? kAlertViewMessageMinH : expectSize.height;
        CGFloat messageLabY = _titleLabel ? (CGRectGetMaxY(_titleLabel.frame) + kVerticalMargin) : (CGRectGetMaxY(_iconImageView.frame) + kVerticalMargin * 0.5);
        _messageLabel.frame = CGRectMake(messageLabelSpacing, messageLabY, kAlertViewW - messageLabelSpacing * 2, messageLabH);
        _messageLabel;
    })];
}


- (void)setupActions {
    
    CGFloat btnY = _alertView.frame.size.height - kAlertViewBtnH;
    if (_leftActionTitle) {
        [_alertView addSubview:({
            _leftAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftAction.tag = SRAlertViewActionTypeLeft;
            _leftAction.titleLabel.font = kBtnTitleFont;
            [_leftAction setTitle:_leftActionTitle forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_leftAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_leftAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_leftAction];
            if (_rightActionTitle) {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _leftAction;
        })];
    }
    
    if (_rightActionTitle) {
        [_alertView addSubview:({
            _rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightAction.tag = SRAlertViewActionTypeRight;
            _rightAction.titleLabel.font = kBtnTitleFont;
            [_rightAction setTitle:_rightActionTitle forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_rightAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_rightAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_rightAction];
            if (_rightActionTitle) {
                _rightAction.frame = CGRectMake(kAlertViewW * 0.5, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _rightAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _rightAction;
        })];
    }
    
    if (_leftActionTitle && _rightActionTitle) {
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line1.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(kAlertViewW * 0.5, btnY, 0.5, kAlertViewBtnH);
        line2.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line2];
    } else {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line];
    }
}



#pragma mark 加载优看和消息模块Banner广告
- (instancetype)initSR_BannerViewWithSuperVC:(UIViewController *)superVC bannerID:(NSString *)bannerId {
    
    if(self = [super initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 60)]) {
        
        bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20, 60)
                                                      appkey:GDTID placementId:bannerId];

        bannerView.isAnimationOn = NO;
        bannerView.showCloseBtn = YES;
        bannerView.currentViewController = superVC.navigationController;
        bannerView.interval = 10;
        bannerView.isGpsOn = YES;
        [bannerView loadAdAndShow];
        
        [self addSubview:bannerView];
    }
    return self;
}


#pragma mark 设置退出原生广告
- (void)setupAlertExitNativeView{
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupEitxNativeView];
    
    [self setupExitNativeMessageLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertViewW, CGRectGetMaxY(_messageLabel.frame) + 10 +kAlertViewBtnH);
    _alertView.center = self.center;
    
    [self setupExitNativeActions];

}


- (void)setupEitxNativeView{
    
    /*开始渲染广告界面*/
    _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewW, 155)];
    _adView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_adView];
    
    /*广告详情图*/
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAlertViewW, 155)];
    _imgV.userInteractionEnabled = YES;
    [_adView addSubview:_imgV];
    
    //加载广告图标
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertViewW-53, 137, 53, 18)];
    adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
    [_adView addSubview:adImageView];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_imgV addGestureRecognizer:tap];
    
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *exitID = [YKXDefaultsUtil getGDTExitID];
    
    //平台退出框
    if(GDTMainID.length == 0 || exitID.length == 0 || [GDTMainID isEqualToString:@"0"] || [exitID isEqualToString:@"0"]){
        GDTMainID = GDTID;
        exitID = GDTExitNativeID;
    }
    
    //拉取广告
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:exitID];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    _nativeAd.controller = vc;
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:1];
}

- (void)setupExitNativeMessageLabel{
    
    CGFloat messageLabelSpacing = 4;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor       = kMessageLabelColor;
        _messageLabel.font            = kMessageFont;
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) { // if message label just has only one line
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(messageLabelSpacing, CGRectGetMaxY(_adView.frame)+10, kAlertViewW - messageLabelSpacing * 2, 30);
        _messageLabel;
    })];
}

- (void)setupExitNativeActions{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(246, 5, 24, 24);
    [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancelButton];
    
    
    CGFloat btnY = _alertView.frame.size.height - kAlertViewBtnH;
    if (_leftActionTitle) {
        [_alertView addSubview:({
            _leftAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftAction.tag = SRAlertViewActionTypeLeft;
            _leftAction.titleLabel.font = kBtnTitleFont;
            [_leftAction setTitle:_leftActionTitle forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_leftAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_leftAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_leftAction];
            if (_rightActionTitle) {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _leftAction;
        })];
    }
    
    if (_rightActionTitle) {
        [_alertView addSubview:({
            _rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightAction.tag = SRAlertViewActionTypeRight;
            _rightAction.titleLabel.font = kBtnTitleFont;
            [_rightAction setTitle:_rightActionTitle forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_rightAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_rightAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_rightAction];
            if (_rightActionTitle) {
                _rightAction.frame = CGRectMake(kAlertViewW * 0.5, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _rightAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _rightAction;
        })];
    }
    
    if (_leftActionTitle && _rightActionTitle) {
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line1.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(kAlertViewW * 0.5, btnY, 0.5, kAlertViewBtnH);
        line2.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line2];
    } else {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line];
    }
}



#pragma mark  获取卡券退出框
- (void)setupAlertGetCardExitNativeView{
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupGetCardEitxNativeView];
    
    [self setupGetCardExitNativeMessageLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertViewW, CGRectGetMaxY(_messageLabel.frame) + 10 +kAlertViewBtnH);
    _alertView.center = self.center;
    
    [self setupGetCardExitNativeActions];
    
}


- (void)setupGetCardEitxNativeView{
    
    /*开始渲染广告界面*/
    _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewW, 155)];
    _adView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_adView];
    
    /*广告详情图*/
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAlertViewW, 155)];
    _imgV.userInteractionEnabled = YES;
    [_adView addSubview:_imgV];
    
    //加载广告图标
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertViewW-53, 137, 53, 18)];
    adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
    [_adView addSubview:adImageView];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_imgV addGestureRecognizer:tap];
    
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *getCardID = [YKXDefaultsUtil getGetCardNativeID];
    
    //卡券获取
    if(GDTMainID.length == 0 || getCardID.length == 0 || [GDTMainID isEqualToString:@"0"] || [getCardID isEqualToString:@"0"]){
        GDTMainID = GDTID;
        getCardID = GDTGetCardNativeID;
    }
    
    //拉取广告
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:getCardID];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    _nativeAd.controller = vc;
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:1];
}

- (void)setupGetCardExitNativeMessageLabel{
    
    CGFloat messageLabelSpacing = 4;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor       = kMessageLabelColor;
        _messageLabel.font            = kMessageFont;
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) { // if message label just has only one line
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(messageLabelSpacing, CGRectGetMaxY(_adView.frame)+10, kAlertViewW - messageLabelSpacing * 2, 30);
        _messageLabel;
    })];
}

- (void)setupGetCardExitNativeActions{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(246, 5, 24, 24);
    [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancelButton];
    
    
    CGFloat btnY = _alertView.frame.size.height - kAlertViewBtnH;
    if (_leftActionTitle) {
        [_alertView addSubview:({
            _leftAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftAction.tag = SRAlertViewActionTypeLeft;
            _leftAction.titleLabel.font = kBtnTitleFont;
            [_leftAction setTitle:_leftActionTitle forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_leftAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_leftAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_leftAction];
            if (_rightActionTitle) {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _leftAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _leftAction;
        })];
    }
    
    if (_rightActionTitle) {
        [_alertView addSubview:({
            _rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightAction.tag = SRAlertViewActionTypeRight;
            _rightAction.titleLabel.font = kBtnTitleFont;
            [_rightAction setTitle:_rightActionTitle forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_rightAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_rightAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_rightAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_rightAction];
            if (_rightActionTitle) {
                _rightAction.frame = CGRectMake(kAlertViewW * 0.5, btnY, kAlertViewW * 0.5, kAlertViewBtnH);
            } else {
                _rightAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            }
            _rightAction;
        })];
    }
    
    if (_leftActionTitle && _rightActionTitle) {
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line1.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(kAlertViewW * 0.5, btnY, 0.5, kAlertViewBtnH);
        line2.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line2];
    } else {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
        line.backgroundColor = [UIColor lightGrayColor];
        [_alertView addSubview:line];
    }
}


#pragma mark 使用卡券退出框
- (void)setupAlertUseCardExitNativeView{
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupUseCardEitxNativeView];
    
    [self setupUseCardExitNativeMessageLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertViewW, CGRectGetMaxY(_messageLabel.frame) + 10 +kAlertViewBtnH);
    _alertView.center = self.center;
    
    [self setupUseCardExitNativeActions];
    
}


- (void)setupUseCardEitxNativeView{
    
    /*开始渲染广告界面*/
    _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertViewW, 155)];
    _adView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_adView];
    
    /*广告详情图*/
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAlertViewW, 155)];
    _imgV.userInteractionEnabled = YES;
    [_adView addSubview:_imgV];
    
    //加载广告图标
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertViewW-53, 137, 53, 18)];
    adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
    [_adView addSubview:adImageView];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_imgV addGestureRecognizer:tap];
    
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *useCardID = [YKXDefaultsUtil getUseCardNativeID];
    
    //卡券获取
    if(GDTMainID.length == 0 || useCardID.length == 0 || [GDTMainID isEqualToString:@"0"] || [useCardID isEqualToString:@"0"]){
        GDTMainID = GDTID;
        useCardID = GDTUseCardNativeID;
    }
    
    //拉取广告
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:useCardID];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    _nativeAd.controller = vc;
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:1];
}

- (void)setupUseCardExitNativeMessageLabel{
    
    CGFloat messageLabelSpacing = 4;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor       = kMessageLabelColor;
        _messageLabel.font            = kMessageFont;
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) { // if message label just has only one line
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(messageLabelSpacing, CGRectGetMaxY(_adView.frame)+10, kAlertViewW - messageLabelSpacing * 2, 30);
        _messageLabel;
    })];
}

- (void)setupUseCardExitNativeActions{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(246, 5, 24, 24);
    [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancelButton];
    
    
    CGFloat btnY = _alertView.frame.size.height - kAlertViewBtnH;
    if (_leftActionTitle) {
        [_alertView addSubview:({
            _leftAction = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftAction.tag = SRAlertViewActionTypeLeft;
            _leftAction.titleLabel.font = kBtnTitleFont;
            [_leftAction setTitle:_leftActionTitle forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnNormalTitleColor forState:UIControlStateNormal];
            [_leftAction setTitleColor:kBtnHighlightedTitleColor forState:UIControlStateHighlighted];
            //            [_leftAction setBackgroundImage:[self imageWithColor:kBtnHighlightedBackgroundColor] forState:UIControlStateHighlighted];
            [_leftAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:_leftAction];
            _leftAction.frame = CGRectMake(0, btnY, kAlertViewW, kAlertViewBtnH);
            _leftAction;
        })];
    }
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, btnY, kAlertViewW, 0.5);
    line.backgroundColor = [UIColor lightGrayColor];
    [_alertView addSubview:line];
    
}

#pragma mark native代理
//数据拉取成功
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    
    //加载成功时
    if(nativeAdDataArray.count >0){
        _currentAd = [nativeAdDataArray objectAtIndex:0];
        
        NSURL *imageURL = [NSURL URLWithString:[_currentAd.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imgV.image = [UIImage imageWithData:imageData];
                
                 [_nativeAd attachAd:_currentAd toView:_adView];
            });
        });
    }
}

- (void)nativeAdFailToLoad:(NSError *)error{
    
}


- (void)viewTapped:(UITapGestureRecognizer *)gr{
    
    [_nativeAd clickAd:_currentAd];
}


- (void)nativeAdClosed{
    //不能再点击的时候删除，只能在最后广告关闭的时候删除
    [_adView removeFromSuperview];
    _adView = nil;
    [self dismiss];
}


#pragma mark 设置签到弹框
- (void)setupAlertSignNativeView{
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupExitSignNativeView];
    
    [self setupSignNativeMessageLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertSignViewW, CGRectGetMaxY(_messageLabel.frame) + 30);
    _alertView.layer.borderColor = [UIColor whiteColor].CGColor;
    _alertView.layer.borderWidth = 0.6f;
    _alertView.center = self.center;
    
    [self setupSignNativeActions];
}

- (void)setupExitSignNativeView {
    
    /*开始渲染广告界面*/
    _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertSignViewW, 163)];
    _adView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_adView];
    
    /*广告详情图*/
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAlertSignViewW, 163)];
    _imgV.userInteractionEnabled = YES;
    [_adView addSubview:_imgV];
    
    
    //加载广告图标
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertSignViewW-53, 145, 53, 18)];
    adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
    [_adView addSubview:adImageView];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_imgV addGestureRecognizer:tap];
    
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *signID = [YKXDefaultsUtil getGDTSignNativeID];
    
    if(GDTMainID.length == 0 || signID.length == 0 || [GDTMainID isEqualToString:@"0"] || [signID isEqualToString:@"0"]){
        
        GDTMainID = GDTID;
        signID = GDTSignNativeID;
    }
    
    //拉取广告
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:signID];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    _nativeAd.controller = vc;
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:1];
    
}

- (void)setupSignNativeMessageLabel{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adView.frame)+30, kAlertSignViewW, 30)];
    titleLabel.text = @"签到成功";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_alertView addSubview:titleLabel];
    
    
    CGFloat messageLabelSpacing = 4;
    [_alertView addSubview:({
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor       = [UIColor colorWithHexString:@"#989898"];
        _messageLabel.font            = [UIFont systemFontOfSize:14.0f];
        _messageLabel.numberOfLines   = 0;
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maxSize = CGSizeMake(kAlertSignViewW - messageLabelSpacing * 2, MAXFLOAT);
        _messageLabel.text = @"one";
        CGSize tempSize    = [_messageLabel sizeThatFits:maxSize];
        _messageLabel.text = _message;
        
        CGSize expectSize  = [_messageLabel sizeThatFits:maxSize];
        if (expectSize.height == tempSize.height) { // if message label just has only one line
            _messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        [_messageLabel sizeToFit];
        _messageLabel.frame = CGRectMake(messageLabelSpacing, CGRectGetMaxY(titleLabel.frame)+16, kAlertSignViewW - messageLabelSpacing * 2, 30);
        _messageLabel;
    })];
}

- (void)setupSignNativeActions{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(261, 5, 24, 24);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancelButton];
}



#pragma mark 设置原生播放界面广告
- (void)setupAlertVideoPlayNativeView {
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupVideoPlaySignNativeView];
    
    [self setupVideoMessageNativeLabel];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertVideoPlayViewW, 3*kAlertVideoPlayViewW/2+44);
    _alertView.layer.borderColor = [UIColor whiteColor].CGColor;
    _alertView.layer.borderWidth = 0.6f;
    _alertView.center = self.center;
    
    [self setupVideoPlayNativeActions];
    
    
}

- (void)setupVideoPlaySignNativeView {
    
    /*开始渲染广告界面*/
    _adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAlertVideoPlayViewW, 3*kAlertVideoPlayViewW/2+44)];
    _adView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_adView];
    
    /*广告详情图*/
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAlertVideoPlayViewW, 3*kAlertVideoPlayViewW/2)];
    _imgV.userInteractionEnabled = YES;
    [_adView addSubview:_imgV];
    
    //加载广告图标
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAlertVideoPlayViewW-53, 3*kAlertVideoPlayViewW/2-18, 53, 18)];
    adImageView.image = [UIImage imageNamed:@"GDT_adlogo"];
    [_adView addSubview:adImageView];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [_imgV addGestureRecognizer:tap];
    
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *VIPID = [YKXDefaultsUtil getGDTVIPNativeID];
    
    
    if(GDTMainID.length == 0 || VIPID.length == 0 || [GDTMainID isEqualToString:@"0"] || [VIPID isEqualToString:@"0"]){
        
        GDTMainID = GDTID;
        VIPID = GDTVIPNativeID;
    }
    
    //拉取广告
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:GDTMainID placementId:VIPID];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    _nativeAd.controller = vc;
    _nativeAd.delegate = self;
    
    [_nativeAd loadAd:1];
}


- (void)setupVideoMessageNativeLabel {
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake((kAlertVideoPlayViewW-130)/2, CGRectGetMaxY(_imgV.frame), 130, 44)];
    [_adView addSubview:_titleView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 110, 30)];
    titleLabel.text = @"视频加载中";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [_titleView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 14, 10, 16)];
    textLabel.text = @"4";
    textLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    [_titleView addSubview:textLabel];
    self.textLabel = textLabel;
    
    _skiptimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(skipTime) userInfo:nil repeats:YES];
}

- (void)setupVideoPlayNativeActions {
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(kAlertVideoPlayViewW - 29, 5, 24, 24);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:cancelButton];
}

- (void)skipTime{
    
    _runLoopTimes++;
    _textLabel.text = [NSString stringWithFormat:@"%ld", 4-_runLoopTimes];
    
    if(_runLoopTimes == 4){
        [_skiptimer invalidate];
        _skiptimer = nil;
        self.titleLabel.text = @"视频加载成功";
        self.textLabel.text = @"";
        
    }
}


#pragma mark 创建选集弹出框
- (void)setupSelectAnthology{
    
    [self addSubview:({
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor     = [UIColor whiteColor];
        _alertView.layer.cornerRadius  = 10.0;
        _alertView.layer.masksToBounds = YES;
        _alertView;
    })];
    
    [self setupSelectAnthologyNativeView];
    
    [self setupSelectAnthologyButton];
    
    _alertView.frame  = CGRectMake(0, 0, kAlertSignViewW, CGRectGetMaxY(_contentScrollView.frame));
    _alertView.layer.borderColor = [UIColor whiteColor].CGColor;
    _alertView.layer.borderWidth = 0.6f;
    _alertView.center = self.center;
    
    [self setupSelectAnthologyActions];
}


- (void)setupSelectAnthologyNativeView {
    
    NSString *GDTMainID = [YKXDefaultsUtil getGDTMainID];
    NSString *xuanJiNativeID = [YKXDefaultsUtil getSVIPXuanJiBannerID];
    
    if(GDTMainID.length == 0 || xuanJiNativeID.length == 0 || [GDTMainID isEqualToString:@"0"] || [xuanJiNativeID isEqualToString:@"0"]){
        
        GDTMainID = GDTID;
        xuanJiNativeID = GDTXuanJiNativeID;
    }
    
    
    bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, kAlertSignViewW, 60) appkey:GDTMainID placementId:xuanJiNativeID];
    bannerView.isAnimationOn = NO;
    bannerView.delegate = self;
    bannerView.showCloseBtn = YES;
    bannerView.currentViewController = self.superVC.navigationController;
    bannerView.interval = 10;
    bannerView.isGpsOn = YES;
    [bannerView loadAdAndShow];
    
    [_alertView addSubview:bannerView];
    
}

- (void)setupSelectAnthologyButton{
    
    
    //单个宽度
    NSInteger itemColumn = 5;
    CGFloat itemViewW = (kAlertSignViewW-60.0)/itemColumn;
    CGFloat itemViewH = itemViewW;
    
    NSInteger count = self.xuanjiArray.count;
    
    float tempNum = (float)(count)/itemColumn;
    
    NSInteger totalHeight = ceilf(tempNum);

    
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame), kAlertSignViewW, 234)];
    _contentScrollView.contentSize = CGSizeMake(kAlertSignViewW, itemViewH * totalHeight + (totalHeight + 1) * 10);
    [_alertView addSubview:_contentScrollView];
    
    
    
    UIButton *lastButton = nil;
    for (int idx = 0; idx < count; idx++) {
        
        
        NSDictionary *xuanjiDic = self.xuanjiArray[idx];
        NSString *selected = xuanjiDic[@"selected"];
        NSString *number = xuanjiDic[@"number"];
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setTitle:number forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor colorWithHexString:DEEP_COLOR] forState:UIControlStateNormal];
        itemButton.backgroundColor = [UIColor colorWithHexString:LIGHT_COLOR];
        itemButton.layer.cornerRadius = 5;
        itemButton.layer.masksToBounds = YES;
        itemButton.tag = 100+idx;
        [itemButton addTarget:self action:@selector(xuanjiAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:itemButton];
        
        if([selected isEqualToString:@"1"]){//集数的选中状态
            
            itemButton.backgroundColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
        }
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(itemViewW);
            make.height.mas_equalTo(itemViewH);
            
            if(!lastButton){//如果是循环创建的第一个button
                make.top.equalTo(@(10));
                make.left.equalTo(@(10));
            }else{
                if (idx % itemColumn == 0) { // 每行第一个控件
                    make.top.equalTo(lastButton.mas_bottom).offset(10);
                    make.left.equalTo(_contentScrollView).offset(10);
                } else {
                    make.top.equalTo(lastButton.mas_top).offset(0.0);
                    make.left.equalTo(lastButton.mas_right).offset(10);
                }
            }
        }];
        lastButton = itemButton;
        
    }
}

- (void)setupSelectAnthologyActions{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(261, 5, 24, 24);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickDismiss) forControlEvents:UIControlEventTouchUpInside];
    [bannerView addSubview:cancelButton];
}


- (void)xuanjiAction:(UIButton *)sender {
    
    [self dismiss];
    
    NSInteger index = sender.tag;
    NSDictionary *xuanjiDic = self.xuanjiArray[index-100];
    NSString *urlStr = xuanjiDic[@"url"];
    NSString *title = xuanjiDic[@"title"];
    
    if(_delegate || [_delegate respondsToSelector:@selector(alertViewXuanJiAction:title:)]){
        
        [_delegate alertViewXuanJiAction:urlStr title:title];
    }
}



#pragma mark - Actions

- (void)onClickDismiss{
    
    [self dismiss];
}

- (void)btnAction:(UIButton *)btn {
    
    if (self.selectActionBlock) {
        self.selectActionBlock(btn.tag);
    }
    if ([self.delegate respondsToSelector:@selector(alertViewDidSelectAction:)]) {
        [self.delegate alertViewDidSelectAction:btn.tag];
    }
    
    [self dismiss];
}


#pragma mark - Animations
- (void)showVideoPlayNative {
    
    if (!_blurEffect) {
        [self coverView];
    } else {
        [self blurView];
    }
    
    
    [self.superVC.view addSubview:self];
    
    
    if (!_blurEffect) {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.coverView.alpha = 1.0;
                         } completion:nil];
    } else {
        self.blurView.blurRadius = 10;
    }
    
    switch (self.animationStyle) {
        case SRAlertViewAnimationNone:
        {
            // No animation
            break;
        }
        case SRAlertViewAnimationZoomSpring:
        {
            [self.alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [self.alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationTopToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 //                                 self.alertView.layer.position = self.center;
                                 self.alertView.layer.position = CGPointMake(self.center.x, 300);
                                 
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationDownToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, SCREEN_HEIGHT);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationLeftToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(-kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationRightToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(SCREEN_WIDTH + kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
    }
}



- (void)showNative {
    
    if (!_blurEffect) {
        [self coverView];
    } else {
        [self blurView];
    }
    
    
    [self.superVC.view.window addSubview:self];

    
    if (!_blurEffect) {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.coverView.alpha = 1.0;
                         } completion:nil];
    } else {
        self.blurView.blurRadius = 10;
    }
    
    switch (self.animationStyle) {
        case SRAlertViewAnimationNone:
        {
            // No animation
            break;
        }
        case SRAlertViewAnimationZoomSpring:
        {
            [self.alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [self.alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationTopToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationDownToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, SCREEN_HEIGHT);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationLeftToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(-kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationRightToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(SCREEN_WIDTH + kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
    }
}

- (void)showSignNative {
    
    if (!_blurEffect) {
        [self coverView];
    } else {
        [self blurView];
    }
    
    
    [self.superVC.view addSubview:self];
    
    
    if (!_blurEffect) {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.coverView.alpha = 1.0;
                         } completion:nil];
    } else {
        self.blurView.blurRadius = 10;
    }
    
    switch (self.animationStyle) {
        case SRAlertViewAnimationNone:
        {
            // No animation
            break;
        }
        case SRAlertViewAnimationZoomSpring:
        {
            [self.alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [self.alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationTopToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 //                                 self.alertView.layer.position = self.center;
                                 self.alertView.layer.position = CGPointMake(self.center.x, 240);
                                 
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationDownToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, SCREEN_HEIGHT);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationLeftToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(-kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationRightToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(SCREEN_WIDTH + kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
    }
}


- (void)show {
    
    if (!_blurEffect) {
        [self coverView];
    } else {
        [self blurView];
    }
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (!_blurEffect) {
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.coverView.alpha = 1.0;
                         } completion:nil];
    } else {
        self.blurView.blurRadius = 10;
    }
    
    switch (self.animationStyle) {
        case SRAlertViewAnimationNone:
        {
            // No animation
            break;
        }
        case SRAlertViewAnimationZoomSpring:
        {
            [self.alertView.layer setValue:@(0) forKeyPath:@"transform.scale"];
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 [self.alertView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationTopToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, -self.alertView.frame.size.height);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationDownToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(self.center.x, SCREEN_HEIGHT);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationLeftToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(-kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
        case SRAlertViewAnimationRightToCenterSpring:
        {
            CGPoint startPoint = CGPointMake(SCREEN_WIDTH + kAlertViewW, self.center.y);
            self.alertView.layer.position = startPoint;
            [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.alertView.layer.position = self.center;
                             } completion:nil];
            break;
        }
    }
}

- (void)dismiss {

    [self.alertView removeFromSuperview];
    self.alertView = nil;
    
    if (!_blurEffect) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _coverView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    } else {
        [_blurView removeFromSuperview];
        [self removeFromSuperview];
    }
}

#pragma mark - Tool Methods

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Public Methods

- (void)setAnimationStyle:(SRAlertViewAnimationStyle)animationStyle {
    
    if (_animationStyle == animationStyle) {
        return;
    }
    _animationStyle = animationStyle;
}

- (void)setBlurEffect:(BOOL)blurEffect {
    
    if (_blurEffect == blurEffect) {
        return;
    }
    _blurEffect = blurEffect;
}

- (void)setActionTitleColorWhenHighlighted:(UIColor *)actionTitleColorWhenHighlighted {
    
    _actionTitleColorWhenHighlighted = actionTitleColorWhenHighlighted;
    
    [self.leftAction  setTitleColor:actionTitleColorWhenHighlighted forState:UIControlStateHighlighted];
    [self.rightAction setTitleColor:actionTitleColorWhenHighlighted forState:UIControlStateHighlighted];
}

- (void)setActionBackgroundColorWhenHighlighted:(UIColor *)actionBackgroundColorWhenHighlighted {
    
    _actionBackgroundColorWhenHighlighted = actionBackgroundColorWhenHighlighted;
    
    [self.leftAction  setBackgroundImage:[self imageWithColor:actionBackgroundColorWhenHighlighted] forState:UIControlStateHighlighted];
    [self.rightAction setBackgroundImage:[self imageWithColor:actionBackgroundColorWhenHighlighted] forState:UIControlStateHighlighted];
}

@end
