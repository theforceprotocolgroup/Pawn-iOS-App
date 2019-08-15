//
//  UpdateModel.h
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateModel : NSObject
//
@property (nonatomic, strong) NSString * currentVersion;
//
@property (nonatomic, strong) NSString * appURL;
//
@property (nonatomic, strong) NSString * updateContent;
//
@property (nonatomic, strong) NSString * updateVersion;

//
@property (nonatomic, assign) NSInteger appUpdateLevel;
@end

NS_ASSUME_NONNULL_END
