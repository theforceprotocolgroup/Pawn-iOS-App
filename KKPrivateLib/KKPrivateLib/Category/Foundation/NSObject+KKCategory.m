//
//  NSObject+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSObject+KKCategory.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "KKMacro.h"
#import <UIKit/UIKit.h>
@import ObjectiveC.message;
KKSYNTH_DUMMY_CLASS(NSObject_KKCategory)

#pragma mark - Weak support
@interface _KKWeakAssociatedObject : NSObject
@property (nonatomic, weak) id value;
@end
@implementation _KKWeakAssociatedObject
@end

#pragma mark - SKVO support
typedef NS_ENUM(int, SKObserverContext) {
    SKObserverContextKey,
    SKObserverContextKeyWithChange,
    SKObserverContextManyKeys,
    SKObserverContextManyKeysWithChange
};
@interface _SKObserver : NSObject {
    BOOL _isObserving;
}
@property (nonatomic, readonly, unsafe_unretained) id observer;
@property (nonatomic, readonly) NSMutableArray *keyPaths;
@property (nonatomic, readonly) id task;
@property (nonatomic, readonly) SKObserverContext context;
- (id)initWithObserver:(id)observer keyPaths:(NSArray *)keyPaths context:(SKObserverContext)context task:(id)task;
@end
static void *SKObserverBlocksKey = &SKObserverBlocksKey;
static void *SKBlockObservationContext = &SKBlockObservationContext;
@implementation _SKObserver
- (instancetype)initWithObserver:(id)observer keyPaths:(NSArray *)keyPaths
                         context:(SKObserverContext)context task:(id)task {
    if ((self = [super init])) {
        _observer = observer;
        _keyPaths = [keyPaths mutableCopy];
        _context = context;
        _task = [task copy];
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context != SKBlockObservationContext) return;
    @synchronized(self) {
        switch (self.context) {
            case SKObserverContextKey: {
                void (^task)(id) = self.task;
                task(object);
                break;
            }
            case SKObserverContextKeyWithChange: {
                void (^task)(id, NSDictionary *) = self.task;
                task(object, change);
                break;
            }
            case SKObserverContextManyKeys: {
                void (^task)(id, NSString *) = self.task;
                task(object, keyPath);
                break;
            }
            case SKObserverContextManyKeysWithChange: {
                void (^task)(id, NSString *, NSDictionary *) = self.task;
                task(object, keyPath, change);
                break;
            }
        }
    }
}
- (void)startObservingWithOptions:(NSKeyValueObservingOptions)options {
    @synchronized(self) {
        if (_isObserving) return;
        [self.keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
            [self.observer addObserver:self forKeyPath:keyPath options:options context:SKBlockObservationContext];
        }];
        _isObserving = YES;
    }
}
- (void)stopObservingKeyPath:(NSString *)keyPath {
    NSParameterAssert(keyPath);
    
    @synchronized (self) {
        if (!_isObserving) return;
        if (![self.keyPaths containsObject:keyPath]) return;
        
        NSObject *observee = self.observer;
        if (!observee) return;
        
        [self.keyPaths removeObject: keyPath];
        keyPath = [keyPath copy];
        if (!self.keyPaths.count) {
            _task = nil;
            _observer = nil;
            _keyPaths = nil;
        }
        [observee removeObserver:self forKeyPath:keyPath context:SKBlockObservationContext];
    }
}
- (void)_stopObservingLocked {
    if (!_isObserving) return;
    _task = nil;
    
    NSObject *observer = self.observer;
    NSArray *keyPaths = [self.keyPaths copy];
    _observer = nil;
    _keyPaths = nil;
    
    [keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
        [observer removeObserver:self forKeyPath:keyPath context:SKBlockObservationContext];
    }];
}
- (void)stopObserving {
    if (_observer == nil) return;
    @synchronized (self) {
        [self _stopObservingLocked];
    }
}
- (void)dealloc {
    if (self.keyPaths) {
        [self _stopObservingLocked];
    }
}
@end

#pragma mark - Main Caterory

@implementation NSObject (KKCategory)

- (NSEnumerator *)kkEnumerator {
    if ([self conformsToProtocol:@protocol(KKEnumerableProtocol)]) {
        return [(id<KKEnumerableProtocol>)self kkCollectionEnumerator];
    }
    return nil;
}

#pragma mark - Algorithms correlation
///=============================================================================
/// @name 计算相关
///=============================================================================

/*! 所有元素 block 返回值都为 YES 时, 返回 YES, 反之返回 NO. */
- (BOOL)kkAllSatisfy:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) return block(self);
    for (id each in enumerator) {
        if (!block(each)) return NO;
    }
    return YES;
}

/*! 任一元素 block 返回值为 YES 时, 返回 YES, 反之返回 NO. */
- (BOOL)kkAnySatisfy:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) return block(self);
    for (id each in enumerator) {
        if (block(each)) return YES;
    }
    return NO;
}

/*! 检测元素值, 返回第一个 block 返回值为 YES 的元素值. */
- (id)kkDetect:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) return block(self) ? self : nil;
    for (id each in enumerator) {
        if (block(each)) return each;
    }
    return nil;
}

/*! 返回第一个元素值, 为空返 nil. */
- (id)kkFirst {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) return self;
    for (id each in enumerator) {
        return each;
    }
    return nil;
}

/*! e.g.  @"12345" -(3)-> @"123" */
- (id)kkFirst:(NSUInteger)count {
    return self;
}

/*! 剔除元素值中所有 block 返回 YES 的元素, 返回一个receiver类型的值 */
- (id)kkReject:(BOOL (^)(id each))block {
    return [self kkSelect:^BOOL(id each) {
        return !block(each);
    }];
}

/*! 剔除元素值中所有 block 返回 NO 的元素, 返回一个receiver类型的值 */
- (id)kkSelect:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator || ![self conformsToProtocol:@protocol(KKEnumerableCollectionProtocol)])
        return block(self) ? self : nil;
    id<KKEnumerableCollectionProtocol> this = (id<KKEnumerableCollectionProtocol>)self;
    id mutInstance = [this kkMutableInstance];
    for (id each in enumerator) {
        if (block(each)) {
            [this kkAddObject:each toMutableInstance:mutInstance];
        }
    }
    return [this kkInstanceFromMutable:mutInstance];
}

/*!
 Evaluate whileBlock with each of the receiver's elements as the argument
 until it answers NO. Answer a collection with all of the elements that
 evaluated to YES up to that point.
 ==> 取 第一个 block 返回值为 NO 之前的所有元素, 返回一个receiver类型的值
 */
- (id)kkTakeWhile:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator || ![self conformsToProtocol:@protocol(KKEnumerableCollectionProtocol)])
        return block(self) ? self : nil;
    id<KKEnumerableCollectionProtocol> this = (id<KKEnumerableCollectionProtocol>)self;
    id mutInstance = [this kkMutableInstance];
    for (id each in enumerator) {
        if (block(each)) {
            [this kkAddObject:each toMutableInstance:mutInstance];
        } else {
            return [this kkInstanceFromMutable:mutInstance];
        }
    }
    return [this kkInstanceFromMutable:mutInstance];
}

/*! 取 第一个 block 返回值为 NO 和之后的所有元素, 返回一个receiver类型的值 */
- (id)kkDropWhile:(BOOL (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator || ![self conformsToProtocol:@protocol(KKEnumerableCollectionProtocol)])
        return block(self) ? self : nil;
    id<KKEnumerableCollectionProtocol> this = (id<KKEnumerableCollectionProtocol>)self;
    id mutInstance = [this kkMutableInstance];
    BOOL kepDrop = YES;
    for (id each in enumerator) {
        if (kepDrop) kepDrop = block(each);
        if (!kepDrop) {
            [this kkAddObject:each toMutableInstance:mutInstance];
        }
    }
    return [this kkInstanceFromMutable:mutInstance];
}

#pragma mark - Map
/*! 取 每个 block 返回值组成一个新的集合, 返回一个receiver类型的值 */
- (id)kkMap:(id (^)(id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator || ![self conformsToProtocol:@protocol(KKEnumerableCollectionProtocol)])
        return block(self);
    id<KKEnumerableCollectionProtocol> this = (id<KKEnumerableCollectionProtocol>)self;
    id mutInstance = [this kkMutableInstance];
    for (id each in enumerator) {
        [this kkAddObject:block(each) toMutableInstance:mutInstance];
    }
    return [this kkInstanceFromMutable:mutInstance];
}

/*! */
- (id)kkReduce:(id (^)(id accumulator, id each))block {
    return [self kkReduce:nil block:block];
}

- (id)kkReduce:(id)initial block:(id (^)(id accumulator, id each))block {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) return block(initial, self);
    id accumulator = initial;
    for (id each in enumerator) {
        accumulator = block(accumulator, each);
    }
    return accumulator;
}

#pragma mark - Null

- (BOOL)kkIsNull {
    return [self isEqual:[NSNull null]];
}

- (BOOL)kkIsNotNull {
    return ![self kkIsNull];
}

#pragma mark - Enum

/*! 遍历 */
- (void)kkEach:(void (^)(id each))eachBlock {
    [self kkEachWithIndex:^(id  _Nonnull each, NSUInteger idx) {
        eachBlock(each);
    } separatedBy:nil];
}

/*! */
- (void)kkEachWithIndex:(void (^)(id each, NSUInteger idx))eachBlock {
    [self kkEachWithIndex:eachBlock separatedBy:nil];
}

- (void)kkEach:(void (^)(id each))eachBlock separatedBy:(void (^)(void))separatorBlock {
    [self kkEachWithIndex:^(id  _Nonnull each, NSUInteger idx) {
        eachBlock(each);
    } separatedBy:separatorBlock];
}

- (void)kkEachWithIndex:(void (^)(id each, NSUInteger idx))eachBlock separatedBy:(void (^)(void))separatorBlock {
    NSEnumerator *enumerator = [self kkEnumerator];
    if (!enumerator) eachBlock(self, 0);
    NSUInteger idx = 0;
    for (id each in enumerator) {
        if (idx>0) {
            if (separatorBlock) separatorBlock();
        }
        eachBlock(each, idx);
        idx++;
    }
}

- (BOOL)kkIsEmpty {
    if ([self respondsToSelector:@selector(count)]) {
        return [(id)self count] == 0;
    }
    if ([self respondsToSelector:@selector(length)]) {
        return [(id)self length] == 0;
    }
    if ([self conformsToProtocol:@protocol(KKEnumerableProtocol)]) {
        for (id __attribute__((unused))each in [(id<KKEnumerableProtocol>)self kkCollectionEnumerator]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmpty {
    return ![self kkIsEmpty];
}

#pragma mark - Class Correlation
///=============================================================================
/// @name Class Correlation
///=============================================================================

+ (NSString *)kkClassName {
    return NSStringFromClass(self);
}

- (NSString *)kkClassName {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

- (NSDictionary *)kkPropertyDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0; i<outCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        [dict setObject:propValue?:[NSNull null] forKey:propName];
    }
    free(props);
    return dict;
}

- (NSArray<NSString *> *)kkPropertyKeys {
    return [[self class] kkPropertyKeys];
}

+ (NSArray<NSString *> *)kkPropertyKeys {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (unsigned int i=0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

- (NSArray *)kkPropertiesInfo {
    return [[self class] kkPropertiesInfo];
}

+ (NSArray *)kkPropertiesInfo {
    NSMutableArray *propertieArray = [NSMutableArray array];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        NSDictionary *dict = [self kkDictionaryWithProperty:properties[i]];
        [propertieArray addObject:dict];
    }
    free(properties);
    return propertieArray;
}

- (NSDictionary *)kkDictionaryWithProperty:(objc_property_t)property {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    /* name */
    NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    result[@"name"] = propertyName;
    /* attribute */
    NSMutableDictionary *attributeDictionary = ({
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        unsigned int attributeCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(property, &attributeCount);
        for (int i = 0; i < attributeCount; i++) {
            NSString *name = [NSString stringWithCString:attrs[i].name encoding:NSUTF8StringEncoding];
            NSString *value = [NSString stringWithCString:attrs[i].value encoding:NSUTF8StringEncoding];
            [dictionary setObject:value forKey:name];
        }
        free(attrs);
        dictionary;
    });
    NSMutableArray *attributeArray = [NSMutableArray array];
    /***
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
     R           | The property is read-only (readonly).
     C           | The property is a copy of the value last assigned (copy).
     &           | The property is a reference to the value last assigned (retain).
     N           | The property is non-atomic (nonatomic).
     G<name>     | The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
     S<name>     | The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
     D           | The property is dynamic (@dynamic).
     W           | The property is a weak reference (__weak).
     P           | The property is eligible for garbage collection.
     t<encoding> | Specifies the type using old-style encoding.
     */
    // R
    if ([attributeDictionary objectForKey:@"R"]) [attributeArray addObject:@"readonly"];
    // C
    if ([attributeDictionary objectForKey:@"C"]) [attributeArray addObject:@"copy"];
    // &
    if ([attributeDictionary objectForKey:@"&"]) [attributeArray addObject:@"strong"];
    // N
    if ([attributeDictionary objectForKey:@"N"]) {
        [attributeArray addObject:@"nonatomic"];
    } else {
        [attributeArray addObject:@"atomic"];
    }
    // G<name>
    if ([attributeDictionary objectForKey:@"G"]) [attributeArray addObject:[NSString stringWithFormat:@"getter=%@", [attributeDictionary objectForKey:@"G"]]];
    // S<name>
    if ([attributeDictionary objectForKey:@"S"]) [attributeArray addObject:[NSString stringWithFormat:@"setter=%@", [attributeDictionary objectForKey:@"G"]]];
    // D
    if ([attributeDictionary objectForKey:@"D"]) {
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"isDynamic"];
    } else {
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"isDynamic"];
    }
    // W
    if ([attributeDictionary objectForKey:@"W"]) [attributeArray addObject:@"weak"];
    // P
    if ([attributeDictionary objectForKey:@"P"]) {
        //TODO:P | The property is eligible for garbage collection.
    }
    // T
    if ([attributeDictionary objectForKey:@"T"]) {
        /*
         https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         c               A char
         i               An int
         s               A short
         l               A long l is treated as a 32-bit quantity on 64-bit programs.
         q               A long long
         C               An unsigned char
         I               An unsigned int
         S               An unsigned short
         L               An unsigned long
         Q               An unsigned long long
         f               A float
         d               A double
         B               A C++ bool or a C99 _Bool
         v               A void
         *               A character string (char *)
         @               An object (whether statically typed or typed id)
         #               A class object (Class)
         :               A method selector (SEL)
         [array type]    An array
         {name=type...}  A structure
         (name=type...)  A union
         bnum            A bit field of num bits
         ^type           A pointer to type
         ?               An unknown type (among other things, this code is used for function pointers)
         
         */
        NSDictionary *typeDic = @{@"c":@"char",
                                  @"i":@"int",
                                  @"s":@"short",
                                  @"l":@"long",
                                  @"q":@"long long",
                                  @"C":@"unsigned char",
                                  @"I":@"unsigned int",
                                  @"S":@"unsigned short",
                                  @"L":@"unsigned long",
                                  @"Q":@"unsigned long long",
                                  @"f":@"float",
                                  @"d":@"double",
                                  @"B":@"BOOL",
                                  @"v":@"void",
                                  @"*":@"char *",
                                  @"@":@"id",
                                  @"#":@"Class",
                                  @":":@"SEL",
                                  };
        //TODO:An array
        NSString *key = [attributeDictionary objectForKey:@"T"];
        id type_str = [typeDic objectForKey:key];
        if (type_str == nil) {
            if ([[key substringToIndex:1] isEqualToString:@"@"] && [key rangeOfString:@"?"].location == NSNotFound) {
                type_str = [[key substringWithRange:NSMakeRange(2, key.length - 3)] stringByAppendingString:@"*"];
            } else if ([[key substringToIndex:1] isEqualToString:@"^"]) {
                id str = [typeDic objectForKey:[key substringFromIndex:1]];
                if (str) {
                    type_str = [NSString stringWithFormat:@"%@ *",str];
                }
            } else {
                type_str = @"unknow";
            }
        }
        [result setObject:type_str forKey:@"type"];
    }
    [result setObject:attributeArray forKey:@"attribute"];
    
    return result;
}


+ (NSString *)kkDecodeType:(const char *)cString{
    if (!strcmp(cString, @encode(char)))
        return @"char";
    if (!strcmp(cString, @encode(int)))
        return @"int";
    if (!strcmp(cString, @encode(short)))
        return @"short";
    if (!strcmp(cString, @encode(long)))
        return @"long";
    if (!strcmp(cString, @encode(long long)))
        return @"long long";
    if (!strcmp(cString, @encode(unsigned char)))
        return @"unsigned char";
    if (!strcmp(cString, @encode(unsigned int)))
        return @"unsigned int";
    if (!strcmp(cString, @encode(unsigned short)))
        return @"unsigned short";
    if (!strcmp(cString, @encode(unsigned long)))
        return @"unsigned long";
    if (!strcmp(cString, @encode(unsigned long long)))
        return @"unsigned long long";
    if (!strcmp(cString, @encode(float)))
        return @"float";
    if (!strcmp(cString, @encode(double)))
        return @"double";
    if (!strcmp(cString, @encode(bool)))
        return @"bool";
    if (!strcmp(cString, @encode(_Bool)))
        return @"_Bool";
    if (!strcmp(cString, @encode(void)))
        return @"void";
    if (!strcmp(cString, @encode(char *)))
        return @"char *";
    if (!strcmp(cString, @encode(id)))
        return @"id";
    if (!strcmp(cString, @encode(Class)))
        return @"class";
    if (!strcmp(cString, @encode(SEL)))
        return @"SEL";
    if (!strcmp(cString, @encode(BOOL)))
        return @"BOOL";
    
    //@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    } else {
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *",
                      [NSString kkDecodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return result;
}


#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================

- (void)kkSetAssociateValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)kkSetAssociateWeakValue:(id)value withKey:(const void *)key {
    _KKWeakAssociatedObject *assObj = objc_getAssociatedObject(self, key);
    if (!assObj) {
        assObj = [_KKWeakAssociatedObject new];
        [self kkSetAssociateWeakValue:assObj withKey:key];
    }
    assObj.value = value;
}

- (void)kkSetAssociateCopyValue:(__autoreleasing id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)kkGetAssociatedValueForKey:(const void *)key {
    id value = objc_getAssociatedObject(self, key);
    if (value && [value isKindOfClass:[_KKWeakAssociatedObject class]]) {
        return [(_KKWeakAssociatedObject *)value value];
    }
    return value;
}

- (void)kkRemoveAssociatedValues {
    objc_removeAssociatedObjects(self);
}

#pragma mark - Sending messages with variable parameters

///=============================================================================
/// @name Sending messages with variable parameters -- NSInvocation
///=============================================================================

/*
 NSInvocation is much slower than objc_msgSend()...
 Do not use it if you have performance issues.
 
 // TODO: 1. implementation in objc_msgSend()
 // TODO: 2. implementation in block
 */

#define INIT_INV(_last_arg_, _return_) \
NSMethodSignature * sig = [self methodSignatureForSelector:sel]; \
if (!sig) { [self doesNotRecognizeSelector:sel]; return _return_; } \
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig]; \
if (!inv) { [self doesNotRecognizeSelector:sel]; return _return_; } \
[inv setTarget:self]; \
[inv setSelector:sel]; \
va_list args; \
va_start(args, _last_arg_); \
[NSObject setInv:inv withSig:sig andArgs:args]; \
va_end(args);

- (id)kkPerformSelectorWithArgs:(SEL)sel, ...{
    INIT_INV(sel, nil);
    [inv invoke];
    return [NSObject getReturnFromInv:inv withSig:sig];
}

- (void)kkPerformSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...{
    INIT_INV(delay, );
    [inv retainArguments];
    [inv performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (id)kkPerformSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...{
    INIT_INV(wait, nil);
    if (!wait) [inv retainArguments];
    [inv performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

- (id)kkPerformSelectorWithArgs:(SEL)sel onThread:(NSThread *)thr waitUntilDone:(BOOL)wait, ...{
    INIT_INV(wait, nil);
    if (!wait) [inv retainArguments];
    [inv performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

- (void)kkPerformSelectorWithArgsInBackground:(SEL)sel, ...{
    INIT_INV(sel, );
    [inv retainArguments];
    [inv performSelectorInBackground:@selector(invoke) withObject:nil];
}

#undef INIT_INV

- (void)kkPerformSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
    [self performSelector:selector withObject:nil afterDelay:delay];
}

+ (id)getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig {
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
#define return_with_number(_type_) \
do { \
_type_ ret; \
[inv getReturnValue:&ret]; \
return @(ret); \
} while (0)
    
    switch (*type) {
        case 'v': return nil; // void
        case 'B': return_with_number(bool);
        case 'c': return_with_number(char);
        case 'C': return_with_number(unsigned char);
        case 's': return_with_number(short);
        case 'S': return_with_number(unsigned short);
        case 'i': return_with_number(int);
        case 'I': return_with_number(unsigned int);
        case 'l': return_with_number(int);
        case 'L': return_with_number(unsigned int);
        case 'q': return_with_number(long long);
        case 'Q': return_with_number(unsigned long long);
        case 'f': return_with_number(float);
        case 'd': return_with_number(double);
        case 'D': { // long double
            long double ret;
            [inv getReturnValue:&ret];
            return [NSNumber numberWithDouble:ret];
        };
            
        case '@': { // id
            id ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        case '#': { // Class
            Class ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };
            
        default: { // struct / union / SEL / void* / unknown
            const char *objCType = [sig methodReturnType];
            char *buf = calloc(1, length);
            if (!buf) return nil;
            [inv getReturnValue:buf];
            NSValue *value = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return value;
        };
    }
#undef return_with_number
}

+ (void)setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args {
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        switch (*type) {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            }
                
            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case 'D': // 16: long double
            {
                long double arg = va_arg(args, long double);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '*': // char *
            case '^': // pointer
            {
                void *arg = va_arg(args, void *);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case ':': // SEL
            {
                SEL arg = va_arg(args, SEL);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '#': // Class
            {
                Class arg = va_arg(args, Class);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '@': // id
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;
                
            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;
                
            case '(': // union
            {
                unsupportedType = YES;
            } break;
                
            case '[': // array
            {
                unsupportedType = YES;
            } break;
                
            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }
        
        if (unsupportedType) {
            // Try with some dummy type...
            
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            
#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg = va_arg(args, struct dummy); \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
                NSLog(@"PerformSelectorWithArgs unsupported type:%s (%lu bytes)",
                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
            }
#undef case_size
            
        }
    }
}

///=============================================================================
/// @name Sending messages with variable parameters -- block
///=============================================================================

static id <NSObject, NSCopying> KKDispatchCancellableBlock(dispatch_queue_t queue, NSTimeInterval delay, void(^block)(void)) {
    dispatch_time_t time = KKTimeDelay(delay);
    
#if DISPATCH_CANCELLATION_SUPPORTED
    if (KKSupportDispatchCancellation()) {
        dispatch_block_t ret = dispatch_block_create(0, block);
        dispatch_after(time, queue, ret);
        return ret;
    }
#endif
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    dispatch_after(time, queue, ^{
        wrapper(NO);
    });
    return wrapper;
}

- (id <NSObject, NSCopying>)kkPerformOnQueue:(dispatch_queue_t)queue
                                  afterDelay:(NSTimeInterval)delay
                                  usingBlock:(void (^)(id obj))block {
    NSParameterAssert(block != nil);
    return KKDispatchCancellableBlock(queue, delay, ^{
        block(self);
    });
}

- (id <NSObject, NSCopying>)kkPerformAfterDelay:(NSTimeInterval)delay
                                     usingBlock:(void (^)(id))block {
    return [self kkPerformOnQueue:KKMainQueue() afterDelay:delay usingBlock:block];
}

- (id <NSObject, NSCopying>)kkPerformInBackgroundAfterDelay:(NSTimeInterval)delay
                                                 usingBlock:(void (^)(id obj))block {
    return [self kkPerformOnQueue:KKDefaultQueue() afterDelay:delay usingBlock:block];
}


+ (void)kkCancelBlock:(id <NSObject, NSCopying>)block {
    NSParameterAssert(block != nil);
#if DISPATCH_CANCELLATION_SUPPORTED
    if (KKSupportDispatchCancellation()) {
        dispatch_block_cancel((dispatch_block_t)block);
        return;
    }
#endif
    void (^wrapper)(BOOL) = (void(^)(BOOL))block;
    wrapper(YES);
}


#pragma mark - KVO--Block

///=============================================================================
/// @name KVO--Block
///=============================================================================

static const NSUInteger KKKeyValueObservingOptionWantsChangeDictionary = 0x1000;

- (NSString *)kkAddObserverForKeyPath:(NSString *)keyPath task:(void (^)(id target))task {
    NSString *token = [[NSProcessInfo processInfo] globallyUniqueString];
    [self kkAddObserverForKeyPaths:@[keyPath] identifier:token options:0 context:SKObserverContextKey task:task];
    return token;
}

- (NSString *)kkAddObserverForKeyPaths:(NSArray *)keyPaths task:(void (^)(id obj, NSString *keyPath))task {
    NSString *token = [[NSProcessInfo processInfo] globallyUniqueString];
    [self kkAddObserverForKeyPaths:keyPaths identifier:token options:0 context:SKObserverContextManyKeys task:task];
    return token;
}

- (NSString *)kkAddObserverForKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSString *keyPath, NSDictionary *change))task {
    NSString *token = [[NSProcessInfo processInfo] globallyUniqueString];
    options = options | KKKeyValueObservingOptionWantsChangeDictionary;
    [self kkAddObserverForKeyPaths:keyPaths identifier:token options:options task:task];
    return token;
}

- (NSString *)kkAddObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSDictionary *change))task {
    NSString *token = [[NSProcessInfo processInfo] globallyUniqueString];
    options = options | KKKeyValueObservingOptionWantsChangeDictionary;
    [self kkAddObserverForKeyPath:keyPath identifier:token options:options task:task];
    return token;
}

- (void)kkAddObserverForKeyPath:(NSString *)keyPath identifier:(NSString *)identifier options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSDictionary *change))task {
    SKObserverContext context = (options == 0) ? SKObserverContextKey : SKObserverContextKeyWithChange;
    options = options & (~KKKeyValueObservingOptionWantsChangeDictionary);
    [self kkAddObserverForKeyPaths:@[keyPath] identifier:identifier options:options context:context task:task];
}

- (void)kkAddObserverForKeyPaths:(NSArray *)keyPaths identifier:(NSString *)identifier options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSString *keyPath, NSDictionary *change))task {
    SKObserverContext context = (options == 0) ? SKObserverContextManyKeys : SKObserverContextManyKeysWithChange;
    options = options & (~KKKeyValueObservingOptionWantsChangeDictionary);
    [self kkAddObserverForKeyPaths:keyPaths identifier:identifier options:options context:context task:task];
}


- (void)kkRemoveObserverForKeyPath:(NSString *)keyPath identifier:(NSString *)token {
    NSParameterAssert(keyPath.length);
    NSParameterAssert(token.length);
    
    NSMutableDictionary *dict;
    @synchronized (self) {
        dict = [self kkObserverBlocks];
        if (!dict) return;
    }
    _SKObserver *observer = dict[token];
    [observer stopObservingKeyPath:keyPath];
    if (observer.keyPaths.count == 0) {
        [dict removeObjectForKey:token];
    }
    if (dict.count == 0) [self kkSetObserverBlocks:nil];
}

- (void)kkRemoveObserversWithIdentifier:(NSString *)token {
    NSParameterAssert(token);
    
    NSMutableDictionary *dict;
    @synchronized (self) {
        dict = [self kkObserverBlocks];
        if (!dict) return;
    }
    _SKObserver *observer = dict[token];
    [observer stopObserving];
    
    [dict removeObjectForKey:token];
    if (dict.count == 0) [self kkSetObserverBlocks:nil];
}

- (void)kkRemoveAllBlockObservers {
    NSDictionary *dict;
    @synchronized (self) {
        dict = [[self kkObserverBlocks] copy];
        [self kkSetObserverBlocks:nil];
    }
    [dict.allValues enumerateObjectsUsingBlock:^(_SKObserver *observer, NSUInteger idx, BOOL *stop) {
        [observer stopObserving];
    }];
}

- (void)kkAddObserverForKeyPaths:(NSArray *)keyPaths identifier:(NSString *)identifier options:(NSKeyValueObservingOptions)options context:(SKObserverContext)context task:(id)task {
    NSParameterAssert(keyPaths.count);
    NSParameterAssert(identifier.length);
    NSParameterAssert(task);
    
    Class classToSwizzle = self.class;
    NSMutableSet *classes = self.class.observedClassesHash;
    @synchronized (classes) {
        NSString *classname = classToSwizzle.kkClassName;
        if (![classes containsObject:classname]) {
            SEL deallocSelector = sel_registerName("dealloc");
            
            __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
            
            id newDealloc = ^(__unsafe_unretained id objSelf) {
                [objSelf kkRemoveAllBlockObservers];
                if (originalDealloc == NULL) {
                    struct objc_super superInfo = {
                        .receiver = objSelf,
                        .super_class = class_getSuperclass(classToSwizzle)
                    };
                    void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                    msgSend(&superInfo, deallocSelector);
                } else {
                    originalDealloc(objSelf, deallocSelector);
                }
            };
            
            IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
            if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
                // The class already contains a method implementation.
                Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
                // We need to store original implementation before setting new implementation
                // in case method is called at the time of setting.
                originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
                // We need to store original implementation again, in case it just changed.
                originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
            }
            [classes addObject:classname];
        }
    }
    NSMutableDictionary *dict;
    _SKObserver *observer = [[_SKObserver alloc] initWithObserver:self keyPaths:keyPaths context:context task:task];
    [observer startObservingWithOptions:options];
    
    @synchronized (self) {
        dict = [self kkObserverBlocks];
        if (dict == nil) {
            dict = [NSMutableDictionary dictionary];
            [self kkSetObserverBlocks:dict];
        }
    }
    dict[identifier] = observer;
}

+ (NSMutableSet *)observedClassesHash {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    return swizzledClasses;
}

- (void)kkSetObserverBlocks:(NSMutableDictionary *)dict {
    [self kkSetAssociateValue:dict withKey:SKObserverBlocksKey];
}

- (NSMutableDictionary *)kkObserverBlocks {
    return  [self kkGetAssociatedValueForKey:SKObserverBlocksKey];
}

@end
