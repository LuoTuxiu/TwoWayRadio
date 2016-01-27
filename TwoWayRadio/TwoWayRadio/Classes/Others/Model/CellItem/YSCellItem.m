//
//  YSCellItem.m
//  BookKeeping
//
//  Created by 夏思立 on 15/10/22.
//  Copyright © 2015年 Kingdee. All rights reserved.
//

#import "YSCellItem.h"

@implementation YSCellItem

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title subtitle:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    YSCellItem *cellItem = [[self alloc] init];
    cellItem.title = title;
    cellItem.subtitle = subtitle;
    return cellItem;
}

@end
