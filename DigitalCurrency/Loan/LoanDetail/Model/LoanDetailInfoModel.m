//
//  LoanDetailInfoModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailInfoModel.h"

@implementation LoanDetailInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"orderInfo" : NSClassFromString(@"LoanInfoOrderInfoModel"),
             @"repayInfo": NSClassFromString(@"LoanDetailInfoViewModel"),
             @"orderCycle":NSClassFromString(@"LoanDetailInfoViewModel"),
             @"borrowProtocol": NSClassFromString(@"ProtocolModel"),
             };
}
@end
