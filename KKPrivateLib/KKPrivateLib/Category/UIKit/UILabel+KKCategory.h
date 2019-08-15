//
//  UILabel+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (KKCategory)
/*! 接收 id(NSString or NSAttributeString) */
- (void)kkText:(id)string;
@end

NS_ASSUME_NONNULL_END
