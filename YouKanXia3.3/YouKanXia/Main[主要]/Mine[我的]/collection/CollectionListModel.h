//
//  CollectionListModel.h
//  YouKanXia
//
//  Created by 汪立 on 2017/10/8.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionListModel : NSObject

//收藏时间
@property (nonatomic,copy) NSString *addtime;

@property (nonatomic,copy) NSString *collection_id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *vweb;

@end
