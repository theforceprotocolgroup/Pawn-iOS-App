//
//  UIView+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KKCategory)

#pragma mark - Snapshot
///=============================================================================
/// @name Snapshot
///=============================================================================

/*! Create a snapshot from view.
 @return Returns a bitmap image with the same contents and dimensions as the receiver.
 */
- (UIImage *)kkSnapshotImage;

#pragma mark - Tap Size
///=============================================================================
/// @name Tap Size
///=============================================================================

/*! 允许扩大按钮的点击范围 */
- (void)kkExtendHitTestSizeByWidth:(CGFloat)width
                            height:(CGFloat)height;

/*! 测试扩大的点击范围 */
- (void)kkVisuallyExtendHitTestSizeByWidth:(CGFloat)width
                                    height:(CGFloat)height;

#pragma mark - Gesture
///=============================================================================
/// @name Gesture
///=============================================================================

/*! 添加Tap手势 */
- (void)kkAddTapAction:(KKActionHandle)block;

/*! 添加Pan手势 */
- (void)kkAddPanAction:(KKActionHandle)block;

/*! 添加LongPress手势 */
- (void)kkAddLongPressAction:(KKActionHandle)block;

#pragma mark - 直接获取控件的frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
//等宽适配
+ (float)getHeight:(float)defaultW defaultH:(float)defaultH;

@end

NS_ASSUME_NONNULL_END
