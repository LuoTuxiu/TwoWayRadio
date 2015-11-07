//
//  TWAdpcm.h
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/22.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import <Foundation/Foundation.h>
struct adpcm_state {
    short	valprev;	/* Previous output value */
    char	index;		/* Index into stepsize table */
};
@interface TWAdpcm : NSObject
@property (nonatomic,assign) struct adpcm_state currentAdpcmState;
@property (nonatomic,assign) struct adpcm_state beforeAdpcmState;
@property (nonatomic,assign) struct adpcm_state decodeAdpcmState;
-(instancetype)initWithBeforeAdpcmState:(struct adpcm_state)inputBeforeAdpcmState inputCurrentAdpcmState:(struct adpcm_state)inputCurrentAdpcmState decodeAdpcmState:(struct adpcm_state)decodeAdpcmState;
-(char) AFadpcm_coder:(int16_t *)indata outdata:(int8_t *)outdata len:(int)len
                state:(struct adpcm_state)state;
-(void)AFadpcm_decoder:(int8_t *)indata outdata:(int16_t *)outdata len:(int)len
                 state:(struct adpcm_state)state;
@end
