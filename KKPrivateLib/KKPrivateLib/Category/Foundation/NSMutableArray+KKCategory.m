//
//  NSMutableArray+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/14.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSMutableArray+KKCategory.h"

@implementation NSMutableArray (KKCategory)

+ (NSMutableArray *)kkArrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)kkArrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self kkArrayWithPlistData:data];
}


- (id)kkPopFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self kkShift];
    }
    return obj;
}

- (id)kkPopLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)kkPush:(id)obj {
    if (obj) [self addObject:obj];
}


- (void)kkPushObjs:(NSArray *)objs {
    if (!objs) return;
    [self addObjectsFromArray:objs];
}

- (void)kkPop {
    [self removeLastObject];
}

- (void)kkShift {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)kkUnShift:(id)obj {
    if (obj) [self insertObject:obj atIndex:0];
}

- (void)kkUnShiftObjs:(NSArray *)objs {
    if (!objs) return;
    NSUInteger i = 0;
    for (id obj in objs) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)kkReverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)kkShuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
