//
//  TWStatusView.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/5.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWStatusView.h"
#import "TWStatusButton.h"
#import "UIButton+Bootstrap.h"

@interface TWStatusView()
{
    
}
@property (nonatomic,strong) UIImageView *iconOfPeople;
@property (nonatomic,strong) UILabel *accountName;


@end
@implementation TWStatusView

-(UIImageView *)iconOfPeople
{
    
    if (_iconOfPeople == nil) {
        _iconOfPeople = [UIImageView new];
    }
    return _iconOfPeople;
}


-(UILabel *)accountName
{
    
    if (_accountName == nil) {
        _accountName = [[UILabel alloc] init];
        
    }
    return _accountName;
}

-(TWStatusButton *)statusBtn
{
    
    if (_statusBtn == nil) {
        _statusBtn = [[TWStatusButton alloc] init];
        
    }
    return _statusBtn;
}

-(UIButton *)connectBtn
{
    
    if (_connectBtn == nil) {
        _connectBtn = [[UIButton alloc] init];
        
    }
    return _connectBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //添加头像
    CGFloat iconOfPeopleH = 60;
    CGFloat iconOfPeopleY = (self.frame.size.height - iconOfPeopleH) / 2;
    CGFloat iconOfPeopleW = iconOfPeopleH;
    //    UIImageView *iconOfPeople =  [[UIImageView alloc]initWithFrame:CGRectMake(20, iconOfPeopleY, iconOfPeopleW , iconOfPeopleH)];
    self.iconOfPeople.frame = CGRectMake(20, iconOfPeopleY, iconOfPeopleW , iconOfPeopleH);
    self.iconOfPeople.image = [UIImage imageNamed:@"Home_people"];
    self.iconOfPeople.contentMode = UIViewContentModeScaleAspectFit;
    
    //添加账户名UILabel
    CGFloat acountNameX = _iconOfPeople.frame.origin.x + _iconOfPeople.frame.size.width + 10;
    CGFloat acountNameY = 0;
    CGFloat acountNameW = 150 ;
    CGFloat acountNameH = 44;
//    UILabel *accountName = [[UILabel alloc]initWithFrame:CGRectMake(acountNameX, acountNameY, acountNameW, acountNameH)];
    self.accountName.frame = CGRectMake(acountNameX, acountNameY, acountNameW, acountNameH);
    //拼接字符串
    NSString *string;//结果字符串
    NSString *string1 = @"账号:";
    NSString *string2 = @"admin";
    string = [string1 stringByAppendingString:string2];
    //    accountName.backgroundColor =  [UIColor redColor];
    self.accountName.text = string;

    
    //添加连接button
    CGFloat connectBtnFrameX = self.accountName.frame.origin.x + self.accountName.frame.size.width +10 ;
    CGFloat connectBtnFrameY = self.accountName.frame.origin.y +5;
    CGFloat connectBtnFrameW = TWmainScreenFrame.size.width - self.accountName.frame.origin.x - self.accountName.frame.size.width - 15;
    CGFloat connectBtnFrameH = self.accountName.frame.size.height -5;
    self.connectBtn.frame = CGRectMake(connectBtnFrameX, connectBtnFrameY, connectBtnFrameW, connectBtnFrameH);
    [self.connectBtn primaryStyle];
    //添加连接button
    [self.connectBtn setTitle:@"正在连接" forState:UIControlStateNormal];
    self.connectBtn.titleLabel.font =  [UIFont systemFontOfSize:12.0];
    [self.connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.connectBtn setBackgroundColor:[UIColor blueColor]];
//    self.connectBtn.titleLabel.font =  [UIFont systemFontOfSize:8.0];
    //添加监听
    [self.connectBtn addTarget:self action:@selector(touchConnect) forControlEvents:UIControlEventTouchUpInside];
    
    //添加状态button
    //与上一个label对齐
    CGFloat statusBtnX = _accountName.frame.origin.x;
    CGFloat statusBtnY = _accountName.frame.origin.y + _accountName.frame.size.height;
    CGFloat statusBtnW = _accountName.frame.size.width;
    CGFloat statusBtnH = self.frame.size.height - _accountName.frame.size.height - _accountName.frame.origin.y;
    self.statusBtn.frame = CGRectMake(statusBtnX, statusBtnY, statusBtnW, statusBtnH);
    [self.statusBtn setImage:[UIImage imageNamed:@"status_error"] forState:UIControlStateNormal];
    self.statusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.statusBtn setTitle:@"正在连接网络中" forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.statusBtn.titleLabel.font =  [UIFont systemFontOfSize:12.0];
    self.statusBtn.userInteractionEnabled = NO;

}


-(void)commonInit
{
    //添加头像


    [self addSubview:self.iconOfPeople];
    
    //添加账户名UILabel
     [self addSubview:self.accountName];
    

    
    //参考开源按钮代码
    //参考网址：http://code4app.com/ios/UIButton-Bootstrap/52635e8c6803fa576b000000
//    NSLog(@"%@",connectBtn);
//    connectBtn.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.connectBtn];
    

//    //添加状态button
//    //与上一个label对齐
//    statusBtn.backgroundColor =  [UIColor redColor];
      [self addSubview:self.statusBtn];
}

-(void)touchConnect
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_touchConnect" object:self userInfo:nil];
}

-(void)setStatusBtnWithConnectStatus:(int)connectStatus
{
    NSLog(@"connectStatus is %d",connectStatus);
//    NSLog(@"in the setStatusBtnWithConnectStatus %@",self.connectBtn.titleLabel);
#warning 修改控件一定要在主线程修改，要不然会出现意外情况
    dispatch_async(dispatch_get_main_queue(), ^{
        if (connectStatus == CONNECT_SUCCESS) {
            
            [self.statusBtn setImage:[UIImage imageNamed:@"status_OK"] forState:UIControlStateNormal];
            self.statusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.statusBtn setTitle:@"已经连通网络，请按住对讲" forState:UIControlStateNormal];
//            NSLog(@"%@",[NSThread currentThread]);
            [self.connectBtn setTitle:@"退出连接" forState:UIControlStateNormal];
//            NSLog(@"%@",self.connectBtn);
        } else if(connectStatus == CONNECT_FAIL){
            [self.connectBtn setTitle:@"点击连接" forState:UIControlStateNormal];
            [self.statusBtn setImage:[UIImage imageNamed:@"status_error"] forState:UIControlStateNormal];
            self.statusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.statusBtn setTitle:@"无法连接网络，请重新连接" forState:UIControlStateNormal];
        }
        else if(connectStatus == CONNECT_ING){
            [self.statusBtn setImage:[UIImage imageNamed:@"status_error"] forState:UIControlStateNormal];
            [self.statusBtn setTitle:@"正在连接网络中" forState:UIControlStateNormal];
            [self.connectBtn setTitle:@"正在连接" forState:UIControlStateNormal];
        }
        else{
            
        }
    });
//    NSLog(@"in the setStatusBtnWithConnectStatus %@",self.connectBtn.titleLabel);
}
@end
