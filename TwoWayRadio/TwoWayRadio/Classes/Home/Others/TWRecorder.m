//
//  TWRecorder.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/20.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWRecorder.h"
#import <Foundation/Foundation.h>
#import  <AVFoundation/AVFoundation.h>
#import  <AudioToolbox/AudioToolbox.h>
#import "HYOpenALHelper.h"


@import CoreFoundation;
#define kNumberAudioQueueBuffers 3  //定义了三个缓冲区
#define kDefaultBufferDurationSeconds 0.1279   //调整这个值使得录音的缓冲区大小为2048bytes
#define kDefaultSampleRate 8000   //定义采样率为8000

@interface TWRecorder()
{
    //音频输入队列
    AudioQueueRef _audioQueue;
    //音频输入数据format
    AudioStreamBasicDescription _recordFormat;
    //音频输入缓冲区
    AudioQueueBufferRef _audioBuffers[kNumberAudioQueueBuffers];
    
    //测试用例
//    long audioDataLength;
//    Byte audioByte[999999];//这个大小需不需要调整？
//    long audioDataIndex;
}
@property (nonatomic, assign) NSUInteger sampleRate;
@property (nonatomic, assign) double bufferDurationSeconds;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic,strong) HYOpenALHelper *pcmPlay;
@property (nonatomic,strong) TWAdpcm *adpcm;//录音时需要发送当前adpcm编码的adpcm_state，所以这里实例化了一个类

@end
@implementation TWRecorder

-(TWAdpcm *)adpcm
{
    if (_adpcm == nil) {
        struct adpcm_state initState = {0,0};
        _adpcm = [[TWAdpcm alloc]initWithBeforeAdpcmState:initState inputCurrentAdpcmState:initState decodeAdpcmState:initState];
    }
    return _adpcm;
}

-(instancetype)init
{
    TWRecorder *recorder = [super init];
    if (recorder) {
        //这里才是本身的初始化
        recorder.sampleRate = kDefaultSampleRate;
        recorder.bufferDurationSeconds = kDefaultBufferDurationSeconds;
        //设置录音的format数据
        [recorder setupAudioFormat:kAudioFormatLinearPCM SampleRate:(int)recorder.sampleRate];

    }


    
    return recorder;
}


// 设置录音格式
- (void)setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampeleRate
{
    //重置下
    memset(&_recordFormat, 0, sizeof(_recordFormat));
    
    //设置采样率，这里先获取系统默认的测试下 //TODO:
    //采样率的意思是每秒需要采集的帧数
    _recordFormat.mSampleRate = sampeleRate;//[[AVAudioSession sharedInstance] sampleRate];
    
    //设置通道数,这里先使用系统的测试下 //TODO:
    _recordFormat.mChannelsPerFrame = 1;//(UInt32)[[AVAudioSession sharedInstance] inputNumberOfChannels];
    
    //    NSLog(@"sampleRate:%f,通道数:%d",_recordFormat.mSampleRate,_recordFormat.mChannelsPerFrame);
    
    //设置format，怎么称呼不知道。
    _recordFormat.mFormatID = inFormatID;
    
    if (inFormatID == kAudioFormatLinearPCM){
        //这个屌属性不知道干啥的。，//要看看是不是这里属性设置问题
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目
        _recordFormat.mBitsPerChannel = 16;
        //结果分析: 8bit为1byte，即为1个通道里1帧需要采集2byte数据，再*通道数，即为所有通道采集的byte数目。
        //所以这里结果赋值给每帧需要采集的byte数目，然后这里的packet也等于一帧的数据。
        //至于为什么要这样。。。不知道。。。
        _recordFormat.mBytesPerPacket = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mFramesPerPacket = 1;
    }
}

//相当于中断服务函数，每次录取到音频数据就进入这个函数
//inAQ 是调用回调函数的音频队列
//inBuffer 是一个被音频队列填充新的音频数据的音频队列缓冲区，它包含了回调函数写入文件所需要的新数据
//inStartTime 是缓冲区中的一采样的参考时间，对于基本的录制，你的毁掉函数不会使用这个参数
//inNumPackets是inPacketDescs参数中包描述符（packet descriptions）的数量，如果你正在录制一个VBR(可变比特率（variable bitrate））格式, 音频队列将会提供这个参数给你的回调函数，这个参数可以让你传递给AudioFileWritePackets函数. CBR (常量比特率（constant bitrate）) 格式不使用包描述符。对于CBR录制，音频队列会设置这个参数并且将inPacketDescs这个参数设置为NULL，官方解释为The number of packets of audio data sent to the callback in the inBuffer parameter.
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    NSLog(@"we are in the 回调函数\n");
    TWRecorder *recorder = (__bridge TWRecorder*)inUserData;
    
    //NSLog(@"we are in inputBufferHandler\n");
    
    if (inNumPackets > 0) {
        //NSLog(@"maudioDataByteSize is %d\n",inBuffer->mAudioDataByteSize);
        
        //本地pcm播放，调用下面insertPCMDataToQueue语句，但是要先初始化pcmPLay
//        [pcmPlay insertPCMDataToQueue:(unsigned char *)inBuffer->mAudioData size:(UInt32)inBuffer->mAudioDataByteSize];
        
        //luo add
        NSLog(@"in the callback the current thread is %@\n",[NSThread currentThread]);
        [recorder processAudioBuffer:inBuffer withQueue:inAQ];
        //AudioQueueEnqueueBuffer(recorder.aqc.queue, inBuffer, 0, NULL);
    }
    
    if (recorder.isRecording) {
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

- (void) processAudioBuffer:(AudioQueueBufferRef)buffer withQueue:(AudioQueueRef) queue  //将缓冲区的代码复制到audioByte数组中
{
    //测试用例
//    memcpy(audioByte + audioDataIndex, buffer->mAudioData, buffer->mAudioDataByteSize);
//    audioDataIndex+=buffer->mAudioDataByteSize;
//    audioDataLength = audioDataIndex;
    
    NSLog(@"processAudioData :%u", (unsigned int)buffer->mAudioDataByteSize);
    
    //本地pcm播放，调用下面insertPCMDataToQueue语句，但是要先初始化pcmPLay
//    [_pcmPlay insertPCMDataToQueue:(unsigned char *)buffer->mAudioData size:(UInt32)buffer->mAudioDataByteSize];
    
    int8_t out[512];
    [self.adpcm setCurrentAdpcmState:_adpcm.beforeAdpcmState];
//    _adpcm.CurrentAdpcmState = _adpcm.beforeAdpcmState;
    
//    _adpcm.stateCoder = _stateadpcmCoder.stateCoder;
//    [adpcm setstateCoderindexandvalprev:stateadpcmCoder.stateCoder.index inputvalprev:stateadpcmCoder.stateCoder.valprev];
//    NSLog(@"before adpcm encoder is valprev:%d\n",adpcm.stateCoder.valprev);
//    NSLog(@"before adpcm encoder is index:%d\n",adpcm.stateCoder.index);
    
    //这里mAudioData的大小应该是之前设置了采集pcm为16bit，所以应该是short类型的数据
    //AFadpcm_coder算出来下一个stateCoder，保存在stateadpcmCoder
    [_adpcm AFadpcm_coder:(int16_t *)buffer->mAudioData outdata:out len:1024 state:(_adpcm.beforeAdpcmState)];
    //len is set to 1024 not the 2048;(int16_t *)buffer->mAudioData指定了buffer区被分为int16_t类型的数据
    NSLog(@"_adpcm.CurrentAdpcmState.valprev :%d",_adpcm.currentAdpcmState.valprev);
    NSLog(@"_adpcm.CurrentAdpcmState.index :%d",_adpcm.currentAdpcmState.index);
    if ([_delegate respondsToSelector:@selector(sendAudio: state:)]) {
        //发送out和stateCoder给服务器
        [_delegate sendAudio:out state:(struct adpcm_state)_adpcm.currentAdpcmState];
    }
   
    //[rtpAssociation sendAudio:out state:(__bridge Adpcm *)(&stateSend)];

    
}

-(void)startRecord
{
    
    _recordFormat.mSampleRate = self.sampleRate;
    
    //初始化adpcm、stateadpcmCoder
//    adpcm=[[Adpcm alloc]init:0 inputvalprev:0];
//    stateadpcmCoder=[[Adpcm alloc]init:0 inputvalprev:0];
    
    //初始化音频输入队列
    AudioQueueNewInput(&_recordFormat, inputBufferHandler, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue);//inputBufferHandler这个是回调函数名
    //AudioQueueNewInput(&_recordFormat, inputBufferHandler, NULL, NULL, NULL, 0, &_audioQueue);//inputBufferHandler这个是回调函数名
    //计算估算的缓存区大小
    int frames = (int)ceil(self.bufferDurationSeconds * _recordFormat.mSampleRate);//返回大于或者等于指定表达式的最小整数
    int bufferByteSize = frames * _recordFormat.mBytesPerFrame;//缓冲区大小在这里设置
    //NSLog(@"缓冲区大小:%d",bufferByteSize);
    
    
    
    
//    audioDataIndex=0;//将audioDataIndex清零后就解决延时问题了
//    //NSLog(@"sizeof the audioByte is %lu\n",sizeof(audioByte));
//    memset(audioByte, 0, sizeof(audioByte));//将audioByte清零,但是不知为何会有延时才会播放声音
    //创建缓冲器
    for (int i = 0; i < kNumberAudioQueueBuffers; i++){
        AudioQueueAllocateBuffer(_audioQueue, bufferByteSize, &_audioBuffers[i]);
        AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);//将 _audioBuffers[i]添加到队列中
    }
    
    // 开始录音
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    AudioQueueStart(_audioQueue, NULL);
    
    self.isRecording = YES;
//    self.rtpAssociation.isRecording=true;
    //NSLog(@"start recording\n");
}

-(void)stopRecord
{
    NSLog(@"stop recording out\n");//为什么没有显示
    if (self.isRecording)
    {
//        self.rtpAssociation.isRecording=false;
        self.isRecording = NO;
        NSLog(@"stop recording\n");
        //停止录音队列和移除缓冲区,以及关闭session，这里无需考虑成功与否
        AudioQueueStop(_audioQueue, true);
        AudioQueueDispose(_audioQueue, true);//移除缓冲区,true代表立即结束录制，false代表将缓冲区处理完再结束
        //[[[AVAudioSession sharedInstance] paste:&_audioQueue]]
        //[[AVAudioSession sharedInstance] setActive:NO error:nil];
        
        //[play Play:audioByte Length:audioDataLength];//在这里进行播放，就是录完一段音后进行播放
        
        //测试用例
//        _pcmPlay =  [[HYOpenALHelper alloc]init];
//        if (![_pcmPlay initOpenAL]) {
//            NSLog(@"error in the init");
//        }
//        [_pcmPlay insertPCMDataToQueue:audioByte size:audioDataLength];
//        [_pcmPlay TWinsertPCMDataToQueue:audioByte size:audioDataLength];
//        [_pcmPlay clean];
    }
    
    
}

-(void)dealloc
{
    DebugMethod();
}

@end
