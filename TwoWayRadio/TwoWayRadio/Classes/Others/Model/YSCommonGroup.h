//
//  YSCommonGroup.h
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCommonGroup : NSObject

/** 组头 */
@property (nonatomic, copy) NSString *header;
/** 组尾 */
@property (nonatomic, copy) NSString *footer;
/** 这组的所有cell模型*/
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSMutableArray *mutableItems;
+ (instancetype)group;

@end
