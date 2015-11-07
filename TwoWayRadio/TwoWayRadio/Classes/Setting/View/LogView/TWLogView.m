//
//  TWLogView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/4.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWLogView.h"

@implementation TWLogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)logView
{
    return [[NSBundle mainBundle] loadNibNamed:@"TWLogView" owner:nil options:nil] [0];
}
@end
