//
//  NSString+KKURLString.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSString+KKURLString.h"
#import "KKKeyChain.h"
#import "NSString+KKCategory.h"

@implementation NSString (KKURLString)

-(NSString *)kkFormaterCustomURLString;
{
    
    NSMutableString * temStr = [NSMutableString stringWithFormat:@"%@",[self kkStringByWhitespaceAndNewline]];

    [temStr appendString:@"?"];
    
    NSInteger count = [self urlPathArr].count;
    [[self urlPathArr]enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temStr appendFormat:@"%@",obj];
        [temStr appendString:@"="];
        if (idx < [[self urlPathParma] count]) {
            [temStr appendFormat:@"%@",[self urlPathParma][idx]];
        }
        if (idx != count-1) {
            [temStr appendString:@"&"];
        }
    }];
    
    return temStr;
}

-(NSString *)version
{
    return @"1.0.0";
}

-(NSString *)format
{
    return @"json";
}
-(NSString *)appplt
{
    return @"ios";
}
-(NSString *)appid
{
    return @"com.bbd.mrge";
}
-(NSString *)appversion
{
    NSString *app_version = [[[NSBundle mainBundle] infoDictionary]
                             objectForKey:@"CFBundleShortVersionString"];
    return app_version;
}
- (NSString *)uuid {
    NSString * uuidStr ;
    KKKeyChain *key = [[KKKeyChain alloc] init];
    if ([key readUUID]) {
    }else {
        [key saveUUID:[NSString kkStringWithUUID]];
    }
    uuidStr = [key readUUID];
    return uuidStr;
}
-(NSArray *)urlPathArr;
{
    return @[@"version",@"format",@"appplt",@"appid",@"appversion",@"udid"];
}
-(NSArray *)urlPathParma
{
    return @[[self version],[self format],[self appplt],[self appid],[self appversion],[self uuid]];
}
@end
