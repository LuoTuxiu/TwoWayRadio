//
//  TWTabBarControllerConfig.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/11/15.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWTabBarControllerConfig.h"
#import "HomeViewController.h"
#import "TWNavigationController.h"
#import "CYLTabBarController.h"
@implementation TWTabBarControllerConfig
-(TWTabBarController *)tabBarController
{
    if (!_tabBarController) {
        [self setupViewControllers];
        
    }
    return _tabBarController;
}


-(void)setupViewControllers
{
        HomeViewController *home = [[HomeViewController alloc]init];
    
        TWNavigationController *firstNavigationController = [[TWNavigationController alloc]
                                                             initWithRootViewController:home];
        TWTabBarController *tabBarController = [[TWTabBarController alloc] init];
        [self customizeTabBarForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNavigationController,
                                               
                                               ]];
        _tabBarController = tabBarController;
}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"tabbar_home",
                            CYLTabBarItemSelectedImage : @"tabbar_home_selected",
                            };
  
    
    NSArray *tabBarItemsAttributes = @[ dict1];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(252, 109, 8),UITextAttributeTextColor,nil] forState:UIControlStateNormal];
}


-(void)dealloc
{
    DebugMethod();
}
@end
