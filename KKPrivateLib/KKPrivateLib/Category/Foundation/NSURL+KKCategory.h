//
//  NSURL+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define o autoreleasepool{} [NSURL URLWithString:o];

/**
 // In its most basic form, a URI is comprised of a scheme name and a hierarchical part, with an optional query and fragment:
 <scheme name> : <hierarchical part> [ ? <query> ] [ # <fragment> ]
 
 // Protocols(like Https)  regular structure
 *http:// root:Password1@example.com:8042/over/there/index.dtb;param=value?type=animal&name=narwhal#nose
 | * |   | * |    *    |     *     | *  |       *        | * |     *     |          *            | * |
 SCHEME USERNAME PASSWORD HOSTNAME   PORT    PATH(.EXTENSION) PARAMETERSTRING      QUERY          FRAGMENT
 
 @discuss  More Info<http://nshipster.cn/nsurl/>(Chinese)  <http://nshipster.com/nsurl/>(English)
 */

@interface NSURL (KKCategory)

- (NSDictionary *)kkParametersDict;

@end

NS_ASSUME_NONNULL_END
