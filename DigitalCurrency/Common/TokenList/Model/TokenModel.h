//
//  TokenModel.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/19.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenModel : NSObject
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSString * symbol;
//
@property (nonatomic, strong) NSString * name;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * maxAvaliableBorrowCount;
//
@property (nonatomic, strong) NSString * minAvaliableBorrowCount;

@end

NS_ASSUME_NONNULL_END
