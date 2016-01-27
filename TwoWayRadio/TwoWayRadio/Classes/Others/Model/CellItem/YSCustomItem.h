//
//  YSCustomItem.h
//  BookKeeping
//
//  Created by 夏思立 on 15/9/8.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonItem.h"

@interface YSCustomItem : YSCommonItem

@property (nonatomic,copy)NSString *curstomImageName;

+ (instancetype)itemWithTitle:(NSString *)title curstomImage:(NSString *)imageName;

@end
