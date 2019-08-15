//
//  UILabel+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UILabel+KKCategory.h"

@implementation UILabel (KKCategory)
/*! 接收 id(NSString or NSAttributeString) */
- (void)kkText:(id)string {
    if ([string isKindOfClass:[NSString class]]) {
        self.text = string;
    } else if ([string isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = string;
    }
}
@end
