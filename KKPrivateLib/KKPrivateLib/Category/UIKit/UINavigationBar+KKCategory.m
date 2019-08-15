//
//  UINavigationBar+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UINavigationBar+KKCategory.h"
#import <objc/runtime.h>
#import "KKMacro.h"
#import "UIDevice+KKCategory.h"
#import "UIColor+KKCategory.h"
#import "UIImage+KKCategory.h"
@implementation UINavigationBar (KKCategory)

#pragma mark - Property
///=============================================================================
/// @name Property
///=============================================================================

- (UIView *)overlay {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, @selector(overlay), overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)kkBarColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkBarColor:(UIColor *)kkBarColor {
    objc_setAssociatedObject(self, @selector(kkBarColor), kkBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kkSetBackgroundColor:kkBarColor];
}

- (CGFloat)kkTranslationY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setKkTranslationY:(CGFloat)kkTranslationY {
    objc_setAssociatedObject(self, @selector(kkTranslationY), @(kkTranslationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kkSetTranslationY:kkTranslationY];
}

- (CGFloat)kkAlpha {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setKkAlpha:(CGFloat)kkAlpha {
    objc_setAssociatedObject(self, @selector(kkAlpha), @(kkAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kkSetElementsAlpha:kkAlpha];
}

- (BOOL)kkHairlineHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKkHairlineHidden:(BOOL)kkHairlineHidden {
    objc_setAssociatedObject(self, @selector(kkHairlineHidden), @(kkHairlineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kkSetView:self hairlineHidden:kkHairlineHidden];
}

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

- (void)setOverlayerHidden:(BOOL)hidden {
    self.overlay.hidden = hidden;
}

- (void)kkSetView:(UIView *)view hairlineHidden:(BOOL)kkHairlineHidden {
    UIImageView *hairlineView = [self findHairlineImageViewUnder:view];
    if (hairlineView) hairlineView.hidden = kkHairlineHidden;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        UIImageView * imageview  = (UIImageView*)view;
        imageview.image = [UIImage kkImageFromColor:KKHexColor(e0e0e0)];
        return imageview;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            imageView.image = [UIImage kkImageFromColor:KKHexColor(e0e0e0)];
            return imageView;
        }
    }
    return nil;
}

- (void)kkSetElementsAlpha:(CGFloat)alpha {
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)kkSetTranslationY:(CGFloat)y {
    self.transform =  CGAffineTransformMakeTranslation(0, y);
}

- (void)kkSetBackgroundColor:(UIColor *)color {
    if (!color) {
        [self kkResetBar];
        return;
    }
    
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGFloat height = CGRectGetHeight(self.bounds);
        if (iPhoneX) {
            self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), height> 44?height:height+StatusBarHeight)];
        }else
        {
            self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), height> 44?height:height+StatusBarHeight)];
        }
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = color;
}

- (void)kkResetBar {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}



@end
