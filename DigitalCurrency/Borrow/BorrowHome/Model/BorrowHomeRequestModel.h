//
//  BorrowHomeRequestModel.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/30.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BorrowHomeRequestModel : NSObject
//
@property (nonatomic, strong) NSString * borrowType;
//
@property (nonatomic, strong) NSString * count;
//
@property (nonatomic, strong) NSString * rate;
//
@property (nonatomic, strong) NSString * mrgeType;
//
@property (nonatomic, strong) NSString * interval;

@end

NS_ASSUME_NONNULL_END
