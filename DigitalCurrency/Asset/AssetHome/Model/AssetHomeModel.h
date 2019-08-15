//
//  AssetHomeModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetHomeTokenModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AssetHomeModel : NSObject
//
@property (nonatomic, strong) NSString * quotesCurrency;
//
@property (nonatomic, strong) NSString * quotesCurrencyCount;
//
@property (nonatomic, strong) NSString * quotesToken;
//
@property (nonatomic, strong) NSString * quotesTokenCount;
//
@property (nonatomic, strong) NSArray * walletList;
@end

NS_ASSUME_NONNULL_END
