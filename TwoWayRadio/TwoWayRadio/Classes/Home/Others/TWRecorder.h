//
//  TWRecorder.h
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/20.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWAdpcm.h"

@protocol TWRecorderDelegate<NSObject>
@optional
-(void)sendAudio:(int8_t *)out state:(struct adpcm_state)state;
@end
@interface TWRecorder : NSObject
@property (nonatomic,weak) id<TWRecorderDelegate> delegate;
-(instancetype)init;
-(void)startRecord;
-(void)stopRecord;
@end
