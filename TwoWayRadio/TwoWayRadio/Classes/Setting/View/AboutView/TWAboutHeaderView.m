//
//  TWAboutHeaderView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWAboutHeaderView.h"

@implementation TWAboutHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:@"TWAboutHeaderView" owner:nil options:nil][0];
}

@end
