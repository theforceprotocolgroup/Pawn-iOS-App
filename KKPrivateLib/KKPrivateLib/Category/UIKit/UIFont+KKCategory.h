//
//  UIFont+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*! 系统字体 */
#define KKCNFont(A)           [UIFont cnFont:A]
/*! 英文字体-Helvetica */
#define KKENFont(A)           [UIFont enFont:A]
/*! 系统加粗字体 */
#define KKCNBFont(A)          [UIFont cnBFont:A]
/*! 英文加粗字体-Helvetica */
#define KKENBFont(A)          [UIFont enBFont:A]

#define KKThirdFont(A)         [UIFont thirdFont:A]
@interface UIFont (KKCategory)

/*! 系统字体 */
+ (UIFont *)cnFont:(CGFloat)size;
+ (UIFont *)cnBFont:(CGFloat)size;
/*! 英文、数字字体 */
+ (UIFont *)enFont:(CGFloat)size;
+ (UIFont *)enBFont:(CGFloat)size;

+ (UIFont *)thirdFont:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
