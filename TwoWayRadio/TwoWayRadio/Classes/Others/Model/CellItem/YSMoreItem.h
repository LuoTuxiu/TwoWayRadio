//
//  YSMoreItem.h
//  BookKeeping
//
//  Created by 夏思立 on 15/9/11.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonItem.h"

@interface YSMoreItem : YSCommonItem

@property (nonatomic,copy)NSString *centerTitle;

+ (instancetype)itemWithCenterTitle:(NSString *)title;

@end
