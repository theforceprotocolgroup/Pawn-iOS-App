//
//  LoanConfirmOrderInfoModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanConfirmOrderInfoModel : NSObject
//
@property (nonatomic, strong) NSString * borrowCount;
//
@property (nonatomic, strong) NSString * borrowTokenType;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * interval;
//
@property (nonatomic, strong) NSString * dailyRate;
//
@property (nonatomic, strong) NSString * expected;
@end

NS_ASSUME_NONNULL_END
