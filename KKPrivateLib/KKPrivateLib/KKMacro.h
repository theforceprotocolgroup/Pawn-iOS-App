//
//  KKMacro.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sys/time.h>
#import <pthread.h>
#import <objc/runtime.h>

#ifndef KKMacro_h
#define KKMacro_h

//用来适配ios11废弃
#define MAIN(block) if ([NSThread isMainThread]) block(); else dispatch_async(dispatch_get_main_queue(),block)


#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 KKSYNTH_DUMMY_CLASS(NSString_YYAdd)
 */
#ifndef KKSYNTH_DUMMY_CLASS
#define KKSYNTH_DUMMY_CLASS(_name_) \
@interface KKSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation KKSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


////////////////////////////////////////////////////////////////////////////////
#if TARGET_IPHONE_SIMULATOR
#define KKLog( s, ... ) NSLog( @"[%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] \
lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define KKLog( s, ... )
#endif
////////////////////////////////////////////////////////////////////////////////


#pragma mark - Dispatch Function
///=============================================================================
/// @name Dispatch Function
///=============================================================================

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1010)
#define DISPATCH_CANCELLATION_SUPPORTED 1
#else
#define DISPATCH_CANCELLATION_SUPPORTED 1
#endif

NS_INLINE dispatch_queue_t _Nullable KKDefaultQueue(void) {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

NS_INLINE dispatch_queue_t _Nullable KKCreateQueue(const char *_Nullable label) {
    return dispatch_queue_create(label, NULL);
}

NS_INLINE dispatch_queue_t _Nullable KKMainQueue(void) {
    return dispatch_get_main_queue();
}



NS_INLINE dispatch_time_t KKTimeDelay(NSTimeInterval t) {
    return dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * t));
}

NS_INLINE BOOL KKSupportDispatchCancellation(void) {
#if DISPATCH_CANCELLATION_SUPPORTED
    return (&dispatch_block_cancel != NULL);
#else
    return NO;
#endif
}

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

#define KKPadding(L6) (DEVICE_HEIGHT >= 667 ? L6/2.0 : L6/2.3)
#define KKPlusPadding(L6) (DEVICE_HEIGHT >= 667 ? (DEVICE_HEIGHT >= 736 ? L6/1.81 : L6/2.0) : L6/2.3)
#define UFNarrow(L6, L5) (DEVICE_WIDTH == 320 ? L5 : L6)

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

/*!  */
/// Convert degrees to radians.
static inline CGFloat KKDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/// Convert radians to degrees.
static inline CGFloat KKRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

#pragma mark - 变量-编译相关
///=============================================================================
/// @name 变量-编译相关
///=============================================================================

/// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif

/// 使用iOS7 API时要加`ifdef IOS7_SDK_ALLOWED`的判断
#ifndef __IPHONE_7_0
#define __IPHONE_7_0 70000
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define IOS7_SDK_ALLOWED YES
#endif

/// 使用iOS8 API时要加`ifdef IOS8_SDK_ALLOWED`的判断
#ifndef __IPHONE_8_0
#define __IPHONE_8_0 80000
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define IOS8_SDK_ALLOWED YES
#endif

/// 使用iOS9 API时要加`ifdef IOS9_SDK_ALLOWED`的判断
#ifndef __IPHONE_9_0
#define __IPHONE_9_0 90000
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define IOS9_SDK_ALLOWED YES
#endif

/// 使用iOS10 API时要加`ifdef IOS10_SDK_ALLOWED`的判断
#ifndef __IPHONE_10_0
#define __IPHONE_10_0 100000
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#define IOS10_SDK_ALLOWED YES
#endif

///
#define BeginIgnorePerformSelectorLeaksWarning _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
#define EndIgnorePerformSelectorLeaksWarning _Pragma("clang diagnostic pop")

#define BeginIgnoreAvailabilityWarning _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wpartial-availability\"")
#define EndIgnoreAvailabilityWarning _Pragma("clang diagnostic pop")

#define BeginIgnoreDeprecatedWarning _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
#define EndIgnoreDeprecatedWarning _Pragma("clang diagnostic pop")

#pragma mark - 变量-设备相关
///=============================================================================
/// @name 变量-设备相关
///=============================================================================

/// 设备类型


/// 操作系统版本号
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

/*! 是否横竖屏 */
/// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
/// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/*! 屏幕宽度 */
/// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH (IOS_VERSION >= 8.0 ? \
[[UIScreen mainScreen] bounds].size.width : \
(IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : \
[[UIScreen mainScreen] bounds].size.width))
/// 屏幕宽度，跟横竖屏无关
#define DEVICE_WIDTH (IOS_VERSION >= 8.0 ? \
(IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : \
[[UIScreen mainScreen] bounds].size.width) : \
[[UIScreen mainScreen] bounds].size.width)
/// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT (IOS_VERSION >= 8.0 ? \
[[UIScreen mainScreen] bounds].size.height : \
(IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : \
[[UIScreen mainScreen] bounds].size.height))
/// 屏幕高度，跟横竖屏无关
#define DEVICE_HEIGHT (IOS_VERSION >= 8.0 ? \
(IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : \
[[UIScreen mainScreen] bounds].size.height) : \
[[UIScreen mainScreen] bounds].size.height)

/// 是否支持动态字体
#define IS_RESPOND_DYNAMICTYPE [UIApplication \
instancesRespondToSelector:@selector(preferredContentSizeCategory)]

/// 设备屏幕尺寸
//#define IS_55INCH_SCREEN [QMUIHelper is55InchScreen]
//#define IS_47INCH_SCREEN [QMUIHelper is47InchScreen]
//#define IS_40INCH_SCREEN [QMUIHelper is40InchScreen]
//#define IS_35INCH_SCREEN [QMUIHelper is35InchScreen]

#define Height_NavBar  ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define Height_StatusBar ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define Height_NavBar ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define Height_TabBar ((iPhoneX==YES || iPhoneXR ==YES || iPhoneXS== YES || iPhoneXSMax== YES) ? 83.0 : 49.0)

#pragma mark - 变量-布局相关
///=============================================================================
/// @name 变量-布局相关
///=============================================================================

/// 屏幕尺寸
#define ScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
/// 屏幕像素级尺寸
#define ScreenNativeBoundsSize (IOS_VERSION >= 8.0 ? \
([[UIScreen mainScreen] nativeBounds].size) : ScreenBoundsSize)
/// 缩放比例
#define ScreenScale ([[UIScreen mainScreen] scale])
#define ScreenNativeScale (IOS_VERSION >= 8.0 ? \
([[UIScreen mainScreen] nativeScale]) : ScreenScale)
/// 区分设备是否处于放大模式（iPhone 6及以上的设备支持放大模式）
#define ScreenInDisplayZoomMode (ScreenNativeScale > ScreenScale)

// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)
#define StatusBarHeight (IOS_VERSION >= 8.0 ? \
([[UIApplication sharedApplication] statusBarFrame].size.height) : \
(IS_LANDSCAPE ? \
([[UIApplication sharedApplication] statusBarFrame].size.width) : \
([[UIApplication sharedApplication] statusBarFrame].size.height)))

#pragma mark - 方法-创建器
///=============================================================================
/// @name 方法-创建器
///=============================================================================



#pragma mark - 方法-C对象、结构操作
///=============================================================================
/// @name 方法-C对象、结构操作
///=============================================================================

/*! 基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *  eg: 例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE float flatfSpecificScale(float floatValue, float scale) {
    scale = scale == 0 ? ScreenScale : scale;
    CGFloat flattedValue = ceilf(floatValue * scale) / scale;
    return flattedValue;
}

/*! 基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flatf() 函数。
 */
CG_INLINE float flatf(float floatValue) {
    return flatfSpecificScale(floatValue, 0);
}

/*! 类似flatf()，只不过 flatf 是向上取整，而 floorfInPixel 是向下取整 */
CG_INLINE float floorfInPixel(float floatValue) {
    CGFloat resultValue = floorf(floatValue * ScreenScale) / ScreenScale;
    return resultValue;
}

CG_INLINE BOOL betweenf(float minimumValue, float value, float maximumValue) {
    return minimumValue < value && value < maximumValue;
}

CG_INLINE BOOL betweenOrEqualf(float minimumValue, float value, float maximumValue) {
    return minimumValue <= value && value <= maximumValue;
}


#pragma mark - 方法-CGFloat
///=============================================================================
/// @name 方法-CGFloat
///=============================================================================

/// 用于居中运算
CG_INLINE CGFloat CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flatf((parent - child) / 2.0);
}

#pragma mark - CGPoint
///=============================================================================
/// @name 方法 - CGPoint
///=============================================================================

/// 两个point相加
CG_INLINE CGPoint CGPointUnion(CGPoint point1, CGPoint point2) {
    return CGPointMake(flatf(point1.x + point2.x), flatf(point1.y + point2.y));
}

/// 获取rect的center，包括rect本身的x/y偏移
CG_INLINE CGPoint CGPointGetCenterWithRect(CGRect rect) {
    return CGPointMake(flatf(CGRectGetMidX(rect)), flatf(CGRectGetMidY(rect)));
}

/// 获取size的center
CG_INLINE CGPoint CGPointGetCenterWithSize(CGSize size) {
    return CGPointMake(flatf(size.width / 2.0), flatf(size.height / 2.0));
}

#pragma mark - UIEdgeInsets
///=============================================================================
/// @name 方法 - UIEdgeInsets
///=============================================================================

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

/// 将两个UIEdgeInsets合并为一个
CG_INLINE UIEdgeInsets UIEdgeInsetsConcat(UIEdgeInsets insets1, UIEdgeInsets insets2) {
    insets1.top += insets2.top;
    insets1.left += insets2.left;
    insets1.bottom += insets2.bottom;
    insets1.right += insets2.right;
    return insets1;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsSetTop(UIEdgeInsets insets, CGFloat top) {
    insets.top = flatf(top);
    return insets;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsSetLeft(UIEdgeInsets insets, CGFloat left) {
    insets.left = flatf(left);
    return insets;
}
CG_INLINE UIEdgeInsets UIEdgeInsetsSetBottom(UIEdgeInsets insets, CGFloat bottom) {
    insets.bottom = flatf(bottom);
    return insets;
}

CG_INLINE UIEdgeInsets UIEdgeInsetsSetRight(UIEdgeInsets insets, CGFloat right) {
    insets.right = flatf(right);
    return insets;
}

#pragma mark - CGSize
///=============================================================================
/// @name 方法 - CGSize
///=============================================================================

/// 判断一个size是否为空（宽或高为0）
CG_INLINE BOOL CGSizeIsEmpty(CGSize size) {
    return size.width <= 0 || size.height <= 0;
}

/// 将一个CGSize像素对齐
CG_INLINE CGSize CGSizeFlatted(CGSize size) {
    return CGSizeMake(flatf(size.width), flatf(size.height));
}

/// 将一个 CGSize 以 pt 为单位向上取整
CG_INLINE CGSize CGSizeCeil(CGSize size) {
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

/// 将一个 CGSize 以 pt 为单位向下取整
CG_INLINE CGSize CGSizeFloor(CGSize size) {
    return CGSizeMake(floorf(size.width), floorf(size.height));
}

#pragma mark - CGRect
///=============================================================================
/// @name 方法 - CGRect
///=============================================================================

/// 判断一个CGRect是否存在NaN
CG_INLINE BOOL CGRectIsNaN(CGRect rect) {
    return isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height);
}

/// 创建一个像素对齐的CGRect
CG_INLINE CGRect CGRectFlatMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(flatf(x), flatf(y), flatf(width), flatf(height));
}

/// 对CGRect的x/y、width/height都调用一次flatf，以保证像素对齐
CG_INLINE CGRect CGRectFlatted(CGRect rect) {
    return CGRectMake(flatf(rect.origin.x), flatf(rect.origin.y), flatf(rect.size.width), flatf(rect.size.height));
}

/// 为一个CGRect叠加scale计算
CG_INLINE CGRect CGRectApplyScale(CGRect rect, CGFloat scale) {
    return CGRectFlatted(CGRectMake(CGRectGetMinX(rect) * scale,
                                    CGRectGetMinY(rect) * scale, CGRectGetWidth(rect) * scale, CGRectGetHeight(rect) * scale));
}

/// 计算view的水平居中，传入父view和子view的frame，返回子view在水平居中时的x值
CG_INLINE CGFloat CGRectGetMinXHorizontallyCenterInParentRect(CGRect parentRect, CGRect childRect) {
    return flatf((CGRectGetWidth(parentRect) - CGRectGetWidth(childRect)) / 2.0);
}

/// 计算view的垂直居中，传入父view和子view的frame，返回子view在垂直居中时的y值
CG_INLINE CGFloat CGRectGetMinYVerticallyCenterInParentRect(CGRect parentRect, CGRect childRect) {
    return flatf((CGRectGetHeight(parentRect) - CGRectGetHeight(childRect)) / 2.0);
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持垂直居中时，layoutingRect的originY
CG_INLINE CGFloat CGRectGetMinYVerticallyCenter(CGRect referenceRect, CGRect layoutingRect) {
    return CGRectGetMinY(referenceRect) + CGRectGetMinYVerticallyCenterInParentRect(referenceRect, layoutingRect);
}

/// 返回值：同一个坐标系内，想要layoutingRect和已布局完成的referenceRect保持水平居中时，layoutingRect的originX
CG_INLINE CGFloat CGRectGetMinXHorizontallyCenter(CGRect referenceRect, CGRect layoutingRect) {
    return CGRectGetMinX(referenceRect) + CGRectGetMinXHorizontallyCenterInParentRect(referenceRect, layoutingRect);
}

/// 为给定的rect往内部缩小insets的大小
CG_INLINE CGRect CGRectInsetEdges(CGRect rect, UIEdgeInsets insets) {
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= UIEdgeInsetsGetHorizontalValue(insets);
    rect.size.height -= UIEdgeInsetsGetVerticalValue(insets);
    return rect;
}

/// 传入size，返回一个x/y为0的CGRect
CG_INLINE CGRect CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/// 修改CGRect的Top
CG_INLINE CGRect CGRectFloatTop(CGRect rect, CGFloat top) {
    rect.origin.y = top;
    return rect;
}

/// 修改CGRect的Bottom
CG_INLINE CGRect CGRectFloatBottom(CGRect rect, CGFloat bottom) {
    rect.origin.y = bottom - CGRectGetHeight(rect);
    return rect;
}

/// 修改CGRect的Right
CG_INLINE CGRect CGRectFloatRight(CGRect rect, CGFloat right) {
    rect.origin.x = right - CGRectGetWidth(rect);
    return rect;
}

/// 修改CGRect的Left
CG_INLINE CGRect CGRectFloatLeft(CGRect rect, CGFloat left) {
    rect.origin.x = left;
    return rect;
}

/// 保持rect的左边缘不变，改变其宽度，使右边缘靠在right上
CG_INLINE CGRect CGRectLimitRight(CGRect rect, CGFloat rightLimit) {
    rect.size.width = rightLimit - rect.origin.x;
    return rect;
}

/// 保持rect右边缘不变，改变其宽度和origin.x，使其左边缘靠在left上。只适合那种右边缘不动的view
/// 先改变origin.x，让其靠在offset上
/// 再改变size.width，减少同样的宽度，以抵消改变origin.x带来的view移动，从而保证view的右边缘是不动的
CG_INLINE CGRect CGRectLimitLeft(CGRect rect, CGFloat leftLimit) {
    CGFloat subOffset = leftLimit - rect.origin.x;
    rect.origin.x = leftLimit;
    rect.size.width = rect.size.width - subOffset;
    return rect;
}

/// 限制rect的宽度，超过最大宽度则截断，否则保持rect的宽度不变
CG_INLINE CGRect CGRectLimitMaxWidth(CGRect rect, CGFloat maxWidth) {
    CGFloat width = CGRectGetWidth(rect);
    rect.size.width = width > maxWidth ? maxWidth : width;
    return rect;
}

/// 修改CGRect的x值
CG_INLINE CGRect CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = flatf(x);
    return rect;
}

/// 修改CGRect的y值
CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = flatf(y);
    return rect;
}

/// 修改CGRect的x、y值
CG_INLINE CGRect CGRectSetXY(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x = flatf(x);
    rect.origin.y = flatf(y);
    return rect;
}

/// 修改CGRect的width值
CG_INLINE CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = flatf(width);
    return rect;
}

/// 修改CGRect的height值
CG_INLINE CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
  rect.size.height = flatf(height);
 return rect;
}

/// 修改CGRect的size值
CG_INLINE CGRect CGRectSetSize(CGRect rect, CGSize size) {
    rect.size = CGSizeFlatted(size);
    return rect;
}


#define KKWeakObj(o)   autoreleasepool{} __weak   typeof(o) o##Weak = o;
#define KKStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#endif /* KKMacro_h */
