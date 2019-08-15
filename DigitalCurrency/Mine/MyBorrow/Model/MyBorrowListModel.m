//
//  MyBorrowListModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowListModel.h"


#define force_inline __inline__ __attribute__((always_inline))

static force_inline UIColor* BorrowColorStatus(NSString * code)
{
    if ([code isEqualToString:@"2"]) {
        return KKHexColor(4470E4);
    }else if ([code isEqualToString:@"1"]){
        return KKHexColor(FF7120);
    }else if ([code isEqualToString:@"3"])
    {
        return KKHexColor(16AC3E);
    }else if ([code isEqualToString:@"4"])
    {
        return KKHexColor(E84A55);
    }
    return KKHexColor(ffffff);
}
static force_inline NSString* BorrowTitleStatus(NSString * code)
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
static force_inline NSString* BorrowSubTitleStatus(NSString * code)
{
    return @"利息金额：";
}
static force_inline NSString* BorrowContentTitleStatus(NSString * code)
{
    if ([code isEqualToString:@"2"]) {
        return @"还款日：";
    }else if ([code isEqualToString:@"1"]){
        return @"申请日：";
    }else if ([code isEqualToString:@"3"]){
        return @"结清时间";
    }else if ([code isEqualToString:@"4"]){
        return @"申请日：";
    }
    return @"";
}
@implementation MyBorrowListModel


-(UIColor *)statusColer;
{
    return BorrowColorStatus(self.status);
}
-(NSString *)statusText;
{
    return BorrowTitleStatus(self.status);
}
-(NSString *)subTitleText;
{
    NSString * str = BorrowSubTitleStatus(self.status);
    //利息金额
    return [NSString stringWithFormat:@"%@%@%@",str,self.interestCount,self.borrowTokenType];
}
-(NSString *)contentTitleText;
{
    if ([self.status isEqualToString:@"2"]) {
        return [NSString stringWithFormat:@"%@%@",BorrowContentTitleStatus(self.status),self.repaymentExpectedTime];
    }else if ([self.status isEqualToString:@"1"]){
        return [NSString stringWithFormat:@"%@%@",BorrowContentTitleStatus(self.status),self.createdTime];
    }else if ([self.status isEqualToString:@"3"]){
        return [NSString stringWithFormat:@"%@%@",BorrowContentTitleStatus(self.status),self.repaymentActualTime];
    }else if ([self.status isEqualToString:@"4"]){
        return [NSString stringWithFormat:@"%@%@",BorrowContentTitleStatus(self.status),self.createdTime];;
    }
    return @"";
}
@end
