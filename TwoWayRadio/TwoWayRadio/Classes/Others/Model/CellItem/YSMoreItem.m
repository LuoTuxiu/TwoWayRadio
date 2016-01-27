//
//  YSMoreItem.m
//  BookKeeping
//
//  Created by 夏思立 on 15/9/11.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSMoreItem.h"

@implementation YSMoreItem

+ (instancetype)itemWithCenterTitle:(NSString *)title
{
    YSMoreItem *item = [[self alloc] init];
    item.centerTitle = title;
    return item;
}

@end
