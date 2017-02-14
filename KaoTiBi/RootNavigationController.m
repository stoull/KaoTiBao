//
//  RootNavigationController.m
//  LeYaoXiu
//
//  Created by AChang on 5/17/16.
//  Copyright © 2016 AChang. All rights reserved.
//

#import "RootNavigationController.h"

@implementation RootNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    __weak id<UINavigationControllerDelegate> seakSelf = self;
    self.delegate = seakSelf;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)initialize
{
    // 设置整个工程的navgationBar的样式
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:kThemeColor];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [bar setTintColor:[UIColor whiteColor]];
    
    bar.translucent = NO;
//    bar.barStyle = UIBarStyleBlackTranslucent;
    
    // 设置整个工程的uibarbuttonItem的样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //    UIBarButtonItem *item = [UINavigationBar appearance];
    
    
    // 普通状态下的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // disable状态下的样式
    NSMutableDictionary *distableTextAttrs = [NSMutableDictionary dictionary];
    distableTextAttrs[NSForegroundColorAttributeName] = kDisableStatusColor;
    distableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:distableTextAttrs forState:UIControlStateDisabled];
    
}

#pragma mark - Navigation

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (self.viewControllers.count > 0) {
//        // 边距
////        UIBarButtonItem *navigationSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
////        navigationSpace.width = -6;
////        UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"bank" highImage:@"bank"];
////        
////        backItem.tag = (NSInteger)animated;
////        
////        viewController.navigationItem.leftBarButtonItems = @[navigationSpace, backItem];
//////        viewController.navigationItem.leftBarButtonItem = backItem;
//        
//    }
//    else
//    {
//        
//    }
//    [super pushViewController:viewController animated:animated];
//}


#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count < 2) {
        if ([viewController isKindOfClass:NSClassFromString(@"SetingTableViewController")]) {
            self.navigationBar.hidden = NO;
        }else{
            self.navigationBar.hidden = YES;
        }
        self.tabBarController.tabBar.hidden = NO;
    }else {
        if ([viewController isKindOfClass:NSClassFromString(@"PhotoEidtController")]) {
            self.navigationBar.hidden = YES;
        }else{
            self.navigationBar.hidden = NO;
        }
        self.tabBarController.tabBar.hidden = YES;
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

@end
