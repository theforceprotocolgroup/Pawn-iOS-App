//
//  UIButton+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIButton+KKCategory.h"
#import <objc/runtime.h>
#import "UIColor+KKCategory.h"
#import "UIImage+KKCategory.h"
#import "KKConfig.h"

@implementation UIButton (KKCategory)
static char kkButtonTypeKey;
static char kkTitleKey;

#pragma mark - Associated

- (KKButtonType)kkButtonType {
    return [objc_getAssociatedObject(self, &kkButtonTypeKey) integerValue];
}

- (void)setKkButtonType:(KKButtonType)kkButtonType {
    [self configButtonUI:kkButtonType];
    objc_setAssociatedObject(@(kkButtonType), &kkButtonTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)kkTitle {
    return objc_getAssociatedObject(self, &kkTitleKey);
}

- (void)setKkTitle:(NSString *)kkTitle {
    [self setTitle:kkTitle forState:UIControlStateNormal];
    objc_setAssociatedObject(kkTitle, &kkButtonTypeKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark -
///=============================================================================
/// @name UI
///=============================================================================

- (void)configButtonUI:(KKButtonType)kkButtonType {
    switch (kkButtonType) {
        case KKButtonTypeCustom:
            break;
        case KKButtonTypePriSolid:
            [self configSolidUI];
            break;
        case KKButtonTypePriHollow:
            [self configHollowUI];
            break;
        default:
            break;
    }
}

- (void)configHollowUI {
    self.layer.borderWidth = 1;
    self.layer.borderColor = KKBtnHollowBorderColor.CGColor;
    [self setTitleColor:KKBtnHollowTitleNomalColor forState:UIControlStateNormal];
    [self setTitleColor:KKBtnHollowTitleDiableColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnHollowBgDisableColor]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnHollowBgNomalColor]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnHollowBgHighlightColor]
                    forState:UIControlStateHighlighted];
}

- (void)kkConfigHollowUI:(UIColor *)norColor {
    self.layer.borderWidth = 1;
    self.layer.borderColor = norColor.CGColor;
    [self setTitleColor:norColor forState:UIControlStateNormal];
    [self setTitleColor:KKHexColor(999999) forState:UIControlStateDisabled];
}


- (void)configSolidUI {
    self.layer.borderWidth = 0;
    [self setTitleColor:KKBtnSolidTitleNomalColor forState:UIControlStateNormal];
    [self setTitleColor:KKBtnSolidTitleDiableColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnSolidBgDisableColor]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnSolidBgNomalColor]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage kkImageFromColor:KKBtnSolidBgHighlightColor]
                    forState:UIControlStateHighlighted];
//    self.layer.shadowColor = [UIColor colorWithRed:68/255.0 green:112/255.0 blue:228/255.0 alpha:0.29].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0,3);
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowRadius = 6;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 22;
}
@end
