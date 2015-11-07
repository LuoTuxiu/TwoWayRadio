//
//  TWStatusButton.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWStatusButton.h"
@interface TWStatusButton()
{
    
}
@property (nonatomic,assign) CGRect btnFrame;
@end
@implementation TWStatusButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20,0,200,20);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    _btnFrame = CGRectMake(0, 0, 20, 20);
    return _btnFrame;
}

@end
