//
//  KKRequest.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/17.
//  Copyright © 2018 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestTask.h"
NS_ASSUME_NONNULL_BEGIN


@class AFSecurityPolicy;
@class AFHTTPRequestSerializer;
@class AFHTTPResponseSerializer;

@interface KKRequest : NSObject

/*!  */
+ (KKRequestTask *)request;
/*! 上传 Json 数据 */
+ (KKRequestTask *)jsonRequest;
/*! 不带 */
+ (KKRequestTask *)defaultRequest;
/*! 下载数据 */
+ (KKRequestTask *)dataRequest;                                                                                                                                                              


@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Custom Serialization
////////////////////////////////////////////////////////////////////////////////

@interface KKSerialization : NSObject

#pragma mark - Custom -- AFURLRequestSerializer
///=============================================================================
/// @name Custom -- AFURLRequestSerializer
///=============================================================================

+ (AFHTTPRequestSerializer *)kkRequestSerializer;

+ (AFHTTPRequestSerializer *)kkJsonRequestSerializer;


#pragma mark - Custom -- AFURLResponseSerializer
///=============================================================================
/// @name Custom -- AFURLResponseSerializer
///=============================================================================

+ (AFHTTPResponseSerializer *)kkResponseSerializer;


#pragma mark - Custom -- AFSecurityPolicy
///=============================================================================
/// @name Custom -- AFSecurityPolicy
///=============================================================================

+ (AFSecurityPolicy *)kkSecurityPolicy;

@end
NS_ASSUME_NONNULL_END
