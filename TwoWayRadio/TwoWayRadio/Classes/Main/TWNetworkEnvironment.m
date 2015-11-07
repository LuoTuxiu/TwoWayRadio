//
//  TWNetworkEnvironment.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/12.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWNetworkEnvironment.h"

@implementation TWNetworkEnvironment
static TWNetworkEnvironment *g_instance = nil;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/**
 * @brief           Whether there are single instance
 * @return          the result
 */
+ (BOOL)sharedInstanceExists
{
    return (nil != g_instance);
}

/**
 * @brief           get the signalton engine object
 * @return          the engine object
 */
+ (TWNetworkEnvironment *)sharedInstance
{
    @synchronized(self) {
        if ( g_instance == nil ) {
            g_instance = [[[self  class] alloc] init];
            //any other specail init as required
        }
    }
    return g_instance;
}


/**
 * @brief           get the network statue
 */
- (BOOL)isNetworkReachable
{
    BOOL isReachable = NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:{
            isReachable = NO;
        }
            break;
        case ReachableViaWWAN:{
            isReachable = YES;
        }
            break;
        case ReachableViaWiFi:{
            isReachable = YES;
        }
            break;
        default:
            isReachable = NO;
            break;
    }
    return isReachable;
}

/**
 * @brief           Judgment wifi is connected
 */
- (BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

/**
 * @brief           To judge whether the 3G connection
 */
- (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


@end
