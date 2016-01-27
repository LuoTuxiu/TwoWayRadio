//
//  YSCommonItem.m
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonItem.h"

@implementation YSCommonItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    YSCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}


+ (instancetype)itemWithTitle:(NSString *)title rightImage:(NSString *)rightImage{
    YSCommonItem *item = [self itemWithTitle:title];
    item.rightImage = rightImage;
    return item;
}

@end
