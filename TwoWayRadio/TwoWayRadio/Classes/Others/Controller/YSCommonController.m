//
//  YSCommonController.m
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonController.h"
#import "YSCommonCell.h"

@interface YSCommonController ()

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation YSCommonController

- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

//- (id)init {
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

- (YSCommonGroup *)addGroup {
    YSCommonGroup *group = [YSCommonGroup group];
    [self.groups addObject:group];
    return group;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - init
-(void)commonSetupTableView:(UITableViewStyle)style
{
    //添加tableview到一个视图
    CGRect tableViewRect = CGRectMake(0, 0, TWScreenWidth, TWScreenHeight);
    UITableView *tableView =  [[UITableView alloc]initWithFrame:tableViewRect style:style];
    //    tableView.backgroundColor = [UIColor greenColor];
    _tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    // 设置tableView属性
    self.tableView.sectionFooterHeight = 10;
    self.tableView.sectionHeaderHeight = 0;

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSCommonCell *cell = [YSCommonCell cellWithTableView:tableView];
    YSCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSCommonGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSCommonGroup *group = self.groups[section];
    return group.header;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 1.取出这行对应的item模型
    YSCommonGroup *group = self.groups[indexPath.section];
    YSCommonItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation();
    }
}

@end
