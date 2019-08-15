//
//  MineHomeModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineHomeModel : NSObject
//
@property (nonatomic, strong) NSString * quotesCurrency;
//
@property (nonatomic, strong) NSString * quotesCurrencyCount;
//
@property (nonatomic, strong) NSString * quotesToken;
//
@property (nonatomic, strong) NSString * quotesTokenCount;
//
@property (nonatomic, assign) NSInteger unreadMessages;
//
@property (nonatomic, strong) NSString * userIdentified;
@end

NS_ASSUME_NONNULL_END
