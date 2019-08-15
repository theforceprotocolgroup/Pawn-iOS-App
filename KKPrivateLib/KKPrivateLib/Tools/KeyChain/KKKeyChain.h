//
//  KKKeyChain.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/18.
//  Copyright © 2018 keke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKKeyChain : NSObject
/**
 *  存储UUID
 *
 *  @param UUID UUID
 */
- (void)saveUUID:(NSString *)UUID;

/**
 *  读取UUID
 *
 *  @return BACK UUID
 */
- (id)readUUID;

- (void)deleteUUID;

@end

NS_ASSUME_NONNULL_END
