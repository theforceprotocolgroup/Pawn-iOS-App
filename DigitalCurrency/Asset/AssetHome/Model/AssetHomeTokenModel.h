//
//  AssetHomeTokenModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetHomeTokenModel : NSObject
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSString * tokenName;
//
@property (nonatomic, strong) NSString * tokenSymbol;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * tokenBalance;
//
@property (nonatomic, strong) NSString * tokenFrozen;
//
@property (nonatomic, assign) BOOL ignored;
//
@property (nonatomic, strong) NSString * quotesType;
//
@property (nonatomic, strong) NSString * quotesCurrencyCount;
@end

NS_ASSUME_NONNULL_END
