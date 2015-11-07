//
//  TWSettingItem.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWSettingItem : NSObject
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) void (^operation)();//点击cell后要执行的操作


+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

+(instancetype)itemWithtitle:(NSString *)title;

@end
