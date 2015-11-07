//
//  TWFirstViewLoginViewController.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/13.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWFirstViewLoginViewController.h"

@interface TWFirstViewLoginViewController ()
@end

@implementation TWFirstViewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  [UIColor whiteColor];

    [self addAccountView];
    [self addBtnView];
    
    [self.logBtn addTarget:self action:@selector(touchLog) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchLog
{
//    NSLog(@"%s",__func__);

    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    BOOL isSavePwd = [userDefaults boolForKey:@"isSavePwd"];
    
    
    //判断是WiFi状态才进入重新连接登陆状态
    if (YES ==  [[TWNetworkEnvironment sharedInstance] isEnableWIFI]) {
        NSLog(@"now the NetworkEnvironment is wifi");
        if (self.isSwitchOn) {
            if (!(self.accountTextField.text.length && self.passwdTextField.text.length && self.serverIpTextField.text.length && self.serverPortTextField.text.length)) {
                
//                [MBProgressHUD showError:@"请输入账号、密码、服务器地址"];
                return;
                
            } else {
                if (isSavePwd) {
                    //获取到单例
                    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
                    //保存账号和密码
                    [userDefaults setObject:self.accountTextField.text forKey:@"account"];
                    [userDefaults setObject:self.passwdTextField.text forKey:@"passwd"];
                    [userDefaults setObject:self.serverIpTextField.text forKey:@"serverIp"];
                    [userDefaults setObject:self.serverPortTextField.text forKey:@"serverPort"];
                    //立即保存
                    [userDefaults synchronize];

                    
                    //发送消息通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_log" object:@"TWFirstViewLoginViewController" userInfo:nil];
                    //跳转到tabbarcontroller页面
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                

            }
        }
        else
        {
            if (!(self.accountTextField.text.length && self.passwdTextField.text.length)) {
                
//                [MBProgressHUD showError:@"您必须输入账号和密码才能登陆"];
                return;
                
            } else {
                if (isSavePwd) {
                    
                    //获取到单例
                    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
                    
                    //这种情况下先查看是否保存了服务器ip和端口
                    NSString * serverIp = [userDefaults stringForKey:@"serverIp"];
                    NSString * serverPort =  [userDefaults stringForKey:@"serverPort"];
                    if ([serverIp length] == 0 || [serverPort length] == 0) {
//                        [MBProgressHUD showError:@"您必须设置服务器才能登陆"];
                        return;
                        
                    }

                    //保存账号和密码
                    [userDefaults setObject:self.accountTextField.text forKey:@"account"];
                    [userDefaults setObject:self.passwdTextField.text forKey:@"passwd"];
                    //立即保存
                    [userDefaults synchronize];
                    
                    //发送消息通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_log" object:@"TWFirstViewLoginViewController" userInfo:nil];
                    //跳转到tabbarcontroller页面
                    [self dismissViewControllerAnimated:YES completion:nil];
                }

                

            }
        }
        
    }
    else
    {
//        [MBProgressHUD showError:@"您没有连接指定wifi"];
    }

}

@end
