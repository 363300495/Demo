//
//  YKXChatReceiveModel.m
//  YouKanXia
//
//  Created by 汪立 on 2017/8/9.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "YKXChatReceiveModel.h"
#import "YKXChatReceiveCell.h"
#import "YKXChatSendCell.h"
@implementation YKXChatReceiveModel

- (CGFloat)height{
    
    if(!_height){
        //调用cell的方法计算出高度
        
        if([self.newstype isEqualToString:@"1"]){
            _height = [YKXChatReceiveCell heightTableCellWithModel:self];
        }else{
            _height = [YKXChatSendCell heightTableCellWithModel:self];
        }
    }
    return _height;
}

@end
