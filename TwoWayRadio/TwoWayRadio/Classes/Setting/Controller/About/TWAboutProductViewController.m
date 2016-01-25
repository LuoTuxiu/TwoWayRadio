//
//  TWAboutProductViewController.m
//  TwoWayRadio
//
//  Created by LuoTuxiu on 16/1/25.
//  Copyright © 2016年 Trbocare. All rights reserved.
//

#import "TWAboutProductViewController.h"
#import "TWAboutHeaderView.h"
@interface TWAboutProductViewController ()

@end

@implementation TWAboutProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    
    //2.设置头部的部件
    TWAboutHeaderView *aboutView = [TWAboutHeaderView headerView];
    self.tableView.tableHeaderView = aboutView;

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

@end
