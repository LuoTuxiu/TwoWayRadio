//
//  UdpNetwork.h
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/21.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdpNetwork : NSObject

@property (nonatomic,assign) BOOL connectSuccessful;
-(instancetype)initWithAddress:(NSString *)address port:(uint32_t)port;
-(void)beginSendRecord;
-(void)stopSendRecord;
//-(BOOL)returnConnectSuccessful;
-(void)disconect;
-(void)sendExitMassage;
-(void)socketBeginRuning;
@end
