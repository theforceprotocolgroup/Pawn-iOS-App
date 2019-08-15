//
//  UIDevice+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "UIDevice+KKCategory.h"
#import "KKMacro.h"

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
@implementation UIDevice (KKCategory)

#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)
+ (float)kkSystemVersion {
    static float version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.floatValue;
    });
    return version;
}

/** This method retruns the hardware type */
- (NSString *)kkHardwareString {
    static NSString *hardware;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int name[] = {CTL_HW,HW_MACHINE};
        size_t size = 100;
        sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
        char *hw_machine = malloc(size);
        
        sysctl(name, 2, hw_machine, &size, NULL, 0);
        hardware = [NSString stringWithUTF8String:hw_machine];
        free(hw_machine);
    });
    return hardware;
}

- (Hardware)kkHardware {
    static Hardware ware = NOT_AVAILABLE;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ware = [self kkWareString];
    });
    return ware;
}

- (NSString *)kkHardwareDescription {
    static NSString *hardware;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hardware = [self hardwareDescription];
    });
    return hardware;
}

- (NSString *)kkHardwareSimpleDescription {
    static NSString *hardware;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hardware = [self hardwareSimpleDescription];
    });
    return hardware;
}

- (CGSize)kkBackCameraStillImageResolutionInPixels {
    static CGSize pixels;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pixels = [self backCameraStillImageResolutionInPixels];
    });
    return pixels;
}

- (NSString *)hardwareDescription {
    NSString *hardware = [self kkHardwareString];
    if ([hardware isEqualToString:iPhone1_1])    return @"iPhone 2G";
    if ([hardware isEqualToString:iPhone1_2])    return @"iPhone 3G";
    if ([hardware isEqualToString:iPhone2_1])    return @"iPhone 3GS";
    
    if ([hardware isEqualToString:iPhone3_1])    return @"iPhone 4 (GSM)";
    if ([hardware isEqualToString:iPhone3_2])    return @"iPhone 4 (GSM Rev. A)";
    if ([hardware isEqualToString:iPhone3_3])    return @"iPhone 4 (CDMA)";
    if ([hardware isEqualToString:iPhone4_1])    return @"iPhone 4S";
    
    if ([hardware isEqualToString:iPhone5_1])    return @"iPhone 5 (GSM)";
    if ([hardware isEqualToString:iPhone5_2])    return @"iPhone 5 (Global)";
    if ([hardware isEqualToString:iPhone5_3])    return @"iPhone 5C (GSM)";
    if ([hardware isEqualToString:iPhone5_4])    return @"iPhone 5C (Global)";
    if ([hardware isEqualToString:iPhone6_1])    return @"iPhone 5S (GSM)";
    if ([hardware isEqualToString:iPhone6_2])    return @"iPhone 5S (Global)";
    
    if ([hardware isEqualToString:iPhone7_1])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:iPhone7_2])    return @"iPhone 6";
    if ([hardware isEqualToString:iPhone8_1])    return @"iPhone 6S";
    if ([hardware isEqualToString:iPhone8_2])    return @"iPhone 6S Plus";
    if ([hardware isEqualToString:iPhone8_4])    return @"iPhone SE";
    
    
    if ([hardware isEqualToString:iPhone9_1])    return @"iPhone 7";
    if ([hardware isEqualToString:iPhone9_2])    return @"iPhone 7 Plus";
    if ([hardware isEqualToString:iPhone9_3])    return @"iPhone 7";
    if ([hardware isEqualToString:iPhone9_4])    return @"iPhone 7 Plus";
    
    if ([hardware isEqualToString:iPhone10_1])    return @"iPhone 8";
    if ([hardware isEqualToString:iPhone10_2])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:iPhone10_3])    return @"iPhone X";
    if ([hardware isEqualToString:iPhone10_4])    return @"iPhone 8";
    if ([hardware isEqualToString:iPhone10_5])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:iPhone10_6])    return @"iPhone X";
    
    if ([hardware isEqualToString:iPod1_1])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:iPod2_1])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:iPod3_1])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:iPod4_1])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:iPod5_1])      return @"iPod Touch (5 Gen)";
    if ([hardware isEqualToString:iPod7_1])      return @"iPod Touch (7 Gen)";
    
    if ([hardware isEqualToString:iPad1_1])      return @"iPad (WiFi)";
    if ([hardware isEqualToString:iPad1_2])      return @"iPad 3G";
    
    if ([hardware isEqualToString:iPad2_1])      return @"iPad 2 (WiFi)";
    if ([hardware isEqualToString:iPad2_2])      return @"iPad 2 (GSM)";
    if ([hardware isEqualToString:iPad2_3])      return @"iPad 2 (CDMA)";
    if ([hardware isEqualToString:iPad2_4])      return @"iPad 2 (WiFi Rev. A)";
    if ([hardware isEqualToString:iPad2_5])      return @"iPad Mini (WiFi)";
    if ([hardware isEqualToString:iPad2_6])      return @"iPad Mini (GSM)";
    if ([hardware isEqualToString:iPad2_7])      return @"iPad Mini (CDMA)";
    
    if ([hardware isEqualToString:iPad3_1])      return @"iPad 3 (WiFi)";
    if ([hardware isEqualToString:iPad3_2])      return @"iPad 3 (CDMA)";
    if ([hardware isEqualToString:iPad3_3])      return @"iPad 3 (Global)";
    if ([hardware isEqualToString:iPad3_4])      return @"iPad 4 (WiFi)";
    if ([hardware isEqualToString:iPad3_5])      return @"iPad 4 (CDMA)";
    if ([hardware isEqualToString:iPad3_6])      return @"iPad 4 (Global)";
    
    if ([hardware isEqualToString:iPad4_1])      return @"iPad Air (WiFi)";
    if ([hardware isEqualToString:iPad4_2])      return @"iPad Air (WiFi+GSM)";
    if ([hardware isEqualToString:iPad4_3])      return @"iPad Air (WiFi+CDMA)";
    if ([hardware isEqualToString:iPad4_4])      return @"iPad Mini Retina (WiFi)";
    if ([hardware isEqualToString:iPad4_5])      return @"iPad Mini Retina (WiFi+CDMA)";
    if ([hardware isEqualToString:iPad4_6])      return @"iPad Mini Retina (WiFi+Cellular)";
    if ([hardware isEqualToString:iPad4_7])      return @"iPad Mini 3 (WiFi)";
    if ([hardware isEqualToString:iPad4_8])      return @"iPad Mini 3 (WiFi+Cellular)";
    if ([hardware isEqualToString:iPad4_9])      return @"iPad Mini 3 (WiFi+Cellular+CN)";
    
    if ([hardware isEqualToString:iPad5_1])      return @"iPad Mini 4 (WiFi)";
    if ([hardware isEqualToString:iPad5_2])      return @"iPad Mini 4 (WiFi+Cellular)";
    if ([hardware isEqualToString:iPad5_3])      return @"iPad Air 2 (WiFi)";
    if ([hardware isEqualToString:iPad5_4])      return @"iPad Air 2 (WiFi+Cellular)";
    
    if ([hardware isEqualToString:iPad6_7])      return @"iPad Pro (WiFi)";
    if ([hardware isEqualToString:iPad6_8])      return @"iPad Pro (WiFi+Cellular)";
    
    if ([hardware isEqualToString:i386_Sim])         return @"Simulator";
    if ([hardware isEqualToString:x86_64_Sim])       return @"Simulator";
    
    [self _kkLogMessage:hardware];
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    return @"";
}

- (NSString *)hardwareSimpleDescription {
    NSString *hardware = [self kkHardwareString];
    if ([hardware isEqualToString:iPhone1_1])    return @"iPhone 2G";
    if ([hardware isEqualToString:iPhone1_2])    return @"iPhone 3G";
    if ([hardware isEqualToString:iPhone2_1])    return @"iPhone 3GS";
    
    if ([hardware isEqualToString:iPhone3_1])    return @"iPhone 4";
    if ([hardware isEqualToString:iPhone3_2])    return @"iPhone 4";
    if ([hardware isEqualToString:iPhone3_3])    return @"iPhone 4";
    if ([hardware isEqualToString:iPhone4_1])    return @"iPhone 4S";
    
    if ([hardware isEqualToString:iPhone5_1])    return @"iPhone 5";
    if ([hardware isEqualToString:iPhone5_2])    return @"iPhone 5";
    if ([hardware isEqualToString:iPhone5_3])    return @"iPhone 5C";
    if ([hardware isEqualToString:iPhone5_4])    return @"iPhone 5C";
    if ([hardware isEqualToString:iPhone6_1])    return @"iPhone 5S";
    if ([hardware isEqualToString:iPhone6_2])    return @"iPhone 5S";
    
    if ([hardware isEqualToString:iPhone7_1])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:iPhone7_2])    return @"iPhone 6";
    if ([hardware isEqualToString:iPhone8_1])    return @"iPhone 6S";
    if ([hardware isEqualToString:iPhone8_2])    return @"iPhone 6S Plus";
    if ([hardware isEqualToString:iPhone8_4])    return @"iPhone SE";
    
    if ([hardware isEqualToString:iPhone9_1])    return @"iPhone 7";
    if ([hardware isEqualToString:iPhone9_2])    return @"iPhone 7 Plus";
    if ([hardware isEqualToString:iPhone9_3])    return @"iPhone 7";
    if ([hardware isEqualToString:iPhone9_4])    return @"iPhone 7 Plus";
    
    if ([hardware isEqualToString:iPhone10_1])    return @"iPhone 8";
    if ([hardware isEqualToString:iPhone10_2])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:iPhone10_3])    return @"iPhone X";
    if ([hardware isEqualToString:iPhone10_4])    return @"iPhone 8";
    if ([hardware isEqualToString:iPhone10_5])    return @"iPhone 8 Plus";
    if ([hardware isEqualToString:iPhone10_6])    return @"iPhone X";
    
    if ([hardware isEqualToString:iPod1_1])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:iPod2_1])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:iPod3_1])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:iPod4_1])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:iPod5_1])      return @"iPod Touch (5 Gen)";
    if ([hardware isEqualToString:iPod7_1])      return @"iPod Touch (7 Gen)";
    
    if ([hardware isEqualToString:iPad1_1])      return @"iPad";
    if ([hardware isEqualToString:iPad1_2])      return @"iPad";
    
    if ([hardware isEqualToString:iPad2_1])      return @"iPad 2";
    if ([hardware isEqualToString:iPad2_2])      return @"iPad 2";
    if ([hardware isEqualToString:iPad2_3])      return @"iPad 2";
    if ([hardware isEqualToString:iPad2_4])      return @"iPad 2";
    if ([hardware isEqualToString:iPad2_5])      return @"iPad Mini";
    if ([hardware isEqualToString:iPad2_6])      return @"iPad Mini";
    if ([hardware isEqualToString:iPad2_7])      return @"iPad Mini";
    
    if ([hardware isEqualToString:iPad3_1])      return @"iPad 3";
    if ([hardware isEqualToString:iPad3_2])      return @"iPad 3";
    if ([hardware isEqualToString:iPad3_3])      return @"iPad 3";
    if ([hardware isEqualToString:iPad3_4])      return @"iPad 4";
    if ([hardware isEqualToString:iPad3_5])      return @"iPad 4";
    if ([hardware isEqualToString:iPad3_6])      return @"iPad 4";
    
    if ([hardware isEqualToString:iPad4_1])      return @"iPad Air";
    if ([hardware isEqualToString:iPad4_2])      return @"iPad Air";
    if ([hardware isEqualToString:iPad4_3])      return @"iPad Air";
    if ([hardware isEqualToString:iPad4_4])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:iPad4_5])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:iPad4_6])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:iPad4_7])      return @"iPad Mini 3";
    if ([hardware isEqualToString:iPad4_8])      return @"iPad Mini 3";
    if ([hardware isEqualToString:iPad4_9])      return @"iPad Mini 3";
    
    if ([hardware isEqualToString:iPad5_1])      return @"iPad Mini 4";
    if ([hardware isEqualToString:iPad5_2])      return @"iPad Mini 4";
    if ([hardware isEqualToString:iPad5_3])      return @"iPad Air 2";
    if ([hardware isEqualToString:iPad5_4])      return @"iPad Air 2";
    
    if ([hardware isEqualToString:iPad6_3])      return @"iPad Pro (9.7inch)";
    if ([hardware isEqualToString:iPad6_4])      return @"iPad Pro (9.7inch)";
    if ([hardware isEqualToString:iPad6_7])      return @"iPad Pro (12.9inch)";
    if ([hardware isEqualToString:iPad6_8])      return @"iPad Pro (12.9inch)";
    
    if ([hardware isEqualToString:i386_Sim])         return @"Simulator";
    if ([hardware isEqualToString:x86_64_Sim])       return @"Simulator";
    
    [self _kkLogMessage:hardware];
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    
    return @"";
}

- (Hardware)kkWareString {
    NSString *hardware = [self kkHardwareString];
    if ([hardware isEqualToString:iPhone1_1])    return IPHONE_2G;
    if ([hardware isEqualToString:iPhone1_2])    return IPHONE_3G;
    if ([hardware isEqualToString:iPhone2_1])    return IPHONE_3GS;
    
    if ([hardware isEqualToString:iPhone3_1])    return IPHONE_4;
    if ([hardware isEqualToString:iPhone3_2])    return IPHONE_4;
    if ([hardware isEqualToString:iPhone3_3])    return IPHONE_4_CDMA;
    if ([hardware isEqualToString:iPhone4_1])    return IPHONE_4S;
    
    if ([hardware isEqualToString:iPhone5_1])    return IPHONE_5;
    if ([hardware isEqualToString:iPhone5_2])    return IPHONE_5_CDMA_GSM;
    if ([hardware isEqualToString:iPhone5_3])    return IPHONE_5C;
    if ([hardware isEqualToString:iPhone5_4])    return IPHONE_5C_CDMA_GSM;
    if ([hardware isEqualToString:iPhone6_1])    return IPHONE_5S;
    if ([hardware isEqualToString:iPhone6_2])    return IPHONE_5S_CDMA_GSM;
    
    if ([hardware isEqualToString:iPhone7_1])    return IPHONE_6_PLUS;
    if ([hardware isEqualToString:iPhone7_2])    return IPHONE_6;
    if ([hardware isEqualToString:iPhone8_1])    return IPHONE_6S;
    if ([hardware isEqualToString:iPhone8_2])    return IPHONE_6S_PLUS;
    
    if ([hardware isEqualToString:iPod1_1])      return IPOD_TOUCH_1G;
    if ([hardware isEqualToString:iPod2_1])      return IPOD_TOUCH_2G;
    if ([hardware isEqualToString:iPod3_1])      return IPOD_TOUCH_3G;
    if ([hardware isEqualToString:iPod4_1])      return IPOD_TOUCH_4G;
    if ([hardware isEqualToString:iPod5_1])      return IPOD_TOUCH_5G;
    if ([hardware isEqualToString:iPod7_1])      return IPOD_TOUCH_6G;
    
    if ([hardware isEqualToString:iPad1_1])      return IPAD;
    if ([hardware isEqualToString:iPad1_2])      return IPAD_3G;
    if ([hardware isEqualToString:iPad2_1])      return IPAD_2_WIFI;
    if ([hardware isEqualToString:iPad2_2])      return IPAD_2;
    if ([hardware isEqualToString:iPad2_3])      return IPAD_2_CDMA;
    if ([hardware isEqualToString:iPad2_4])      return IPAD_2;
    if ([hardware isEqualToString:iPad2_5])      return IPAD_MINI_WIFI;
    if ([hardware isEqualToString:iPad2_6])      return IPAD_MINI;
    if ([hardware isEqualToString:iPad2_7])      return IPAD_MINI_WIFI_CDMA;
    if ([hardware isEqualToString:iPad3_1])      return IPAD_3_WIFI;
    if ([hardware isEqualToString:iPad3_2])      return IPAD_3_WIFI_CDMA;
    if ([hardware isEqualToString:iPad3_3])      return IPAD_3;
    if ([hardware isEqualToString:iPad3_4])      return IPAD_4_WIFI;
    if ([hardware isEqualToString:iPad3_5])      return IPAD_4;
    if ([hardware isEqualToString:iPad3_6])      return IPAD_4_GSM_CDMA;
    if ([hardware isEqualToString:iPad4_1])      return IPAD_AIR_WIFI;
    if ([hardware isEqualToString:iPad4_2])      return IPAD_AIR_WIFI_GSM;
    if ([hardware isEqualToString:iPad4_3])      return IPAD_AIR_WIFI_CDMA;
    if ([hardware isEqualToString:iPad4_4])      return IPAD_MINI_RETINA_WIFI;
    if ([hardware isEqualToString:iPad4_5])      return IPAD_MINI_RETINA_WIFI_CDMA;
    if ([hardware isEqualToString:iPad4_6])      return IPAD_MINI_RETINA_WIFI_CELLULAR_CN;
    if ([hardware isEqualToString:iPad4_7])      return IPAD_MINI_3_WIFI;
    if ([hardware isEqualToString:iPad4_8])      return IPAD_MINI_3_WIFI_CELLULAR;
    if ([hardware isEqualToString:iPad4_9])      return IPAD_MINI_3_WIFI_CELLULAR_CN;
    if ([hardware isEqualToString:iPad5_1])      return IPAD_MINI_4_WIFI;
    if ([hardware isEqualToString:iPad5_2])      return IPAD_MINI_4_WIFI_CELLULAR;
    
    if ([hardware isEqualToString:iPad5_3])      return IPAD_AIR_2_WIFI;
    if ([hardware isEqualToString:iPad5_4])      return IPAD_AIR_2_WIFI_CELLULAR;
    
    if ([hardware isEqualToString:iPad6_7])      return IPAD_PRO_WIFI;
    if ([hardware isEqualToString:iPad6_8])      return IPAD_PRO_WIFI_CELLULAR;
    
    if ([hardware isEqualToString:i386_Sim])         return SIMULATOR;
    if ([hardware isEqualToString:x86_64_Sim])       return SIMULATOR;
    
    //log message that your device is not present in the list
    [self _kkLogMessage:hardware];
    
    return NOT_AVAILABLE;
}

- (CGSize)backCameraStillImageResolutionInPixels {
    switch ([self kkHardware]) {
        case IPHONE_2G:
        case IPHONE_3G:
            return CGSizeMake(1600, 1200);
            break;
        case IPHONE_3GS:
            return CGSizeMake(2048, 1536);
            break;
        case IPHONE_4:
        case IPHONE_4_CDMA:
        case IPAD_3_WIFI:
        case IPAD_3_WIFI_CDMA:
        case IPAD_3:
        case IPAD_4_WIFI:
        case IPAD_4:
        case IPAD_4_GSM_CDMA:
            return CGSizeMake(2592, 1936);
            break;
        case IPHONE_4S:
        case IPHONE_5:
        case IPHONE_5_CDMA_GSM:
        case IPHONE_5C:
        case IPHONE_5C_CDMA_GSM:
        case IPHONE_6:
        case IPHONE_6_PLUS:
        case IPAD_AIR_2_WIFI:
        case IPAD_AIR_2_WIFI_CELLULAR:
            return CGSizeMake(3264, 2448);
            break;
            
        case IPHONE_6S:
        case IPHONE_6S_PLUS:
            return CGSizeMake(4032, 3024);
            break;
            
        case IPOD_TOUCH_4G:
            return CGSizeMake(960, 720);
            break;
        case IPOD_TOUCH_5G:
            return CGSizeMake(2440, 1605);
            break;
            
        case IPAD_2_WIFI:
        case IPAD_2:
        case IPAD_2_CDMA:
            return CGSizeMake(872, 720);
            break;
            
        case IPAD_MINI_WIFI:
        case IPAD_MINI:
        case IPAD_MINI_WIFI_CDMA:
            return CGSizeMake(1820, 1304);
            break;
            
        case IPAD_PRO_97_WIFI:
        case IPAD_PRO_97_WIFI_CELLULAR:
            return CGSizeMake(4032, 3024);
            break;
            
        default:
            NSLog(@"We have no resolution for your device's camera listed in this category. Please, make photo with back camera of your device, get its resolution in pixels (via Preview Cmd+I for example) and add a comment to this repository on GitHub.com in format Device = Hpx x Wpx.");
            NSLog(@"Your device is: %@", [self kkHardwareDescription]);
            break;
    }
    return CGSizeZero;
}

- (float)hardwareNumber:(Hardware)hardware {
    switch (hardware) {
        case IPHONE_2G:             return 1.1f;
        case IPHONE_3G:             return 1.2f;
        case IPHONE_3GS:            return 2.1f;
            
        case IPHONE_4:              return 3.1f;
        case IPHONE_4_CDMA:         return 3.3f;
        case IPHONE_4S:             return 4.1f;
            
        case IPHONE_5:              return 5.1f;
        case IPHONE_5_CDMA_GSM:     return 5.2f;
        case IPHONE_5C:             return 5.3f;
        case IPHONE_5C_CDMA_GSM:    return 5.4f;
        case IPHONE_5S:             return 6.1f;
        case IPHONE_5S_CDMA_GSM:    return 6.2f;
            
        case IPHONE_6:         return 7.2f;
        case IPHONE_6_PLUS:    return 7.1f;
        case IPHONE_6S:        return 8.1f;
        case IPHONE_6S_PLUS:   return 8.2f;
        case IPHONE_SE:        return 8.4f;
            
        case IPOD_TOUCH_1G:    return 1.1f;
        case IPOD_TOUCH_2G:    return 2.1f;
        case IPOD_TOUCH_3G:    return 3.1f;
        case IPOD_TOUCH_4G:    return 4.1f;
        case IPOD_TOUCH_5G:    return 5.1f;
        case IPOD_TOUCH_6G:    return 7.1f;
            
        case IPAD:                          return 1.1f;
        case IPAD_3G:                       return 1.2f;
        case IPAD_2_WIFI:                   return 2.1f;
        case IPAD_2:                        return 2.2f;
        case IPAD_2_CDMA:                   return 2.3f;
        case IPAD_MINI_WIFI:                return 2.5f;
        case IPAD_MINI:                     return 2.6f;
        case IPAD_MINI_WIFI_CDMA:           return 2.7f;
        case IPAD_3_WIFI:                   return 3.1f;
        case IPAD_3_WIFI_CDMA:              return 3.2f;
        case IPAD_3:                        return 3.3f;
        case IPAD_4_WIFI:                   return 3.4f;
        case IPAD_4:                        return 3.5f;
        case IPAD_4_GSM_CDMA:               return 3.6f;
        case IPAD_AIR_WIFI:                 return 4.1f;
        case IPAD_AIR_WIFI_GSM:             return 4.2f;
        case IPAD_AIR_WIFI_CDMA:            return 4.3f;
        case IPAD_MINI_RETINA_WIFI:         return 4.4f;
        case IPAD_MINI_RETINA_WIFI_CDMA:    return 4.5f;
            
        case IPAD_MINI_RETINA_WIFI_CELLULAR_CN:     return 4.6f;
            
        case IPAD_MINI_3_WIFI:              return 4.7f;
        case IPAD_MINI_3_WIFI_CELLULAR:     return 4.8f;
        case IPAD_MINI_3_WIFI_CELLULAR_CN:  return 4.9f;
            
        case IPAD_MINI_4_WIFI:              return 5.1f;
        case IPAD_MINI_4_WIFI_CELLULAR:     return 5.2f;
        case IPAD_AIR_2_WIFI:               return 5.3f;
        case IPAD_AIR_2_WIFI_CELLULAR:      return 5.4f;
            
        case IPAD_PRO_97_WIFI:              return 6.3f;
        case IPAD_PRO_97_WIFI_CELLULAR:     return 6.4f;
            
        case IPAD_PRO_WIFI:                 return 6.7f;
        case IPAD_PRO_WIFI_CELLULAR:        return 6.8f;
            
        case SIMULATOR:               return 100.0f;
        case NOT_AVAILABLE:           return 200.0f;
    }
    return 200.0f; //Device is not available
}

- (NSDate *)kkSystemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

- (void)_kkLogMessage:(NSString *)hardware {
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/InderKumarRathore/DeviceUtil and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
}

#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/**
 *  lo0      ->  Local ip, 127.0.0.1
 *  en0      ->  LAN   ip, 192.168.1.23
 *  pdp_ip0  ->  WWAN  ip, 3G ip,
 *  bridge0  ->  Bridge、Hotspot ip，172.20.10.1
 */

- (NSString *)kkIpAddressWIFI {
    return [self kkIpAddressWithIfa:@"en0"];
}

- (NSString *)kkIpAddressCell {
    return [self kkIpAddressWithIfa:@"pdp_ip0"];
}

- (NSString *)kkIpAddressWithIfa:(NSString *)ifaName {
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr != NULL) {
            if (addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:ifaName]) {
                    address = [NSString stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

#pragma mark - MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *)kkMacAddress {
    // TODO: is valide
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

- (int64_t)kkDiskSpace {
    return [self _kkDiskInfo:NSFileSystemSize];
}

- (int64_t)kkDiskSpaceFree {
    return [self _kkDiskInfo:NSFileSystemFreeSize];
}

- (int64_t)_kkDiskInfo:(NSString *)key {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:key] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)kkDiskSpaceUsed {
    int64_t total = self.kkDiskSpace;
    int64_t free = self.kkDiskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

- (int64_t)kkMemoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

- (int64_t)kkMemoryUsed {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

- (int64_t)kkMemoryFree {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

- (int64_t)kkMemoryActive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

- (int64_t)kkMemoryInactive {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

- (int64_t)kkMemoryWired {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

- (int64_t)kkMemoryPurgable {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

- (NSUInteger)kkCpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (float)kkCpuUsage {
    float cpu = 0;
    NSArray *cpus = [self kkCpuUsagePerProcessor];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

- (NSArray *)kkCpuUsagePerProcessor {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

#pragma mark sysctl utils

- (NSUInteger)_kkGetSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    // TODO: Learning more about CTL_HW,  what the difference between  vm_statistics
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger)kkCpuFrequency {
    return [self _kkGetSysInfo:HW_CPU_FREQ];
}

- (NSUInteger)kkBusFrequency {
    return [self _kkGetSysInfo:HW_BUS_FREQ];
}

#pragma mark - Test
///=============================================================================
/// @name Test
///=============================================================================

static BOOL ARRunningUnitTests = NO;

+ (BOOL)kkIsRunningUnitTests {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSString *XCInjectBundle = [[[NSProcessInfo processInfo] environment] objectForKey:@"XCInjectBundle"];
        ARRunningUnitTests = [XCInjectBundle hasSuffix:@".xctest"];
    });
    return ARRunningUnitTests;
}


@end
