//
//  BorrowInfoModel.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/30.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BorrowLoanViewModel.h"
#import "ContentViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BorrowInfoModel : NSObject
//
@property (nonatomic, strong) NSArray * repayinfo;
//
@property (nonatomic, strong) BorrowLoanViewModel* mrgeInfo;
//
@property (nonatomic, strong) NSString * userIdentified;
//
@property (nonatomic, strong) NSDictionary * lendInfo;
@end

NS_ASSUME_NONNULL_END
