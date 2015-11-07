//
//  HomeViewController.m
//  TwoWayRadio
//
//  Created by 徐磊 on 15/9/20.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "HomeViewController.h"
#import "UdpNetwork.h"
#import "TWRadioView.h"
#import "TWRadioButton.h"
#import "TWStatusView.h"
#import "TWAudioSession.h"
#import "TWtabBarController.h"
@interface HomeViewController()

@property (nonatomic,strong) UdpNetwork *netWork;
@property (nonatomic,strong) TWRadioView *radioView;
@property (nonatomic,strong) TWRadioButton *radioBtn;
@property (nonatomic,strong) TWStatusView *statusView;
@property (nonatomic,copy) NSString * serverIp;
@property (nonatomic,copy) NSString * serverPort;
@property (nonatomic,copy) NSString * account;
@property (nonatomic,copy) NSString * passwd;
@property (nonatomic,strong) TWAudioSession *session;

@property (nonatomic,copy) NSString * saveConnectStatus;
@end
@implementation HomeViewController

#pragma mark 懒加载
-(UdpNetwork *)netWork
{
    if (_netWork == nil) {
        NSLog(@"I alloc the _netWork here");
        
        //执行一次信息有效性判断，包括账号、密码、服务器地址、服务器端口
        NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
        _serverIp = [userDefaults stringForKey:@"serverIp"];
        _serverPort =  [userDefaults stringForKey:@"serverPort"];
        _account = [userDefaults stringForKey:@"account"];
        _passwd =  [userDefaults stringForKey:@"passwd"];
        if (_account ==  nil || _passwd == nil) {
//            [MBProgressHUD showError:@"您未登陆账号和密码"];
            return nil;
        }
        if (_serverPort ==  nil || _serverIp == nil) {
//            [MBProgressHUD showError:@"您未设置服务器地址和端口"];
            return nil;
        }
        
        _netWork = [[UdpNetwork alloc] initWithAddress:_serverIp port:(uint32_t)[_serverPort integerValue]];
//            [_netWork socketBeginRuning];
//        _netWork = [[UdpNetwork alloc] initWithAddress:@"192.168.1.150" port:3301];
        
    }
    return _netWork;
}

-(TWRadioView *)radioView
{
    
    if (_radioView == nil) {
//        NSLog(@"I alloc the _radioView here");
        CGFloat radioViewX = self.view.frame.origin.x;
        CGFloat radioViewY = self.view.frame.origin.y;
        CGFloat radioViewW = self.view.frame.size.width;
        CGFloat radioViewH = self.view.frame.size.height;
        CGRect radioViewOfFrame = CGRectMake(radioViewX, radioViewY, radioViewW, radioViewH);
        _radioView = [[TWRadioView alloc] initWithFrame:radioViewOfFrame];
        
    }
    return _radioView;
}

-(TWStatusView *)statusView
{
    
    if (_statusView == nil) {
        
        CGFloat statusViewY = rectNav.size.height + rectStatus.size.height;
        CGRect statusViewFrame =  CGRectMake(0, statusViewY, TWmainScreenFrame.size.width, 80);
        _statusView = [[TWStatusView alloc] initWithFrame:statusViewFrame];
        
    }
    return _statusView;
}

#pragma mark 系统默认函数
-(void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    //打印当前版本
    
//    NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    //设置主页背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor  = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:235.0/255.0f alpha:1.0];
    
    

    
    //添加一个自定义视图：旋转按钮
    self.radioView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.radioView];
    


    //添加状态视图到主视图
    [self.view addSubview:self.statusView];

    
    //添加按钮到主视图
    [self addRadiobtn];
    
//    [self.radioBtn.layer addSublayer:self.radioView.layer];


    //先更新一次视图

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchLog) name:@"Notification_log" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkConnectStatus:) name:@"sendConnectStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchConnect) name:@"Notification_touchConnect" object:nil];
    
    //添加连接超时的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeOut) name:@"Notification_timeOut" object:nil];
    
    //添加接收语音结束的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecvAllAudio:) name:@"Notification_didRecvAllAudio" object:nil];
    
//
    self.session  = [[TWAudioSession alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
//    [self checkConnectStatus];
    NSLog(@"%s",__func__);
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
}


//接收语音结束的回调
-(void)didRecvAllAudio:(NSNotification *)notification
{
    NSString *recv = [notification object];
    if ([recv isEqualToString:@"true"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = @"正在对讲";
            //接收语音逆时针转动
            [self animationBeginWithIsClockwise:false];
            _radioBtn.userInteractionEnabled = NO;
        });


    } else if([recv isEqualToString:@"false"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animationStop];
            self.navigationItem.title = @"首页";
            _radioBtn.userInteractionEnabled = YES;
        });

    }else{
        NSLog(@"error in the didRecvAllAudio");
    }
    

}

//点击了“连接”按钮就会调用这个函数
-(void)touchConnect
{
    NSLog(@"%s",__func__);
        NSString *btnTitle = self.statusView.connectBtn.titleLabel.text;
    //判断是WiFi状态才进入重新连接登陆状态
    if (YES ==  [[TWNetworkEnvironment sharedInstance] isEnableWIFI]) {
        NSLog(@"now the NetworkEnvironment is wifi");
        
        
        //    NSLog(@"self.statusView.connectBtn.titleLabel.text :%@",self.statusView.connectBtn.titleLabel.text);

        //    NSLog(@"in the touchConnect : %@",self.statusView.connectBtn.titleLabel);
        if ([btnTitle isEqualToString:@"退出连接"]) { //点击了退出按钮
            NSLog(@"in the 退出连接");
            //更新模型
            [_netWork sendExitMassage];
            [_netWork disconect];
            
            self.netWork = nil;
            //更新连接按钮的文字
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
            ((TWtabBarController *)self.parentViewController.parentViewController).connectStatus = @"false";
            
        }else if ([btnTitle isEqualToString:@"点击连接"]){
            NSLog(@"in the 点击连接");
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_ING];
            

            [self.netWork socketBeginRuning];
                

            NSLog(@"in the touchConnect %@",_netWork);
            //更新按钮的文字
            //        [self checkConnectStatus];
            
        }
        else if([btnTitle isEqualToString:@"正在连接"]){
            if (self.netWork.connectSuccessful) {
                [self.statusView setStatusBtnWithConnectStatus:CONNECT_SUCCESS];
                
            }
        }
        else{
            NSLog(@"error in the touchConect");
        }
        

    }
    //如果在连接成功状态下断掉wifi，此时状态还是正在连接，此时应该更新成连接失败的状态
    else if (NO ==  [[TWNetworkEnvironment sharedInstance] isEnableWIFI] && [btnTitle isEqualToString:@"退出连接"])
    {
        //更新模型
        [_netWork sendExitMassage];
        [_netWork disconect];
        
        self.netWork = nil;
        //更新连接按钮的文字
        [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
    }
    else
    {
//        [MBProgressHUD showError:@"您没有连接指定wifi"];
    }
}


-(void)touchLog
{
    NSLog(@"%s",__func__);
    //登录
    //懒加载了，所以这里不用写初始化
    [self.netWork socketBeginRuning];

}


-(void)checkConnectStatus:(NSNotification *)notification
{
    NSLog(@"%s",__func__);
    NSString *recv = [notification object];
    _saveConnectStatus = recv;
        if ([recv isEqualToString:@"true"]) {
            //更新TWtabBarController中的公共变量，以供TWSettingViewController使用
            ((TWtabBarController *)self.parentViewController.parentViewController).connectStatus = @"true";
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_SUCCESS];
        }
        else if ([recv isEqualToString:@"false"]){
            ((TWtabBarController *)self.parentViewController.parentViewController).connectStatus = @"false";
            //更新模型
            [_netWork sendExitMassage];
            [_netWork disconect];
            
            self.netWork = nil;
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
        }
        else{
            NSLog(@"error in the -(void)checkConnectStatus:(NSNotification *)notification");
        }

    
}

-(void)checkConnectStatus
{
    NSLog(@"%s",__func__);
    NSString *recv = _saveConnectStatus;
    NSLog(@"checkConnectStatus:%@",recv);
    if ([recv isEqualToString:@"true"]) {

        [self.statusView setStatusBtnWithConnectStatus:CONNECT_SUCCESS];
    }
    else if ([recv isEqualToString:@"false"]){
        [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
    }
    else{
        NSLog(@"error in the -(void)checkConnectStatus:(NSNotification *)notification");
    }
    
    
}


-(void)timeOut
{
    NSLog(@"%s",__func__);
//    [MBProgressHUD showError:@"连接超时"];
    [self.statusView.connectBtn setTitle:@"点击连接" forState:UIControlStateNormal];
    [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
    [_netWork disconect];
//    [_netWork sendExitMassage];
    self.netWork = nil;

}

-(void)addRadiobtn
{
    TWRadioButton *radioBtn = [TWRadioButton buttonWithType:UIButtonTypeCustom];
//    CGFloat radioBtnY = self.view.frame.origin.y + 300;
    radioBtn.frame  = CGRectMake((TWmainScreenFrame.size.width - 256) / 2.0, (TWmainScreenFrame.size.height - 256)/ 2.0, 256, 256);
//    radioBtn.frame  = CGRectMake((TWmainScreenFrame.size.width - 256) / 2.0, radioBtnY, 256, 256);
    radioBtn.center =  self.view.center;
//    NSLog(@"%@",radioBtn);
    
    [radioBtn setImage:[UIImage imageNamed:@"Radio"] forState:UIControlStateNormal];
    
//    [radioBtn setImage:[UIImage imageNamed:@"radioBtn_selected"] forState:UIControlStateHighlighted];
    
//    radioBtn.imageEdgeInsets =  UIEdgeInsetsMake(64, 64, 64, 64);
//    radioBtn.backgroundColor =  [UIColor redColor];
    //添加监听
    [radioBtn addTarget:self action:@selector(beginTalking) forControlEvents:UIControlEventTouchDown];
    [radioBtn addTarget:self action:@selector(stopTalking) forControlEvents:UIControlEventTouchUpInside];
    _radioBtn = radioBtn;
    [self.view addSubview:radioBtn];

}



-(void)beginTalking
{
//    NSLog(@"%s", __func__);

//    self.title = @"正在对讲";
    if (_netWork.connectSuccessful) {
        self.navigationItem.title = @"正在对讲";
        self.radioView.isSelected = YES;
        
        [self.netWork beginSendRecord];
        //发送语音顺时针转动
        [self animationBeginWithIsClockwise:YES];
    }
    else
    {
//        [MBProgressHUD showError:@"您未连接网络"];
    }

}

-(void)stopTalking
{
    self.navigationItem.title = @"首页";
//    self.title = @"首页";
    if (_netWork != nil) {
        [self.netWork stopSendRecord];
    }

    [self animationStop];
}


-(void)animationBeginWithIsClockwise:(BOOL)isClockwise
{
    NSLog(@"%s",__func__);
    self.radioView.isSelected = YES;
    //调用以下函数，则会自动调用drawRect
    [self.radioView setNeedsDisplay];
    
    
    //创建核心动画
    CABasicAnimation *anima =  [CABasicAnimation animation];
    anima.keyPath = @"transform";
    
    //        //2.设置动画执行完毕后不删除动画
    //        anima.removedOnCompletion = NO;
    
    //        //3.设置保存动画的最新状态
    //        anima.fillMode =  kCAFillModeForwards;
    
    //3.设置动画时间
    anima.duration = 1.0;
    //设置动画重复次数
    //        anima.repeatDuration = 2;
    anima.repeatCount =MAXFLOAT;
    
    //        //动画结束后执行逆动画
    //        anima.autoreverses  = YES;

    //4.修改动画
    
    //    // 旋转方向——顺时针
    //    CATransform3DMakeRotation(M_PI/2, 0.0, 0.0, 1.0)
    //    // 旋转方向——逆时针
    //    CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0)
    if (isClockwise) {
        //顺时针转动
            anima.toValue =  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0, 0, 1)];
    } else {
        //逆时针转动
            anima.toValue =  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    }

    
    //5.添加核心动画到layer,注意要在stop移除动画
    [self.radioView.layer addAnimation:anima forKey:nil];
}

-(void)animationStop
{
    self.radioView.isSelected = NO;
    [self.radioView setNeedsDisplay];
#warning 记得这里要移除动画
    NSLog(@"%s",__func__);
    [self.radioView.layer removeAllAnimations];
}


-(void)dealloc
{
    NSLog(@"%s",__func__);
}
@end




