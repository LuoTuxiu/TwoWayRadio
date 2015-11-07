//
//  TWRadioButton.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWRadioButton.h"

@implementation TWRadioButton
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake((256 - 128) / 2.0, (256 - 128) / 2.0, 128, 128);
}


@end
