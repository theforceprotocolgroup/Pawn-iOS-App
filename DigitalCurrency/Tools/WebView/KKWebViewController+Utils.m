//
//  KKWebViewController+Utils.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKWebViewController+Utils.h"

@implementation KKWebViewController (Utils)

-(BOOL)isHostURLJDJK:(NSString*)urlhost
{
    return [urlhost containsString:@""]||[urlhost containsString:@""]||[urlhost containsString:@""];
}

//h5风控登录拦截
-(BOOL)isH5CertMutibleLogin:(NSString*)urlString
{
    return [urlString containsString:@""];
}

//h5其他登录拦截
-(BOOL)isH5MutibleLogin:(NSString*)urlString
{
    return [urlString containsString:@""];
}
//跳转safari浏览器
-(BOOL)isJumpToSafari:(NSString*)urlString
{
    return [urlString containsString:@""];
}

//跳转原生页面
-(BOOL)isJumpToLocationPage:(NSString*)urlString
{
    return [urlString containsString:@"native://"];
}
// 跳转新开启一个webView
- (BOOL)isJumpToWebViewPage:(NSString *)urlString {
    return [urlString containsString:@""];
}
//跳转逻辑
-(BOOL)jumpToOtherPage:(NSURLRequest*)request
{
    
    NSString *urlString = request.URL.absoluteString;
    
    if ([self isH5CertMutibleLogin:urlString]) {
//        [UFQUserManager clearLoginInfo];
//        [UFQUserManager handleCustomLogoutWithCode:1002];
        return YES;
    }
    
    if ([self isH5MutibleLogin:urlString]) {
        
//        [UFQUserManager clearLoginInfo];
//        [[SZRouter pushUri:UFQLoginVCString navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask *  t) {
//            [self reloadWebView];
//            return nil;
//        }];
        return YES;
    }
    
    if ([self isJumpToSafari:urlString]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return YES;
    }
    
    if ([self isJumpToLocationPage:urlString]) {
        if ([urlString containsString:@"native://login"]) {
//            [[SZRouter pushUri:UFQLoginVCString navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask *  t) {
//                if (t.result && [urlString containsString:@"goBackAfterLogin=true"]) {
//                    [self reloadWebView];
//                } else {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kEventEmitterToHomeEvent object:nil];
//                    [SZRouter pushUri:UFQHomeVCString];
//                }
//                return nil;
//            }];
        } else {
//            [SZRouter pushUri:urlString];
        }
        return YES;
    }
    
    if ([self isJumpToWebViewPage:urlString]) {
//        NSString *tempStr = @"hetrone_webview=true";
//        NSString *url = [urlString stringByReplacingOccurrencesOfString:tempStr withString:@"false"];
//        [SZRouter pushUri:@"SDBBaseWebViewController" params:RACTuplePack(url) navi:self.navigationController];
        return YES;
    }
    
    return NO;
    
}

@end
