//
//  KKTabBarManager.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKTabBarManager.h"
#import "AppDelegate.h"
#import "ViewController.h"
@implementation KKTabBarManager

#pragma mark - Custom
///=============================================================================
/// @name Custom
///=============================================================================

+ (NSArray *)viewControllerClass {
    static NSArray *mutArr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mutArr = @[
                   @"BorrowHomwPageViewController",
                   @"LoanHomePageViewController",
                   @"BorrowMoneyViewController",
                   @"AssetHomePageViewController",
                   @"MineHomePageViewController",
                   ];
    });
    return mutArr;
}

+ (NSArray *)tabBarItemTitle {
    static NSArray *mutArr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mutArr = @[@"借币", @"出借",@"借款", @"资产", @"我的"];
    });
    return mutArr;
}

+ (NSArray *)tabBarNomarlImage {
    return @[@"tab_borrow_uns", @"tab_loan_uns",@"tab_money_uns", @"tab_asset_uns", @"tab_mine_uns"];
}

+ (NSArray *)tabBarSelectedImage {
    return @[@"tab_borrow_sel", @"tab_loan_sel",@"tab_money_sel", @"tab_asset_sel", @"tab_mine_sel"];
}

+ (UITabBarController *)customTabBarVC {
    UITabBarController *tabBarVC = [UITabBarController new];
//    UIColor *color = KKHexColor(465062);
//    [tabBarVC.tabBar setTintColor:color];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: KKHexColor(465062), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: KKHexColor(757E97), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,KKHexColor(e0e0e0).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UITabBar appearance] setShadowImage:img];
    [[UITabBar appearance]setBackgroundImage:[UIImage new]];
    return tabBarVC;
}

+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]addObserverForName: UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
         [self setup];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

+ (void)setup {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    appDelegate.window.backgroundColor = [UIColor whiteColor];
    ViewController *home = [[NSClassFromString(@"ViewController") alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    homeNav.navigationBar.kkBarColor = KKHexColor(444444);
    appDelegate.window.rootViewController = [self tabBar];
    [appDelegate.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Root" object:nil];
}

+ (UITabBarController *)tabBar {
    UITabBarController *tabBarVC = [self customTabBarVC];
    tabBarVC.viewControllers = [self tabBarViewControllers];
//    tabBarVC.delegate = [KKTabBarManager manager].delegate;
    return tabBarVC;
}

+ (NSArray *)tabBarViewControllers {
    NSArray *clasArray = [self viewControllerClass];
    NSMutableArray *mutArr = [NSMutableArray array];
    [clasArray enumerateObjectsUsingBlock:^(NSString *vcString, NSUInteger index, BOOL *stop) {
        UINavigationController *navi = [self naviWithVCClass:NSClassFromString(vcString) index:index];
        if (navi) [mutArr addObject:navi];
    }];
    return mutArr;
}

+ (UINavigationController *)naviWithVCClass:(Class)class index:(NSInteger)dataIndex {
    UIViewController *vc = (UIViewController *)[class new];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:KKHexColor(ffffff)}];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.tabBarItem.title = [self tabBarItemTitle][dataIndex];
    navi.tabBarItem.image = [[UIImage imageNamed:[self tabBarNomarlImage][dataIndex]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navi.tabBarItem.selectedImage = [[UIImage imageNamed:[self tabBarSelectedImage][dataIndex]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return navi;
}


@end
