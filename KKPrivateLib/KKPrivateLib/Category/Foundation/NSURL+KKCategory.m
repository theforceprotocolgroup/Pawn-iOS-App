//
//  NSURL+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSURL+KKCategory.h"
#import "KKMacro.h"
#import "NSDictionary+KKCategory.h"
@implementation NSURL (KKCategory)

- (NSDictionary *)kkParametersDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString *component in queryComponents) {
        NSString *key = [component componentsSeparatedByString:@"="].firstObject;
        NSString *value = [component substringFromIndex:(key.length + 1)];
        dict.kkSetKeyValue(key, value);
    }
    return dict;
}


@end
