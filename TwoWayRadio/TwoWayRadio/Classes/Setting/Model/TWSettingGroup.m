//
//  TWSettingGroup.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWSettingGroup.h"

@implementation TWSettingGroup

+(instancetype)groupWithItems:(NSArray *)items
{
    TWSettingGroup *group =  [[self alloc] init];
    group.items = items;
    return group;
}
@end
