//
//  NSArray+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSArray+KKCategory.h"
#import "YYKit.h"
@implementation NSArray (KKCategory)

- (NSArray *)addArr:(NSArray *)arr {
    NSMutableArray *mut = [NSMutableArray arrayWithArray:self];
    [mut appendObjects:arr];
    return mut ;
}

#pragma mark -
///=============================================================================
/// @name POP
///=============================================================================

- (void)kkEach:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (void)kkEachWithPreAndIndex:(void (^)(id obj, id preObj, NSUInteger idx))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx==0?nil:self[idx-1], idx);
    }];
}

- (void)kkEachIndex:(void (^)(id obj, NSInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (void)kkEachWithIndex:(void (^)(id obj, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (NSArray *)kkFilter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}


- (BOOL)kkSome:(BOOL (^)(id obj))block {
    for (id obj in self) {
        if (block(obj)) return YES;
    }
    return NO;
}

- (BOOL)kkEvery:(BOOL (^)(id obj))block {
    for (id obj in self) {
        if (!block(obj)) return NO;
    }
    return YES;
}

- (NSString *)kkJoin:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

- (NSArray *)kkFlatten {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:NSArray.class]) {
            [array addObjectsFromArray:[object kkFlatten]];
        } else {
            [array addObject:object];
        }
    }
    return array;
}

- (id)kkRandomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)kkLastObject {
    if ([self isKindOfClass:[NSArray class]] && self.count) {
        return self.lastObject;
    }
    return nil;
}

- (id)kkFirstObject {
    if ([self isKindOfClass:[NSArray class]] && self.count) {
        return self.firstObject;
    }
    return nil;
}

- (id)kkObjectAtIndex:(NSUInteger)index {
    if ([self isKindOfClass:[NSArray class]] && self.count && self.count-1>=index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Plist Data
///=============================================================================
/// @name Plist Data
///=============================================================================

+ (NSArray *)kkArrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *arr = [NSPropertyListSerialization propertyListWithData:plist
                                                             options:NSPropertyListImmutable format:NULL error:NULL];
    if ([arr isKindOfClass:[NSArray class]]) return arr;
    return nil;
}

+ (NSArray *)kkArrayWithPlistString:(NSString *)plistString {
    if (!plistString) return nil;
    NSData *data = [plistString dataUsingEncoding:NSUTF8StringEncoding];
    return [self kkArrayWithPlistData:data];
}

- (NSData *)kkPlistData {
    return [NSPropertyListSerialization dataWithPropertyList:self
                                                      format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];;
}

- (NSString *)kkPlistString {
    NSData *data = [NSPropertyListSerialization
                    dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (data) return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return nil;
}


#pragma mark - JsonString Transform
///=============================================================================
/// @name JsonString Transform
///=============================================================================

- (NSString *)kkJsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)kkJsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}


@end
