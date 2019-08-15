//
//  KKEnumerationCapabilities.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+KKCategory.h"
NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////
#pragma mark - KKEnumerableProtocol
////////////////////////////////////////////////////////////////////////////////

@protocol KKEnumerableProtocol <NSObject>
- (NSEnumerator * _Nullable)kkCollectionEnumerator;
@end

@protocol KKEnumerableCollectionProtocol <NSObject>
- (id _Nullable )kkMutableInstance;
- (void)kkAddObject:(id _Nullable )obj toMutableInstance:(id)instance;
- (id _Nullable )kkInstanceFromMutable:(id)instance;
@end

@interface KKEnumerationCapabilities : NSObject

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - KKAssociation
////////////////////////////////////////////////////////////////////////////////
@interface KKAssociation : NSObject
@property (nonatomic, readonly) id _Nullable key;
@property (nonatomic, readonly) id _Nullable value;
- (instancetype)initWithKey:(id _Nullable )key value:(id)value;
@end

@interface NSObject (KKAssociationSupport)
- (KKAssociation *_Nullable)asAssociationWithKey:(id)key;
- (KKAssociation *_Nullable)asAssociationWithValue:(id)value;
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Enumerator
////////////////////////////////////////////////////////////////////////////////
@interface KKAssociationEnumerator : NSEnumerator
- (instancetype _Nullable )initWithDictionary:(NSDictionary *)dictionary;
@end

@interface KKCharacterEnumerator : NSEnumerator
- (instancetype _Nullable )initWithString:(NSString *)string;
@end

@interface KKIntervalEnumerator : NSEnumerator
//- (instancetype)initWithInterval:(OCInterval *)interval;
@end

@interface KKMapTableEnumerator : NSEnumerator
- (instancetype _Nullable )initWithMapTable:(NSMapTable *)mapTable;
@end

@interface KKNullEnumerator : NSEnumerator
@end

@interface KKInterval : NSObject <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
@property (nonatomic, readonly) NSInteger from;
@property (nonatomic, readonly) NSInteger to;
@property (nonatomic, readonly) NSInteger by;
- (instancetype _Nullable )initWithFrom:(NSInteger)from to:(NSInteger)to by:(NSInteger)by;
- (NSEnumerator *_Nullable)intervalEnumerator;
@end


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Extend
////////////////////////////////////////////////////////////////////////////////

@interface NSArray<ObjectType> (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
- (ObjectType)kkDetect:(BOOL (^_Nullable)(id each))block;
- (ObjectType _Nullable )kkFirst;
- (NSArray<ObjectType> *)kkReject:(BOOL (^)(id each))block;
- (NSArray<ObjectType> *)kkSelect:(BOOL (^)(id each))block;
- (NSArray<ObjectType> *)kkTakeWhile:(BOOL (^)(id each))block;
- (NSArray<ObjectType> *)kkDropWhile:(BOOL (^)(id each))block;

#pragma mark - Map
- (NSArray *)kkMap:(id (^)(id each))block;
@end

@interface NSDictionary (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
@end

@interface NSHashTable (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
@end

@interface NSMapTable (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
@end

@interface NSNull (KKEnumerationCapabilities) <KKEnumerableProtocol>
@end

@interface NSNumber (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
- (NSNumber *)kkDetect:(BOOL (^)(id each))block;
- (NSNumber *)kkFirst;
- (NSArray<NSNumber *> *)kkReject:(BOOL (^)(id each))block;
- (NSArray<NSNumber *> *)kkSelect:(BOOL (^)(id each))block;
- (NSArray<NSNumber *> *)kkTakeWhile:(BOOL (^)(id each))block;
- (NSArray<NSNumber *> *)kkDropWhile:(BOOL (^)(id each))block;
#pragma mark - Map
- (NSArray<NSNumber *> *)kkMap:(id (^)(id each))block;
@end

@interface NSPointerArray (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
@end

@interface NSSet<ObjectType> (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
- (ObjectType)kkDetect:(BOOL (^)(id each))block;
- (ObjectType)kkFirst;
- (NSSet<ObjectType> *)kkReject:(BOOL (^)(id each))block;
- (NSSet<ObjectType> *)kkSelect:(BOOL (^)(id each))block;
- (NSSet<ObjectType> *)kkTakeWhile:(BOOL (^)(id each))block;
- (NSSet<ObjectType> *)kkDropWhile:(BOOL (^)(id each))block;
#pragma mark - Map
- (NSSet<ObjectType> *)kkMap:(id (^)(id each))block;
@end

@interface NSString (KKEnumerationCapabilities) <KKEnumerableProtocol, KKEnumerableCollectionProtocol>
- (NSString *)kkDetect:(BOOL (^)(id each))block;
- (NSString *)kkFirst;
- (NSString *)kkReject:(BOOL (^)(id each))block;
- (NSString *)kkSelect:(BOOL (^)(id each))block;
- (NSString *)kkTakeWhile:(BOOL (^)(id each))block;
- (NSString *)kkDropWhile:(BOOL (^)(id each))block;
#pragma mark - Map
- (NSString *)kkMap:(id (^)(id each))block;
@end

NS_ASSUME_NONNULL_END
