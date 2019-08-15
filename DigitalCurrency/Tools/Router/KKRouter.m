//
//  KKRouter.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKRouter.h"
NSString * const LoginVCString        = @"native://login";         ///< 登录界面
NSString * const BorrowVCString        = @"native://borrow";           ///< 借币
NSString * const LoanVCString        = @"native://loan";           ///< 出借
NSString * const AssetVCString     = @"native://asset";      ///< 资产
NSString * const MineVCString     = @"native://mine";      ///< 我的
NSString * const RegisterVCString  = @"native://register";
NSString * const MoneyVCString        = @"native://money";         ///< 登录界面

@implementation KKRouter
+ (BFTask *)pushUri:(NSString *)uriString {
    return [self pushUri:uriString params:nil];
}

+ (BFTask *)pushUri:(NSString *)uriString params:(id)data {
    return [self pushUri:uriString params:data navi:nil];
}

+ (BFTask *)pushUri:(NSString *)uriString navi:(UINavigationController *)navi {
    return [self pushUri:uriString params:nil navi:navi];
}

+ (BFTask *)pushUri:(NSString *)uriString params:(id)data navi:(UINavigationController *)navi {
    if (!([uriString isKindOfClass:[NSString class]] && uriString.length)) return nil;
    
    if ([uriString hasPrefix:@"http"]) {
        // 网页
        return [self pushWebUrl:uriString params:data navi:navi];
    } else if ([uriString hasPrefix:@"native:"]) {
        // URI
        return [self pushUriString:uriString data:data navi:navi];
    } else {
        return [self pushViewControllerWithVC:uriString data:data navi:navi];
    }
}

+ (BFTask *)popUri:(NSString *)uriString {
    if (!([uriString isKindOfClass:[NSString class]] && uriString.length)) return nil;
    UINavigationController *temp = [self topNavi];
    for (UIViewController *vc in temp.childViewControllers) {
        if ([vc isKindOfClass:[NSClassFromString(uriString) class]]) {
            [temp popToViewController:vc animated:YES];
            return nil;
        }
    }
    [temp popToRootViewControllerAnimated:YES];
    return nil;
}

#pragma mark -
///=============================================================================
/// @name
///=============================================================================

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

/*! 解析 URI 参数 */
+ (NSDictionary *)paraDict:(NSString *)para {
    if (!para) return nil;
    para = [para stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *arr = [para componentsSeparatedByString:@"&"];
    [arr kkEach:^(NSString *obj) {
        NSArray *keyValue = [obj componentsSeparatedByString:@"="];
        [dict setValue:keyValue.kkLastObject?:@"" forKey:keyValue.kkFirstObject];
    }];
    return dict;
}

/*! 解析 URI 路径 */
+ (NSArray<UIViewController *> *)pathArr:(NSString *)path {
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    return [[self vcsFromArr:[arr kkFilter:^BOOL(NSString *obj) {
        return obj.length;
    }]] kkMap:^id(NSString *each) {
        UIViewController *vc = [[NSClassFromString(each) alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        NSParameterAssert(vc);
        return vc;
    }];
}

+ (NSArray<UIViewController *> *)vcsFromArr:(NSArray *)arr {
    return [arr kkMap:^id(NSString *each) {
        if ([[self.mapDict allKeys] containsObject:each])
            return self.mapDict[each];
        return each;
    }];
}

+ (BFTask *)pushUriString:(NSString *)uri
                     data:(id)data
                     navi:(UINavigationController *)navi {
    NSURL *url = [NSURL URLWithString:uri];
    NSString *vcString = self.mapDict[url.host];
    id dict = [self paraDict:url.query];
    if (!dict) dict = data;
    if ([url.host isEqualToString:@"login"]) {
        return [self presentVcString:@"LoginViewController" data:dict navi:navi];
    }else if ([url.host isEqualToString:@"register"])
    {
        return [self presentVcString:@"RegistViewController" data:@(NO) navi:navi];
    }
    else if ([self.tabMapArr containsObject:url.host]) {
        NSInteger index = [self.tabMapArr indexOfObject:url.host];
        if (!url.path.length) {
            UINavigationController *temp = navi ?: self.navi;
            if (!self.tabBar || self.tabBar.selectedIndex == index) {
                [temp popToRootViewControllerAnimated:YES];
            } else {
                [temp popToRootViewControllerAnimated:NO];
                self.tabBar.selectedIndex = index;
            }
            UIViewController *vc = [self.navi.childViewControllers kkObjectAtIndex:0];
            if ([vc conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
                [vc respondsToSelector:@selector(routerPassParamters:)]) {
                [(id<KKRouterDataDelegate>)vc routerPassParamters:dict];
            }
        } else {
            NSArray *arr = [self pathArr:url.path];
            UINavigationController *temp = navi ?: [self topNavi];
            BOOL isCur = !self.tabBar || index == self.tabBar.selectedIndex;
            if(!isCur) self.tabBar.selectedIndex = index;
            __block BFTask *task;
            UINavigationController *toNavi = self.tabBar?self.tabBar.viewControllers[index]:temp;
            NSArray *mutArr = [@[toNavi.viewControllers[0]] addArr:arr];
            if ([mutArr.kkLastObject conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
                [mutArr.kkLastObject respondsToSelector:@selector(delegateTask)]) {
                task = [(id<KKRouterDataDelegate>)mutArr.kkLastObject delegateTask];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setViewControllersWithVCs:mutArr data:dict navi:toNavi];
                if (!isCur) [temp popToRootViewControllerAnimated:NO];
            });
            return task;
        }
        return nil;
    } else if (![self.tabMapArr containsObject:url.host]) {
        UINavigationController *temp = navi ?: [self topNavi];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp.viewControllers];
        NSString *hostVCStrin = self.mapDict[url.host]?:url.host;
        UIViewController *vc = [[NSClassFromString(hostVCStrin) alloc] init];
        NSParameterAssert(vc);
        [arr appendObject:vc];
        if (url.path) [arr appendObjects:[self pathArr:url.path]];
        return [self setViewControllersWithVCs:arr data:dict navi:temp];
    } else {
        return [self pushViewControllerWithVC:vcString data:dict navi:navi];
    }
}

+ (BFTask *)presentVcString:(NSString *)vcString data:(id)data navi:(UINavigationController *)navi {
    UIViewController *vc = [[NSClassFromString(vcString) alloc] init];
    UINavigationController *toNavi = [[UINavigationController alloc] initWithRootViewController:vc];
    [toNavi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:KKHexColor(4c5b61)}];
    [toNavi.navigationBar setTintColor:KKHexColor(ffffff)];
    NSParameterAssert(vc);
    if (!vc) return nil;
    if (data && [vc conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vc respondsToSelector:@selector(routerPassParamters:)]) {
        [(id<KKRouterDataDelegate>)vc routerPassParamters:data];
    }
    UINavigationController *temp = navi ?: [self topNavi];
    if (!temp) return nil;
    [temp.visibleViewController presentViewController:toNavi animated:YES completion:^{
        
    }];
    if ([vc conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vc respondsToSelector:@selector(delegateTask)]) {
        return [(id<KKRouterDataDelegate>)vc delegateTask];
    }
    return nil;
}

/*! 跳转网页 */
+ (BFTask *)pushWebUrl:(NSString *)urlString params:(id)data navi:(UINavigationController *)navi {
    return [self pushViewControllerWithVC:@"KKWebViewController" data:RACTuplePack(urlString, data) navi:navi];
}

+ (BFTask *)setViewControllersWithVCs:(NSArray<UIViewController *> *)vcArr
                                 data:(id)data navi:(UINavigationController *)navi {
    if (!vcArr.count) return nil;
    if (data && [vcArr.kkLastObject conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vcArr.kkLastObject respondsToSelector:@selector(routerPassParamters:)]) {
        [(id<KKRouterDataDelegate>)vcArr.kkLastObject routerPassParamters:data];
    }
    UINavigationController *temp = navi ?: [self topNavi];
    if (!temp) return nil;
    [temp setViewControllers:vcArr animated:YES];
    if ([vcArr.kkLastObject conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vcArr.kkLastObject respondsToSelector:@selector(delegateTask)]) {
        return [(id<KKRouterDataDelegate>)vcArr.kkLastObject delegateTask];
    }
    return nil;
}

+ (BFTask *)pushViewControllerWithVC:(NSString *)vcString data:(id)data navi:(UINavigationController *)navi {
    UIViewController *vc = [[NSClassFromString(vcString) alloc] init];
    NSParameterAssert(vc);
    if (!vc) return nil;
    if (data && [vc conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vc respondsToSelector:@selector(routerPassParamters:)]) {
        [(id<KKRouterDataDelegate>)vc routerPassParamters:data];
    }
    UINavigationController *temp = navi ?: [self topNavi];
    if (!temp) return nil;
    [temp pushViewController:vc animated:YES];
    if ([vc conformsToProtocol:@protocol(KKRouterDataDelegate)] &&
        [vc respondsToSelector:@selector(delegateTask)]) {
        return [(id<KKRouterDataDelegate>)vc delegateTask];
    }
    return nil;
}

#pragma mark - Navi
///=============================================================================
/// @name Navi
///=============================================================================

+ (UINavigationController *)topNavi {
    UIViewController *topVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    while ([topVC presentedViewController]) {
        topVC = [topVC presentedViewController];
    }
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = [(UITabBarController *)topVC selectedViewController];
    }
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topVC;
    }
    return nil;
}

+ (UITabBarController *)tabBar {
    id vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)vc;
    }
    return nil;
}

+ (UINavigationController *)navi {
    id vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)vc selectedViewController];
    }
    return vc;
}

#pragma mark - mapDict
///=============================================================================
/// @name mapDict
///=============================================================================

+ (NSArray *)tabMapArr {
    static NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"borrow",@"loan",@"money",@"asset",@"mine"];
    });
    return arr;
}

+ (NSDictionary *)mapDict {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 @"money" : @"BorrowMoneyViewController",
                 @"borrow" : @"BorrowHomwPageViewController",
                 @"login" : @"LoginViewController",
                 @"mine" : @"MineHomePageViewController",
                 @"loan" : @"LoanHomePageViewController",
                 @"asset" : @"AssetHomePageViewController",
                 @"register" : @"RegistViewController",
                 };
    });
    return dict;
}

@end
