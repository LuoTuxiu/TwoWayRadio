//
//  UIView+FrameAdjust.h
//  BooKKeeping
//
//  Created by yeer on 15/2/5.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameAdjust)
/**
 *  原点x
 */
@property (nonatomic, assign) CGFloat x;
/**
 *  原点y
 */
@property (nonatomic, assign) CGFloat y;
/**
 *  中点x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 *  中点y
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 *  右侧x
 */
@property (nonatomic, assign) CGFloat rightX;
/**
 *  底部y
 */
@property (nonatomic, assign) CGFloat bottomY;
/**
 *  宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  高
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  原点
 */
@property (nonatomic, assign) CGPoint origin;
/**
 *  尺寸
 */
@property (nonatomic, assign) CGSize size;

@end
