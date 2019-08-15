//
//  ReachableCenter.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KKReachabilityStatus) {
    KKReachabilityStatusConnect     = 0,
    KKReachabilityStatusNoNetWork     = 1,
    
};
@interface ReachableCenter : NSObject

+(void)addReachableObserver:(NSObject *)observer selector:(SEL)selector ;

+(void)removeObserver:(NSObject *)observer;

@end

NS_ASSUME_NONNULL_END
