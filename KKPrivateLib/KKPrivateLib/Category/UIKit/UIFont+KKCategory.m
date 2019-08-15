//
//  UIFont+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIFont+KKCategory.h"

@implementation UIFont (KKCategory)

/*! 英文、数字字体 */
+ (UIFont *)cnFont:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}
+ (UIFont *)cnBFont:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}
/*! 中文字体 */
+ (UIFont *)enFont:(CGFloat)size {
    return [UIFont fontWithName:@"Helvetica" size:size];
}
+ (UIFont *)enBFont:(CGFloat)size {
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}

+ (UIFont *)thirdFont:(CGFloat)size;
{
    return [UIFont fontWithName:@"DIN-Medium" size:size];
}

@end
