//
//  BorrowInfoModel.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/30.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowInfoModel.h"

@implementation BorrowInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"repayinfo" : [ContentViewModel class],
             @"mrgeInfo": [BorrowLoanViewModel class]};
}
@end
