//
//  YSCommonCell.h
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSArrowItem.h"
#import "YSCheckItem.h"
#import "YSSwitchItem.h"
#import "YSCustomItem.h"
#import "DZRightTitleItem.h"
#import "DZRightTextFieldItem.h"
#import "DZCommonChangeFrameItem.h"
@class YSCommonCell;
@protocol DZEditCellDelegate <NSObject>
@optional
- (void)editCell:(YSCommonCell *)editCell textFieldValueChangedWithMessage:(NSDictionary *)messageDic;
@end

@interface YSCommonCell : UITableViewCell

/** cell对应的item数据 */
@property (nonatomic, strong) YSCommonItem *item;
@property (nonatomic, strong) void (^switchOpen)(BOOL isOpen);
@property (nonatomic,weak) id<DZEditCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setSwitchOn:(BOOL)on;
@end
