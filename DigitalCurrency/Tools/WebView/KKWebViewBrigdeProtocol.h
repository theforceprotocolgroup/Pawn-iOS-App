//
//  KKWebViewBrigdeProtocol.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//
#import <JavaScriptCore/JavaScriptCore.h>

@protocol KKWebViewBrigdeProtocol <JSExport>

//协议方法必须带参数

JSExportAs(getUserId , -(NSString*)getUserId :(NSString *)string);

JSExportAs(getUserToken , -(NSString*)getUserToken :(NSString *)string);

JSExportAs(h5Share, -(void)h5Share:(NSString*)url :(NSString*)title :(NSString *)description :(NSString*)iconUrl);

JSExportAs(getLocation , -(void)getLocation:(NSString *)string :(NSString *)callBack);

JSExportAs(takePicture, -(void)takePicture:(NSString *)string :(NSString *)callBack);

JSExportAs(getPicture, -(void)getPicture:(NSString *)string :(NSString *)callBack);

@end

