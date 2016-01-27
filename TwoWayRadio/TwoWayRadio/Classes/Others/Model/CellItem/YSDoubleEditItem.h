//
//  YSDoubleEditModel.h
//  BookKeeping
//
//  Created by 夏思立 on 15/10/20.
//  Copyright © 2015年 Kingdee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDoubleEditItem : NSObject

@property (nonatomic,copy)NSString *title1;
@property (nonatomic,copy)NSString *title2;
@property (nonatomic,copy)NSString *subTitle1;
@property (nonatomic,copy)NSString *subTitle2;
@property (nonatomic,assign)BOOL editEnable;

+ (instancetype)itemWithTitle:(NSString *)title1 title2:(NSString *)title2 editEnable:(BOOL)editEnable;
+ (instancetype)itemWithTitle:(NSString *)title1 title2:(NSString *)title2;

@end
