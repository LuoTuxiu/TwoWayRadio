//
//  TWRadioView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWRadioView.h"

@interface TWRadioView()
{
    
}

@property (nonatomic,assign) CGRect frameOfView;
@end
@implementation TWRadioView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
//    _frameOfView = frame;
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {

    if (_isSelected) {
//#warning 不知道为什么不能够使用addArcWithTimes，原因待查:
        //原因如下：
        //因为我是顺时针计算角度，而我clockwise设置方向设置错误了;
//        [self addArcWithTimes:4];
        [self addArcWithTimes:16];

    } else {
        
        // Drawing code
//        NSLog(@"%s",__func__);
        //1.获取上下文
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        
        //2.拼接路径
        //    CGPoint center =  CGPointMake(TWmainScreenFrame.size.width / 2.0, TWmainScreenFrame.size.height / 2.0);
        CGPoint center = self.center;
        CGFloat radius;
        if (isIphone4) {
            radius =  100;
        }
        else
        {
            radius =  128;
        }

        CGFloat startA = 0;//起始角
        CGFloat endA = M_PI * 2;
        UIBezierPath *path =  [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        
        //3.将路径添加到上下文
        CGContextAddPath(ctx, path.CGPath);
        
        //设置颜色
        [[UIColor yellowColor] set];
        
        //设置线条的宽度
        CGContextSetLineWidth(ctx, 10);
        
        //4.渲染上下文
        CGContextStrokePath(ctx);
    }
    
}


-(void)addArcWithTimes:(int)times
{
    CGFloat centerX = self.center.x;
    CGFloat centerY = self.center.y;
    CGFloat radius;
    if (isIphone4) {
        radius =  100;
    }
    else
    {
        radius =  128;
    }
    //1.获取上下文
    CGContextRef ctx =  UIGraphicsGetCurrentContext();

    for (int i =0; i<times; i++) {
        //2.画圆弧
        CGContextAddArc(ctx, centerX, centerY, radius,  M_PI_4 /2 *i,M_PI_4  /2 *(i+1), 0);
        
        //        CGContextClosePath(ctx);
        CGContextSetLineWidth(ctx, 10);
        if (i % 2 == 0) {
            [[UIColor yellowColor] set];
        } else {
            [[UIColor redColor] set];
        }
        
        //3.渲染
        //        CGContextFillPath(ctx);
        CGContextStrokePath(ctx);
    }

}
@end
