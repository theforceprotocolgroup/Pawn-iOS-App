//
//  LoanDetailInfoModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoanInfoOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoanDetailInfoModel : NSObject
//
@property (nonatomic, strong)LoanInfoOrderInfoModel * orderInfo;
//
@property (nonatomic, strong) NSArray * orderCycle;
//
@property (nonatomic, strong) NSArray * repayInfo;
//
@property (nonatomic, strong) NSArray * borrowProtocol;
@end

NS_ASSUME_NONNULL_END
