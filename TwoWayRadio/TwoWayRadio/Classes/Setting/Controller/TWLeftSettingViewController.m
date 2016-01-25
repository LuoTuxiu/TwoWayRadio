//
//  TWLeftSettingViewController.m
//  TwoWayRadio
//
//  Created by LuoTuxiu on 16/1/25.
//  Copyright © 2016年 Trbocare. All rights reserved.
//

#import "TWLeftSettingViewController.h"
#import "TWAboutProductViewController.h"
#import "TWSettingItem.h"
#import "TWSettingGroup.h"
#import "TWSettingArrowItem.h"
#import "TWSettingHeaderView.h"
#import "TWSettingTextItem.h"
#import "TWChangeLoginViewController.h"
#import "UMFeedback.h"
#import "TWTestViewController.h"
#import "YSArrowItem.h"
@interface TWLeftSettingViewController ()

@end

@implementation TWLeftSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor =  [UIColor clearColor];
    
    [self commonSetupTableView:UITableViewStylePlain];
    [self setupGroups];
    
    [self addHeaderView];
    
    // Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

-(void)addHeaderView
{
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"Home_people"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        NSString *string2 = @"admin";
        label.text = string2;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    //    //添加headerView
    //    TWSettingHeaderView *headerView = [TWSettingHeaderView loadHeaderview];
    ////    headerView.width = self.tableView.width;
    //
    //    headerView.width  = leftViewWidth;
    //    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settingHeader"]];
    //
    //    //设置button
    //        NSLog(@"%@",[NSThread currentThread]);
    //    [headerView.logButton setTitle:@"点击切换用户或地址" forState:UIControlStateNormal];
    //    [headerView.logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [headerView.logButton addTarget:self action:@selector(touchLog) forControlEvents:UIControlEventTouchUpInside];
    //    [headerView.logButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //
    //    //设置详细说明label
    //    headerView.detailLabel.text = @"登录以进行实时对讲";
    //    headerView.detailLabel.textAlignment = NSTextAlignmentLeft;
    //    headerView.detailLabel.textColor = [UIColor whiteColor];
    //    headerView.detailLabel.font =  [UIFont systemFontOfSize:12.0];
    //
    //    UIImage *image = [UIImage imageNamed:@"logImage"];
    //    headerView.iconOfPeople.layer.masksToBounds = YES;
    //    headerView.iconOfPeople.layer.cornerRadius = headerView.iconOfPeople.frame.size.width /2;
    //    //    headerView.iconOfPeople.layer.borderColor = [UIColor purpleColor].CGColor;
    //    //    headerView.iconOfPeople.layer.borderWidth = 10;
    //    headerView.iconOfPeople.image = image;
    //    _headerView = headerView;
    //
    //    self.tableView.tableHeaderView =  headerView;
}

#pragma mark - 初始化模型数据
- (void)setupGroups {
    [self.groups removeAllObjects];
    

    [self setupGroup0];


}

-(void)setupGroup0
{
    YSCommonGroup *group = [self addGroup];
    YSArrowItem *about =  [YSArrowItem itemWithTitle:@"关于我们" icon:@"MoreAbout"];
    //    about.showVcClass = [TWAboutViewController class];
    about.operation = ^{
        //
        UIViewController *vc =  [[TWAboutProductViewController alloc]init];
        [self showControllerWithVc:vc];
        
        
    };
    
    //1.评分支持
    YSArrowItem *support =  [YSArrowItem itemWithTitle:@"评分支持" icon:@"recommendToAppstore"];
    //跳去AppStore的评分支持界面,下面的1048837125是在iTunes上面获取的。
    support.operation =^{
        NSString *appStore =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",@"1048837125"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStore]];
        
    };
    
    //    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    
    YSArrowItem *suggestion =  [YSArrowItem itemWithTitle:@"意见反馈" icon:@"feedback"];
  
    suggestion.operation = ^{
        
        UIViewController *vc =  [UMFeedback feedbackViewController];
        
        [self showControllerWithVc:vc];
    };
    //    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    group.items = @[about,support,suggestion];


}
-(void)touchLog
{
    
    TWChangeLoginViewController *vc = [[TWChangeLoginViewController alloc]init];
    [self showControllerWithVc:vc];
}


-(void)showControllerWithVc:(UIViewController *)vc
{
    MMDrawerController *originDrawVc = self.mm_drawerController;
    TWNavigationController *home = [((CYLTabBarController *)originDrawVc.centerViewController).viewControllers firstObject];
    
    [home pushViewController:vc animated:NO];
    [originDrawVc closeDrawerAnimated:YES completion:nil];
    
    
    //    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    //    MMDrawerController *drawerController = (MMDrawerController *)window.rootViewController;
    //    DZNavigationViewController *home = [((CYLTabBarController *)drawerController.centerViewController).viewControllers firstObject];
    //    //注意下面两行代码先后顺序
    //    [home pushViewController:lc animated:NO];
    //    [drawerController closeDrawerAnimated:YES completion:nil];
}


#pragma  mark - uitableview 代理
/**
 *  返回每个cell的高度
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor =  [UIColor clearColor];
    return cell;
}
@end
