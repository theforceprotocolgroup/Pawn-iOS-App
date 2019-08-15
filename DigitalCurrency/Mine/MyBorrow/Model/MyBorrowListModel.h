//
//  MyBorrowListModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBorrowListModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//
@property (nonatomic, strong) NSString * status;
//
@property (nonatomic, strong) NSString * createdTime;
//
@property (nonatomic, strong) NSString * investedTime;
//
@property (nonatomic, strong) NSString * repaymentExpectedTime;
//
@property (nonatomic, strong) NSString * repaymentActualTime;
//
@property (nonatomic, strong) NSString * borrowTokenCount;
//
@property (nonatomic, strong) NSString * borrowTokenType;

//
@property (nonatomic, strong) NSString * interestCount;
-(UIColor *)statusColer;
-(NSString *)statusText;
-(NSString *)subTitleText;
-(NSString *)contentTitleText;
@end

NS_ASSUME_NONNULL_END
