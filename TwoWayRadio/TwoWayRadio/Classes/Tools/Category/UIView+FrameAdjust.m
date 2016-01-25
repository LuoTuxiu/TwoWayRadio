//
//  UIView+FrameAdjust.m
//  BooKKeeping
//
//  Created by yeer on 15/2/5.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "UIView+FrameAdjust.h"

@implementation UIView (FrameAdjust)

- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)x{
    return self.origin.x;
}

- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)y{
    return self.origin.y;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setRightX:(CGFloat)rightX{
    self.frame = CGRectMake(rightX - self.width, self.y, self.width, self.height);
}

- (CGFloat)rightX{
    return self.x + self.width;
}

- (void)setBottomY:(CGFloat)bottomY{
    self.frame = CGRectMake(self.x, bottomY - self.height, self.width, self.height);
}

- (CGFloat)bottomY{
    return self.y + self.height;
}

- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)width{
    return self.size.width;
}

- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width,height);
}

- (CGFloat)height{
    return self.size.height;
}

- (void)setOrigin:(CGPoint)origin{
    self.frame = (CGRect){origin,self.size};
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size{
    self.frame = (CGRect){self.origin,size};
}

- (CGSize)size{
    return self.frame.size;
}

@end
