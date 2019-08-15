//
//  WithdrawModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawModel : NSObject
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSString * tokenSymbol;
//
@property (nonatomic, strong) NSString * tokenName;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * fee;
//
@property (nonatomic, strong) NSString * maxAvailableWithdrawCount;
//
@property (nonatomic, strong) NSString * maxWithdrawCount;
//
@property (nonatomic, strong) NSString * minWithdrawCount;
//
@property (nonatomic, strong) NSString * quoteType;
//
@property (nonatomic, strong) NSString * quotesCount;

@end

NS_ASSUME_NONNULL_END
