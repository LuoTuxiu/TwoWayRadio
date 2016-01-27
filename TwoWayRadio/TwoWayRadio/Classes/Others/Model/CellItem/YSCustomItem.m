//
//  YSCustomItem.m
//  BookKeeping
//
//  Created by 夏思立 on 15/9/8.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCustomItem.h"

@implementation YSCustomItem
+ (instancetype)itemWithTitle:(NSString *)title curstomImage:(NSString *)imageName{
    YSCustomItem *item = [YSCustomItem itemWithTitle:title];
    item.curstomImageName = imageName;
    return item;
}

@end
