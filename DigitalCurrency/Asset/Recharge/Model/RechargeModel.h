//
//  RechargeModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RechargeModel : NSObject
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSString * tokenSymbol;
//
@property (nonatomic, strong) NSString * tokenName;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * tokenBalance;
//
@property (nonatomic, strong) NSString * tokenAddress;
@end

NS_ASSUME_NONNULL_END
