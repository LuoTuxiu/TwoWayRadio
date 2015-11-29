//
//  TWTabBarController.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/20.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWTabBarController.h"
#import "HomeViewController.h"
#import "TWSettingViewController.h"
#import "TWNavigationController.h"
@implementation TWTabBarController
-(void)viewDidLoad
{
    [super viewDidLoad];
    DebugMethod();
    //默认是没连接成功
    self.isConnected = NO;
    
//    HomeViewController *home = [[HomeViewController alloc]init];
//    [self addChildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
//    
//    TWSettingViewController *setting = [[TWSettingViewController alloc]init];
//    [self addChildVc:setting title:@"设置" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];

    
}

-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.tabBarItem.title = title;
    childVc.navigationItem.title = title;
    
    childVc.tabBarItem.image =  [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage =  [UIImage imageNamed:selectedImageName];
    
    //设置item文字的普通样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置item文字的选中时样式
    NSMutableDictionary *SelectedtextAttrs = [NSMutableDictionary dictionary];
    SelectedtextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childVc.tabBarItem setTitleTextAttributes:SelectedtextAttrs forState:UIControlStateSelected];
    
    TWNavigationController *nav = [[TWNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    DebugMethod();
}

-(void)viewDidAppear:(BOOL)animated
{
    DebugMethod();
}


@end
