//
//  TWRadioView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWRadioView.h"

@interface TWRadioView()

@property (nonatomic,assign) CGFloat radius;

@end
@implementation TWRadioView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (isIphone4) {
            _radius =  100;
        }
        else
        {
            _radius =  128;
        }
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
        [self addArcWithTimes:4];

    } else {
        
        [self addArcWithTimes:1];
    }
    
}

/**
 *  添加不同颜色的圆弧，做成一定的动画效果
 *
 *  @param times 将2pi角度变换成多少个圆弧
 */
-(void)addArcWithTimes:(int)times
{
    CGFloat angle =  M_PI  * 2 / times;

    //1.获取上下文
    CGContextRef ctx =  UIGraphicsGetCurrentContext();

    for (int i =0; i<times; i++) {
        //2.画圆弧
        CGContextAddArc(ctx, self.centerX, self.centerY, _radius,  angle  *i,angle   *(i+1), 0);
        
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
