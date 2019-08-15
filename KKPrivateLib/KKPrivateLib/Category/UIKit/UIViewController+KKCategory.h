//
//  UIViewController+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KKCategory)

#pragma mark - NavigationBar Custom
///=============================================================================
/// @name NavigationBar Custom
///=============================================================================

/*! Hides the hairline view at the bottom of a navigation bar.  */
@property (nonatomic, assign) BOOL kkHairlineHidden;

/*! Navigtaion Bar Color. */
@property (nonatomic, strong) UIColor *kkBarColor;
/*! */
@property (nonatomic, strong) UIColor *kkBarTintColor;
/*! */
@property (nonatomic, strong) UIImage *kkNaviImage;

/*!
 Indicate this view controller prefers its navigation bar hidden or not,
 Default to NO.
 */
@property (nonatomic, assign) BOOL kkBarHidden;
/*! 左上角按钮 */
@property (nonatomic, assign) BOOL kkLeftBarItemHidden;
/*! 左上角颜色 */
@property (nonatomic, strong) UIColor *kkLeftBarItemColor;

#pragma mark - InteractivePop Custom
///=============================================================================
/// @name InteractivePop Custom
///=============================================================================

/*!
 Whether the interactive pop gesture is disabled when contained
 in a navigation.
 */
@property (nonatomic, assign) BOOL kkPopGestureEnbled;

/*!
 Max allowed initial distance to left edge when you begin the interactive pop
 gesture.
 */
@property (nonatomic, assign) CGFloat kkDistanceToLeftEdge;


#pragma mark -
///=============================================================================
/// @name Keyboard
///=============================================================================

- (void)autoDismissKeyboard;



@end

NS_ASSUME_NONNULL_END
