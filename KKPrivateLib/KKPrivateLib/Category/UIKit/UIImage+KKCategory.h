//
//  UIImage+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMacro.h"

NS_ASSUME_NONNULL_BEGIN

#define KKResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define KKResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

#define KKImage(o) [UIImage imageNamed:o]

/*! 图片加载 */
/// 使用文件名(不带后缀名)创建一个UIImage对象，会被系统缓存，适用于大量复用的小资源图
#define KKImageMake(img) \
BeginIgnoreAvailabilityWarning \
(IOS_VERSION >= 8.0 ? \
[UIImage imageNamed:img inBundle:nil compatibleWithTraitCollection:nil] \
: [UIImage imageNamed:img]) \
EndIgnoreAvailabilityWarning
// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define KKFileImageMake(name) UIImageMakeWithFileAndSuffix(name, @"png")
// 使用文件名(带后缀名)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define KKFileAndSuffixImageMake(name, suffix) [UIImage \
imageWithContentsOfFile: \
[NSString stringWithFormat:@"%@/%@.%@", \
[[NSBundle mainBundle] resourcePath], name, suffix]]

@interface UIImage (KKCategory)

#pragma mark - Function
///=============================================================================
/// @name Bluring
///=============================================================================

/**
 Return a gaussian blur image.
 
 @param  bias value is added to the sum of weighted pixels before the divisor is applied.
 It can serve to both control rounding and adjust the brightness of the result.
 A large bias (e.g 128 * divisor) may be required for some kernels, such as edge
 detection filters, to return representable results.
 */
- (UIImage *)kkGaussianBlurWithBias:(NSInteger)bias;


///=============================================================================
/// @name Enhancing
///=============================================================================

/**
 Return a enhanced view.
 
 @param kCIImageAutoAdjustKey  Image auto adjustment keys.
 */
- (UIImage *)kkEnhanceWithKey:(NSString *)kCIImageAutoAdjustKey;

///=============================================================================
/// @name Reflection
///=============================================================================

- (UIImage *)kkReflectWithHeight:(NSUInteger)height
                       fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha;

#pragma mark - Rotation
///=============================================================================
/// @name Rotation
///=============================================================================

/**
 Returns a new rotated image (relative to the center).
 
 @param radians   Rotated radians in counterclockwise. ⟲
 @param fitSize   YES: new image's size is extend to fit all content.
 NO: image's size will not change, content may be clipped.
 */
- (UIImage *)kkImageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 Returns a new image rotated counterclockwise by a quarter‑turn (90°). ⤺
 The width and height will be exchanged.
 */
- (UIImage *)kkImageByRotateLeft90;

/**
 Returns a new image rotated clockwise by a quarter‑turn (90°). ⤼
 The width and height will be exchanged.
 */
- (UIImage *)kkImageByRotateRight90;

/**
 Returns a new image rotated 180° . ↻
 */
- (UIImage *)kkImageByRotate180;

/**
 Returns a vertically flipped image. ⥯
 */
- (UIImage *)kkImageByFlipVertical;

/**
 Returns a horizontally flipped image. ⇋
 */
- (UIImage *)kkImageByFlipHorizontal;


#pragma mark - Resizing
///=============================================================================
/// @name Resizing
///=============================================================================

/**
 Returns a new image which is edge inset from this image.
 
 @param insets  Inset (positive) for each of the edges, values can be negative to 'outset'.
 @param color   Extend edge's fill color, nil means clear color.
 @return        The new image, or nil if an error occurs.
 */
- (UIImage *)kkImageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color;



#pragma mark - Image Effect
///=============================================================================
/// @name Image Effect
///=============================================================================

/**
 Tint the image in alpha channel with the given color.
 
 @param color  The color.
 */
- (UIImage *)kkImageByTintColor:(UIColor *)color;


/**
 Returns a color image.
 */
+ (UIImage *)kkImageFromColor:(UIColor *)color;
+ (UIImage *)kkRoundRectWithRadius:(CGFloat)r width:(CGFloat)w height:(CGFloat)h color:(UIColor *)color;
- (id)kkRoundedRectSize:(CGSize)size radius:(NSInteger)r;
+ (UIImage *)kkRoundWithRadius:(CGFloat)r width:(CGFloat)w height:(CGFloat)h color:(UIColor *)color;

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** Return image width,  if image=nil return 0 */
- (CGFloat)kkWidth;
/** Return image height, if image=nil return 0 */
- (CGFloat)kkHeight;
/** Return image width/height if image=nil return 0 */
- (CGFloat)kkRatio;


@end

NS_ASSUME_NONNULL_END
