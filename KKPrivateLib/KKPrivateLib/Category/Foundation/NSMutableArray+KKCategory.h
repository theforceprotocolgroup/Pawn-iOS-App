//
//  NSMutableArray+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (KKCategory)

#pragma mark - Plist
///=============================================================================
/// @name Plist
///=============================================================================

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (NSMutableArray *)kkArrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSMutableArray *)kkArrayWithPlistString:(NSString *)plist;


#pragma mark - Function

///=============================================================================
/// @name Function
///=============================================================================

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)kkPopFirstObject;

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)kkPopLastObject;

/*! Add a object to the end of an Array. */
- (void)kkPush:(id)obj;

/*! Add a objects to the end of an Array. */
- (void)kkPushObjs:(NSArray *)objs;

/*! Remove from the end of an Array. */
- (void)kkPop;

/*! Remove from the front of an Array. */
- (void)kkShift;

/*! Add a object to the front of an Array */
- (void)kkUnShift:(id)obj;

/*! Add objects to the end of an Array. */
- (void)kkUnShiftObjs:(NSArray *)objs;

/*! Reverse the index of object in this array. */
- (void)kkReverse;

/*! Sort the object in this array randomly. */
- (void)kkShuffle;



@end

NS_ASSUME_NONNULL_END
