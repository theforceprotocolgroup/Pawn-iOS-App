//
//  AssetHomeModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "AssetHomeModel.h"

@implementation AssetHomeModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"walletList" : NSClassFromString(@"AssetHomeTokenModel")};
}
@end
