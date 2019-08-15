//
//  TradeRecouderModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradeRecouderModel : NSObject
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * tokenSymbol;
//
@property (nonatomic, strong) NSString * tokenCount;
//
@property (nonatomic, strong) NSString * TxType;
//
@property (nonatomic, strong) NSString * TxTypeInfo;
//
@property (nonatomic, strong) NSArray * TxDescription;
@end

NS_ASSUME_NONNULL_END
