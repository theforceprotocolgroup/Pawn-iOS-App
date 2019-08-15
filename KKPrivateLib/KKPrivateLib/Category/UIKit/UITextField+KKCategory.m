//
//  UITextField+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UITextField+KKCategory.h"
#import <objc/runtime.h>

@implementation UITextField (KKCategory)

- (void)setKkHolderFont:(UIFont *)holderFont {
    objc_setAssociatedObject(self, @selector(kkHolderFont), holderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:holderFont forKeyPath:@"_placeholderLabel.font"];
}
- (UIFont *)kkHolderFont {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKkHolderTextColor:(UIColor *)textColor {
    objc_setAssociatedObject(self, @selector(kkHolderTextColor), textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:textColor forKeyPath:@"_placeholderLabel.textColor"];
}
- (UIFont *)kkHolderTextColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKkRegex:(NSString *)kkRegex {
    objc_setAssociatedObject(self, @selector(kkRegex), kkRegex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)kkRegex {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)kkLength {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setKkLength:(NSInteger)kkLength {
    objc_setAssociatedObject(self, @selector(kkLength), @(kkLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
