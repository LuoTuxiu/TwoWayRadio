//
//  TWStatusView.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TWStatusButton;
@interface TWStatusView : UIView
@property (nonatomic,strong) TWStatusButton *statusBtn;
@property (nonatomic,strong) UIButton *connectBtn;
-(void)setStatusBtnWithConnectStatus:(int)connectStatus;
@end
