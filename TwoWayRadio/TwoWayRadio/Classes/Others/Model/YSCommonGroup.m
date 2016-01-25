//
//  YSCommonGroup.m
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonGroup.h"

@implementation YSCommonGroup

+ (instancetype)group
{
    return [[self alloc] init];
}

- (NSMutableArray *)mutableItems{
    if (!_mutableItems) {
        _mutableItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _mutableItems;
}

@end
