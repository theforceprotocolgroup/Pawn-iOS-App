//
//  NSArray+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType>  (KKCategory)

- (NSArray<ObjectType> *)addArr:(NSArray<ObjectType> *)arr;

#pragma mark -
///=============================================================================
/// @name POP
///=============================================================================

- (void)kkEachIndex:(void (^)(id obj, NSInteger index))block;

/*!
 Tests whether some object in the array passes the test implemented
 by the provided block.
 */
- (BOOL)kkSome:(BOOL (^)(id obj))block;

/*!
 Tests whether all objects in the array pass the test
 implemented by the provided block.
 */
- (BOOL)kkEvery:(BOOL (^)(id obj))block;

- (NSString *)kkJoin:(NSString *)separator;

- (void)kkEachWithPreAndIndex:(void (^)(id obj, id preObj, NSUInteger idx))block;

/**
 Recurse through self checking for NSArrays and extract all elements into one single array
 @return An array of all held arrays merged
 */
- (NSArray<ObjectType> *)kkFlatten;

- (NSArray<ObjectType> *)kkFilter:(BOOL (^)(id object))block;

/*!
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (ObjectType)kkRandomObject;

/*! Return the last object of an array. */
- (ObjectType)kkLastObject;

/*! Return the first object of an array. */
- (ObjectType)kkFirstObject;

/*! Return the object. */
- (ObjectType)kkObjectAtIndex:(NSUInteger)index;

#pragma mark -
///=============================================================================
/// @name Plist Data
///=============================================================================

/*!
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (NSArray *)kkArrayWithPlistData:(NSData *)plist;

/*!
 Creates and returns an array from a specified property list xml string.
 
 @param plistString   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSArray *)kkArrayWithPlistString:(NSString *)plistString;

/*!
 Serialize the array to binary property list data.
 @return A bplist data, or nil if an error occurs.
 */
- (NSData *)kkPlistData;

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)kkPlistString;



#pragma mark -
///=============================================================================
/// @name JsonString Transform
///=============================================================================

/*!
 Convert Array to json string. Return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (NSString *)kkJsonStringEncoded;

/*!
 Convert array to json string.
 */
- (NSString *)kkJsonPrettyStringEncoded;



@end

NS_ASSUME_NONNULL_END
