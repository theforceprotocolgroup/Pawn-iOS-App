//
//  NSAttributedString+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KKMultiAttriString(o) [NSMutableAttributedString string:o]

@interface NSAttributedString (KKCategory)

- (CGFloat (^)(CGFloat width))kkHeight;

@end

@interface NSMutableAttributedString (KKCategory)
/*!  */
+ (instancetype)string:(NSString *)string;
/*!  */
- (NSMutableAttributedString *(^)(UIFont *font))kkFont;
/*!  */
- (NSMutableAttributedString *(^)(UIColor *color))kkColor;
@end
NS_ASSUME_NONNULL_END
