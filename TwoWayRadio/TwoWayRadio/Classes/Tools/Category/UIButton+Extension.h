//
//  UIButton+Extension.h
//  btSimpleRippleButton
//
//  Created by kingdee on 15/11/19.
//  Copyright © 2015年 Balram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
/**
 *  设置该按钮为涟漪状态
 *
 *  @param btn 传入需要设置的按钮
 */
-(void)setRippleStatusWithbutton:(UIButton *)btn;

/**
 *  设置该按钮为填充的涟漪状态
 *
 *  @param btn 传入需要设置的按钮
 */
-(void)setRippleStatusfillWithbutton:(UIButton *)btn;

/**
 *  取消该按钮的涟漪状态
 *
 *  @param btn 传入需要设置的按钮
 */
-(void)endRippleStatus:(UIButton *)btn;
@end
