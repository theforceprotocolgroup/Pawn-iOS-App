//
//  KKKeyChain.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/11/18.
//  Copyright © 2018 keke. All rights reserved.
//

#import "KKKeyChain.h"

static NSString *const KEY_IN_KEYCHAIN = @"UUIDINFO";
static NSString *const KEY_UUID = @"UUID";

@implementation KKKeyChain

- (void)saveUUID:(NSString *)UUID {
    
    NSMutableDictionary *UUIDDict = [NSMutableDictionary dictionary];
    [UUIDDict setObject:UUID forKey:KEY_UUID];
    [self save:KEY_IN_KEYCHAIN data:UUIDDict];
    
}


- (id)readUUID {
    
    NSMutableDictionary *UUIDDict = (NSMutableDictionary *)[self load:KEY_IN_KEYCHAIN];
    return [UUIDDict objectForKey:KEY_UUID];
    
}

- (void)deleteUUID {
    
    [self delete:KEY_IN_KEYCHAIN];
    
}


- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass, service, (__bridge_transfer id)kSecAttrService, service, (__bridge_transfer id)kSecAttrAccount, (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock, (__bridge_transfer id)kSecAttrAccessible, nil];
    
}

- (void)save:(NSString *)service data:(id)data {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
}

- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
