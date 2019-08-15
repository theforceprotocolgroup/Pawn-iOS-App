//
//  NSNumber+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKEnumerationCapabilities.h"
#define KKRand(A) (@(A)).kkRandom.integerValue

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (KKCategory)

#pragma mark - Modify Number
///=============================================================================
/// @name Modify Number
///=============================================================================

/*!
 Return a String with the given digit.
 e.g.   2.345(digit=2) ==> 2.35
 */
- (NSString *)kkNumStringWithDigit:(NSUInteger)digit;

/*!
 Return a String with the given digit.
 e.g.   0.34554(digit=2) ==> 34.55%
 */
- (NSString *)kkPercentStringWithDigit:(NSUInteger)digit;

/*!
 Return a String with the currency symbol.
 e.g.   554(digit=2) ==> 34.55%
 */
- (NSString *)kkCurrencyString;

//- (NSString *)kk


#pragma mark -
///=============================================================================
/// @name
///=============================================================================

/*!
 Answer a random integer from 0 to self (excluded).
 */
- (NSNumber *)kkRandom;

/*!
 Evaluate repeatBlock the number of times represented by the receiver.
 */
- (void)kkTimesRepeat:(void (^)(void))repeatBlock;
- (void)kkTimesRepeatWithIndex:(void (^)(NSUInteger idx))repeatBlock;

/*!
 Answer an Interval from the receiver up to other, with each next element
 computed by incrementing the previous one by 1
 */
- (KKInterval *)kkTo:(NSNumber *)other;

/*!
 Answer an Interval from the receiver up to other, with each next element
 computed by incrementing the previous one by stepSize
 */
- (KKInterval *)kkTo:(NSNumber *)other by:(NSNumber *)stepSize;

@end

NS_ASSUME_NONNULL_END
