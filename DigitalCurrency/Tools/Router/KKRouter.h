//
//  KKRouter.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRouter : NSObject
/*! 跳转页面 */
+ (BFTask *)pushUri:(NSString *)uriString;
/*! 跳转页面 带参数 */
+ (BFTask *)pushUri:(NSString *)uriString params:(id __nullable)data;
/*! 跳转页面 带navi */
+ (BFTask *)pushUri:(NSString *)uriString navi:(UINavigationController * __nullable)navi;
/*! 跳转页面 带参数 navi */
+ (BFTask *)pushUri:(NSString *)uriString params:(id __nullable)data navi:(UINavigationController * __nullable)navi;

/*! 跳转页面 */
+ (BFTask *)popUri:(NSString *)uriString;
// 临时跳转控制器，webview跳转到webview
+ (BFTask *)pushViewControllerWithVC:(NSString *)vcString data:(id)data navi:(UINavigationController *)navi;

+ (UINavigationController *)topNavi;
@end

FOUNDATION_EXPORT NSString * const LoginVCString;                ///< 登录界面
FOUNDATION_EXPORT NSString * const BorrowVCString;                 ///< 借币
FOUNDATION_EXPORT NSString * const LoanVCString;                 ///< 出借
FOUNDATION_EXPORT NSString * const AssetVCString;              ///< 资产
FOUNDATION_EXPORT NSString * const MineVCString;              ///< 我的
FOUNDATION_EXPORT NSString * const RegisterVCString;
FOUNDATION_EXPORT NSString * const MoneyVCString;

NS_ASSUME_NONNULL_END
