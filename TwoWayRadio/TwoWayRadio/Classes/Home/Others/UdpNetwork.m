//
//  UdpNetwork.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/21.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "UdpNetwork.h"
#import "GCDAsyncUdpSocket.h"
#import "TWRecorder.h"
#import "HYOpenALHelper.h"
#import "TWAdpcm.h"
#import "MSWeakTimer.h"
#define NMCP_VERSION 1  //版本为1
#define SubP_ID 2
#define TWtransaction(transactionID) ((transactionID) & 0x000000ff),((transactionID) >> 8) & 0x000000ff,((transactionID) >> 16) & 0x000000ff,((transactionID) >> 24) & 0x000000ff
#define AUDIO_DATA_HEAD_LENGTH 84


typedef struct
{
    uint8_t version:4;
    uint8_t subP_ID:4;
    uint8_t descrip;
    uint16_t length;
    uint32_t transactionID;
}NMCP_HEAD;


@interface UdpNetwork()<GCDAsyncUdpSocketDelegate,TWRecorderDelegate>
{
    __block int8_t buf[2048];
    uint8_t *bufpoint;
    __block uint32_t connecttag;
    int8_t audio[512];
    int16_t receiveBuf[1024];
}

@property (nonatomic,strong) GCDAsyncUdpSocket *socket;
@property (nonatomic,assign) NMCP_HEAD nmcp_hd;
@property (nonatomic,strong) NSData *sendData;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) uint32_t port;
@property (nonatomic,strong) TWRecorder *recorder;
@property (nonatomic,strong) HYOpenALHelper *playPcmData;
@property (nonatomic,strong) TWAdpcm *receiveAdpcm;

@property (nonatomic,copy) NSString * account;
@property (nonatomic,copy) NSString * passwd;
@property (nonatomic,copy) NSString * serverIp;
@property (nonatomic,assign) int * serverPort;
@property (nonatomic,strong) MSWeakTimer *repeatTime;
@property (nonatomic,assign) BOOL isChangeConectState;
@property (nonatomic,assign) BOOL isWorking;
//表示即将是第一次接收语音状态
@property (nonatomic,assign) BOOL isFirstRecvAudio;

@end

@implementation UdpNetwork

-(HYOpenALHelper *)playPcmData
{
    if (_playPcmData == nil) {
        _playPcmData =  [[HYOpenALHelper alloc]init];
        if (_playPcmData != nil) {
            if(![_playPcmData initOpenAL])
            {
                NSLog(@"error in the initOpenal");
            }
        }
    }
    return _playPcmData;
}

-(TWAdpcm *)receiveAdpcm
{
    if (_receiveAdpcm == nil) {
        NSLog(@"I alloc the adpcm in here");
        struct adpcm_state initState = {0,0};
        _receiveAdpcm = [[TWAdpcm alloc]initWithBeforeAdpcmState:initState inputCurrentAdpcmState:initState decodeAdpcmState:initState];
    }
    return _receiveAdpcm;
}

-(TWRecorder *)recorder
{
    if (_recorder == nil) {
        _recorder = [[TWRecorder alloc]init];
        _recorder.delegate =self;
    }
    NSLog(@"%s", __func__);
    return _recorder;
}


-(instancetype)initWithAddress:(NSString *)address port:(uint32_t)port
{
    if( self = [super init])
    {
        NSLog(@"We are in initWithAddress\n");
        
        _connectSuccessful = NO;
        _isWorking = NO;
        _isFirstRecvAudio = YES;
        _isChangeConectState = NO;
        //2015.10.11 将queue调整为串行线程，即解决了播放卡顿的问题
        dispatch_queue_t netWorkQueue =  dispatch_queue_create("netWorkQueue", NULL);
        _socket  = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:netWorkQueue];

        _address = address;
        _port = port;
        
        NSError *error = nil;
        if(![_socket bindToPort:_port error:&error])//绑定端口
        {
            NSLog(@"error in bindToPort");
            //return;
        }
        
        NSError *receiveOnceError = nil;
//        if(![_socket beginReceiving:&error])//异步接收
        if(![_socket receiveOnce:&receiveOnceError])//仅接收一次数据
        {
            NSLog(@"error in receiveOnce\n");
        }
    
    }
    
    
    return self;

}






-(void)socketBeginRuning
{
    memset(&_nmcp_hd, 0, sizeof(_nmcp_hd));//对nmcp_hd清零
    
    _nmcp_hd.version = NMCP_VERSION;//定义nmcp_hd结构体
    _nmcp_hd.subP_ID = SubP_ID;
    _nmcp_hd.length = 0 ;
    _nmcp_hd.descrip=1;
    _nmcp_hd.transactionID=1;
    
    memcpy(buf, &_nmcp_hd, sizeof(_nmcp_hd));
    _sendData =  [NSData dataWithBytes:buf length:8];
    //设置5s为超时时间
    [_socket sendData:_sendData toHost:_address port:_port withTimeout:2.0 tag:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(requestTimeOut) withObject:@"timeOut" afterDelay:TWTimeOut];
    });

}


-(void)requestTimeOut
{
    NSLog(@"%s",__func__);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_timeOut" object:nil userInfo:nil];
    
}
#pragma mark - Network callback 回调函数
#pragma mark -回调函数
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSError *error = nil;
    //                    if(![_socket beginReceiving:&error])//这是设置开始不断接收模式
    if(![_socket receiveOnce:&error])
    {
        NSLog(@"error in beginReceiving\n");
    }
    bufpoint=(uint8_t *)[data bytes];//将收到的数据缓存在bufpoint

    switch (*(bufpoint+0))
    {
        case 0x21:
//            NSLog(@"receive the 0x21\n");
            if (*(bufpoint+1) != 0x09 && *(bufpoint+1) != 0x07 && *(bufpoint+1) != 0x08)//第一个进入的是登陆，所以不能是第二个字节不能是0x07，0x08，0x09；
            {
                //收到第一个包的回应的话，说明网络是通的，取消timeout的执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeOut) object:@"timeOut"];
                });
                //第三个步骤
                //接收到transactionID，在这里设置transactionID
                _nmcp_hd.transactionID = [self bytesToInt:bufpoint offset:8];
                //NSLog(@"recieve the CONN_CONNECT\n");
                //NSLog(@"nmcp_hd.TransactionID is %u\n",nmcp_hd.TransactionID);
                uint8_t data1[] =
                {
                    0x51, 0x00,0x30,0x00,TWtransaction(_nmcp_hd.transactionID), 0x01, 0x00, 0x28, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x24, 0x00,
                    
                    0x61, 0x64, 0x6D, 0x69, 0x6E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                    0x21, 0x23, 0x2F,0x29, 0x7A, 0x57, 0xA5, 0xA7,0x43,0x89, 0x4A,
                    0x0E, 0x4A, 0x80, 0x1F,0xC3
                    
                };

                NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
                _account = [userDefaults stringForKey:@"account"];
                _passwd =  [userDefaults stringForKey:@"passwd"];
                if (_account != nil) {
                    NSData *accountData  =  [_account dataUsingEncoding:NSUTF8StringEncoding];
                    Byte *accountByte = (Byte *)[accountData bytes];

                     memcpy(data1 + 20,accountByte,20);
                }
               
                
                [self sendWithData:data1 dataLength:sizeof(data1) address:address];

//                NSLog(@"send the 3th:login\n");
                
            }
            else if(*(bufpoint+1) == 0x08)//这里进入的是收到心跳包的回应
            {
                connecttag--;
                if (connecttag==1 || connecttag==-1)//if connecttag is 1,就是说第一次发心跳包没接收到，但第二次发送时收到回应了，这时我需要重新置connecttag为0
                {
                    connecttag=0;
                }
            }
            else
                ;
            break;
            
        case 0x51:
            //NSLog(@"bufpoint[1] is %x\n",*(bufpoint+1));
            if (*(bufpoint+2)==0x90)    //因为这里服务器发送过来两次，所以如果不加这个的话就会发送两次,但是发现邦仁文档里面的第二个参数也就是descrip会变化，但我想第三个参数length应该不会变，暂时用第三个
            {
                //接下来是第五个步骤
                if (_account != nil) {
                    Byte errorLog[] =  {0x00,0x00,0x00,0x00,0x01,0x00,0x04,0x00};
                    
#warning //如果与上述错误标志位相同，则说明账户或者密码错误，则不必要继续下一步了！
                    
                    if(!memcmp(bufpoint + 16, errorLog, 8))
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showError:@"账号或者密码错误，请重新登录"];
                        });
//                        NSLog(@"error in the 账号或者密码");
                        _connectSuccessful = NO;
                        
                        return;
                    }
                    else
                    {
                        NSLog(@"账号和密码正确");
                    }
                    
                }

            
                //NSLog(@"recieve the 5th\n");
                uint8_t data2[] =
                {
                    0xb1,*(bufpoint+1),0x08,0x00, TWtransaction(_nmcp_hd.transactionID), 0x01, 0x00,0x88,0x00,*(bufpoint+12),0x00,0x00,0x00
                };//*(bufpoint+1)有修改,但这应该不是必须的
                
                [self sendWithData:data2 dataLength:sizeof(data2) address:address];


                // NSLog(@"send the 6th\n");
                
                //接下来是第七个步骤
                (*(bufpoint+12))++;//Tid需要在这里自加1，但应该也不是必需的
                
                uint8_t data3[] =
                {
                    0x51, 0x00,0x14,0x00, TWtransaction(_nmcp_hd.transactionID),
                    0xc8, 0x00,0x0c,0x00,*(bufpoint+12),0x00,0x00,0x00,
                    0xc8,0x00,0x08,0x00,
                    0x01,0x00,0x00,0x00,0x00,0x00,0x01,0x00
                };
                [self sendWithData:data3 dataLength:sizeof(data3) address:address];

                //NSLog(@"send the 7th\n");

                
            }
            else if (*(bufpoint+1)==0x00 || *(bufpoint +1) ==  0x58)
            {
                
                if (*(bufpoint+12)==0x02)
                {
                    //NSLog(@"recieve the 10th\n");
                    uint8_t data4[] =
                    {
                        0xB1, 0x00, 0x08, 0x00,TWtransaction(_nmcp_hd.transactionID),
                        0xC8, 0x00, 0x08, 0x00, *(bufpoint+12), 0x00, 0x00, 0x00
                    };
                    [self sendWithData:data4 dataLength:sizeof(data4) address:address];

                    //NSLog(@"send the 11th\n");
                    
                    (*(bufpoint+12))++;//Tid需要在这里自加1，但应该也不是必需的
                    uint8_t data5[] =
                    {
                        0x51, 0x00, 0x14, 0x00,TWtransaction(_nmcp_hd.transactionID), 0x36,
                        0x00, 0x0C, 0x00, *(bufpoint+12), 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        0x00, 0xBC,0x82, 0xF9, 0x54, 0x00, 0x00, 0x00, 0x00                    };
                    
                    [self sendWithData:data5 dataLength:sizeof(data5) address:address];

//                     NSLog(@"send the 12th\n");
                }
                else if(*(bufpoint+12)==0x03)
                {
//                    NSLog(@"recieve the 14th\n");
                    uint8_t data6[] =
                    {
                        0xB1, 0x00, 0x08, 0x00, TWtransaction(_nmcp_hd.transactionID),
                        0x36, 0x00, 0x08, 0x00, *(bufpoint+12), 0x00, 0x00, 0x00                    };
                    [self sendWithData:data6 dataLength:sizeof(data6) address:address];
                    //NSLog(@"send the 15th\n");
                    
                    (*(bufpoint+12))++;//Tid需要在这里自加1，但应该也不是必需的
                    
                    uint8_t data7[] =
                    {
                        0x51 ,0x00 ,0x14 ,0x00, TWtransaction(_nmcp_hd.transactionID),
                        0xC8 ,0x00 ,0x0C ,0x00 ,*(bufpoint+12) ,0x00 ,0x00 ,0x00 ,
                        0xC8 ,0x00 ,0x08 ,0x00 ,0x01 ,0x00 ,0x00 ,0x00 ,0x02 ,0x03 ,0x01,0x00                 };
                    [self sendWithData:data7 dataLength:sizeof(data7) address:address];

                    //NSLog(@"send the 16th\n");
                    
                }
                else
                    ;
                
                
            }
            else
                ;
            break;
            
        case 0xb1:
//            NSLog(@"we are recieve 0xb1\n");
            //NSError *error = nil;
            if(![_socket beginReceiving:nil])
                //if(![udpSocket receiveOnce:nil])
            {
                NSLog(@"error in beginReceiving\n");
            }
            //取消isFirst的判断,2015.10.04
            if (*(bufpoint+12)==0x04 )//表明已经进入到17阶段了，则已经成功了，这是如果是isFirst，则开始发送心跳包
            {
                _connectSuccessful = true;//it means coonnect successfully
                _isChangeConectState = true;
                connecttag=0;
                NSLog(@"connect successfully");
                //如果能够进入这里，说明已经连接成功
                NSString *connectStatus = @"true";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendConnectStatus" object:connectStatus];
                //发送连接成功的消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"connectSuccessfully" object:nil];
                _isChangeConectState = false;
                //NSLog(@"after the (*(bufpoint+12)==0x04) current thread is %@\n",[NSThread currentThread]);
#warning 这里应该有循环引用的问题
//                __weak typeof(self) weakSelf= self;
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//                    if (weakSelf) {
//                        if (_connectSuccessful) {
////                            __strong typeof(self) strongSelf = weakSelf;
//                            NSTimer * repeatTime = [NSTimer scheduledTimerWithTimeInterval:5.0 target:weakSelf selector:@selector(sendHeart) userInfo:nil repeats:YES];
//                            _repeatTime = repeatTime;
////                            [[NSRunLoop currentRunLoop] addTimer:_repeatTime forMode:NSDefaultRunLoopMode];//添加timer加入到当前线程的runloop中，timer才能在该线程生效
//                            [[NSRunLoop currentRunLoop] run];
//                        } else {
//                            if (_repeatTime != nil) {
//                                [_repeatTime invalidate];
//                                _repeatTime = nil;
//                            }
//                        }
//
//                    }
//
//                });
                
                
                
                //调用MSWeakTimer开源库，这样内存不泄露，可以释放本类了
                self.repeatTime = [MSWeakTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(sendHeart) userInfo:self repeats:YES dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            }
            
            break;
        case 0x41:
            //NSLog(@"we are recieve 0x41\n");
            // NSError *error = nil;
            //if(![udpSocket beginReceiving:&error])
//            if(![_socket receiveOnce:nil])
//                NSLog(@"error in beginReceiving\n");
            
            break;
        case 0x31://表示接收到音频数据了
        {
            NSLog(@"recieve the audio");
            if (_isFirstRecvAudio) {
                NSString *isworking = @"true";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_didRecvAllAudio" object:isworking];
            }
            _isFirstRecvAudio = NO;
//            处理音频数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didRecvAllAudio) object:@"didRecvAllAudio"];
            });
            
            _isWorking = YES;
//            @synchronized(self) { //不能够加上这句，要不然会出现中断的情况
                //处理音频数据
                [self handlerReceiveAudio];
                
                //            [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
                //            [[AVAudioSession sharedInstance] setActive:YES error:nil];
                
                //开始解码
                memset(receiveBuf, 0, sizeof(receiveBuf));
                [self.receiveAdpcm AFadpcm_decoder:(int8_t *)audio outdata:receiveBuf len:1024 state:_receiveAdpcm.decodeAdpcmState];
                NSLog(@"sizeof receive is %lu",sizeof(receiveBuf));
                
                //            [self.play insertPCMDataToQueue:(uint8_t *)receiveBuf size:2048];//这里存在变量类型不符的问题
                
                //            uint8_t *Pcmdata = (uint8_t *)malloc(sizeof(receiveBuf));
                //            if (Pcmdata == NULL) {
                //                NSLog(@"error in the malloc");
                //                return;
                //            }
                //            NSLog(@"%lu",sizeof(receiveBuf));
                //            memcpy(Pcmdata,receiveBuf,sizeof(receiveBuf));
                //如果出错这里self.playPcmData会置为空
                //            [[HYOpenALHelper sharedInstance] TWinsertPCMDataToQueue:receiveBuf size:sizeof(receiveBuf)];
                
                //            NSLog(@"sizeof(Pcmdata) %lu",sizeof(Pcmdata));
                //            [self.playPcmData insertPCMDataToQueue:Pcmdata size:2048];
                [self.playPcmData insertPCMDataToQueue:(uint8_t *)receiveBuf size:2048];

//            }
            
//            [self.play Play:(Byte *)receiveBuf Length:sizeof(receiveBuf)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(didRecvAllAudio) withObject:@"didRecvAllAudio" afterDelay:0.5];
            });
        }
            break;
        default:
            break;
            
    }
    

}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    
}

//超过两秒钟还未接收到语音时调用
-(void)didRecvAllAudio
{
    _isWorking = NO;
    NSString *isworking = @"false";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_didRecvAllAudio" object:isworking];
    _isFirstRecvAudio = YES;
    [_playPcmData clean];
    _playPcmData  = nil;
    
}


//-(BOOL)returnConnectSuccessful
//{
//    NSLog(@"_connectSuccessful is %d",_connectSuccessful);
//    return _connectSuccessful;
//}
-(void)handlerReceiveAudio   //收到音频，进行处理
{
//    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"%s",__func__);
    memset(audio, 0, sizeof(audio));//先清零
    memcpy(audio, bufpoint+AUDIO_DATA_HEAD_LENGTH, 512);//将收到的音频数据解析到audio数组
    if(_receiveAdpcm != nil)
    {
        // [receiveState setstateCoderindexandvalprev:(uint8_t)*(bufpoint+78) inputvalprev:(uint16_t)*(bufpoint+76)];//2015.08.18删除此处，但测试效果依然不佳
        short valprev=(short)((*(bufpoint+76) & 0xff) | ((*(bufpoint+77)<<8) & 0xff));
        struct adpcm_state recieveAdpcm={valprev,(int8_t)*(bufpoint+78)};
        NSLog(@"recieveAdpcm.valprev,recieveAdpcm.index %d,%d",recieveAdpcm.valprev,recieveAdpcm.index);
//        [_receiveAdpcm setCurrentAdpcmState:recieveAdpcm];
        [_receiveAdpcm setDecodeAdpcmState:recieveAdpcm];
//        [_receiveAdpcm setstateCoderindexandvalprev:(int8_t)*(bufpoint+78) inputvalprev:(short)valprev];
        //NSLog(@"bufpoint:index is %d\n",*(bufpoint+76));
        //NSLog(@"bufpoint:valprev is %d\n",*(bufpoint+78));
    }
    
    
}

-(void)sendWithData:(uint8_t *)data dataLength:(int)dataLength address:(NSData *)address
{
    
    memset(buf, 0, sizeof(buf));//将buf清零
    memcpy(buf, data, dataLength);//将data1复制进buf的前sizeof(data1)字节
    _sendData=[NSData dataWithBytes:buf length:dataLength];//注意，这里送入的length:sizeof(data1)
    [_socket sendData:_sendData toAddress:address withTimeout:-1 tag:0];
}


-(void)sendHeart
{
    if (_isWorking ==  NO) {
        if (connecttag>=2)
        {
            //if connecttag is not the 0,it means connect have fail,we should connect again;
            _connectSuccessful=false;
            _isChangeConectState = true;
            NSString *connectStatus = @"false";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendConnectStatus" object:connectStatus];
            connecttag=0;
        }
        if (_connectSuccessful && (connecttag<=1))//when the connectSuccessful is true and the connecttag is 0 it means we already can send the heart package;
        {
            
            uint8_t data8[] =
            {
                0x21 ,0x07 ,0x00 ,0x00, TWtransaction(_nmcp_hd.transactionID)
            };//心跳包
            
            memset(&buf, 0, sizeof(buf));
            memcpy(buf, data8, sizeof(data8));
            NSData * heartData=[NSData dataWithBytes:buf length:sizeof(data8)];
            [_socket sendData:heartData toHost:_address port:_port withTimeout:-1 tag:0];
            //        [self sendWithData:data8 dataLength:sizeof(data8) address:[_address dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"sending the heartBeat\n");
            connecttag ++;
        }
        else
        {
            if (connecttag<2 )
                connecttag++;
            NSLog(@"we don's send the heart\n");
            
            [_repeatTime invalidate];
            _repeatTime = nil;
            
        }

    }

    
}


-(uint8_t) bytesToInt:(uint8_t *)inputBuf offset:(int)offset
{
    return (inputBuf[offset] & 0xff)
    | ( inputBuf[offset+1] & 0xff )<<8
    | ( inputBuf[offset+2] & 0xff )<<16
    | ( inputBuf[offset+3] & 0xff )<<24;
    
}



-(void)beginSendRecord
{
//    _recorder;
//    [[HYOpenALHelper sharedInstance] clean];
    [self.recorder startRecord];
    _isWorking = YES;
}


-(void)stopSendRecord
{
    [_recorder stopRecord];
    _recorder = nil;
    _isWorking = NO;
    
}




-(void)disconect
{
    [_repeatTime invalidate];
    _repeatTime = nil;
    
//    _connectSuccessful = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendConnectStatus" object:nil];
}

//客户端发送三次退出对讲系统信号
-(void)sendExitMassage
{
    NSLog(@"%s",__func__);
#warning 停止音频传输,但目前我直接用下面的21连接直接关闭了
//        uint8_t data9[] =
//        {
//            0x51 ,0x00 ,0x14 ,0x00, TWtransaction(_nmcp_hd.transactionID),
//            0XC8,0X00,0X0C,0X00, //command head
//            0X04,0X00,0X00,0X00,// Tid
//            0XC8,0X00,0X08,0X00,//common request
//            0X00,0X00,0X00,0X00,//接下来的 8 字节表示控制数据流的开始与关闭命令
//            0X00,0X00,0X00,0X00
//        };
//        
//        memset(&buf, 0, sizeof(buf));
//        memcpy(buf, data9, sizeof(data9));
//        NSData * heartData=[NSData dataWithBytes:buf length:sizeof(data9)];
//        [_socket sendData:heartData toHost:_address port:_port withTimeout:-1 tag:0];
    
    //停止音频传输
    uint8_t data10[] =
    {
        0x21 ,0x09 ,0x00 ,0x00, TWtransaction(_nmcp_hd.transactionID)
    };
    
    memset(&buf, 0, sizeof(buf));
    memcpy(buf, data10, sizeof(data10));
    NSData * endData=[NSData dataWithBytes:buf length:sizeof(data10)];
    [_socket sendData:endData toHost:_address port:_port withTimeout:-1 tag:0];


}

#pragma mark -发送音频数据代理方法
-(void)sendAudio:(int8_t *)out state:(struct adpcm_state)state
{
    if (_connectSuccessful)//判断成功才进行下一步的发送音频
    {
        int     length = 512;
        
        int8_t buffer[596] = {0};//is int8_t or uint8_t ?
        memset(buffer, 0, sizeof(int8_t));
        
        uint8_t head[] =
        {
            0x31,0xc6,0x4c,0x2,TWtransaction(_nmcp_hd.transactionID),
            0x2,0x4,0xc,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1,0xc0,0x2,0x3a,0x87,0xc0,0x17,
            0x37,0x23,0x67,0xb3,0x61,0x17,0x23,0x67,0xb3,0x61,0xf,0x8b,0x80,0xa,0x0,0x80,0xa,
            0x0,0x0,0xff,0xff,0x0,0xff,0xff,0xff,0xff,0xff,0xff,
            0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
            0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0x50,0x1,0x20,0xff,0xff,0xff,0xff,0xff
        };//siziof the head is 84
        
        //  NSLog(@"sizeof the head is %d\n",sizeof(head));
        //NSLog(@"rtp:nmcp_hd.TransactionID is %u\n",nmcp_hd.TransactionID);
        
        memcpy(buffer, head, sizeof(head));//将head复制进buffer数组
        for (int i=0; i<length; i++) {
            buffer[i+AUDIO_DATA_HEAD_LENGTH]=out[i];
            //NSLog(@"data %d is %d\n",i,data[i]);
        }
        
        
        buffer[76]=(int8_t)(state.valprev & 0x00ff);//我以前是写着uint8_t，0702修改过来了
        buffer[77]=(int8_t)((state.valprev & 0xff00)>>8);
        buffer[78]=(int8_t)state.index;
        // NSLog(@"state->valprev is %d\n",statestate.valprev);
        // NSLog(@"state->index is %d\n",statestate.index);
        NSLog(@" buffer[76] is %d\n",buffer[76]);
        NSLog(@" buffer[77] is %d\n",buffer[77]);
        NSLog(@" buffer[78] is %u\n",buffer[78]);
        // NSLog(@"siziof of the buffer is %lu\n",sizeof(buffer));
        
        NSData * sendData=[NSData dataWithBytes:buffer length:sizeof(buffer)];//转换成data格式，以便通过udp发送出去
        
        //NSLog(@"serviceAddress is %@\n",serviceAddress);
        //NSLog(@"port is %d\n",servicePort);
        //NSLog(@"before\n");
        //NSLog(@"before the sendAudio the current thread is %@\n",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];//这里我延时了0.1ms，解决了会出现断断续续的为问题；
        [_socket sendData:sendData toHost:_address port:_port withTimeout:-1 tag:0];
        //NSLog(@"we are in the rtp\n");
        // NSLog(@"sendAudio当前线程是：%@\n",[NSThread currentThread]);
        
        //NSLog(@"sendData is :%@\n",sendData);
    }
    else    //尚未连接成功
    {
        NSLog(@"connect is not successful,connect again\n");
        
    }
    //    [_play insertPCMDataToQueue:(unsigned char *)out size:2048];
    
}


-(void)dealloc
{
    NSLog(@"%s",__func__);

    [_socket close];
    _socket= nil;
//    [_playPcmData clean];
//    _playPcmData  = nil;
    _receiveAdpcm = nil;
}


@end
