//
//  MyLoanDetailModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyLoanDetailModel.h"

#define force_inline __inline__ __attribute__((always_inline))

static force_inline UIColor* LoanColorStatus(NSString * code)
{
    if ([code isEqualToString:@"1"]) {
        return KKHexColor(4470E4);
    }else if ([code isEqualToString:@"2"]){
        return KKHexColor(16AC3E);
    }
    return KKHexColor(ffffff);
}
static force_inline NSString* LoanTitleStatus(NSString * code)
{
    if ([code isEqualToString:@"1"]) {
        return @"持有中";
    }else if ([code isEqualToString:@"2"]){
        return @"已回款";
    }
    return @"";
}


@implementation MyLoanDetailModel

-(UIColor *)statusColer;
{
    return LoanColorStatus(self.status);
}
-(NSString *)statusText;
{
    return LoanTitleStatus(self.status);
}
@end
