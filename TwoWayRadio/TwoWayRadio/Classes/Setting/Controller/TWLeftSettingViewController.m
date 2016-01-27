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
    self.view.width = TWLeftViewWidth;
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
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 50.0;
//        imageView.layer.borderColor = [UIColor clearColor].CGColor;
//        imageView.layer.borderWidth = 3.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        imageView.centerX  = self.view.width / 2;
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
    
}

#pragma mark - 初始化模型数据
- (void)setupGroups {
    [self.groups removeAllObjects];
    

    [self setupGroup0];


}

-(void)setupGroup0
{
    YSCommonGroup *group = [self addGroup];
    YSArrowItem *about =  [YSArrowItem itemWithTitle:@"关于我们" icon:nil];
    //    about.showVcClass = [TWAboutViewController class];
    about.operation = ^{
        //
        TWAboutProductViewController *vc =  [[TWAboutProductViewController alloc]init];
        [self showControllerWithVc:vc];
        
    };
    
    //1.评分支持
    YSArrowItem *support =  [YSArrowItem itemWithTitle:@"评分支持" icon:nil];
    //跳去AppStore的评分支持界面,下面的1048837125是在iTunes上面获取的。
    support.operation =^{
        NSString *appStore =  [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",@"1048837125"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStore]];
        
    };
    
    //    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    
    YSArrowItem *suggestion =  [YSArrowItem itemWithTitle:@"意见反馈" icon:nil];
  
    suggestion.operation = ^{
        
        UIViewController *vc =  [UMFeedback feedbackViewController];
        
        [self showControllerWithVc:vc];
    };
    //    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    
    YSArrowItem *logOut =  [YSArrowItem itemWithTitle:@"退出登陆" icon:nil];
    
    logOut.operation = ^{
        NSLog(@"%s",__func__);
//        UIViewController *vc =  [UMFeedback feedbackViewController];
//        
//
        UIAlertController *alert  =[UIAlertController alertControllerWithTitle:nil message:@"您确定要注销重新登录吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            DebugLog(@"从相册选择");
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"DZConnectLose" object:nil];
            //2.设置根控制器
            TWFirstViewLoginViewController *loginVc = [[TWFirstViewLoginViewController alloc]init];
            
            TWKeyWindow.rootViewController = loginVc;
        }]];
        //如果设置为UIAlertActionStyleCancel则后面黑色半透明的背景点击会自动退出
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DebugLog(@"touch 取消");
            //        [[NSNotificationCenter defaultCenter]postNotificationName:@"DZClearData" object:nil];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:^{
            //        DebugLog(@"%@",alert.view.subviews);
            //        DebugLog(@"%lu",(unsigned long)[alert.view.subviews count]);
            //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBackGroud)];
            //        [alert.view addGestureRecognizer:tap];
        }];

    };
    //    TWSettingGroup *group =  [TWSettingGroup groupWithItems:nil];
    group.items = @[about,support,suggestion,logOut];


}
-(void)touchLog
{
    
    TWChangeLoginViewController *vc = [[TWChangeLoginViewController alloc]init];
    [self showControllerWithVc:vc];
}


-(void)showControllerWithVc:(UIViewController *)vc
{
    TWTabBarController *tabVc   = (TWTabBarController *)self.frostedViewController.contentViewController;
    TWNavigationController *nav  =  (TWNavigationController *)[tabVc.viewControllers firstObject];
    //        [nav addChildViewController:vc];
    //
    //        self.frostedViewController.contentViewController = vc;
    [nav pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
    //        [self showControllerWithVc:vc];
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
//    cell.backgroundColor =  [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

@end
