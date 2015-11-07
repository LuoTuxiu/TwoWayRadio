//
//  TWBaseSettingViewController.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWSettingGroup.h"
#import "TWSettingItem.h"
#import "TWSettingTableViewCell.h"
#import "TWSettingArrowItem.h"
@interface TWBaseSettingViewController : UIViewController
{
    NSMutableArray *_allGroups; //所有组模型
}
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) UITextField *accountField;
@end
