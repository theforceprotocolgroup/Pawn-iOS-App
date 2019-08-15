//
//  LoanHomePageModel.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/27.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanHomePageModel : NSObject
//
@property (nonatomic, strong) NSString * orderID;
//
@property (nonatomic, strong) NSString * borrowCount;
//
@property (nonatomic, strong) NSString * borrowType;
//
@property (nonatomic, strong) NSString * iconURI;
//
@property (nonatomic, strong) NSString * borrowUserID;
//
@property (nonatomic, strong) NSString * dailyRate;
//
@property (nonatomic, strong) NSString * interval;
//
@property (nonatomic, strong) NSString * expected;
@end

NS_ASSUME_NONNULL_END
