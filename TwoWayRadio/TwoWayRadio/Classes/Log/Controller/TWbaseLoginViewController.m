//
//  TWbaseLoginViewController.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/13.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWbaseLoginViewController.h"
#define labelWidth 60
@interface TWbaseLoginViewController ()

@property (nonatomic,weak)  UISwitch *isChangeServer;
@property (nonatomic,weak) UIView *allView;
@property (nonatomic,weak)  UILabel *switchLabel;
@property (nonatomic,weak)  UILabel *saveSwitchLabel;
@property (nonatomic,strong) UIView *firstView;
@property (nonatomic,strong) UIView *secondView;
@property (nonatomic,strong) UIView *btnView;
@end

@implementation TWbaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0];
    [self addHideKeyBoardButton];
  
    [self addLogIcon];
    
//    UIView *allView = [[UIView alloc]init];
//    _allView = allView;
//    [self.view addSubview:allView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [self addAccountView];
//    [self addBtnView];
    

    
    
}

-(void)keyboardWillShow:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSDictionary *info = [notification userInfo];
//    CGSize kbSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSLog(@"%@",NSStringFromCGSize(kbSize));
////    if (self.view.y < 0) {
////        self.view.y  = 0 - kbSize.height;
////    }
//    
//    if ([self.isChangeServer isOn]) {
//        self.view.y  = 0 - 120;
//    }
//
//
//    NSLog(@"%f",self.view.y);
}



-(void)keyboardWillHide:(NSNotification *)notification
{
//    NSLog(@"%s", __func__);
//    NSDictionary *info = [notification userInfo];
//    CGSize kbSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSLog(@"%@",NSStringFromCGSize(kbSize));
//       self.view.y  += 120;
//        NSLog(@"%f",self.view.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLogIcon
{
    UIImage *image = [UIImage imageNamed:@"logImage"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];

    CGFloat imageViewX = (TWmainScreenFrame.size.width - image.size.width) /2.0;
    CGFloat imageViewY = 20 + 10;
    CGFloat imageViewW = image.size.width;
    CGFloat imageViewH = image.size.height;
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
//    imageView.center = CGPointMake(TWmainScreenFrame.size.width / 2.0, 100);
    _imageView = imageView;
    [self.view addSubview:imageView];
}


-(void)addAccountView
{
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height, TWmainScreenFrame.size.width, 44 * 2  +1 * 2)];
//    firstView.backgroundColor = [UIColor whiteColor];
    _firstView = firstView;
    //账号label
    CGFloat accountX = 10;
    CGFloat accountY = 0;
    CGFloat accountW = labelWidth;
    CGFloat accountH = 44;
    CGRect accountFrame = CGRectMake(accountX, accountY, accountW, accountH);
    UILabel *accountLabel =  [[UILabel alloc] initWithFrame:accountFrame];
    accountLabel.text = @"账号";
    accountLabel.textAlignment =  NSTextAlignmentLeft;
    accountLabel.font =  [UIFont systemFontOfSize:12.0];
    //    accountLabel.backgroundColor =  [UIColor blueColor];
    [firstView addSubview:accountLabel];
    
    //请输入账号textField
    CGFloat accountTextX = accountLabel.frame.origin.x + accountLabel.frame.size.width;
    CGFloat accountTextY = 0;
    CGFloat accountTextW = TWmainScreenFrame.size.width - accountLabel.frame.size.width - 20;
    CGFloat accountTextH = 44;
    CGRect accountTextFrame = CGRectMake(accountTextX, accountTextY, accountTextW, accountTextH);
    UITextField *accountTextField = [[UITextField alloc]initWithFrame:accountTextFrame];
    //    accountTextField.backgroundColor =  [UIColor redColor];
    //    accountTextField.borderStyle =  UITextBorderStyleRoundedRect

    accountTextField.font = [UIFont systemFontOfSize:12.0];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField =  accountTextField;
    [firstView addSubview:accountTextField];
    
    //分割线1
    CGFloat fengeViewX =  10;
    CGFloat fengeViewY =  accountTextField.frame.origin.y + accountTextField.frame.size.height;
    CGFloat fengeViewW =  TWmainScreenFrame.size.width - 2  * fengeViewX;
    CGFloat fengeViewH =  1;
    CGRect fengeViewFrame = CGRectMake(fengeViewX, fengeViewY, fengeViewW, fengeViewH);
    UIView *fengeView =  [[UIView alloc]initWithFrame:fengeViewFrame];
    fengeView.backgroundColor  = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    [firstView addSubview:fengeView];
    
    //密码label
    CGFloat passwdX = 10;
    CGFloat passwdY = fengeView.frame.origin.y+ fengeView.frame.size.height;
    CGFloat passwdW = labelWidth;
    CGFloat passwdH = 44;
    CGRect passwdFrame = CGRectMake(passwdX, passwdY, passwdW, passwdH);
    UILabel *passwdLabel =  [[UILabel alloc] initWithFrame:passwdFrame];
    passwdLabel.text = @"密码";
    passwdLabel.textAlignment =  NSTextAlignmentLeft;
    passwdLabel.font =  [UIFont systemFontOfSize:12.0];
    //    passwdLabel.backgroundColor =  [UIColor blueColor];
    [firstView addSubview:passwdLabel];
    
    //请输入密码textField
    CGFloat passwdTextX = passwdLabel.frame.origin.x + passwdLabel.frame.size.width;
    CGFloat passwdTextY = fengeView.frame.origin.y+ fengeView.frame.size.height;
    CGFloat passwdTextW = TWmainScreenFrame.size.width - passwdLabel.frame.size.width - 20;
    CGFloat passwdTextH = 44;
    CGRect passwdTextFrame = CGRectMake(passwdTextX, passwdTextY, passwdTextW, passwdTextH);
    UITextField *passwdTextField = [[UITextField alloc]initWithFrame:passwdTextFrame];
    //    passwdTextField.backgroundColor =  [UIColor redColor];
    //    accountTextField.borderStyle =  UITextBorderStyleRoundedRect;
//    passwdTextField.placeholder = @"请输入密码";
    passwdTextField.font =  [UIFont systemFontOfSize:12.0];
    passwdTextField.secureTextEntry = YES;
    passwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    passwdTextField.borderStyle = UITextBorderStyleLine;
    _passwdTextField =  passwdTextField;
    [firstView addSubview:passwdTextField];
    
    
    //分割线2
    CGFloat fengeView1X =  10;
    CGFloat fengeView1Y =  passwdTextField.frame.origin.y + passwdTextField.frame.size.height;
    CGFloat fengeView1W =  TWmainScreenFrame.size.width - 2  * fengeViewX;
    CGFloat fengeView1H =  1;
    CGRect fengeView2Frame = CGRectMake(fengeView1X, fengeView1Y, fengeView1W, fengeView1H);
    UIView *fenge2View =  [[UIView alloc]initWithFrame:fengeView2Frame];
    fenge2View.backgroundColor =[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    [firstView addSubview:fenge2View];
    
    
    
    //取出保存的是否保存密码的标志,进而判断是否需要显示账号和密码
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    BOOL isSavePwd = [userDefaults boolForKey:@"isSavePwd"];
    NSString * account = [userDefaults stringForKey:@"account"];
    NSString * passwd =  [userDefaults stringForKey:@"passwd"];
    if (isSavePwd && [account length] != 0 && [passwd length] != 0) {
        accountTextField.text = account;
        if ([passwd length] != 0) {
            self.accountTextField.placeholder = account;
//            NSMutableString *pwdDisplay = [NSMutableString stringWithString:@"*"];
//            for (int i = 0; i<[passwd length] -1 ; i++) {
//                [pwdDisplay appendString:@"*"];
//                self.passwdTextField.text = pwdDisplay;
//            }
            self.passwdTextField.text = passwd;
        }
        else
        {
            NSLog(@"passwd length is 0");
        }
    }
    else
    {
        accountTextField.placeholder = @"请输入账号";
        passwdTextField.placeholder = @"请输入密码";
    }
    
    [self.view addSubview:firstView];
    
    
    
    
 }

-(void)addBtnView
{
    CGFloat btnViewFrameX = 0;
    CGFloat btnViewFrameY = self.firstView.frame.origin.y + self.firstView.frame.size.height;
    CGFloat btnViewFrameW = TWmainScreenFrame.size.width;
    CGFloat btnViewFrameH = 100;
    CGRect btnViewFrame = CGRectMake(btnViewFrameX, btnViewFrameY, btnViewFrameW, btnViewFrameH);
    UIView *btnView = [[UIView alloc]initWithFrame:btnViewFrame];
    //    btnView.backgroundColor = [UIColor whiteColor];
    _btnView = btnView;
    
    //登录按钮
    CGFloat btnY =  0 ;
    CGRect btnFrame  = CGRectMake(0, btnY, TWmainScreenFrame.size.width, 44);
    UIButton *logBtn =  [[UIButton alloc]initWithFrame:btnFrame];
    logBtn.backgroundColor  = [UIColor blueColor];
    [logBtn setTitle:@"登陆" forState:UIControlStateNormal];
    //    [logBtn addTarget:self action:@selector(touchLog:) forControlEvents:UIControlEventTouchUpInside];
    _logBtn =  logBtn;
    [btnView addSubview:logBtn];
    
    
    UISwitch *test = [[UISwitch alloc]init];
    //添加是否更改服务器地址的开关
    CGFloat switchX = TWmainScreenFrame.size.width - test.frame.size.width -20 ;
    CGFloat switchY = logBtn.frame.origin.y + logBtn.frame.size.height + 20;
    CGFloat switchW = 0;
    CGFloat switchH = 0;
    CGRect switchFrame = CGRectMake(switchX, switchY, switchW, switchH);
    UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:switchFrame];
    //默认为关着的状态
    [mySwitch setOn:NO];
    //    mySwitch.backgroundColor =  [UIColor redColor];
    _isChangeServer = mySwitch;
    [mySwitch addTarget:self action:@selector(switchIsChange:) forControlEvents:UIControlEventValueChanged];
    [btnView addSubview:mySwitch];
    
    //添加是否更改服务器地址的开关label
    CGFloat switchLabelW = 100;
    CGFloat switchLabelX = mySwitch.frame.origin.x - switchLabelW - 10;
    CGFloat switchLabelY = switchY ;
    CGFloat switchLabelH = mySwitch.frame.size.height;
    CGRect switchLabelFrame = CGRectMake(switchLabelX, switchLabelY, switchLabelW, switchLabelH);
    UILabel *switchLabel =  [[UILabel alloc] initWithFrame:switchLabelFrame];
    _switchLabel = switchLabel;
    switchLabel.text = @"设置服务器";
    switchLabel.textAlignment =  NSTextAlignmentRight;
    //    switchLabel.font =  [UIFont systemFontOfSize:12.0];
    //    switchLabel.backgroundColor =  [UIColor blueColor];
    [btnView addSubview:switchLabel];
    
    

    //添加是否更改自动保存密码的开关label

    CGFloat saveSwitchLabelX = 20;
    CGFloat saveSwitchLabelY = switchY ;
    CGFloat saveSwitchLabelW = 75;
    CGFloat saveSwitchLabelH = mySwitch.frame.size.height;
    CGRect saveSwitchLabelFrame = CGRectMake(saveSwitchLabelX, saveSwitchLabelY, saveSwitchLabelW, saveSwitchLabelH);
    UILabel *saveSwitchLabel =  [[UILabel alloc] initWithFrame:saveSwitchLabelFrame];
    _saveSwitchLabel = saveSwitchLabel;
    saveSwitchLabel.text = @"保存密码";
    saveSwitchLabel.textAlignment =  NSTextAlignmentLeft;
    //    switchLabel.font =  [UIFont systemFontOfSize:12.0];
    //    switchLabel.backgroundColor =  [UIColor blueColor];
    [btnView addSubview:saveSwitchLabel];
    
    //添加是否更改自动保存密码的开关
    CGFloat saveSwitchX = saveSwitchLabelX + saveSwitchLabelW ;
    CGFloat saveSwitchY = switchY;
    CGFloat saveSwitchW = 0;
    CGFloat saveSwitchH = 0;
    CGRect saveSwitchFrame = CGRectMake(saveSwitchX, saveSwitchY, saveSwitchW, saveSwitchH);
    UISwitch *saveSwitch = [[UISwitch alloc]initWithFrame:saveSwitchFrame];
    
    //取出保存的是否保存密码的标志
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    BOOL isSavePwd = [userDefaults boolForKey:@"isSavePwd"];
    
    //设置为上次保存的样式
    [saveSwitch setOn:isSavePwd];
    //    mySwitch.backgroundColor =  [UIColor redColor];
    
    _isSave = saveSwitch;
    [saveSwitch addTarget:self action:@selector(saveSwitchIsChange:) forControlEvents:UIControlEventValueChanged];
    [btnView addSubview:saveSwitch];
    
  
    
    [self.view addSubview:btnView];

}

-(void)switchIsChange:(UISwitch *)paramSender
{
    NSLog(@"%s",__func__);
    if ([paramSender isOn]) {
        NSLog(@"the switch is turn on");
        _isSwitchOn = YES;
        [self addServerView];

    }
    else
    {
        NSLog(@"the switch is turn off");
        _isSwitchOn = NO;
        [self.secondView removeFromSuperview];
        [self.btnView setFrame:CGRectMake(_btnView.frame.origin.x, self.firstView.frame.origin.y + self.firstView.frame.size.height, _btnView.frame.size.width, _btnView.frame.size.height)];

    }
    
}


-(void)saveSwitchIsChange:(UISwitch *)paramSender
{
    NSLog(@"%s",__func__);
    if ([paramSender isOn]) {
        NSLog(@"the switch is turn on");
        BOOL isSavePwd = YES;
        //获取到单例
        NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
        //保存是否自动保存密码的标志
        [userDefaults setBool:isSavePwd forKey:@"isSavePwd"];
        //立即保存
        [userDefaults synchronize];
    }
    else
    {
        NSLog(@"the switch is turn off");
        BOOL isSavePwd =  NO;
        //获取到单例
        NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
        //保存是否自动保存密码的标志
        [userDefaults setBool:isSavePwd forKey:@"isSavePwd"];
        //立即保存
        [userDefaults synchronize];
        
    }

    
}
-(void)addServerView
{
    CGFloat secondViewY = _firstView.frame.origin.y + _firstView.frame.size.height + 1;
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, secondViewY, TWmainScreenFrame.size.width, 44 * 2  +1 * 2)];
//    secondView.backgroundColor = [UIColor whiteColor];
    _secondView = secondView;
    //账号label
    CGFloat accountX = 10;
    CGFloat accountY = 0;
    CGFloat accountW = labelWidth;
    CGFloat accountH = 44;
    CGRect accountFrame = CGRectMake(accountX, accountY, accountW, accountH);
    UILabel *accountLabel =  [[UILabel alloc] initWithFrame:accountFrame];
    accountLabel.text = @"服务器IP";
    //    accountLabel.textAlignment =  UITextAlignmentLeft;
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.font =  [UIFont systemFontOfSize:12.0];
    //    accountLabel.backgroundColor =  [UIColor blueColor];
    [secondView addSubview:accountLabel];
    
    //请输入账号textField
    CGFloat accountTextX = accountLabel.frame.origin.x + accountLabel.frame.size.width;
    CGFloat accountTextY = 0;
    CGFloat accountTextW = TWmainScreenFrame.size.width - accountLabel.frame.size.width - 20;
    CGFloat accountTextH = 44;
    CGRect accountTextFrame = CGRectMake(accountTextX, accountTextY, accountTextW, accountTextH);
    UITextField *accountTextField = [[UITextField alloc]initWithFrame:accountTextFrame];
    //    accountTextField.backgroundColor =  [UIColor redColor];
    //    accountTextField.borderStyle =  UITextBorderStyleRoundedRect;
//    accountTextField.placeholder = @"请输入服务器IP";
    accountTextField.font = [UIFont systemFontOfSize:12.0];
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _serverIpTextField =  accountTextField;
    [secondView addSubview:accountTextField];
    
    //分割线
    CGFloat fengeViewX =  10;
    CGFloat fengeViewY =  accountTextField.frame.origin.y + accountTextField.frame.size.height;
    CGFloat fengeViewW =  TWmainScreenFrame.size.width - 2  * fengeViewX;
    CGFloat fengeViewH =  1;
    CGRect fengeViewFrame = CGRectMake(fengeViewX, fengeViewY, fengeViewW, fengeViewH);
    UIView *fengeView =  [[UIView alloc]initWithFrame:fengeViewFrame];
    fengeView.backgroundColor  = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    [secondView addSubview:fengeView];
    
    //密码label
    CGFloat passwdX = 10;
    CGFloat passwdY = fengeView.frame.origin.y+ fengeView.frame.size.height;
    CGFloat passwdW = labelWidth;
    CGFloat passwdH = 44;
    CGRect passwdFrame = CGRectMake(passwdX, passwdY, passwdW, passwdH);
    UILabel *passwdLabel =  [[UILabel alloc] initWithFrame:passwdFrame];
    passwdLabel.text = @"端口号";
    //    passwdLabel.textAlignment =  UITextAlignmentLeft;
    passwdLabel.textAlignment = NSTextAlignmentLeft;
    passwdLabel.font =  [UIFont systemFontOfSize:12.0];
    //    passwdLabel.backgroundColor =  [UIColor blueColor];
    [secondView addSubview:passwdLabel];
    
    //请输入密码textField
    CGFloat passwdTextX = passwdLabel.frame.origin.x + passwdLabel.frame.size.width;
    CGFloat passwdTextY = fengeView.frame.origin.y+ fengeView.frame.size.height;
    CGFloat passwdTextW = TWmainScreenFrame.size.width - passwdLabel.frame.size.width - 20;
    CGFloat passwdTextH = 44;
    CGRect passwdTextFrame = CGRectMake(passwdTextX, passwdTextY, passwdTextW, passwdTextH);
    UITextField *passwdTextField = [[UITextField alloc]initWithFrame:passwdTextFrame];
    //    passwdTextField.backgroundColor =  [UIColor redColor];
    //    accountTextField.borderStyle =  UITextBorderStyleRoundedRect;
//    passwdTextField.placeholder = @"请输入端口号";
    passwdTextField.font =  [UIFont systemFontOfSize:12.0];
    passwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _serverPortTextField =  passwdTextField;
    
    
    //取出保存的是否保存密码的标志,进而判断是否需要显示账号和密码
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    NSString * serverIp = [userDefaults stringForKey:@"serverIp"];
    NSString * serverPort =  [userDefaults stringForKey:@"serverPort"];
    if ([serverIp length] != 0 && [serverPort length] != 0) {
        _serverIpTextField.text = serverIp;
        _serverPortTextField.text = serverPort;

    }
    else
    {
        _serverIpTextField.placeholder = @"请输入服务器IP";
        _serverPortTextField.placeholder = @"请输入端口号";
    }
    
    [secondView addSubview:passwdTextField];
    
    
    
    [self.view addSubview:secondView];
    
    
    [self.btnView setFrame:CGRectMake(_btnView.frame.origin.x, secondView.frame.origin.y + secondView.frame.size.height, _btnView.frame.size.width, _btnView.frame.size.height)];

}

-(void)addHideKeyBoardButton
{
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = TWmainScreenFrame;
    [hideBtn addTarget:self action:@selector(touchHideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideBtn];
}

//触摸背景隐藏键盘
-(void)touchHideKeyBoard
{
    [self.accountTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.serverIpTextField resignFirstResponder];
    [self.serverPortTextField resignFirstResponder];

}

@end
