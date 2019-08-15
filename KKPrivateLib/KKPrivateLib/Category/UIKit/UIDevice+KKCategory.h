//
//  UIDevice+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Hardware string of devices
 */
static NSString* const iPhone1_1 = @"iPhone1,1";
static NSString* const iPhone1_2 = @"iPhone1,2";
static NSString* const iPhone2_1 = @"iPhone2,1";
static NSString* const iPhone3_1 = @"iPhone3,1";
static NSString* const iPhone3_2 = @"iPhone3,2";
static NSString* const iPhone3_3 = @"iPhone3,3";
static NSString* const iPhone4_1 = @"iPhone4,1";
static NSString* const iPhone5_1 = @"iPhone5,1";
static NSString* const iPhone5_2 = @"iPhone5,2";
static NSString* const iPhone5_3 = @"iPhone5,3";
static NSString* const iPhone5_4 = @"iPhone5,4";
static NSString* const iPhone6_1 = @"iPhone6,1";
static NSString* const iPhone6_2 = @"iPhone6,2";
static NSString* const iPhone7_1 = @"iPhone7,1";
static NSString* const iPhone7_2 = @"iPhone7,2";
static NSString* const iPhone8_1 = @"iPhone8,1";
static NSString* const iPhone8_2 = @"iPhone8,2";
static NSString* const iPhone8_4 = @"iPhone8,4";
static NSString* const iPhone9_1 = @"iPhone9,1";
static NSString* const iPhone9_2 = @"iPhone9,2";
static NSString* const iPhone9_3 = @"iPhone9,3";
static NSString* const iPhone9_4 = @"iPhone9,4";
static NSString* const iPhone10_1 = @"iPhone10,1";
static NSString* const iPhone10_2 = @"iPhone10,2";
static NSString* const iPhone10_3 = @"iPhone10,3";
static NSString* const iPhone10_4 = @"iPhone10,4";
static NSString* const iPhone10_5 = @"iPhone10,5";
static NSString* const iPhone10_6 = @"iPhone10,6";


static NSString* const iPod1_1 = @"iPod1,1";
static NSString* const iPod2_1 = @"iPod2,1";
static NSString* const iPod3_1 = @"iPod3,1";
static NSString* const iPod4_1 = @"iPod4,1";
static NSString* const iPod5_1 = @"iPod5,1";
static NSString* const iPod7_1 = @"iPod7,1";

static NSString* const iPad1_1 = @"iPad1,1";
static NSString* const iPad1_2 = @"iPad1,2";
static NSString* const iPad2_1 = @"iPad2,1";
static NSString* const iPad2_2 = @"iPad2,2";
static NSString* const iPad2_3 = @"iPad2,3";
static NSString* const iPad2_4 = @"iPad2,4";
static NSString* const iPad2_5 = @"iPad2,5";
static NSString* const iPad2_6 = @"iPad2,6";
static NSString* const iPad2_7 = @"iPad2,7";
static NSString* const iPad3_1 = @"iPad3,1";
static NSString* const iPad3_2 = @"iPad3,2";
static NSString* const iPad3_3 = @"iPad3,3";
static NSString* const iPad3_4 = @"iPad3,4";
static NSString* const iPad3_5 = @"iPad3,5";
static NSString* const iPad3_6 = @"iPad3,6";
static NSString* const iPad4_1 = @"iPad4,1";
static NSString* const iPad4_2 = @"iPad4,2";
static NSString* const iPad4_3 = @"iPad4,3";
static NSString* const iPad4_4 = @"iPad4,4";
static NSString* const iPad4_5 = @"iPad4,5";
static NSString* const iPad4_6 = @"iPad4,6";
static NSString* const iPad4_7 = @"iPad4,7";
static NSString* const iPad4_8 = @"iPad4,8";
static NSString* const iPad4_9 = @"iPad4,9";
static NSString* const iPad5_1 = @"iPad5,1";
static NSString* const iPad5_2 = @"iPad5,2";
static NSString* const iPad5_3 = @"iPad5,3";
static NSString* const iPad5_4 = @"iPad5,4";
static NSString* const iPad6_3 = @"iPad6,3";
static NSString* const iPad6_4 = @"iPad6,4";
static NSString* const iPad6_7 = @"iPad6,7";
static NSString* const iPad6_8 = @"iPad6,8";

static NSString* const i386_Sim    = @"i386";
static NSString* const x86_64_Sim  = @"x86_64";


typedef NS_ENUM(NSUInteger, Hardware) {
    NOT_AVAILABLE,
    
    IPHONE_2G,
    IPHONE_3G,
    IPHONE_3GS,
    
    IPHONE_4,
    IPHONE_4_CDMA,
    IPHONE_4S,
    
    IPHONE_5,
    IPHONE_5_CDMA_GSM,
    IPHONE_5C,
    IPHONE_5C_CDMA_GSM,
    IPHONE_5S,
    IPHONE_5S_CDMA_GSM,
    
    IPHONE_6,
    IPHONE_6_PLUS,
    IPHONE_6S,
    IPHONE_6S_PLUS,
    IPHONE_SE,
    
    IPOD_TOUCH_1G,
    IPOD_TOUCH_2G,
    IPOD_TOUCH_3G,
    IPOD_TOUCH_4G,
    IPOD_TOUCH_5G,
    IPOD_TOUCH_6G,
    
    IPAD,
    IPAD_2,
    IPAD_2_WIFI,
    IPAD_2_CDMA,
    IPAD_3,
    IPAD_3G,
    IPAD_3_WIFI,
    IPAD_3_WIFI_CDMA,
    IPAD_4,
    IPAD_4_WIFI,
    IPAD_4_GSM_CDMA,
    
    IPAD_MINI,
    IPAD_MINI_WIFI,
    IPAD_MINI_WIFI_CDMA,
    IPAD_MINI_RETINA_WIFI,
    IPAD_MINI_RETINA_WIFI_CDMA,
    IPAD_MINI_3_WIFI,
    IPAD_MINI_3_WIFI_CELLULAR,
    IPAD_MINI_3_WIFI_CELLULAR_CN,
    IPAD_MINI_4_WIFI,
    IPAD_MINI_4_WIFI_CELLULAR,
    
    IPAD_MINI_RETINA_WIFI_CELLULAR_CN,
    
    IPAD_AIR_WIFI,
    IPAD_AIR_WIFI_GSM,
    IPAD_AIR_WIFI_CDMA,
    IPAD_AIR_2_WIFI,
    IPAD_AIR_2_WIFI_CELLULAR,
    
    IPAD_PRO_97_WIFI,
    IPAD_PRO_97_WIFI_CELLULAR,
    
    IPAD_PRO_WIFI,
    IPAD_PRO_WIFI_CELLULAR,
    
    SIMULATOR
};


@interface UIDevice (KKCategory)

#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)
+ (float)kkSystemVersion;

/// @see http://theiphonewiki.com/wiki/Models
/// This property retruns the hardware type (e.g. iPhone6,1  iPad4,6)
@property (nonatomic, readonly) NSString *kkHardwareString;

/// This property returns the Hardware enum depending upon harware string
@property (nonatomic, readonly) Hardware kkHardware;

/// This property returns the readable description of hardware string
@property (nonatomic, readonly) NSString *kkHardwareDescription;

/// This property returs the readble description without identifier (GSM, CDMA, GLOBAL, CELLULAR)
@property (nonatomic, readonly) NSString *kkHardwareSimpleDescription;

/**
 This method returns the resolution for still image that can be received
 from back camera of the current device. Resolution returned for image
 oriented landscape right.
 */
@property (nonatomic, readonly) CGSize kkBackCameraStillImageResolutionInPixels;

/// The System's startup time.
@property (nonatomic, readonly) NSDate *kkSystemUptime;


#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111" (IP)
@property (nonatomic, readonly) NSString *kkIpAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nonatomic, readonly) NSString *kkIpAddressCell;

/// Return device mac Address
- (NSString *)kkMacAddress;

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkDiskSpace;

/// Free disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkDiskSpaceFree;

/// Used disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkDiskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kkMemoryPurgable;


#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger kkCpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float kkCpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nonatomic, readonly) NSArray *kkCpuUsagePerProcessor;

/// CPU frequency
- (NSUInteger)kkCpuFrequency;
/// CPU processor
- (NSUInteger)kkBusFrequency;


@end


/**
 iOS version
 */
#ifndef sSystemVersion
#define sSystemVersion [UIDevice kkSystemVersion]
#endif
#ifndef siOS6Later
#define siOS6Later (sSystemVersion >= 6)
#endif
#ifndef siOS7Later
#define siOS7Later (sSystemVersion >= 7)
#endif
#ifndef siOS8Later
#define siOS8Later (sSystemVersion >= 8)
#endif
#ifndef siOS9Later
#define siOS9Later (sSystemVersion >= 9)
#endif
#ifndef siOS10Later
#define siOS10Later (sSystemVersion >= 10)
#endif
#ifndef siOS11Later
#define siOS11Later (sSystemVersion >= 11)
#endif
#ifndef siOS12Later
#define siOS12Later (sSystemVersion >= 12)
#endif

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define iPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

NS_ASSUME_NONNULL_END
