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
-(TWtabBarController *)tabBarController
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
        TWtabBarController *tabBarController = [[TWtabBarController alloc] init];
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
                            //                            CYLTabBarItemImage : @"home_normal",
                            //                            CYLTabBarItemSelectedImage : @"home_highlight",
                            };
  
    
    NSArray *tabBarItemsAttributes = @[ dict1];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

@end
