//
//  TWSettingViewController.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWSettingViewController.h"
#import "TWAboutViewController.h"
#import "TWSettingItem.h"
#import "TWSettingGroup.h"
#import "TWSettingArrowItem.h"
#import "TWSettingHeaderView.h"
#import "TWSettingTextItem.h" 
#import "TWtabBarController.h"
#import "TWChangeLoginViewController.h"
@interface TWSettingViewController ()
@property (nonatomic,weak) TWSettingHeaderView *headerView;
@end

@implementation TWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%s",__func__);
    // Do any additional setup after loading the view.
    [self add0Sectionitems];
    
    [self add1Sectionitems];
    
    [self addHeaderView];

    self.tableView.sectionFooterHeight = 1.0;
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
//    [self.tableView setFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.origin.y + self.tableView.tableHeaderView.frame.size.height +100, TWmainScreenFrame.size.width, TWmainScreenFrame.size.height)];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.tableView.tableHeaderView setFrame:CGRectMake(0, 200,self.tableView.tableHeaderView.frame.size.width, self.tableView.tableHeaderView.frame.size.height)];
    
//    [self.tableView setFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.origin.y + self.tableView.tableHeaderView.frame.size.height +10, TWmainScreenFrame.size.width, TWmainScreenFrame.size.height)];
}



-(void)addHeaderView
{
    //添加headerView
    TWSettingHeaderView *headerView = [TWSettingHeaderView settingHeaderview];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingHeader"]];
    
    //设置button
        NSLog(@"%@",[NSThread currentThread]);
    [headerView.logButton setTitle:@"点击切换用户或地址" forState:UIControlStateNormal];
    [headerView.logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView.logButton addTarget:self action:@selector(touchLog) forControlEvents:UIControlEventTouchUpInside];
    [headerView.logButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    //设置详细说明label
    headerView.detailLabel.text = @"登录以进行实时对讲";
    headerView.detailLabel.textAlignment = NSTextAlignmentLeft;
    headerView.detailLabel.textColor = [UIColor whiteColor];
    headerView.detailLabel.font =  [UIFont systemFontOfSize:12.0];
    
    UIImage *image = [UIImage imageNamed:@"logImage"];
    headerView.iconOfPeople.layer.masksToBounds = YES;
    headerView.iconOfPeople.layer.cornerRadius = headerView.iconOfPeople.frame.size.width /2;
    //    headerView.iconOfPeople.layer.borderColor = [UIColor purpleColor].CGColor;
    //    headerView.iconOfPeople.layer.borderWidth = 10;
    headerView.iconOfPeople.image = image;
    _headerView = headerView;
    
    self.tableView.tableHeaderView =  headerView;
}
-(void)touchLog
{
//    TWLoginViewController *vc =  [[TWLoginViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    TWChangeLoginViewController *vc = [[TWChangeLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 添加第0组的模型数据
-(void)add0Sectionitems
{
    
    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    
    [_allGroups addObject:group];
}


-(void)add1Sectionitems
{
//    TWSettingArrowItem *address =  [TWSettingArrowItem itemWithIcon:@"server" title:@"地址设置"];
//    address.showVcClass = [TWServerViewController class];
    
    TWSettingArrowItem *about =  [TWSettingArrowItem itemWithIcon:@"MoreAbout" title:@"关于我们"];
    about.showVcClass = [TWAboutViewController class];
    
    
    //1.评分支持
    TWSettingArrowItem *support = [TWSettingArrowItem itemWithIcon:@"recommendToAppstore" title:@"评分支持"];
    //跳去AppStore的评分支持界面,下面的1048837125是在iTunes上面获取的。
    support.operation =^{
        NSString *appStore =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",@"1048837125"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStore]];
        
    };
    
//    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    
        TWSettingGroup *group =  [TWSettingGroup groupWithItems:@[about,support]];
    [_allGroups addObject:group];

}


//-(void)add2Sectionitems
//{
//    //1.评分支持
//    TWSettingArrowItem *support = [TWSettingArrowItem itemWithtitle:@"评分支持"];
//    //跳去AppStore的评分支持界面
//    support.operation =^{
//        NSString *appStore =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", @"954270"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStore]];
//        
//    };
//    
//    //2.客服电话
//    TWSettingArrowItem *phone = [TWSettingArrowItem itemWithtitle:@"客服电话"];
//    phone.subtitle = @"暂未开通";
//    
//    TWSettingGroup *group = [TWSettingGroup groupWithItems:@[support,phone]];
//    [_allGroups addObject:group];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
