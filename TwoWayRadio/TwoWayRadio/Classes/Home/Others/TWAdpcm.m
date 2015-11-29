//
//  TWAdpcm.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/22.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWAdpcm.h"

int indexTable[16] =
{
    -1, -1, -1, -1, 2, 4, 6, 8,
    -1, -1, -1, -1, 2, 4, 6, 8,
};

int stepsizeTable[89] =
{
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17,
    19, 21, 23, 25, 28, 31, 34, 37, 41, 45,
    50, 55, 60, 66, 73, 80, 88, 97, 107, 118,
    130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
    337, 371, 408, 449, 494, 544, 598, 658, 724, 796,
    876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,
    2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
    5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
    15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767
};



@interface TWAdpcm()
{
    
}

@end
@implementation TWAdpcm

//-(void)setStateCoder:(struct adpcm_state)stateCoder
//{
//    _stateCoder.valprev = stateCoder.valprev;
//    _stateCoder.index = stateCoder.index;
//}
//
//-(struct adpcm_state)stateCoder
//{
//    return _stateCoder;
//}


-(void)setBeforeAdpcmState:(struct adpcm_state)beforeAdpcmState
{
    _beforeAdpcmState.valprev = beforeAdpcmState.valprev;
    _beforeAdpcmState.index = beforeAdpcmState.index;
}

-(void)setCurrentAdpcmState:(struct adpcm_state)CurrentAdpcmState
{
    _currentAdpcmState.valprev = CurrentAdpcmState.valprev;
    _currentAdpcmState.index = CurrentAdpcmState.index;
}

-(void)setDecodeAdpcmState:(struct adpcm_state)decodeAdpcmState
{
    _decodeAdpcmState.valprev = decodeAdpcmState.valprev;
    _decodeAdpcmState.index = decodeAdpcmState.index;
}

-(instancetype)initWithBeforeAdpcmState:(struct adpcm_state)inputBeforeAdpcmState inputCurrentAdpcmState:(struct adpcm_state)inputCurrentAdpcmState decodeAdpcmState:(struct adpcm_state)decodeAdpcmState
{
    self =[super init];
    if(self)
    {
        _beforeAdpcmState.index=inputBeforeAdpcmState.index;
        _beforeAdpcmState.valprev=inputBeforeAdpcmState.valprev;
        
        _currentAdpcmState.index = inputCurrentAdpcmState.index;
        _currentAdpcmState.valprev = inputCurrentAdpcmState.valprev;
        
        _decodeAdpcmState.index  = decodeAdpcmState.index;
        _decodeAdpcmState.valprev  = decodeAdpcmState.valprev;
    }
//    _stateCoderAddress=&_stateCoder;
    return self;
}



-(char) AFadpcm_coder:(int16_t *)indata outdata:(int8_t *)outdata len:(int)len
                state:(struct adpcm_state)state
{
    //NSLog(@"We have in here\n");
    int16_t *inp;		/* Input buffer pointer */
    int8_t *outp;		/* Output buffer pointer */
    int val;			/* Current input sample value */
    int sign;			/* Current adpcm sign bit */
    int delta;			/* Current adpcm output value */
    int diff;			/* Difference between val and valprev */
    int step;			/* Stepsize */
    int valpred;		/* Predicted output value */
    int vpdiff;			/* Current change to valpred */
    int index;			/* Current step change index */
    int outputbuffer = 0;	/* place to keep previous 4-bit value */
    int bufferstep;		/* toggle between outputbuffer/output */
    
    char once = 0;
    char rc = 0;
    
    outp = outdata;
    inp = indata;
    
    valpred = state.valprev;
    index = state.index;
    NSLog(@" in coder valpred is %d\n",valpred);
    NSLog(@" in coder index is %d\n",index);
    step = stepsizeTable[index];
    
    bufferstep = 1;
    
    for ( ; len > 0 ; len-- ) {
        val = *inp++;
        
        /* Step 1 - compute difference with previous value */
        diff = val - valpred;
        sign = (diff < 0) ? 8 : 0;
        if ( sign ) diff = (-diff);
        
        /* Step 2 - Divide and clamp */
        /* Note:
         ** This code *approximately* computes:
         **    delta = diff*4/step;
         **    vpdiff = (delta+0.5)*step/4;
         ** but in shift step bits are dropped. The net result of this is
         ** that even if you have fast mul/div hardware you cannot put it to
         ** good use since the fixup would be too expensive.
         */
        delta = 0;
        vpdiff = (step >> 3);
        
        if ( diff >= step ) {
            delta = 4;
            diff -= step;
            vpdiff += step;
        }
        step >>= 1;
        if ( diff >= step  ) {
            delta |= 2;
            diff -= step;
            vpdiff += step;
        }
        step >>= 1;
        if ( diff >= step ) {
            delta |= 1;
            vpdiff += step;
        }
        
        /* Step 3 - Update previous value */
        if ( sign )
            valpred -= vpdiff;
        else
            valpred += vpdiff;
        
        /* Step 4 - Clamp previous value to 16 bits */
        if ( valpred > 32767 )
            valpred = 32767;
        else if ( valpred < -32768 )
            valpred = -32768;
        
        /* Step 5 - Assemble value, update index and step values */
        delta |= sign;
        
        index += indexTable[delta];
        if ( index < 0 ) index = 0;
        if ( index > 88 ) index = 88;
        
        if (once == 0)
        {
            rc = index;
            once = 1;
        }
        
        step = stepsizeTable[index];
        
        /* Step 6 - Output value */
        if ( bufferstep ) {
            outputbuffer = delta & 0x0f;
        } else {
            *outp++ = ((delta << 4) & 0xf0) | outputbuffer;
        }
        bufferstep = !bufferstep;
    }
    
    /* Output last step, if needed */
    if ( !bufferstep )
        *outp++ = outputbuffer;
    
    _beforeAdpcmState.valprev = valpred;
    _beforeAdpcmState.index = index;
//    state->valprev = valpred;
//    state->index = index;
    
    return rc;
    
}


-(void)AFadpcm_decoder:(int8_t *)indata outdata:(int16_t *)outdata len:(int)len
                 state:(struct adpcm_state)state
{
    int8_t *inp;		/* Input buffer pointer */
    int16_t *outp;		/* output buffer pointer */
    int sign;			/* Current adpcm sign bit */
    int delta;			/* Current adpcm output value */
    int step;			/* Stepsize */
    int valpred;		/* Predicted value */
    int vpdiff;			/* Current change to valpred */
    int index;			/* Current step change index */
    int inputbuffer = 0;		/* place to keep next 4-bit value */
    int bufferstep;		/* toggle between inputbuffer/input */
    
    outp = outdata;
    inp = indata;
    
    valpred = state.valprev;//修改过后的
    index = state.index;
    //valpred = (uint16_t)state.valprev;//原本觉得这里是接收有问题的bug所在，但是测试过后效果一样？？
    //index = (uint8_t)state.index;
    step = stepsizeTable[index];
    
    NSLog(@"in decoder the valpred is %d",valpred);
    NSLog(@"in decoder the index is %d",index);
    
    bufferstep = 0;
    
    for ( ; len > 0 ; len-- ) {
        
        /* Step 1 - get the delta value */
        if ( bufferstep ) {
            delta = (inputbuffer >> 4) & 0xf;
        } else {
            inputbuffer = *inp++;
            delta = inputbuffer & 0xf;
        }
        bufferstep = !bufferstep;
        
        /* Step 2 - Find new index value (for later) */
        index += indexTable[delta];
        if ( index < 0 ) index = 0;
        if ( index > 88 ) index = 88;
        
        /* Step 3 - Separate sign and magnitude */
        sign = delta & 8;
        delta = delta & 7;
        
        /* Step 4 - Compute difference and new predicted value */
        /*
         ** Computes 'vpdiff = (delta+0.5)*step/4', but see comment
         ** in adpcm_coder.
         */
        vpdiff = step >> 3;
        if ( delta & 4 ) vpdiff += step;
        if ( delta & 2 ) vpdiff += step>>1;
        if ( delta & 1 ) vpdiff += step>>2;
        
        if ( sign )
            valpred -= vpdiff;
        else
            valpred += vpdiff;
        
        /* Step 5 - clamp output value */
        if ( valpred > 32767 )
            valpred = 32767;
        else if ( valpred < -32768 )
            valpred = -32768;
        
        /* Step 6 - Update step value */
        step = stepsizeTable[index];
        
        /* Step 7 - Output value */
        *outp++ = valpred;
        
    }
    
    state.valprev = valpred;
    state.index = index;
}

-(void)dealloc
{
    DebugMethod();
}

@end
