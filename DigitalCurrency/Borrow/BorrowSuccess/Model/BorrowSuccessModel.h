//
//  BorrowSuccessModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BorrowSuccessModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//
@property (nonatomic, strong) NSString * borrowCount;
//
@property (nonatomic, strong) NSString * borrowSymbol;
//
@property (nonatomic, strong) NSString * tips;
//
@property (nonatomic, strong) NSArray * repayInfo;

@end

NS_ASSUME_NONNULL_END
