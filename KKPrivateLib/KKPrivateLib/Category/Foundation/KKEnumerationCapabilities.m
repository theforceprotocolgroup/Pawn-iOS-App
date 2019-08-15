//
//  KKEnumerationCapabilities.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "KKEnumerationCapabilities.h"
#define KKEnumeration_Implementation \
- (id)kkDetect:(BOOL (^)(id each))block { \
    return [super kkDetect:block]; \
} \
- (id)kkFirst { \
    return [super kkFirst]; \
} \
- (id)kkReject:(BOOL (^)(id each))block { \
    return [super kkReject:block]; \
} \
- (id)kkSelect:(BOOL (^)(id each))block { \
    return [super kkSelect:block]; \
} \
- (id)kkTakeWhile:(BOOL (^)(id each))block { \
    return [super kkTakeWhile:block]; \
} \
- (id)kkDropWhile:(BOOL (^)(id each))block { \
    return [super kkDropWhile:block]; \
} \
- (id)kkMap:(id  _Nonnull (^)(id _Nonnull))block { \
    return [super kkMap:block]; \
}

@implementation KKEnumerationCapabilities

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - KKAssociation
////////////////////////////////////////////////////////////////////////////////
@implementation KKAssociation
- (instancetype)initWithKey:(id)key value:(id)value {
    if (self = [super init]) {
        _key = key;
        _value = value;
    }
    return self;
}
@end

@implementation NSObject (OCAssociationSupport)
- (KKAssociation *)asAssociationWithKey:(id)key {
    return [[KKAssociation alloc] initWithKey:key value:self];
}
- (KKAssociation *)asAssociationWithValue:(id)value {
    return [[KKAssociation alloc] initWithKey:self value:value];
}
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Enumerator
////////////////////////////////////////////////////////////////////////////////

@interface KKAssociationEnumerator ()
@property (nonatomic, readonly) NSDictionary *backingDictionary;
@property (nonatomic, readonly) NSEnumerator *keyEnumerator;
@end


@implementation KKAssociationEnumerator
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _backingDictionary = dictionary;
        _keyEnumerator = [_backingDictionary keyEnumerator];
    }
    return self;
}

- (id)nextObject {
    id nextKey = [self.keyEnumerator nextObject];
    if (!nextKey) {
        return nil;
    }
    id nextValue = [self.backingDictionary objectForKey:nextKey];
    return [nextKey asAssociationWithValue:nextValue];
}
@end


@interface KKCharacterEnumerator ()
@property (nonatomic, readonly) NSString *backingString;
@property (nonatomic, readwrite) NSUInteger currentIndex;
@end


@implementation KKCharacterEnumerator

- (instancetype)initWithString:(NSString *)string {
    if (self = [super init]) {
        _backingString = string;
        _currentIndex = 0;
    }
    return self;
}

- (id)nextObject {
    if (self.currentIndex >= self.backingString.length) {
        return nil;
    }
    id current = [self.backingString substringWithRange:NSMakeRange(self.currentIndex, 1)];
    self.currentIndex++;
    return current;
}

@end


@interface KKIntervalEnumerator ()
@property (nonatomic, readonly) KKInterval *interval;
@property (nonatomic, readwrite) NSInteger index;
@end


@implementation KKIntervalEnumerator

- (instancetype)initWithInterval:(KKInterval *)interval {
    if (self = [super init]) {
        _interval = interval;
        _index = 0;
    }
    return self;
}

- (NSInteger)size {
    if (self.interval.by == 0) {
        return 0;
    }
    if (self.interval.by < 0) {
        if (self.interval.from < self.interval.to) {
            return 0;
        } else {
            return (self.interval.to - self.interval.from) / self.interval.by + 1;
        }
    } else {
        if (self.interval.to < self.interval.from) {
            return 0;
        } else {
            return (self.interval.to - self.interval.from) / self.interval.by + 1;
        }
    }
}

- (id)nextObject {
    NSInteger end = [self size] - 1;
    if (self.index <= end) {
        return @(self.interval.from + (self.interval.by * self.index++));
    }
    return nil;
}

@end


@interface KKMapTableEnumerator ()
@property (nonatomic, readonly) NSMapTable *mapTable;
@property (nonatomic, readonly) NSEnumerator *keyEnumerator;
@end


@implementation KKMapTableEnumerator

- (instancetype)initWithMapTable:(NSMapTable *)mapTable {
    if (self = [super init]) {
        _mapTable = mapTable;
        _keyEnumerator = [_mapTable keyEnumerator];
    }
    return self;
}

- (id)nextObject {
    id nextKey = [self.keyEnumerator nextObject];
    if (!nextKey) {
        return nil;
    }
    id nextValue = [self.mapTable objectForKey:nextKey];
    return [nextKey asAssociationWithValue:nextValue];
}

@end


@implementation KKNullEnumerator
- (id)nextObject {
    return nil;
}
@end

@implementation KKInterval
- (instancetype)initWithFrom:(NSInteger)from to:(NSInteger)to by:(NSInteger)by {
    if (self = [super init]) {
        _from = from;
        _to = to;
        _by = by;
    }
    return self;
}

- (id)kkMutableInstance {
    return [NSMutableArray array];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    [instance addObject:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    return [NSArray arrayWithArray:instance];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [self intervalEnumerator];
}

- (NSEnumerator *)intervalEnumerator {
    return [[KKIntervalEnumerator alloc] initWithInterval:self];
}
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Extend
////////////////////////////////////////////////////////////////////////////////

@implementation NSArray (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [NSMutableArray array];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [self objectEnumerator];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    [instance addObject:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    return [NSArray arrayWithArray:instance];
}

KKEnumeration_Implementation
@end


@implementation NSNull (KKEnumerationCapabilities)
- (NSEnumerator *)kkCollectionEnumerator {
    return [[KKNullEnumerator alloc] init];
}

KKEnumeration_Implementation
@end

@implementation NSNumber (KKEnumerationCapabilities)
- (NSEnumerator *)kkCollectionEnumerator {
    return [[KKIntervalEnumerator alloc] initWithInterval:
            [[KKInterval alloc] initWithFrom:0 to:self.integerValue by:1]];
}

- (id _Nullable )kkMutableInstance {
    return [[[KKInterval alloc] init] kkMutableInstance];
}
- (void)kkAddObject:(id _Nullable )obj toMutableInstance:(id)instance {
    KKInterval *inter = instance;
    [inter kkAddObject:obj toMutableInstance:instance];
}
- (id _Nullable )kkInstanceFromMutable:(id)instance {
    return [[[KKInterval alloc] init] kkInstanceFromMutable:instance];
}

KKEnumeration_Implementation
@end

@implementation NSDictionary (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [NSMutableDictionary dictionary];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [[KKAssociationEnumerator alloc] initWithDictionary:self];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    KKAssociation *assoc = obj;
    [instance setObject:assoc.value forKey:assoc.key];
}

- (id)kkInstanceFromMutable:(id)instance {
    return [NSDictionary dictionaryWithDictionary:instance];
}

KKEnumeration_Implementation
@end


@implementation NSHashTable (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [[NSHashTable alloc] initWithPointerFunctions:self.pointerFunctions capacity:self.count];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [self objectEnumerator];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    NSHashTable *hashTable = instance;
    [hashTable addObject:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    // there are no mutable/immutable variants of NSHashTable, so it is
    // safe to just return collection here
    return instance;
}

KKEnumeration_Implementation
@end


@implementation NSMapTable (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [[NSMapTable alloc] initWithKeyPointerFunctions:self.keyPointerFunctions valuePointerFunctions:self.valuePointerFunctions capacity:self.count];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [[KKMapTableEnumerator alloc] initWithMapTable:self];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    NSMapTable *mapTable = instance;
    KKAssociation *association = obj;
    [mapTable setObject:association.value forKey:association.key];
}

- (id)kkInstanceFromMutable:(id)instance {
    // there are no mutable/immutable variants of NSMapTable, so it is
    // safe to just return collection here
    return instance;
}

KKEnumeration_Implementation
@end


@implementation NSPointerArray (KKEnumerationCapabilities)

- (void)kk_addObject:(id)object {
    [self addPointer:(__bridge void *)object];
}

- (id)kkMutableInstance {
    return [NSPointerArray pointerArrayWithPointerFunctions:self.pointerFunctions];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [self.allObjects objectEnumerator];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    NSPointerArray *other = instance;
    [other kk_addObject:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    // there are no mutable/immutable variants of NSPointerArray, so it is
    // safe to just return collection here
    return instance;
}

KKEnumeration_Implementation
@end


@implementation NSSet (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [NSMutableSet set];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [self objectEnumerator];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    [instance addObject:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    return [self.class setWithSet:instance];
}


KKEnumeration_Implementation
@end


@implementation NSString (KKEnumerationCapabilities)

- (id)kkMutableInstance {
    return [NSMutableString stringWithString:@""];
}

- (NSEnumerator *)kkCollectionEnumerator {
    return [[KKCharacterEnumerator alloc] initWithString:self];
}

- (void)kkAddObject:(id)obj toMutableInstance:(id)instance {
    [instance appendString:obj];
}

- (id)kkInstanceFromMutable:(id)instance {
    // there is no reliable way to distinguish between mutable and immutable
    // string instances; [self.class stringWithString:collection] would crash
    // with _NSCFString instances (constant strings)
    return instance;
}

KKEnumeration_Implementation
@end

