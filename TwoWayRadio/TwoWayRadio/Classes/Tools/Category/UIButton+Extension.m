//
//  UIButton+Extension.m
//  btSimpleRippleButton
//
//  Created by kingdee on 15/11/19.
//  Copyright © 2015年 Balram. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
-(void)setRippleStatusWithbutton:(UIButton *)btn
{
    
    UIColor *stroke = RGB(0xFB, 0X80, 0X93);
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:10];
        // 构建矩形内椭圆，传入一个CGRect，根据这个矩形构建一个内椭圆形。当然，如果传入的是一个正方形，构成的就是一个圆了。
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds cornerRadius:10];
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self convertPoint:self.center fromView:self.superview];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 2;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1)];
    
    // 缩放倍数
    //        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    //        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.0f;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];


}

-(void)setRippleStatusfillWithbutton:(UIButton *)btn
{
    
    UIColor *stroke = RGB(0xFB, 0X80, 0X93);
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.bounds.size.width, self.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:10];
    // 构建矩形内椭圆，传入一个CGRect，根据这个矩形构建一个内椭圆形。当然，如果传入的是一个正方形，构成的就是一个圆了。
    //        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds cornerRadius:10];
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self convertPoint:self.center fromView:self.superview];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
//    circleShape.fillColor = stroke.CGColor;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 4;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
    
    // 缩放倍数
    //        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    //        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @0;
    alphaAnimation.toValue = @0.5;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.0f;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    
    
    
    //第二层动画
    CGFloat num = 1.15;
    CGRect pathFrame2 = CGRectMake(-CGRectGetMidX(self.bounds)* num, -CGRectGetMidY(self.bounds) *num, self.bounds.size.width * num , self.bounds.size.height * num);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:pathFrame2 cornerRadius:10];
    // 构建矩形内椭圆，传入一个CGRect，根据这个矩形构建一个内椭圆形。当然，如果传入的是一个正方形，构成的就是一个圆了。
    //        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds cornerRadius:10];
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition2 = [self convertPoint:self.center fromView:self.superview];
    
    CAShapeLayer *circleShape2 = [CAShapeLayer layer];
    circleShape2.path = path2.CGPath;
    circleShape2.position = shapePosition2;
    //    circleShape.fillColor = stroke.CGColor;
    circleShape2.fillColor = [UIColor clearColor].CGColor;
    circleShape2.opacity = 0;
    circleShape2.strokeColor = stroke.CGColor;
    circleShape2.lineWidth = 3.5;
    
    [self.layer addSublayer:circleShape2];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
    
    // 缩放倍数
    //        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    //        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    
    CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation2.fromValue = @0;
    alphaAnimation2.toValue = @0.2;
    
    CAAnimationGroup *animation2 = [CAAnimationGroup animation];
    animation2.animations = @[scaleAnimation2, alphaAnimation2];
    animation2.duration = 1.0f;
    animation2.repeatCount = HUGE_VALF;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape2 addAnimation:animation2 forKey:nil];

}

-(void)endRippleStatus:(UIButton *)btn
{

    for (CALayer * layer in btn.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeAnimationForKey:@"animation"];
            [layer removeAllAnimations];
            break;
        }
    }
//    NSLog(@"%@",btn.layer.sublayers);
////    [btn.layer removeAllAnimations];
}

@end
