//
//  UIViewController+BackButtonHandler.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIViewController+BackButtonHandler.h"
#import <objc/runtime.h>

@implementation UIViewController (BackButtonHandler)

@end

static NSString *const kOriginDelegate = @"kOriginDelegate";

@implementation UINavigationController (ShouldPopOnBackButton)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(new_viewDidLoad);
        
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originMethod),
                                method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)new_viewDidLoad {
    [self new_viewDidLoad];
    
    objc_setAssociatedObject(self, [kOriginDelegate UTF8String], self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

#pragma mark - 按钮

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    id<UIViewControllerTransitionCoordinator> tc = [self topViewController].transitionCoordinator;
    if (!tc) return YES;
    UIViewController *fromVC = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    if([fromVC respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        return [fromVC navigationShouldPopOnBackButton];
    }
    if([fromVC respondsToSelector:@selector(navigationPopActiveForType:)]) {
        return [fromVC navigationPopActiveForType:KKBackTypeButton];
    }
    return YES;
}

#pragma mark - 手势

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        UIViewController *vc = [self topViewController];
        if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
            return [vc navigationShouldPopOnBackButton];
        }
        id<UIGestureRecognizerDelegate> originDelegate = objc_getAssociatedObject(self, [kOriginDelegate UTF8String]);
        return [originDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

@end
