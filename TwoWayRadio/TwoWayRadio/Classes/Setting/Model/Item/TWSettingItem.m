//
//  TWSettingItem.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWSettingItem.h"

@implementation TWSettingItem
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    TWSettingItem *item  = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    
    if (item.icon == nil) {
        NSLog(@"not found the image name: %@",icon);
    }
    return item;
}

+(instancetype)itemWithtitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}
@end
