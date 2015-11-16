//
//  TWSettingHeaderView.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWSettingHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *logButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconOfPeople;
+(instancetype)loadHeaderview;

@end
