//
//  NSAttributedString+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSAttributedString+KKCategory.h"
#import "YYKit.h"
@implementation NSAttributedString (KKCategory)
- (CGFloat (^)(CGFloat width))kkHeight {
    return ^CGFloat(CGFloat width) {
        UILabel *label = [UILabel new];
        label.attributedText = self;
        return [label.attributedText boundingRectWithSize:CGSizeMake(width, LONG_MAX) options:0 context:nil].size.height;
    };
}
@end

@implementation NSMutableAttributedString (KKCategory)

/*!  */
+ (instancetype)string:(NSString *)string {
    return [[NSMutableAttributedString alloc] initWithString:string?:@""];
}

- (NSMutableAttributedString *(^)(UIFont *font))kkFont {
    return ^NSMutableAttributedString *(UIFont *font) {
        self.font = font;
        return self;
    };
}

/*!  */
- (NSMutableAttributedString *(^)(UIColor *color))kkColor {
    return ^NSMutableAttributedString *(UIColor *color) {
        self.color = color;
        return self;
    };
}

@end
