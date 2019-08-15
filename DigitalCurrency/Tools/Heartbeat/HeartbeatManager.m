//
//  HeartbeatManager.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/30.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "HeartbeatManager.h"

@implementation HeartbeatManager
+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName: UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setup:note.userInfo];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}
+ (void)setup:(NSDictionary *)launchOptions
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        if (@available(iOS 10.0, *)) {
//            NSTimer * timer = [NSTimer timerWithTimeInterval:10 * 60.f repeats:YES block:^(NSTimer * _Nonnull timer) {
//                [self requestHeartbeat];
//            }];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        } else {
//            NSTimer * timer = [NSTimer timerWithTimeInterval:10 * 60.f target:self selector:@selector(requestHeartbeat) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        }
//        
//        //子线程需要手动开启Runloop
//        [[NSRunLoop currentRunLoop] run];
//    });
}

+(void)requestHeartbeat
{
//    [[KKRequest jsonRequest].paramaters() {
//        if (t.result) {
//            NSLog(@"heartbeat! success!");
//        }else
//        {
//            NSLog(@"heartbeat! failed!");
//        }
//        return nil;
//    }];

}
@end
