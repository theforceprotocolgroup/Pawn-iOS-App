//
//  MyBorrowDetailModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MrgeInfoModel.h"
#import "ClosePositionStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyBorrowDetailModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//1募集中  2还款中  3已结清  4已取消
@property (nonatomic, strong) NSString * status;
//借币数量金额
@property (nonatomic, strong) NSString * titleCount;
//借币种类
@property (nonatomic, strong) NSString * borrowTokenType;
//日利率
@property (nonatomic, strong) NSString * dailyRate;
//服务费
@property (nonatomic, strong) NSString * fee;

//
@property (nonatomic, strong) NSString * borrowTokenAddress;
//
@property (nonatomic, strong) NSString * mrgeTokenType;
//
@property (nonatomic, strong) NSString * mrgeTokenAddress;
//还款方式 1:正常还款 2:价值平仓 3:逾期平仓
@property (nonatomic, strong) NSString * repaymentStatus;

//是否预警
@property (nonatomic, assign) BOOL reachPreCautiousLine;

//质押平仓金额
@property (nonatomic, strong) NSString * coverLineCount;

//
@property (nonatomic, strong) NSArray * borrowInfo;
//
@property (nonatomic, strong) NSArray * mortgageInfo;
//
@property (nonatomic, strong) NSArray * repaymentInfo;

//
@property (nonatomic, strong) NSString * tips;
//质押信息


////
//@property (nonatomic, strong) ClosePositionStatusModel * closePositionStatus;
////
//@property (nonatomic, strong) MrgeInfoModel * mrgeInfo;


-(UIColor *)statusTextColor;

-(NSString *)statusText;

-(NSString *)titleText;


@end

NS_ASSUME_NONNULL_END
