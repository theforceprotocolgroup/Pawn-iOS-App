//
//  KKWebViewController+Utils.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN


#define kForJSgetUserId @"getUserId"
#define kForJSh5Share @"h5Share"
#define kToJSgetSupportedShareType @"getSupportedShareType()"
#define kToJSappShare @"appShare()"
#define kJSBridge @"bridge"
#define kJSCamera @"camera"

@interface KKWebViewController (Utils)

//跳转逻辑(总的)
-(BOOL)jumpToOtherPage:(NSURLRequest*)request;

//优分期的host
-(BOOL)isHostURLJDJK:(NSString*)urlhost;

//h5风控登录拦截
-(BOOL)isH5CertMutibleLogin:(NSString*)urlString;

//h5其他登录拦截
-(BOOL)isH5MutibleLogin:(NSString*)urlString;

//跳转safari浏览器
-(BOOL)isJumpToSafari:(NSString*)urlString;

//跳转原生页面
-(BOOL)isJumpToLocationPage:(NSString*)urlString;
@end

NS_ASSUME_NONNULL_END
