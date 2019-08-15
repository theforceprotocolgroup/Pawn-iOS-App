//
//  BorrowHomeViewModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/1.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class BorrowHomePageTableViewModel;

@interface BorrowHomeViewModel : NSObject
//
@property (nonatomic, strong) NSArray * rateArr;
//
@property (nonatomic, strong) NSArray * intervalArr;
//
@property (nonatomic, strong) NSArray <BorrowHomePageTableViewModel*> * borrowCellArr;
//
@property (nonatomic, strong) NSArray <BorrowHomePageTableViewModel*> * borrowDetailCellArr;
@end

@interface BorrowHomePageTableViewModel : NSObject

//
@property (nonatomic, strong) NSString * icon;
//
@property (nonatomic, strong) NSString * title;
//
@property (nonatomic, strong) NSString * placeholder;
//
@property (nonatomic, strong) id content;
//
@property (nonatomic, strong) NSString * actionType;

@end
NS_ASSUME_NONNULL_END
