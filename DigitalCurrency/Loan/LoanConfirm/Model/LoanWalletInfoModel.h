//
//  LoanWalletInfoModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/16.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanWalletInfoModel : NSObject
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * tokenAddress;
//
@property (nonatomic, strong) NSString * tokenBalance;
//
@property (nonatomic, strong) NSString * tokenType;
@end

NS_ASSUME_NONNULL_END
