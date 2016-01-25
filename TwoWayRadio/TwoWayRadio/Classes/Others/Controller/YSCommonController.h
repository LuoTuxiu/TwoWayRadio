//
//  YSCommonController.h
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCommonItem.h"
#import "YSCommonGroup.h"

@interface YSCommonController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong ) UITableView *tableView;
- (NSMutableArray *)groups;
- (YSCommonGroup *)addGroup;

-(void)commonSetupTableView:(UITableViewStyle)style;

@end
