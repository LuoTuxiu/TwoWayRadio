//
//  TWSettingTableViewCell.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TWSettingItem;
@class TWSaveInfo;
@interface TWSettingTableViewCell : UITableViewCell
@property (nonatomic,strong) TWSettingItem *item;
@property (nonatomic,strong) TWSaveInfo *saveInfo;
@end
