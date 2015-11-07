//
//  TWBaseSettingViewController.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWBaseSettingViewController.h"
#import "TWSettingGroup.h"
#import "TWSettingItem.h"
#import "TWSettingTableViewCell.h"
#import "TWSettingArrowItem.h"
#import "TWSaveInfo.h"
@interface TWBaseSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TWBaseSettingViewController

-(void)loadView
{
    _allGroups =  [NSMutableArray array];
    
    UITableView *tableView =  [[UITableView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
    tableView.dataSource =self;
    tableView.delegate = self;
//    tableView.backgroundColor = [UIColor redColor];
    self.view  = tableView;
    _tableView = tableView;
}

//设置tableview的话在这里才有效
-(void)viewDidAppear:(BOOL)animated
{
//    CGRect screenFrame =  [UIScreen mainScreen].applicationFrame;
//    CGRect tableViewFrame = screenFrame;
//    tableViewFrame.origin.y = screenFrame.origin.y + 20;
//    tableViewFrame.size.height = screenFrame.size.height - 20;
//    self.tableView.frame = tableViewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TWSettingGroup *group = _allGroups[section];
    return group.items.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =  @"cell";
    
    TWSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell =  [[TWSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    
    //取出模型
    TWSettingGroup *group = _allGroups[indexPath.section];
    TWSettingItem *item =  group.items[indexPath.row];
    cell.item = item;
    NSLog(@"%@",[cell.accessoryView class]);
    if ([cell.item.title isEqualToString:@"账号"]) {
        _accountField = (UITextField *)cell.accessoryView;
    }
    return cell;

}

#pragma mark 点击了cell的操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //点击过后取消选中该cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //取出这行对应的模型
    TWSettingGroup *group =  _allGroups[indexPath.section];
    TWSettingItem *item =  group.items[indexPath.row];
    
    //取出这行模型对应的block代码，如果有操作，则跳去执行block
    if (item.operation) {
        item.operation();
        return;
    }
    
    //检测有没有要跳转的控制器
    if ([item isKindOfClass:[TWSettingArrowItem class]]) {
        TWSettingArrowItem *arrowitem = (TWSettingArrowItem *)item;
        if (arrowitem.showVcClass) {
            UIViewController *vc =  [[arrowitem.showVcClass alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    

}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 8.0;
//}
@end
