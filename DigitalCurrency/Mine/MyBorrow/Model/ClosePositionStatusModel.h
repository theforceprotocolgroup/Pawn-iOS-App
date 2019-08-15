//
//  ClosePositionStatusModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClosePositionStatusModel : NSObject
//
@property (nonatomic, assign) BOOL closeStatus;
//
@property (nonatomic, strong) NSString * coverPositionDateBefore;
//
@property (nonatomic, strong) NSString * coverPositionCount;
@end

NS_ASSUME_NONNULL_END
