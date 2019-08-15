//
//  MyBorrowDetailModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowDetailModel.h"

#define force_inline __inline__ __attribute__((always_inline))

static force_inline UIColor* BorrowColorStatus(NSString * code)
{
    if ([code isEqualToString:@"2"]) {
        //还款中
        return KKHexColor(4470E4);
    }else if ([code isEqualToString:@"1"]){
        //募集中
        return KKHexColor(FF7120);
    }else if ([code isEqualToString:@"3"]){
        //已结清
        return KKHexColor(16AC3E);
    }else if ([code isEqualToString:@"4"]){
        //借币失败
        return KKHexColor(E84A55);
    }
    return KKHexColor(ffffff);
}
static force_inline NSString* BorrowStatusTitle(NSString * code)
{
    if ([code isEqualToString:@"2"]) {
        return @"还款中";
    }else if ([code isEqualToString:@"1"]){
        return @"募集中";
    }else if ([code isEqualToString:@"3"]){
        return @"已结清";
    }else if ([code isEqualToString:@"4"]){
        return @"借币失败";
    }
    return @"";
}
static force_inline NSString* BorrowTitle(NSString * code)
{
    if ([code isEqualToString:@"2"]) {
        return @"应还金额";
    }else if ([code isEqualToString:@"1"]){
        return @"借币金额";
    }else if ([code isEqualToString:@"3"]){
        return @"账单金额";
    }else if ([code isEqualToString:@"4"]){
        return @"借币金额";
    }
    return @"";
}
@implementation MyBorrowDetailModel


-(UIColor *)statusTextColor;
{
    return BorrowColorStatus(self.status);
}

-(NSString *)statusText;
{
    return BorrowStatusTitle(self.status);
}

-(NSString *)titleText;
{
    return BorrowTitle(self.status);
}

@end
