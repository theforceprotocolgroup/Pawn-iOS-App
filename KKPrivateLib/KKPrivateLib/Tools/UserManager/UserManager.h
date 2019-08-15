//
//  UserManager.h
//  DigitalCurrency
//
//  Created by 张可 on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

+ (instancetype)manager;

/*! 登录信号 */
+ (RACSignal *)loginSignal;

#pragma mark - UserInfo
///=============================================================================
/// @name 用户信息
///=============================================================================

/*! 用户名(手机号) */
@property (nonatomic, strong, readonly) NSString *username;
/*! 用户token */
@property (nonatomic, strong, readonly) NSString *token;
/*! 用户id */
@property (nonatomic, strong, readonly) NSString *userid;

/*! 登录保存信息 */
+ (void)saveUserInfo:(NSDictionary *)data;

/*! 清除用户登录信息 */
+ (void)clearLoginInfo ;
#pragma mark - 密码加密
///=============================================================================
/// @name 密码加密
///=============================================================================

/*! 加密密码
 *  加密规则 = RSAALG(phone + '\001' + pw + '\001' + timestamp, RSAKey)
 */
+ (NSString *)encryptPhone:(NSString *)phone password:(NSString *)pw;

/*! 加密密码 密码先MD5
 *  加密规则 = RSAALG(phone + '\001' + MD5(pw) + '\001' + timestamp, RSAKey)
 */
+ (NSString *)encryptMd5Phone:(NSString *)phone password:(NSString *)pw;

+ (void)handleCustomLogoutWithCode:(NSInteger)code;
@end

NS_ASSUME_NONNULL_END
