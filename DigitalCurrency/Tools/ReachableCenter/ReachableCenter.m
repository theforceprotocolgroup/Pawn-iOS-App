//
//  ReachableCenter.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "ReachableCenter.h"
#import "AFNetworkReachabilityManager.h"

@implementation ReachableCenter

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

+ (void)setup {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self notificationBlcok];
}


+(void)notificationBlcok
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 无网络发通知告诉首页显示提示
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWork" object:@(KKReachabilityStatusNoNetWork)];
                
            }   break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
            default:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWork" object:@(KKReachabilityStatusConnect)];
                
            }break;
        }
        
    }];
}

+(void)addReachableObserver:(NSObject *)observer selector:(SEL)selector ;
{
    // 检测网络连接的单例,网络变化时的回调方法
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:@"NetWork" object:nil];
}
+(void)removeObserver:(NSObject *)observer;
{
    [[NSNotificationCenter defaultCenter]removeObserver:observer name:@"NetWork" object:nil];
}
@end
