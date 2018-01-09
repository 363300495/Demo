//
//  ShenHeTableViewCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/12/13.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "ShenHeTableViewCell.h"

@interface ShenHeTableViewCell ()

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIView *rootView;

@property (nonatomic,strong) UILabel *contentLabel;

@end



@implementation ShenHeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout{
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#8E8F90"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    rootView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:rootView];
    self.rootView = rootView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.textColor = [UIColor colorWithHexString:@"#C4C4C4"];
    [rootView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setModel:(ShenHeModel *)model{
    
    _model = model;
    
    NSString *time = [YKXCommonUtil timeStamp:[model.addtime integerValue]];
    self.timeLabel.text = time;
    self.contentLabel.text = model.content;
    
    
    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    self.rootView.frame = CGRectMake(10, CGRectGetMaxY(_timeLabel.frame)+10, SCREEN_WIDTH-20, contentSize.height+20);
    
    self.contentLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, contentSize.height);
}

@end
