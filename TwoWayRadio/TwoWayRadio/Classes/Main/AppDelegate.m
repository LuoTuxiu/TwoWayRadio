//
//  AppDelegate.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/18.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "AppDelegate.h"
#import "TWtabBarController.h"
#import "TWFirstViewLoginViewController.h"
//#import <MediaPlayer/MPNowPlayingInfoCenter.h> //2015.10.12 add
@interface AppDelegate ()

@end

@implementation AppDelegate

//程序启动的时候调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.创建窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame  = [UIScreen mainScreen].bounds;
    
    //2.设置根控制器
    TWtabBarController *tabbarVc = [[TWtabBarController alloc]init];
    TWFirstViewLoginViewController *loginVc = [[TWFirstViewLoginViewController alloc]init];

    self.window.rootViewController = tabbarVc;
   //    TWFirstViewLoginViewController *loginVc = [[TWFirstViewLoginViewController alloc]init];
//    self.window.rootViewController = loginVc;

    //3.显示窗口
    [self.window makeKeyAndVisible];
//    [tabbarVc presentModalViewController:loginVc animated:YES];
    [tabbarVc presentViewController:loginVc animated:YES completion:nil];
    return YES;
}

//进入后台先调用这个
//模拟器下：三分钟才会调beginBackgroundTaskWithExpirationHandler这个函数
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%s",__func__);
    UIBackgroundTaskIdentifier myTask;
    myTask =  [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"in the beginBackgroundTaskWithExpirationHandler%s",__func__);
    }];
}

//进入后台后调用，官方文档中要求此方法需在5秒内结束。
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//从后台返回前台时调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//程序退出时调用
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
