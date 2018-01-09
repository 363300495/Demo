//
//  YKXChatSendCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/11.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXChatSendCell.h"

@interface YKXChatSendCell ()

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UIImageView *messageImageView;

@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation YKXChatSendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createViewAtuoLayout];
    }
    
    return self;
}

- (void)createViewAtuoLayout{
    
    self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor colorWithHexString:@"#AEAEAE"];
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:timeLabel];
    
    self.timeLabel = timeLabel;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 20;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    
    self.headImageView = headImageView;
    
    UIImageView *messageImageView = [[UIImageView alloc] init];
    messageImageView.image = [UIImage SDResizeWithImage:[UIImage imageNamed:@"right_bubble"]];
    [self.contentView addSubview:messageImageView];
    self.messageImageView = messageImageView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.messageImageView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setModel:(YKXChatReceiveModel *)model{
    
    _model = model;
    
    NSString *timeStr = [YKXCommonUtil detailDayStr:[model.addtime integerValue]];
    self.timeLabel.text = timeStr;
    
    
    NSDictionary *userInfo = [YKXDefaultsUtil getLoginUserInfo];
    NSString *headimgurl = userInfo[@"headimgurl"];
    //设置头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headimgurl]];
    
    self.contentLabel.text = model.content;
    
    if([model.isTimeShow isEqualToString:@"0"]){//隐藏时间列表
        
        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 0);
        
        self.headImageView.frame = CGRectMake(SCREEN_WIDTH-50, CGRectGetMaxY(self.timeLabel.frame), 40, 40);
    }else if ([model.isTimeShow isEqualToString:@"1"]){//显示时间列表
        
        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 20);
        
        self.headImageView.frame = CGRectMake(SCREEN_WIDTH-50, CGRectGetMaxY(self.timeLabel.frame)+20, 40, 40);
        
    }
    
    
    CGFloat contentW = 0.0 ;
    CGFloat contentH = 0.0 ;
    CGFloat contentMaxW = SCREEN_WIDTH - 120;
    
    //计算文本宽度
    CGSize contentStrSize = [model.content boundingRectWithSize:CGSizeMake(contentMaxW-contentEdgeLeft-contentEdgeRight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
    
    //字体的宽度
    CGFloat contentStrW = contentStrSize.width+contentEdgeLeft+contentEdgeRight;
    
    contentW = contentMaxW<contentStrW?contentMaxW:contentStrW;
    
    contentH = contentMaxW<contentStrW?contentStrSize.height+contentEdgeTop+contentEdgeBottom:contentStrSize.height+contentEdgeTop;
    
    self.messageImageView.frame = CGRectMake(SCREEN_WIDTH-60-contentW, self.headImageView.frame.origin.y, contentW, contentH);
    
    self.contentLabel.frame = CGRectMake(10, 0, contentW-20, contentH);
}

+ (CGFloat)heightTableCellWithModel:(YKXChatReceiveModel *)model{
    
    CGFloat contentW = 0.0 ;
    CGFloat contentH = 0.0 ;
    CGFloat contentMaxW = SCREEN_WIDTH - 120;
    
    //计算文本宽度
    CGSize contentStrSize = [model.content boundingRectWithSize:CGSizeMake(contentMaxW-contentEdgeLeft-contentEdgeRight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
    
    //字体的宽度
    CGFloat contentStrW = contentStrSize.width+contentEdgeLeft+contentEdgeRight;
    
    contentW = contentMaxW<contentStrW?contentMaxW:contentStrW;
    
    contentH = contentMaxW<contentStrW?contentStrSize.height+contentEdgeTop+contentEdgeBottom:contentStrSize.height+contentEdgeTop;
    
    if([model.isTimeShow isEqualToString:@"0"]){
        return contentH + 40;
    }else{
        return contentH + 80;
    }

}

@end
