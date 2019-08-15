//
//  NSData+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSData (KKCategory)
- (NSString *)kkToString;

- (NSString *)kkMD5;

+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end

NS_ASSUME_NONNULL_END
