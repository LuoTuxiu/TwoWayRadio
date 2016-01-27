//
//  YSCommonItem.h
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCellItem.h"

@interface YSCommonItem : YSCellItem

/** 图标 */
@property (nonatomic, copy) NSString *icon;
/** 右边图片 **/
@property (nonatomic, copy) NSString *rightImage;

/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;
/** 封装点击这行cell想做的事情 */
@property (nonatomic, copy) void (^operation)();

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title rightImage:(NSString *)rightImage;

@end
