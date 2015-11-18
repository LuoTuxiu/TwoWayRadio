//
//  UIViewController+extension.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/11/18.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "UIViewController+extension.h"
@implementation UIViewController (extension)
-(void)showControllerWithVc:(UIViewController *)vc
{
    MMDrawerController *originDrawVc = self.mm_drawerController;
    TWtabBarController *originTabVc = (TWtabBarController *)originDrawVc.centerViewController;
    TWNavigationController *originVc =(TWNavigationController *) originTabVc.selectedViewController;
    [originVc pushViewController:vc animated:NO];
    [originDrawVc closeDrawerAnimated:YES completion:nil];
}
@end
