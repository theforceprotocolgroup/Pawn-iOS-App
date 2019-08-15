//
//  MyLoanListModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLoanListModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//
@property (nonatomic, strong) NSString * status;
//
@property (nonatomic, strong) NSString * expectedRepaymentDate;
//
@property (nonatomic, strong) NSString * investedCount;
//
@property (nonatomic, strong) NSString * investedTokenType;
//
@property (nonatomic, strong) NSString * interestCount;

-(UIColor *)statusColer;
-(NSString *)statusText;
-(NSString *)subTitleText;
@end

NS_ASSUME_NONNULL_END
