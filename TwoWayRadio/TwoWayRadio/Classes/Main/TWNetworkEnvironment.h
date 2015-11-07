//
//  TWNetworkEnvironment.h
//  TwoWayRadio
//
//  Created by xulei on 15/10/12.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface TWNetworkEnvironment : NSObject


/**
 * @brief           get the signalton engine object
 * @return          the engine object
 */
+ (TWNetworkEnvironment *)sharedInstance;

/**
 * @brief           get the network statue
 */
- (BOOL)isNetworkReachable;

/**
 * @brief           Judgment wifi is connected
 */
- (BOOL)isEnableWIFI;

/**
 * @brief           To judge whether the 3G connection
 */
- (BOOL)isEnable3G;
@end
