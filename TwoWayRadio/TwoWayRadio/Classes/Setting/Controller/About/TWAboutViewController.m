//
//  TWAboutViewController.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWAboutViewController.h"
#import "TWAboutHeaderView.h"
@interface TWAboutViewController ()

@end

@implementation TWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor =  [UIColor redColor];
    self.title = @"关于";
    
    //2.设置头部的部件
    TWAboutHeaderView *aboutView = [TWAboutHeaderView headerView];
    self.tableView.tableHeaderView = aboutView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *vc =  [[TWAboutViewController alloc]init];
    
    MMDrawerController *originDrawVc = (MMDrawerController *)window.rootViewController;
    TWtabBarController *originTabVc = (TWtabBarController *)originDrawVc.centerViewController;
    TWNavigationController *originVc =(TWNavigationController *) originTabVc.selectedViewController;
    originDrawVc.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    //        [originDrawVc closeDrawerAnimated:YES completion:nil];
    [originVc pushViewController:vc animated:YES];
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
