//
//  TWtabBarController.h
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/20.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWtabBarController : UITabBarController
//添加公共属性，保存登录状态
@property (nonatomic,copy) NSString *connectStatus;
//是否是第一个登陆界面的标志
@property (nonatomic,copy) NSString *isFirstLoginView;
@end
