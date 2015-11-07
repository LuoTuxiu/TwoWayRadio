//
//  TWAudioSession.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/9.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWAudioSession.h"

@implementation TWAudioSession
-(instancetype)init
{
    self = [super init];  // Call a designated initializer here.
    if (self != nil) {
        // 省略其他细节
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
        {
            NSLog(@"Error creating session: %@", [sessionError description]);
        }
        else
        {
            //当没有接入任何音频设备时，一般情况下声音会默认从扬声器出来，但有一个例外的情况：在PlayAndRecord这个category下，听筒会成为默认的输出设备。如果你想要改变这个行为，可以提供MPVolumeView来让用户切换到扬声器，也可通过overrideOutputAudioPort方法来programmingly切换到扬声器，也可以修改category option为AVAudioSessionCategoryOptionDefaultToSpeaker。
            //设置默认输出至扬声器
            [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
            NSError *sessionSetActiveError=nil;
            [session setActive:YES error:&sessionSetActiveError];
            if (sessionSetActiveError != nil) {
                NSLog(@"error in the sessionSetActiveError");
            }
            
        }
        
        
    }
    return self;

}
@end
