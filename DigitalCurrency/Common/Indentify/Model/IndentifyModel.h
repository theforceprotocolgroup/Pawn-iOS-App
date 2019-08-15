//
//  IndentifyModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/21.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndentifyModel : NSObject
//
@property (nonatomic, strong) NSString * realName;
//
@property (nonatomic, strong) NSString * IDcardNumber;
//
@property (nonatomic, strong) NSString * IDcardFrontURI;
//
@property (nonatomic, strong) NSString * IDcardBackURI;
//
@property (nonatomic, strong) NSString * IDcardInHandURI;
//0未认证 1初级认证（身份证号和姓名）2认证中 3认证失败 4认证成功
@property (nonatomic, assign) NSInteger identified;
@end

NS_ASSUME_NONNULL_END
