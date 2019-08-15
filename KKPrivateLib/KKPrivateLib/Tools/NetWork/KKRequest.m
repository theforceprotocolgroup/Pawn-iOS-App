//
//  KKRequest.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/17.
//  Copyright © 2018 keke. All rights reserved.
//

#import "KKRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "KKKeyChain.h"
#import "NSString+KKCategory.h"
#import "UserManager.h"
@implementation KKRequest

/*!  */
+ (KKRequestTask *)request {
    KKRequestTask *task = [KKRequestTask manager];
    task.securityPolicy     = [KKSerialization kkSecurityPolicy];
    task.requestSerializer  = [KKSerialization kkRequestSerializer];
    task.responseSerializer = [KKSerialization kkResponseSerializer];
    return task;
}

/*!  */
+ (KKRequestTask *)jsonRequest {
    KKRequestTask *task = [KKRequestTask manager];
    task.securityPolicy     = [KKSerialization kkSecurityPolicy];
    task.requestSerializer  = [KKSerialization kkJsonRequestSerializer];
    task.responseSerializer = [KKSerialization kkResponseSerializer];
    return task;
}

+ (KKRequestTask *)dataRequest {
    KKRequestTask *task = [KKRequestTask manager];
    task.securityPolicy     = [KKSerialization kkSecurityPolicy];
    task.requestSerializer  = [KKSerialization kkRequestSerializer];
    task.responseSerializer = [KKSerialization kkResponseSerializer];
    task.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"image/jpeg",@"image/png",@"application/x-zip-compressed",@"application/zip",@"application/x-www-form-urlencoded",@"multipart/form-data",nil];
    return task;
}

/*!  */
+ (KKRequestTask *)defaultRequest {
    return [KKRequestTask manager];
}

@end

@implementation KKSerialization

#pragma mark - Custom -- AFURLRequestSerializer
///=============================================================================
/// @name UFQ -- AFURLRequestSerializer
///=============================================================================

+ (AFHTTPRequestSerializer *)kkRequestSerializer {
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.timeoutInterval = [self timeoutInterval];
    [self setHeaders:serializer];
    return serializer;
}

+ (AFJSONRequestSerializer *)kkJsonRequestSerializer {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    serializer.timeoutInterval = [self timeoutInterval];
    [self setHeaders:serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return serializer;
}

/* The timeout interval, in seconds. */
+ (NSTimeInterval)timeoutInterval {
    return 90;
}

+ (void)setHeaders:(AFHTTPRequestSerializer *)serializer {
    [serializer setValue:[self netversion] forHTTPHeaderField:@"version"];
    [serializer setValue:[self format] forHTTPHeaderField:@"format"];
    [serializer setValue:[self appplt] forHTTPHeaderField:@"appplt"];
    [serializer setValue:[self appid] forHTTPHeaderField:@"appid"];
    [serializer setValue:[self appversion] forHTTPHeaderField:@"appversion"];
    NSString *uuid = [self uuid];
    [serializer setValue:uuid?uuid:@"" forHTTPHeaderField:@"udid"];
    NSString *uid = [UserManager manager].userid;
    [serializer setValue:uid?uid:@"" forHTTPHeaderField:@"uid"];
    NSString *token = [UserManager manager].token;
    [serializer setValue:token?token:@"" forHTTPHeaderField:@"token"];
}
+(NSString *)netversion
{
    return @"1.0.0";
}
+(NSString *)format
{
    return @"json";
}
+(NSString *)appplt
{
    return @"ios";
}
+(NSString *)appid
{
    return @"com.bbd.mrge";
}
+(NSString *)appversion
{
    return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)uuid {
    NSString * uuidStr ;
    KKKeyChain *key = [[KKKeyChain alloc] init];
    if ([key readUUID]) {
    }else {
        [key saveUUID:[NSString kkStringWithUUID]];
    }
    uuidStr = [key readUUID];
    return uuidStr;
}


#pragma mark - Custom -- AFURLResponseSerializer
///=============================================================================
/// @name UFQ -- AFURLResponseSerializer
///=============================================================================

+ (AFHTTPResponseSerializer *)kkResponseSerializer {
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    return serializer;
}

#pragma mark - Custom -- AFURLResponseSerializer
///=============================================================================
/// @name UFQ -- AFURLResponseSerializer
///=============================================================================

+ (AFSecurityPolicy *)kkSecurityPolicy {
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;
}

@end
