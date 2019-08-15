//
//  ThirdSDKAgent.m
//  DigitalCurrency
//
//  Created by Michael on 2019/3/12.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "ThirdSDKAgent.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
@implementation ThirdSDKAgent
#pragma mark - logical
///=============================================================================
/// @name logical
///=============================================================================

+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName: UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setup];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

+ (void)setup {
    if ([MobClick isPirated]) {
        exit(0);
    }
    
    [self iniMobClick];
    
    BOOL isdebug = NO;
#if DEBUG
    isdebug = YES;
#endif
    
}
+ (void)iniMobClick
{
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:@"" channel:@""];
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
#if DEBUG
    [UMConfigure setLogEnabled:YES];
#endif
}

@end
