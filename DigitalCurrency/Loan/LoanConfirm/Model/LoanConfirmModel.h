//
//  LoanConfirmModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/11.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanConfirmOrderInfoModel.h"
#import "LoanConfirmPaymentInfo.h"
#import "LoanWalletInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoanConfirmModel : NSObject
//
@property (nonatomic, strong) LoanConfirmPaymentInfo * paymentInfo;
//
@property (nonatomic, strong) LoanConfirmOrderInfoModel * orderInfo;
//
@property (nonatomic, strong) NSString * userIdentified;
//
@property (nonatomic, strong) LoanWalletInfoModel * walletInfo;
//
@property (nonatomic, strong) NSString * tips;
@end

NS_ASSUME_NONNULL_END
