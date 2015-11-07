//
//  TWbaseLoginViewController.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/13.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWbaseLoginViewController : UIViewController
@property (nonatomic,weak)  UITextField * accountTextField;
@property (nonatomic,weak)  UITextField * passwdTextField;
@property (nonatomic,weak)  UITextField * serverIpTextField;
@property (nonatomic,weak)  UITextField * serverPortTextField;
@property (nonatomic,assign) BOOL isSwitchOn;

@property (nonatomic,weak)  UIButton    * logBtn;
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak)  UISwitch *isSave;
-(void)addAccountView;
-(void)addBtnView;
@end
