//
//  MyLoanDetailModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLoanDetailModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//
@property (nonatomic, strong) NSString * status;
//xiabian
@property (nonatomic, strong) NSArray * collectInfo;
//
@property (nonatomic, strong) NSArray * lendInfo;
//
@property (nonatomic, strong) NSString * investedCount;
//
@property (nonatomic, strong) NSString * investedCoinType;
//
@property (nonatomic, strong) NSString * tips;


-(UIColor *)statusColer;

-(NSString *)statusText;
@end

NS_ASSUME_NONNULL_END
