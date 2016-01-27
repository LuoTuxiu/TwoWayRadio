//
//  YSEditItem.h
//  BookKeeping
//
//  Created by 夏思立 on 15/9/14.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCellItem.h"

typedef enum {
    YSEditItemTypeOnlyAllowedNumber,
    YSEditItemTypeAllowedAll
}YSEditItemType;

@interface YSEditItem : YSCellItem

@property (nonatomic,assign)YSEditItemType editType;

@end
