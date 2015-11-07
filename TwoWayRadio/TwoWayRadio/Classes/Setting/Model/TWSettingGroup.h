//
//  TWSettingGroup.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWSettingGroup : NSObject
@property (nonatomic,copy) NSString * header;
@property (nonatomic,copy) NSString * footer;
@property (nonatomic,strong) NSArray *items;
+(instancetype)groupWithItems:(NSArray *)items;

@end
