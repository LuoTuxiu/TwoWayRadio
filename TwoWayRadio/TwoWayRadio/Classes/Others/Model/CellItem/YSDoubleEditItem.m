//
//  YSDoubleEditModel.m
//  BookKeeping
//
//  Created by 夏思立 on 15/10/20.
//  Copyright © 2015年 Kingdee. All rights reserved.
//

#import "YSDoubleEditItem.h"

@implementation YSDoubleEditItem

+ (instancetype)itemWithTitle:(NSString *)title1 title2:(NSString *)title2 editEnable:(BOOL)editEnable{
    YSDoubleEditItem *editItem = [[YSDoubleEditItem alloc] init];
    editItem.editEnable = editEnable;
    editItem.title1 = title1;
    editItem.title2 = title2;
    return editItem;
}

+ (instancetype)itemWithTitle:(NSString *)title1 title2:(NSString *)title2{
    return [YSDoubleEditItem itemWithTitle:title1 title2:title2 editEnable:YES];
}

@end
