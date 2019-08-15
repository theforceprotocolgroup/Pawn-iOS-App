//
//  NSDictionary+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (KKCategory)
/*!
 Return a string Value From id type Data.
 @discuss  The return value will no be nil. nil will be replace in @"";
 e.g.  @{@"key":@23.45};   ==>(self.kkString(@"key"))   :@"23.45"
 */
- (NSString *(^)(NSString *key))kkString;

/*!
 Return a number Value From id type Data.
 @discuss  The return value will no be 0. nil will be replace in 0;
 // TODO: is 0 better.
 e.g.  @{@"key":@"23.45"};   ==>(self.kkNumber(key))   :@23.45
 */
- (NSNumber *(^)(NSString *key))kkNumber;


- (NSArray *(^)(NSString *key))kkArray;


#pragma mark - <#name#>
///=============================================================================
/// @name <#name#>
///=============================================================================

/*!
 Answer whether the receiver has a key equal to aKey.
 */
- (BOOL)kkIncludesKey:(id)aKey;

/*!
 Answer whether the receiver has a value equal to aValue.
 */
- (BOOL)kkIncludesValue:(id)aValue;

@end

@interface NSMutableDictionary (KKCategory)

- (NSMutableDictionary *(^)(NSString *key, NSString *value))kkSetKeyValue;

@end

NS_ASSUME_NONNULL_END
