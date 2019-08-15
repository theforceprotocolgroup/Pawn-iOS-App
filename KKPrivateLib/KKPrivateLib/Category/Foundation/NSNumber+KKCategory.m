//
//  NSNumber+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSNumber+KKCategory.h"

@implementation NSNumber (KKCategory)

#pragma mark - Modify Number
///=============================================================================
/// @name Modify Number
///=============================================================================

- (NSString *)kkNumStringWithDigit:(NSUInteger)digit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:digit];
    NSString *result = [formatter stringFromNumber:self];
    if (!result) return @"";
    return result;
}

- (NSString *)kkPercentStringWithDigit:(NSUInteger)digit {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:digit];
    NSString *result = [formatter stringFromNumber:self];
    if (!result) return @"";
    return result;
}

- (NSString *)kkCurrencyString {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
    NSString *result = [formatter stringFromNumber:self];
    if (!result) return @"";
    return result;
}

//- (NSString *)kkDecimalStringWith

#pragma mark -
///=============================================================================
/// @name
///=============================================================================

- (NSNumber *)kkRandom {
    NSInteger sign = [self integerValue] < 0 ? -1 : 1;
    uint32_t limit = abs([self intValue]);
    int rand = arc4random_uniform(limit);
    return @(sign * rand);
}

- (void)kkTimesRepeat:(void (^)(void))repeatBlock {
    [self kkTimesRepeatWithIndex:^(NSUInteger idx) {
        repeatBlock();
    }];
}

- (void)kkTimesRepeatWithIndex:(void (^)(NSUInteger idx))repeatBlock {
    NSAssert([self integerValue] >= 0, @"cannot repeat things a negative number of times");
    NSUInteger count = [self unsignedIntegerValue];
    for (NSUInteger idx = 0; idx < count; idx++) {
        repeatBlock(idx);
    }
}

- (KKInterval *)kkTo:(NSNumber *)other {
    return [self kkTo:other by:@1];
}

- (KKInterval *)kkTo:(NSNumber *)other by:(NSNumber *)stepSize {
    return [[KKInterval alloc] initWithFrom:[self integerValue]
                                         to:[other integerValue]
                                         by:[stepSize integerValue]];
}


@end
