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
#import "TWTabBarController.h"
#import "MSWeakTimer.h"
#import "JCRBlurView.h"
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
@property (nonatomic,weak) MBProgressHUD *hud;


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
//        _account = [userDefaults stringForKey:@"account"];
//        _passwd =  [userDefaults stringForKey:@"passwd"];
//        if (_account ==  nil || _passwd == nil) {
//            [MBProgressHUD showError:@"您未登陆账号和密码"];
//            return nil;
//        }
        if (_serverPort ==  nil || _serverIp == nil) {
            [MBProgressHUD showError:@"您未设置服务器地址和端口"];
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
        _radioView = [[TWRadioView alloc] initWithFrame:self.view.frame];
    }
    return _radioView;
}


-(TWStatusView *)statusView
{
    
    if (_statusView == nil) {
        CGFloat statusViewY = rectNav.size.height + statusBarFrame.size.height;
        CGRect statusViewFrame =  CGRectMake(0, statusViewY, TWmainScreenFrame.size.width, 80);
        _statusView = [[TWStatusView alloc] initWithFrame:statusViewFrame];
        
    }
    return _statusView;
}

#pragma mark 系统默认函数
-(void)viewDidLoad
{
    [super viewDidLoad];
//    DebugMethod();
    //打印当前版本
    
//    NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    //设置主页背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加一个自定义视图：旋转按钮
    self.radioView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.radioView];
    
    //添加状态视图到主视图
    [self.view addSubview:self.statusView];

    //添加按钮到主视图
    [self addRadiobtn];
    
//    [self.radioBtn.layer addSublayer:self.radioView.layer];

    [self addNotification];

    [self setupNavigationItem];
//
    
    self.session  = [[TWAudioSession alloc]init];
    

    
    JCRBlurView *blurView = [JCRBlurView new];
    [blurView setFrame:self.view.frame];
    
    [blurView setBlurTintColor:nil];
    _blurView =  blurView;
    
    
    //开始连接服务器
    [self.netWork socketBeginRuning];
    
    MBProgressHUD *hud =  [[MBProgressHUD alloc]initWithView:self.view];
    _hud = hud;
 
    [TWKeyWindow addSubview:_hud];
    hud.labelText = @"正在连接";
    _hud.dimBackground = YES;
    [_hud show:YES];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    DebugMethod();
    [super viewWillAppear:animated];
    
}

//此方法并未调用
-(void)viewDidAppear:(BOOL)animated
{
    DebugMethod();
    [super viewDidAppear:animated];
    [self.statusView.connectBtn setRippleStatusfillWithbutton:self.statusView.connectBtn];
}

/**
 *  添加监听到本控制器
 */
-(void)addNotification
{
    
    //添加登陆页面的登陆按钮的监听
    [TWDefaultCenter addObserver:self selector:@selector(touchLogBtn) name:@"Notification_log" object:nil];
    
    //添加网络连接状态改变的监听
    [TWDefaultCenter addObserver:self selector:@selector(checkConnectStatus:) name:@"sendConnectStatus" object:nil];
    
    //添加本页面的连接按钮的监听
    [TWDefaultCenter addObserver:self selector:@selector(touchSelfConnectBtn) name:@"Notification_touchConnect" object:nil];
    
    //添加连接超时的监听
    [TWDefaultCenter addObserver:self selector:@selector(timeOut) name:@"Notification_timeOut" object:nil];
    
    //添加接收语音结束的监听
    [TWDefaultCenter addObserver:self selector:@selector(didRecvAllAudio:) name:@"Notification_didRecvAllAudio" object:nil];
    
    //添加接收连接成功的监听
    [TWDefaultCenter addObserver:self selector:@selector(connectSuccessfully) name:@"connectSuccessfully" object:nil];
}


-(void)setupNavigationItem
{

    //设置左导航栏条
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    
    UIImage  *image =[[UIImage imageNamed:@"left_setting_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    
    
//    //设置中间导航栏条
    self.navigationItem.title = @"首页";
//    //    _selectItem.backgroundColor = [UIColor whiteColor];
//    //    _selectItem.tintColor
//    UISegmentedControl *selectItem = [[UISegmentedControl alloc]initWithItems:@[@"未整理",@"已整理"]];
//    //    selectItem.frame = CGRectMake(20.0, 20.0, 250.0, 50.0);
//    
//    selectItem.selectedSegmentIndex = 0;//设置默认选择项索引
//    [selectItem addTarget:self action:@selector(selectItemValueChanged:) forControlEvents:UIControlEventValueChanged];
//    //下面这句设置无效
//    //    _selectItem.tintColor = [UIColor whiteColor];
//    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
//    
//    self.navigationItem.titleView = selectItem;
//    
//    
//    UIButton *history = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [history setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [history setTitle:@"历史" forState:UIControlStateNormal];
//    //    history.rightX = TWScreenWidth;
//    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc]initWithCustomView:history];
//    
//    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [send setTitle:@"发送" forState:UIControlStateNormal];
//    [send addTarget:self action:@selector(touchSend) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *sendItem   =[[UIBarButtonItem alloc]initWithCustomView:send];
//    
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    /**
//     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
//     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
//     */
//    negativeSpacer.width = -10;
//    
//    self.navigationItem.rightBarButtonItems =@[negativeSpacer,sendItem,historyItem];
}

/**
 *  接收语音结束的回调
 *
 *  @param notification :notification description
 */
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


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
//    ((TWTabBarController *)self.tabBarController).blurView = _blurView;
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    [self.tabBarController.view insertSubview:_blurView aboveSubview:self.view];
    [self.frostedViewController presentMenuViewController];
}

/**
 *  连接成功的回调
 */
-(void)connectSuccessfully
{
    NSLog(@"%s", __func__);
//    sleep(1);
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud removeFromSuperview];

//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TWWait) object:nil];
    
    BOOL isConnected = ((TWTabBarController *)self.parentViewController.parentViewController).isConnected;
    NSLog(@"%d",isConnected);
    if (isConnected == YES) {
        [MBProgressHUD showSuccess:@"连接成功"];
    } else {
        [MBProgressHUD showError:@"连接失败"];
    }
    });
}

/**
 *  添加本页面的连接按钮的监听
 */
-(void)touchSelfConnectBtn
{
    DebugMethod();
    //判断是WiFi状态才进入重新连接登陆状态
    if (YES ==  [[TWNetworkEnvironment sharedInstance] isEnableWIFI]) {
        NSLog(@"now the NetworkEnvironment is wifi");
        
        
        MBProgressHUD *hud =  [[MBProgressHUD alloc]initWithView:self.navigationController.view];
        _hud = hud;
        [self.view.window addSubview:_hud];
//        hud.labelText = @"点击了登录";
        _hud.dimBackground = YES;
//            NSLog(@"%s", __func__);
//            hud.labelText = @"点击了登录";

            
        [_hud showWhileExecuting:@selector(touchSelfConnectBtnAction) onTarget:self withObject:nil animated:YES];
        
    }
    //如果在连接成功状态下断掉wifi，此时状态还是正在连接，此时应该更新成连接失败的状态
    else
    {
        //更新模型
        [_netWork sendExitMassage];
        [_netWork disconect];
        
        self.netWork = nil;
        //更新连接按钮的文字
        [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
        [MBProgressHUD showError:@"您没有连接指定wifi"];
    }
}


-(void)touchSelfConnectBtnAction
{
    NSString *btnTitle = self.statusView.connectBtn.titleLabel.text;
    if ([btnTitle isEqualToString:@"退出连接"]) { //点击了退出按钮
        //                NSLog(@"in the 退出连接");
        _hud.labelText = @"退出连接";
        //更新模型
        [_netWork sendExitMassage];
        [_netWork disconect];
        
        self.netWork = nil;
        //更新连接按钮的文字
        [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
        ((TWTabBarController *)self.parentViewController.parentViewController).isConnected  = NO;
        
    }else if ([btnTitle isEqualToString:@"点击连接"]){
        //                NSLog(@"in the 点击连接");
        _hud.labelText = @"正在连接";
//        [self.statusView setStatusBtnWithConnectStatus:CONNECT_ING];
        
        
        [self.netWork socketBeginRuning];
        
        NSLog(@"%@",[NSThread currentThread]);
        //设定延时时间为5秒
        sleep(TWTimeOut);
//        [self performSelector:@selector(TWWait) withObject:nil afterDelay:TWTimeOut];
//        self.showHudTimer  = [MSWeakTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(TWWait) userInfo:nil repeats:NO dispatchQueue:dispatch_get_current_queue()];
        
    }
    else{
        NSLog(@"error in the touchConect");
    }
//    [self performSelector:@selector(TWhideHub) withObject:nil afterDelay:3];

}

/**
 *  空函数
 */
-(void)TWWait
{
    NSLog(@"%s", __func__);
    NSLog(@"%@",[NSThread currentThread]);
    sleep(TWTimeOut);
    NSLog(@"%s", __func__);
}

/**
 *  点击了登陆页面的按钮就会回调这个函数
 */
-(void)touchLogBtn
{
    DebugMethod();
    
//    _hud = nil;
    MBProgressHUD *hud =  [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    _hud = hud;
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    [window addSubview:_hud];
    //        hud.labelText = @"点击了登录";
    _hud.dimBackground = YES;
    //            NSLog(@"%s", __func__);
    //            hud.labelText = @"点击了登录";
    _hud.labelText = @"正在连接";
    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"%@",_hud);
    [_hud showWhileExecuting:@selector(firstLog) onTarget:self withObject:nil animated:YES];

}


-(void)firstLog
{
    //登录
    //懒加载了，所以这里不用写初始化
        [self.netWork socketBeginRuning];
    //设定延时时间为5秒
            sleep(TWTimeOut);
//    [self performSelector:@selector(TWWait) withObject:nil afterDelay:TWTimeOut];


}

/**
 *  网络连接状态改变时的回调函数
 *
 *  @param notification notification description
 */
-(void)checkConnectStatus:(NSNotification *)notification
{
    DebugMethod();
    NSString *recv = [notification object];
        if ([recv isEqualToString:@"true"]) {
            //更新TWTabBarController中的公共变量，以供TWSettingViewController使用
            ((TWTabBarController *)self.parentViewController.parentViewController).isConnected  = YES;
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_SUCCESS];
        }
        else{
            ((TWTabBarController *)self.parentViewController.parentViewController).isConnected  = NO;
            //更新模型
            [_netWork sendExitMassage];
            [_netWork disconect];
            
            self.netWork = nil;
            [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
        }
    
}


/**
 *  连接超时的回调函数
 */
-(void)timeOut
{
    DebugMethod();
//    [MBProgressHUD showError:@"连接超时"];
    [self.statusView.connectBtn setTitle:@"点击连接" forState:UIControlStateNormal];
    [self.statusView setStatusBtnWithConnectStatus:CONNECT_FAIL];
    [_netWork disconect];
//    [_netWork sendExitMassage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_hud removeFromSuperview];
        
//        BOOL isConnected = ((TWTabBarController *)self.parentViewController.parentViewController).isConnected;
//        NSLog(@"%d",isConnected);
//        if (isConnected == YES) {
//            [MBProgressHUD showSuccess:@"连接成功"];
//        } else {
            [MBProgressHUD showError:@"连接失败"];
//        }
        
    });
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
    //添加监听函数
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
//        [self animationBeginWithIsClockwise:YES];
    }
    else
    {
        [MBProgressHUD showError:@"您未连接网络"];
    }
    DebugMethod();
}

-(void)stopTalking
{
    self.navigationItem.title = @"首页";
//    self.title = @"首页";
    if (_netWork != nil) {
        [self.netWork stopSendRecord];
    }

//    [self animationStop];
    DebugMethod();
}


-(void)animationBeginWithIsClockwise:(BOOL)isClockwise
{
    DebugMethod();
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
    anima.repeatCount = MAXFLOAT;
    
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
//    DebugMethod();
    [self.radioView.layer removeAllAnimations];
}


-(void)dealloc
{
    DebugMethod();
    [TWDefaultCenter removeObserver:self];
}
@end




