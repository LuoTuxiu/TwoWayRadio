//
//  TWSettingHeaderView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWSettingHeaderView.h"
@interface TWSettingHeaderView()
{
    
}


@end
@implementation TWSettingHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //视频中的做法：
//    UIImage *oldImage =  [UIImage imageNamed:@"tabbar_profile_selected"];
//    
//    //2.开启上下文
//    UIGraphicsBeginImageContextWithOptions(oldImage.size, NO, 0.0);
//    
//    //3.画圆
//    UIBezierPath *path =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height)];
//    
//    //4.设置裁剪区域
//    [path addClip];
    
//-----------------------华丽的分隔线-------------------------------------//
//    //获取上下文
//    CGContextRef ctx =  UIGraphicsGetCurrentContext();
//    
//    //首先画圆
//    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));
//    
//    //将当前的上下文的形状裁剪出来，以后的内容只能放在这个形状里
//    CGContextClip(ctx);
//    
//    //填充圆
//    CGContextFillPath(ctx);
//    
//    //显示图片
//    UIImage *image =  [UIImage imageNamed:@"user"];
//    [image drawAtPoint:CGPointMake(50, 50)];
    
    
    
}

+(instancetype)settingHeaderview
{
    return [[NSBundle mainBundle] loadNibNamed:@"TWSettingHeaderView" owner:nil options:nil][0];
}
@end
