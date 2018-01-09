//
//  YKXChatReceiveCell.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXChatReceiveCell.h"
#import "UIImage+GIF.h"
@interface YKXChatReceiveCell ()

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView *messageImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *contentImageView;

@property (nonatomic,strong) UILabel *contentLabel;

//放大后的图片
@property (nonatomic, weak) UIImageView *imagView;
//放大后的GIF图片
@property (nonatomic,strong) UIImageView *gifImageView;
//初始的图片的frame
@property (nonatomic, assign) CGRect lastFrame;

@end

@implementation YKXChatReceiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
       [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout{
    
    self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];

    //事件
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
    
    //背景气泡
    UIImageView *messageImageView = [[UIImageView alloc] init];
    messageImageView.userInteractionEnabled = YES;
    messageImageView.image = [UIImage SDResizeWithImage:[UIImage imageNamed:@"left_bubble"]];
    [self.contentView addSubview:messageImageView];
    
    //添加点击手势
    [messageImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]];
    messageImageView.userInteractionEnabled = YES;
    
    self.messageImageView = messageImageView;
    

    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
    timeLabel.numberOfLines = 0;
    [self.messageImageView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    
    //图片
    UIImageView *contentImageView = [[UIImageView alloc] init];
    [self.messageImageView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [self.messageImageView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}


//- (void)setModel:(YKXChatReceiveModel *)model{
//    
//    _model = model;
//    
//    NSString *timeStr = [YKXCommonUtil detailDayStr:[model.addtime integerValue]];
//    
//    //时间
//    self.timeLabel.text = timeStr;
//    //标题
//    self.titleLabel.text = model.title;
//    
//    NSURL *imageURL = [NSURL URLWithString:model.img_url];
//    //图片
//    [self.contentImageView sd_setImageWithURL:imageURL];
//    //内容
//    self.contentLabel.text = model.content;
//    
//    if([model.isTimeShow isEqualToString:@"0"]){//隐藏时间列表
//        
//        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 0);
//        
//        self.headImageView.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame), 40, 40);
//    }else{//显示时间列表
//        
//        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 20);
//        
//        self.headImageView.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame)+20, 40, 40);
//        
//    }
//    
//    if(model.img_url.length == 0){//文字消息内容(此时只有文字，显示的返回数据的内容)
//        
//        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
//        
//        self.titleLabel.hidden = YES;
//        
//        if(model.url.length == 0){
//            
//            self.contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
//        }else{//文字消息有链接
//            
//            self.contentLabel.textColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
//        }
//        
//        CGFloat contentW = 0.0 ;
//        CGFloat contentH = 0.0 ;
//        CGFloat contentMaxW = SCREEN_WIDTH - 120;
//        
//        //计算文本宽度
//        CGSize contentStrSize = [model.content boundingRectWithSize:CGSizeMake(contentMaxW-contentEdgeLeft-contentEdgeRight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
//        
//        //字体的宽度
//        CGFloat contentStrW = contentStrSize.width+contentEdgeLeft+contentEdgeRight;
//        
//        contentW = contentMaxW<contentStrW?contentMaxW:contentStrW;
//        
//        contentH = contentMaxW<contentStrW?contentStrSize.height+contentEdgeTop+contentEdgeBottom:contentStrSize.height+contentEdgeTop;
//        
//        self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, contentW, contentH);
//        self.contentLabel.frame = CGRectMake(15, 0, contentW-20, contentH);
//        
//    }else{
//        
//        //图片或GIF的宽度固定
//        CGFloat itemWidth = 230;
//        CGFloat itemHeight = 0;
//        //根据URL获取图片大小
//        CGSize itemSize = [UIImage getImageSizeWithURL:imageURL];
//        
//        if(itemSize.width){
//            itemHeight = itemSize.height/itemSize.width *itemWidth;
//        }
//        
//        if(model.content.length == 0){//图片消息内容
//            
//            self.titleLabel.hidden = YES;
//            
//            self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, itemWidth+24, itemHeight+20);
//            
//            self.contentImageView.frame = CGRectMake(15, 10, itemWidth, itemHeight);
//            
//        }else{//文字、图片消息内容
//            
//            self.contentLabel.textColor = [UIColor colorWithHexString:@"#848384"];
//            self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
//            
//            self.titleLabel.hidden = NO;
//            
//            CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
//            
//            self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, itemWidth+24, itemHeight+40+contentSize.height);
//            
//            self.titleLabel.frame = CGRectMake(15, 5, itemWidth, 20);
//            
//            self.contentImageView.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame)+5, itemWidth, itemHeight);
//            
//            self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.contentImageView.frame)+5, itemWidth, contentSize.height);
//        }
//    }
//}


- (void)setModel:(YKXChatReceiveModel *)model{
    
    _model = model;
    
    NSString *timeStr = [YKXCommonUtil detailDayStr:[model.addtime integerValue]];
    
    self.timeLabel.text = timeStr;
    
    self.titleLabel.text = model.title;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    self.contentLabel.text = model.content;
    
    if([model.isTimeShow isEqualToString:@"0"]){//隐藏时间列表
        
        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 0);
        
        self.headImageView.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame), 40, 40);
    }else{//显示时间列表
        
        self.timeLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2, 20, 90, 20);
        
        self.headImageView.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame)+20, 40, 40);
        
    }
    
    if([model.type isEqualToString:@"1"]){//文字消息内容(此时只有文字，显示的返回数据的内容)
        
        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
        
        self.titleLabel.hidden = YES;
        
        if(model.url.length == 0){
            
            self.contentLabel.textColor = [UIColor colorWithHexString:DEEP_COLOR];
        }else{//文字消息有链接
            
            self.contentLabel.textColor = [UIColor colorWithHexString:DISCOVERYNAVC_BAR_COLOR];
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
        
        self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, contentW, contentH);
        self.contentLabel.frame = CGRectMake(15, 0, contentW-20, contentH);
        
    }else if([model.type isEqualToString:@"2"]){//图片消息
        
        self.titleLabel.hidden = YES;
        
        self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, 254, 170);
        
        self.contentImageView.frame = CGRectMake(15, 10, 230, 150);
        
    }else{//图文消息
        
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#848384"];
        self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
        
        self.titleLabel.hidden = NO;
        
        CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
        
        self.messageImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y, 254, 190+contentSize.height);
        
        self.titleLabel.frame = CGRectMake(15, 5, self.messageImageView.frame.size.width-20, 20);
        
        self.contentImageView.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.titleLabel.frame)+5, 230, 150);
        
        self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, CGRectGetMaxY(self.contentImageView.frame)+5, 230, contentSize.height);
        
    }
}


+ (CGFloat)heightTableCellWithModel:(YKXChatReceiveModel *)model{
    
//    if(model.img_url.length == 0){//只显示文字
//        
//        CGFloat contentW = 0.0 ;
//        CGFloat contentH = 0.0 ;
//        CGFloat contentMaxW = SCREEN_WIDTH - 120;
//        
//        //计算文本宽度
//        CGSize contentStrSize = [model.content boundingRectWithSize:CGSizeMake(contentMaxW-contentEdgeLeft-contentEdgeRight, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
//        
//        //字体的宽度
//        CGFloat contentStrW = contentStrSize.width+contentEdgeLeft+contentEdgeRight;
//        
//        contentW = contentMaxW<contentStrW?contentMaxW:contentStrW;
//        
//        contentH = contentMaxW<contentStrW?contentStrSize.height+contentEdgeTop+contentEdgeBottom:contentStrSize.height+contentEdgeTop;
//        
//        if([model.isTimeShow isEqualToString:@"0"]){
//            
//            return contentH + 40;
//        }else{
//            
//            return contentH + 80;
//        }
//        
//    }else{
//        
//        NSURL *imageURL = [NSURL URLWithString:model.img_url];
//        CGFloat itemWidth = 230;
//        CGFloat itemHeight = 0;
//        
//        CGSize itemSize = [UIImage getImageSizeWithURL:imageURL];
//        
//        //获取图片或GIF的高度
//        if(itemSize.width){
//            itemHeight = itemSize.height/itemSize.width *itemWidth;
//        }

//        
//        if(model.content.length == 0){//只显示图片
//            
//            if([model.isTimeShow isEqualToString:@"0"]){
//                
//                return itemHeight+60;
//            }else{
//                return itemHeight+100;
//            }
//            
//        }else{//显示文字和图片
//            
//            CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
//            
//            if([model.isTimeShow isEqualToString:@"0"]){
//                return itemHeight+80+contentSize.height;
//            }else{
//                return itemHeight+120+contentSize.height;
//            }
//        }
//    }
    
    if([model.type isEqualToString:@"1"]){
        
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
        
    }else if([model.type isEqualToString:@"2"]){
        
        if([model.isTimeShow isEqualToString:@"0"]){
            
            return 210;
        }else{
            return 250;
        }
    }else{
        
        CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
        
        if([model.isTimeShow isEqualToString:@"0"]){
            return 230+contentSize.height;
        }else{
            return 270+contentSize.height;
        }
    }
}



- (void)tapImageView:(UITapGestureRecognizer *)gesture{
    
    //通过self.model获取当前点击的cell的数据
    NSArray *appInfoUserAgentArray = [YKXDefaultsUtil getAppInfoUserAgent];
    
    NSString *currentUserAgent;
    if([self.model.user_agent isEqualToString:@"user_agent_1"]){
        currentUserAgent = appInfoUserAgentArray[0];
    }else if ([self.model.user_agent isEqualToString:@"user_agent_2"]){
        currentUserAgent = appInfoUserAgentArray[1];
    }else if ([self.model.user_agent isEqualToString:@"user_agent_3"]){
        currentUserAgent = appInfoUserAgentArray[2];
    }else if ([self.model.user_agent isEqualToString:@"user_agent_4"]){
        currentUserAgent = appInfoUserAgentArray[3];
    }
    
    //有链接直接跳转
    if(self.model.url.length >0){
        
        if(_delegate && [_delegate respondsToSelector:@selector(currentCellUserAgent:contentUrl:js_1:js_2:)]){
            
            [_delegate currentCellUserAgent:currentUserAgent contentUrl:self.model.url js_1:self.model.js_1 js_2:self.model.js_2];
        }
        
    }else{//没有链接时点击图片或GIF可以放大
        
        if([self.model.type isEqualToString:@"2"]){
            
            //添加背景遮盖
            UIView *cover = [[UIView alloc] init];
            cover.frame = [UIScreen mainScreen].bounds;
            cover.backgroundColor = [UIColor clearColor];
            [[UIApplication sharedApplication].keyWindow addSubview:cover];
            
            NSURL *imageURL = [NSURL URLWithString:self.model.img_url];
            
            NSString *pathExtension = [imageURL.pathExtension lowercaseString];
            
            if([pathExtension isEqualToString:@"png"] || [pathExtension isEqualToString:@"jpg"]){
                
                [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
                
                //添加图片到遮盖上
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:[cover convertRect:gesture.view.frame fromView:self]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.img_url]];
                
                self.lastFrame = imageView.frame;
                [cover addSubview:imageView];
                self.imagView = imageView;
                
                //放大
                [UIView animateWithDuration:0.3f animations:^{
                    
                    cover.backgroundColor = [UIColor blackColor];
                    CGRect frame = imageView.frame;
                    frame.size.width = cover.frame.size.width;
                    //获取图片的宽高比例
                    frame.size.height = cover.frame.size.width * (imageView.frame.size.height / imageView.frame.size.width);
                    frame.origin.x = 0;
                    frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.5;
                    imageView.frame = frame;
                }];
                
            }else if ([pathExtension isEqualToString:@"gif"]){
                
                [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGIFCover:)]];
                
                
                UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:[cover convertRect:gesture.view.frame fromView:self]];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.img_url]];
                UIImage *image = [UIImage sd_animatedGIFWithData:data];
                gifImageView.image = image;
                
                
                self.lastFrame = gifImageView.frame;
                [cover addSubview:gifImageView];
                self.gifImageView = gifImageView;
                
                //放大
                [UIView animateWithDuration:0.3f animations:^{
                    
                    cover.backgroundColor = [UIColor blackColor];
                    CGRect frame = gifImageView.frame;
                    frame.size.width = cover.frame.size.width;
                    frame.size.height = cover.frame.size.width * (gifImageView.frame.size.height / gifImageView.frame.size.width);
                    frame.origin.x = 0;
                    frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.5;
                    gifImageView.frame = frame;
                }];
            }
        }
    }
}

//点击遮盖的图片
- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3f animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.imagView.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.imagView = nil;
    }];
}

//点击遮盖的GIF图片
- (void)tapGIFCover:(UITapGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.3f animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.gifImageView.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        
        self.gifImageView = nil;
    }];
}


@end
