//
//  KKWebViewController.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWebViewBrigdeProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>

typedef enum {
    LoadTypeURL,
    LoadTypeHTML,
}LoadType;

NS_ASSUME_NONNULL_BEGIN

@interface KKWebViewController : UIViewController<KKRouterDataDelegate>

//使用url
@property (nonatomic,strong)NSString *hostUrl;
//加载url或者htmlstring
@property (nonatomic,assign,readonly)LoadType loadType;
//使用htmlStr
@property (nonatomic,strong)NSString * htmlStr;
//最近一次加载的request
@property (nonatomic, strong ,readonly) NSURLRequest * lastRequest;
//导航栏标题
@property (nonatomic, strong) NSString * navtitle;

@property (nonatomic, assign) BOOL noNeedToRefresh;

-(void)clearCookies;

//子类重写方法
-(BOOL)shouldLaodWebViewHandle:(NSURLRequest*)request;

-(void)loadWebViewFinished:(UIWebView *)webview;

-(void)loadWebViewFailed:(UIWebView *)webview didFailLoadWithError:(NSError *)error;

-(void)reloadWebView;

-(BOOL)canGoBack;

// 手动加载一次页面
- (void)manualLoadPage;

- (BOOL)needreloadByBack;

@end

NS_ASSUME_NONNULL_END
