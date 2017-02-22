//
//  RootTabBarController.m
//  LeYaoXiu
//
//  Created by AChang on 5/17/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "UIViewController+Utils.h"
#import "SetingTableViewController.h"
#import "DocManagerController.h"
#import "ShootingController.h"

@interface RootTabBarController()<UITabBarDelegate>

@property (nonatomic, strong)UINavigationBar *currentNaviBar;
@property (nonatomic, strong)UITabBar   *currentTabBar;

@end

@implementation RootTabBarController

#pragma mark - privite methods

-(instancetype)init
{
    self = [super init];
    if (self) {
        // 文档管理界面
        [self addChildViewController:[[DocManagerController alloc] initWithNibName:@"DocManagerController" bundle:nil]
                           withTitle:NSLocalizedString(@"TableBar.documentManager", @"文档总管")
                            andImage:@"tb_setting"
                    andSelectedImage:@"tb_setting"];
        
        // 拍摄界面
        //        NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
        [self addChildViewController:[[ShootingController alloc] initWithNibName:@"ShootingController" bundle:nil]
                           withTitle:NSLocalizedString(@"TableBar.shoot", @"拍摄")
                            andImage:@"tb_camera"
                    andSelectedImage:@"tb_camera"];
     
        // 设置界面
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SetingTableViewController *settingController = [mainStroyBoard instantiateViewControllerWithIdentifier:@"SetingTableViewController"];
        [self addChildViewController:settingController
                           withTitle:NSLocalizedString(@"TableBar.setting", @"设置")
                            andImage:@"tb_documentation"
                    andSelectedImage:@"tb_documentation"];
        self.delegate = self;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBar.tintColor = kThemeColor;
    return self;
}

-(void)addChildViewController:(UIViewController *)childController withTitle:(NSString *)title andImage:(NSString *)imageName andSelectedImage:(NSString *)selectedImage
{
    // 设置图片
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
//    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 改字体的颜色
    NSMutableDictionary *titleAtt = [NSMutableDictionary dictionary];
    titleAtt[NSForegroundColorAttributeName] = UIColorFromRGB(0x666666);
    titleAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:11];
    NSMutableDictionary *selectedTitleAtt = [NSMutableDictionary dictionary];
    selectedTitleAtt[NSForegroundColorAttributeName] = kThemeColor;
    selectedTitleAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:11];
    [childController.tabBarItem setTitleTextAttributes:titleAtt forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:selectedTitleAtt forState:UIControlStateSelected];
//    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -6);
    
    
    
    //    childController.view.backgroundColor = CCRandomColor;
    
    RootNavigationController *nvc = [[RootNavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nvc];
}

-(BOOL)shouldAutorotate{
    // 在预览界面要支持横屏
    UIViewController *currentController = [UIViewController currentViewController];
    if ([currentController isKindOfClass:NSClassFromString(@"ShootingController")]) {
        return false;
    }
    return true;
}
@end
