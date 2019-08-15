//
//  LoanConfirmPaymentInfo.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanConfirmPaymentInfo : NSObject
//
@property (nonatomic, strong) NSString * tokenType;
//
@property (nonatomic, strong) NSString * paymentCount;
//
@property (nonatomic, strong) NSString * fee;
@end

NS_ASSUME_NONNULL_END
