//
//  HelpCenterModel.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "HelpCenterModel.h"

@implementation HelpCenterModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"issuesContent" : NSClassFromString(@"HelpCenterDetailModel"),
             };
}
@end
