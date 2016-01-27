//
//  YSCellItem.h
//  BookKeeping
//
//  Created by 夏思立 on 15/10/22.
//  Copyright © 2015年 Kingdee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCellItem : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;

+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
