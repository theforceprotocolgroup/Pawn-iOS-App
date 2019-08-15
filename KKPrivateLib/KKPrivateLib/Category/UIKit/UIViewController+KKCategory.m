//
//  UIViewController+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIViewController+KKCategory.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import "UINavigationBar+KKCategory.h"
#import "UIViewController+BackButtonHandler.h"
#import "UIColor+KKCategory.h"
#import "KKMacro.h"
#import "UINavigationBar+KKCategory.h"
#import "NSArray+KKCategory.h"
#import "YYKit.h"
#import "KKConfig.h"
#import "UIDevice+KKCategory.h"


@class KKNavigationRecognizerDelegate;

typedef void (^kkInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (FDFullscreenPopGesturePrivate)
@property (nonatomic, copy) kkInjectBlock kkInjectBlock;
@property (nonatomic, strong) UINavigationBar *kkTransitionNavigationBar;
@property (nonatomic, assign) BOOL kkPrefersNavigationBarBackgroundViewHidden;
@end

@implementation UIViewController (KKCategory)
+ (void)load {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
                                   UIViewController *vc = [aspectInfo instance];
                                   if (vc.kkInjectBlock) {
                                       vc.kkInjectBlock(vc, animated);
                                   }
                                   [self refreshLeftBarItem:vc];
                               } error:NULL];
    [self addNavigationBarSwitchStyle];
}

+ (void)refreshLeftBarItem:(UIViewController *)vc {

    UIImage *image = [UIImage imageNamed:KK_Nav_Bg_Img];
    vc.navigationController.navigationBar.tintColor = vc.kkLeftBarItemColor?:KKNaviBarTintColor;
    [vc.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:vc.kkBarTintColor?:KKNaviBarTintColor}];
    if (vc.navigationController.viewControllers.count<=1 && vc.kkLeftBarItemHidden) {
        vc.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    }else
    {
        UIImage * leftImage = vc.kkLeftBarItemColor ? image : [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftTap:)];
//
//
        UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBarButton.frame = CGRectMake(0, 0, 25, 25);
        [leftBarButton setImage:leftImage forState:UIControlStateNormal];
        [leftBarButton addTarget:self action:@selector(leftTap:) forControlEvents:UIControlEventTouchUpInside];
////
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
//        UIBarButtonItem *space_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        space_item.width = -15;
//        vc.navigationItem.leftBarButtonItems =@[space_item,item];
//        vc.navigationItem.backBarButtonItem = leftBarItem;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        vc.navigationController.navigationBar.backIndicatorImage = leftImage;
//        vc.navigationController.navigationBar.backIndicatorTransitionMaskImage = nil;
//        vc.navigationItem.backBarButtonItem = backItem;
        //配置返回按钮距离屏幕边缘的距离
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width =  siOS11Later ? 0 : -7.5;
        if (siOS11Later) {
            leftBarButton.contentEdgeInsets =UIEdgeInsetsMake(0, -7.5,0, 0);
            leftBarButton.imageEdgeInsets =UIEdgeInsetsMake(0, -7.5,0, 0);
        }
        vc.navigationItem.leftBarButtonItems = @[spaceItem,item];
    }
}

+ (void)leftTap:(UIBarButtonItem *)item {
    UIViewController *vc = [self topNavi].topViewController;
    BOOL isBool = YES;
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        isBool = [vc navigationShouldPopOnBackButton];
    }
    if([vc respondsToSelector:@selector(navigationPopActiveForType:)]) {
        isBool = [vc navigationPopActiveForType:KKBackTypeButton];
    }
    if (isBool) {
        [[self topNavi] popViewControllerAnimated:YES];
    }
}


+ (UINavigationController *)topNavi {
    UIViewController *topVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    while ([topVC presentedViewController]) {
        topVC = [topVC presentedViewController];
    }
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = [(UITabBarController *)topVC selectedViewController];
    }
    return (UINavigationController *)topVC;
}

- (kkInjectBlock)kkInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkInjectBlock:(kkInjectBlock)kkInjectBlock {
    objc_setAssociatedObject(self, @selector(kkInjectBlock), kkInjectBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Navigation Bar
///=============================================================================
/// @name Navigation Bar
///=============================================================================

- (BOOL)kkBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKkBarHidden:(BOOL)kkBarHidden {
    objc_setAssociatedObject(self, @selector(kkBarHidden), @(kkBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kkLeftBarItemHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKkLeftBarItemHidden:(BOOL)kkLeftBarItemHidden {
    objc_setAssociatedObject(self, @selector(kkLeftBarItemHidden), @(kkLeftBarItemHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)kkHairlineHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}



- (void)setKkHairlineHidden:(BOOL)kkHairlineHidden {
    objc_setAssociatedObject(self, @selector(kkHairlineHidden), @(kkHairlineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationController.navigationBar.kkHairlineHidden = kkHairlineHidden;
}

- (UIColor *)kkBarColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkBarColor:(UIColor *)kkBarColor {
    objc_setAssociatedObject(self, @selector(kkBarColor), kkBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.navigationController.navigationBar.kkBarColor = kkBarColor;
}

- (UIColor *)kkBarTintColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkBarTintColor:(UIColor *)kkBarTintColor {
    objc_setAssociatedObject(self, @selector(kkBarTintColor), kkBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!kkBarTintColor) return;
    self.navigationController.navigationBar.barTintColor = kkBarTintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kkBarTintColor}];
}

- (UIImage *)kkNaviImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkNaviImage:(UIImage *)kkNaviImage {
    objc_setAssociatedObject(self, @selector(kkNaviImage), kkNaviImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar setBackgroundImage:kkNaviImage forBarMetrics:UIBarMetricsDefault];
}

- (UIColor *)kkLeftBarItemColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkLeftBarItemColor:(UIColor *)kkLeftBarItemColor {
    objc_setAssociatedObject(self, @selector(kkLeftBarItemColor), kkLeftBarItemColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Gesture
///=============================================================================
/// @name Gesture
///=============================================================================

- (BOOL)kkPopGestureEnbled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKkPopGestureEnbled:(BOOL)kkPopGestureEnbled {
    objc_setAssociatedObject(self, @selector(kkPopGestureEnbled), @(kkPopGestureEnbled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)kkDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setKkDistanceToLeftEdge:(CGFloat)kkDistanceToLeftEdge {
    objc_setAssociatedObject(self, @selector(kkPopGestureEnbled), @(kkDistanceToLeftEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark -
///=============================================================================
/// @name
///=============================================================================

+ (void)addNavigationBarSwitchStyle {
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
                                   [self hookViewDidAppear:(UIViewController *)[aspectInfo instance]];
                               } error:NULL];
    [UIViewController aspect_hookSelector:@selector(viewWillLayoutSubviews)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   [self hookViewWillLayoutSubviews:(UIViewController *)[aspectInfo instance]];
                               } error:NULL];
    [UIViewController aspect_hookSelector:@selector(viewDidLayoutSubviews)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   [self hookViewDidLayoutSubviews:(UIViewController *)[aspectInfo instance]];
                               } error:NULL];
}

+ (void)hookViewDidAppear:(UIViewController *)vc {
    if (vc.kkTransitionNavigationBar) {
        vc.kkBarTintColor = vc.kkBarTintColor?:KKNaviBarTintColor;
        [vc.navigationController.navigationBar setBackgroundImage:vc.kkNaviImage forBarMetrics:UIBarMetricsDefault];
        vc.navigationController.navigationBar.kkHairlineHidden = vc.kkHairlineHidden;
        vc.navigationController.navigationBar.kkBarColor = vc.kkBarColor?:KKNaviBarBgColor;
        [vc.kkTransitionNavigationBar removeFromSuperview];
        vc.kkTransitionNavigationBar = nil;
    } else {
        if (vc.kkNaviImage) {
            [vc.navigationController.navigationBar setBackgroundImage:vc.kkNaviImage forBarMetrics:UIBarMetricsDefault];
        }
    }
    vc.kkPrefersNavigationBarBackgroundViewHidden = vc.kkBarHidden;
}

+ (BOOL)isEqualVC:(UIViewController *)vc toVC:(UIViewController *)toVC {
    return [self compareA:vc.kkNaviImage B:toVC.kkNaviImage]
    && [self compareA:vc.kkBarColor B:toVC.kkBarColor]
    && [self compareA:@(vc.kkHairlineHidden) B:@(toVC.kkHairlineHidden)]
    && [self compareA:@(vc.kkBarHidden) B:@(toVC.kkBarHidden)]
    && [self compareA:vc.kkBarTintColor B:toVC.kkBarTintColor];
}
+ (BOOL)compareA:(id)A B:(id)B {
    if (!A && !B) return YES;
    if ([A isKindOfClass:UIImage.class]) {
        return [A isEqual:B];
    } else if ([A isKindOfClass:UIColor.class]) {
        return CGColorEqualToColor([(UIColor *)A CGColor], [(UIColor *)B CGColor]);
    } else if([A isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)A boolValue] == [(NSNumber *)B boolValue];
    }
    return NO;
}

+ (void)hookViewWillLayoutSubviews:(UIViewController *)vc {
    if (![vc isKindOfClass:UINavigationController.class]) return;
    id<UIViewControllerTransitionCoordinator> tc = vc.transitionCoordinator;
    if (!tc) return;
    UIViewController *fromVC = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([self isEqualVC:fromVC toVC:toVC]) return;
    
    if (!fromVC.kkTransitionNavigationBar) {
        fromVC.view.clipsToBounds = toVC.view.clipsToBounds = NO;
        [fromVC kkAddTransitionNavigationBarIfNeeded];
        [toVC kkAddTransitionNavigationBarIfNeeded];
        toVC.kkPrefersNavigationBarBackgroundViewHidden = YES;
        fromVC.navigationController.navigationBar.kkHairlineHidden = YES;
    }
    
}
+ (void)hookViewDidLayoutSubviews:(UIViewController *)vc {
//    if (vc.kkTransitionNavigationBar) {
//        vc.kkBarTintColor = vc.kkBarTintColor?:KKNaviBarTintColor;
//        [vc.navigationController.navigationBar setBackgroundImage:vc.kkNaviImage forBarMetrics:UIBarMetricsDefault];
//        vc.navigationController.navigationBar.kkHairlineHidden = vc.kkHairlineHidden;
//        vc.navigationController.navigationBar.kkBarColor = vc.kkBarColor?:KKNaviBarBgColor;
//        [vc.kkTransitionNavigationBar removeFromSuperview];
//        vc.kkTransitionNavigationBar = nil;
//    } else {
//        if (vc.kkNaviImage) {
//            [vc.navigationController.navigationBar setBackgroundImage:vc.kkNaviImage forBarMetrics:UIBarMetricsDefault];
//        }
//    }
    vc.navigationController.navigationBar.kkHairlineHidden = vc.kkHairlineHidden;
}
- (void)kkAddTransitionNavigationBarIfNeeded {
    if (self.kkBarHidden) return;
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar);
    CGFloat padding = self.navigationController.navigationBar.translucent ? (self.edgesForExtendedLayout == UIRectEdgeNone ? - Height_NavBar:0) : -Height_NavBar;
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, padding, rect.size.width, rect.size.height)];
    self.kkHairlineHidden = bar.shadowImage = self.kkHairlineHidden ?  [UIImage new] : self.navigationController.navigationBar.shadowImage;
    
    UIImage *image = self.kkNaviImage = self.kkNaviImage ?: [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    bar.kkBarColor = self.kkBarColor?:KKNaviBarBgColor;
    bar.kkHairlineHidden = self.kkHairlineHidden;
    
    self.kkBarTintColor = bar.barTintColor = self.kkBarTintColor ?: KKNaviBarTintColor;
    if (self.kkTransitionNavigationBar) [self.kkTransitionNavigationBar removeFromSuperview];
    
    self.kkTransitionNavigationBar = bar;
    
    if (!bar.subviews.count) {
        UIView *view = [[UIView alloc] initWithFrame:bar.bounds];
        view.backgroundColor = bar.kkBarColor;
        [bar addSubview:view];
        
        if (!self.kkHairlineHidden) {
            UIImageView *barImageView = [self.navigationController.navigationBar findHairlineImageViewUnder:self.navigationController.navigationBar];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:barImageView.image];
            imageView.frame = CGRectMake(0, Height_NavBar-0.5, bar.size.width, 0.5);
            imageView.image = barImageView.image;
            [view addSubview:imageView];
        }
    }
    [self.view addSubview:self.kkTransitionNavigationBar];
    
}

- (UINavigationBar *)kkTransitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkTransitionNavigationBar:(UINavigationBar *)navigationBar {
    objc_setAssociatedObject(self, @selector(kkTransitionNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)kkPrefersNavigationBarBackgroundViewHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKkPrefersNavigationBarBackgroundViewHidden:(BOOL)hidden {
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
     setHidden:hidden];
    [self.navigationController.navigationBar setOverlayerHidden:hidden];
    objc_setAssociatedObject(self, @selector(kkPrefersNavigationBarBackgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark -
///=============================================================================
/// @name Keyboard
///=============================================================================

- (void)autoDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - For NavigationController
////////////////////////////////////////////////////////////////////////////////

@interface KKNavigationRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
/*! */
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation KKNavigationRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        UIViewController *vc = self.navigationController.topViewController;
        if ([vc respondsToSelector:@selector(navigationPopActiveForType:)]) {
            [vc navigationPopActiveForType:KKBackTypeGesture];
        }
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.kkPopGestureEnbled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.kkDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    // 侧滑手势触发位置
    if ([self.navigationController.topViewController respondsToSelector:@selector(navigationPopActiveForType:)]) {
        return [self.navigationController.topViewController navigationPopActiveForType:KKBackTypeGesture];
    }
    
    return YES;
}

@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - For viewController
////////////////////////////////////////////////////////////////////////////////

@interface UINavigationController (KKNavigation)
/*! */
@property (nonatomic, strong) UIPanGestureRecognizer *kkPopGestureRecognaizer;
/*! */
@property (nonatomic, strong) KKNavigationRecognizerDelegate *kkPopDelegate;
@end

@implementation UINavigationController (KKViewController)
+ (void)load {
    [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:)
                                    withOptions:AspectPositionBefore
                                     usingBlock:^(id<AspectInfo> aspectInfo, UIViewController *viewController, BOOL animated) {
                                         [self kkPushViewController:viewController animated:animated navi:(UINavigationController *)[aspectInfo instance]];
                                     } error:NULL];
    [UINavigationController aspect_hookSelector:@selector(setViewControllers:animated:)
                                    withOptions:AspectPositionBefore
                                     usingBlock:^(id<AspectInfo> aspectInfo, NSArray *viewControllers, BOOL animated) {
                                         [self kkPushViewController:viewControllers.kkLastObject animated:animated navi:(UINavigationController *)[aspectInfo instance]];
                                     } error:NULL];
}

+ (void)kkPushViewController:(UIViewController *)toVC animated:(BOOL)animated
                        navi:(UINavigationController *)navi {
    if (navi.viewControllers.count>=1) {
        toVC.hidesBottomBarWhenPushed = YES;
    }
    /* Add gesture */
    if (![navi.interactivePopGestureRecognizer.view.gestureRecognizers
          containsObject:navi.kkPopGestureRecognaizer]) {
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [navi.interactivePopGestureRecognizer.view addGestureRecognizer:navi.kkPopGestureRecognaizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [navi.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        navi.kkPopGestureRecognaizer.delegate = navi.kkPopDelegate;
        [navi.kkPopGestureRecognaizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        navi.interactivePopGestureRecognizer.enabled = NO;
    }
    
    /* Judge the NavigationBar Appearance changed */
    [self isNavigationBarChanged:toVC navi:navi];
}

+ (void)isNavigationBarChanged:(UIViewController *)toVC
                          navi:(UINavigationController *)navi {
    kkInjectBlock block = ^(UIViewController *vc, BOOL animated) {
        if (navi.navigationBarHidden != vc.kkBarHidden) {
            [navi setNavigationBarHidden:vc.kkBarHidden animated:animated];
        }
    };
    toVC.kkInjectBlock = block;
    UIViewController *vc = navi.viewControllers.lastObject;
    if (vc && !vc.kkInjectBlock) {
        vc.kkInjectBlock = block;
    }
}

- (UIPanGestureRecognizer *)kkPopGestureRecognaizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (KKNavigationRecognizerDelegate *)kkPopDelegate {
    KKNavigationRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[KKNavigationRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}
@end
