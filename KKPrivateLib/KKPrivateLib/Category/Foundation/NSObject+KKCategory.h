//
//  NSObject+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKEnumerationCapabilities.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KKCategory)

#pragma mark - Algorithms correlation
///=============================================================================
/// @name 计算相关
///=============================================================================

- (NSEnumerator *)kkEnumerator;

/*！
 Answer true if block answers true for all elements of the receiver.
 An empty collection answers true.
 ==> 所有元素 block 返回值都为 YES 时, 返回 YES, 反之返回 NO.
 */
- (BOOL)kkAllSatisfy:(BOOL (^)(id each))block;

/*!
 Answer true if block answers true for any element of the receiver.
 An empty collection answers false.
 ==> 任一元素 block 返回值为 YES 时, 返回 YES, 反之返回 NO.
 */
- (BOOL)kkAnySatisfy:(BOOL (^)(id each))block;

/*!
 Evaluate block with each of the receiver's elements as the argument.
 Answer the first element for which aBlock evaluates to true.
 ==> 检测元素值, 返回第一个 block 返回值为 YES 的元素值.
 */
- (id)kkDetect:(BOOL (^)(id each))block;

/*!
 Answer the first element. If the receiver is empty, answer nil.
 ==> 返回第一个元素值, 为空返 nil.
 */
- (id)kkFirst;

/*!
 Evaluate block with each of the receiver's elements as the argument.
 Collect into a new collection like the receiver, only those elements for which
 rejectBlock evaluates to false. Answer the new collection.
 ==> 剔除元素值中所有 block 返回 YES 的元素, 返回一个receiver类型的值
 */
- (id)kkReject:(BOOL (^)(id each))block;

/*!
 Evaluate selectBlock with each of the receiver's elements as the argument.
 Collect into a new collection like the receiver, only those elements for which
 selectBlock evaluates to true. Answer the new collection.
 ==> 剔除元素值中所有 block 返回 NO 的元素, 返回一个receiver类型的值
 */
- (id)kkSelect:(BOOL (^)(id each))block;

/*!
 Evaluate whileBlock with each of the receiver's elements as the argument
 until it answers NO. Answer a collection with all of the elements that
 evaluated to YES up to that point.
 ==> 取 第一个 block 返回值为 NO 之前的所有元素, 返回一个receiver类型的值
 */
- (id)kkTakeWhile:(BOOL (^)(id each))block;

/*!
 Evaluate whileBlock with each of the receiver's elements as the argument
 until it answers NO. Answer a collection with the rest of the receiver's
 elements.
 ==> 取 第一个 block 返回值为 NO 和之后的所有元素, 返回一个receiver类型的值
 */
- (id)kkDropWhile:(BOOL (^)(id each))block;

#pragma mark - Map
/*!
 Evaluate mapblock with each of the values of the receiver as the
 argument. Collect the resulting values into a collection that is like
 the receiver. Answer the new collection.
 ==> 取 每个 block 返回值组成一个新的集合, 返回一个receiver类型的值
 */
- (id)kkMap:(id (^)(id each))block;

/*!
 Applies a block against an accumulator and each value of
 the array (from left-to-right) to reduce it to a single value.
 ==> 递归函数
 */
- (id)kkReduce:(id (^)(id accumulator, id each))block;

/*!
 The first time the callback is called, If initialValue is provided in the call to reduce,
 then accumulator will be equal to initial and currentValue will be
 equal to the first value in the array.
 ==> 递归函数
 */
- (id)kkReduce:(nullable id)initial block:(id (^)(id accumulator, id each))block;

#pragma mark - Null
/*!
 Coerce [NSNull null] to true and everything else to false.
 */
- (BOOL)kkIsNull;

/*!
 Coerce [NSNull null] to false and everything else to true.
 */
- (BOOL)kkIsNotNull;

#pragma mark - Enum

/*!
 Evaluate eachBlock with each of the receiver's elements as the argument.
 ==> 遍历
 */
- (void)kkEach:(void (^)(id each))eachBlock;

/*!
 Evaluate eachBlock with each of the receiver's elements as the first argument
 and it's index as the second.
 ==> 遍历
 */
- (void)kkEachWithIndex:(void (^)(id each, NSUInteger idx))eachBlock;

/*!
 Evaluate eachBlock for each element in the collection. Between each pair of
 elements, but not before the first or after the last, evaluate the separatorBlock.
 */
- (void)kkEach:(void (^)(id each))eachBlock
   separatedBy:(nullable void (^)(void))separatorBlock;

/*!
 Evaluate eachBlock with each of the receiver's elements as the first argument
 and it's index as the second. Between each pair of elements, but not before
 the first or after the last, evaluate the separatorBlock.
 */
- (void)kkEachWithIndex:(void (^)(id each, NSUInteger idx))eachBlock
            separatedBy:(nullable void (^)(void))separatorBlock;

/*!
 Answer if the receiver contains no elements.
 ==> 判断是否有数据
 */
- (BOOL)kkIsEmpty;




#pragma mark - Class correlation
///=============================================================================
/// @name Class Correlation
///=============================================================================

/**
 Returns the class name in NSString.
 */
- (NSString *)kkClassName;
+ (NSString *)kkClassName;

/**
 Returns a property dict
 */
- (NSDictionary *)kkPropertyDictionary;

/**
 Returns a list of property name.
 */
- (NSArray<NSString *> *)kkPropertyKeys;
+ (NSArray<NSString *> *)kkPropertyKeys;

/**
 Returns a list of property info.
 */
- (NSArray *)kkPropertiesInfo;
+ (NSArray *)kkPropertiesInfo;

#pragma mark - Associate value

///=============================================================================
/// @name Associate value
///=============================================================================

/**
 Associate one object to `self`, as if it was a strong property (retain, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)kkSetAssociateValue:(nullable id)value withKey:(const void *)key;

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)kkSetAssociateWeakValue:(nullable id)value withKey:(const void *)key;

/**
 Associate one object to `self`, as if it was a weak property (copy, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)kkSetAssociateCopyValue:(nullable id)value withKey:(const void *)key;

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (nullable id)kkGetAssociatedValueForKey:(const void *)key;

/**
 Remove all associated values.
 */
- (void)kkRemoveAssociatedValues;


#pragma mark - Sending messages with variable parameters

///=============================================================================
/// @name Sending messages with variable parameters -- NSInvocation
///=============================================================================

/**
 Sends a specified message to the receiver and returns the result of the message.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       An object that is the result of the message.
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView)];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];
 
 // perform and return object
 UIImage *image = [UIImage.class performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];
 
 // perform and return wrapped number
 NSNumber *lengthValue = [@"hello" performSelectorWithArgs:@selector(length)];
 NSUInteger length = lengthValue.unsignedIntegerValue;
 
 // perform and return wrapped struct
 NSValue *frameValue = [view performSelectorWithArgs:@selector(frame)];
 CGRect frame = frameValue.CGRectValue;
 */
- (id)kkPerformSelectorWithArgs:(SEL)sel, ...;

/**
 Invokes a method of the receiver on the current thread using the default mode after a delay.
 
 @warning      It can't cancelled by previous request.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised immediately.
 
 @param delay  The minimum time before which the message is sent. Specifying
 a delay of 0 does not necessarily cause the selector to be
 performed immediately. The selector is still queued on the
 thread's run loop and performed as soon as possible.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView) afterDelay:2.0];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), afterDelay:0, CGPointMake(0, 0)];
 */
- (void)kkPerformSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

/**
 Invokes a method of the receiver on the main thread using the default mode.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgsOnMainThread:@selector(removeFromSuperView), waitUntilDone:NO];
 
 // variable arg is not object
 [view performSelectorWithArgsOnMainThread:@selector(setCenter:), waitUntilDone:NO, CGPointMake(0, 0)];
 */
- (id)kkPerformSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...;

/**
 Invokes a method of the receiver on the specified thread using the default mode.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param thread The thread on which to execute aSelector.
 
 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.
 
 Sample Code:
 
 [view performSelectorWithArgs:@selector(removeFromSuperView) onThread:mainThread waitUntilDone:NO];
 
 [array  performSelectorWithArgs:@selector(sortUsingComparator:)
 onThread:backgroundThread
 waitUntilDone:NO, ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (id)kkPerformSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDone:(BOOL)wait, ...;

/**
 Invokes a method of the receiver on a new background thread.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @discussion   This method creates a new thread in your application, putting
 your application into multithreaded mode if it was not already.
 The method represented by sel must set up the thread environment
 just as you would for any other new thread in your program.
 
 Sample Code:
 
 [array  performSelectorWithArgsInBackground:@selector(sortUsingComparator:),
 ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (void)kkPerformSelectorWithArgsInBackground:(SEL)sel, ...;

/**
 Invokes a method of the receiver on the current thread after a delay.
 
 @warning     arc-performSelector-leaks
 
 @param sel   A selector that identifies the method to invoke. The method should
 not have a significant return value and should take no argument.
 If the selector is NULL or unrecognized,
 an NSInvalidArgumentException is raised after the delay.
 
 @param delay The minimum time before which the message is sent. Specifying a
 delay of 0 does not necessarily cause the selector to be performed
 immediately. The selector is still queued on the thread's run loop
 and performed as soon as possible.
 
 @discussion  This method sets up a timer to perform the aSelector message on
 the current thread's run loop. The timer is configured to run in
 the default mode (NSDefaultRunLoopMode). When the timer fires, the
 thread attempts to dequeue the message from the run loop and
 perform the selector. It succeeds if the run loop is running and
 in the default mode; otherwise, the timer waits until the run loop
 is in the default mode.
 */
- (void)kkPerformSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;


///=============================================================================
/// @name Sending messages with variable parameters -- block(Dispatch)
///=============================================================================

/** Executes a block after a given delay on the reciever.
 
 @warning *Important:* Use of the **self** reference in a block is discouraged.
 The block argument @c obj should be used instead.
 
 @param delay A measure in seconds.
 @param block A single-argument code block, where @c obj is the reciever.
 @return An opaque, temporary token that may be used to cancel execution.
 */
- (id <NSObject, NSCopying>)kkPerformAfterDelay:(NSTimeInterval)delay
                                     usingBlock:(void (^)(id obj))block;

/** Executes a block in the background after a given delay.
 
 This method is functionally identical to @c +kkPerformAfterDelay:usingBlock:
 except the block will be performed on a background queue.
 
 @see kkPerformAfterDelay:usingBlock:
 @param block A code block.
 @return An opaque, temporary token that may be used to cancel execution.
 */
- (id <NSObject, NSCopying>)kkPerformInBackgroundAfterDelay:(NSTimeInterval)delay
                                                 usingBlock:(void (^)(id obj))block;

/**
 Executes a block in the background after a given delay.
 
 @see kkPerformAfterDelay:usingBlock:
 @param queue A background queue.
 @param delay A measure in seconds.
 @param block A single-argument code block, where @c obj is the reciever.
 @return An opaque, temporary token that may be used to cancel execution.
 */
- (id <NSObject, NSCopying>)kkPerformOnQueue:(dispatch_queue_t)queue
                                  afterDelay:(NSTimeInterval)delay
                                  usingBlock:(void (^)(id obj))block;

/**
 Cancels the potential execution of a block.
 
 @warning *Important:* It is not recommended to cancel a block executed
 with a delay of @c 0.
 
 @param block A cancellation token, as returned from one of the `kk_perform`
 methods.
 */
+ (void)kkCancelBlock:(id <NSObject, NSCopying>)block;


#pragma mark - Adds an observer to an object conforming to NSKeyValueObserving--Block

///=============================================================================
/// @name Adds an observer to an object conforming to NSKeyValueObserving.-Block
///=============================================================================

/**
 Adds a block observer that executes a block upon a state change.
 
 @param keyPath The property to observe, relative to the reciever.
 @param task A block with no return argument, and a single parameter: the reciever.
 @return Returns a globally unique process identifier for removing
 observation with kkRemoveObserverWithBlockToken:.
 @see kkAddObserverForKeyPath:identifier:options:task:
 */
- (NSString *)kkAddObserverForKeyPath:(NSString *)keyPath task:(void (^)(id target))task;

/**
 Adds a block observer that executes the same block upon
 multiple state changes.
 
 @param keyPaths An array of properties to observe, relative to the reciever.
 @param task A block with no return argument and two parameters: the
 reciever and the key path of the value change.
 @return A unique identifier for removing
 observation with kkRemoveObserverWithBlockToken:.
 @see kkAddObserverForKeyPath:identifier:options:task:
 */
- (NSString *)kkAddObserverForKeyPaths:(NSArray *)keyPaths task:(void (^)(id obj, NSString *keyPath))task;

/**
 Adds a block observer that executes a block upon a state change
 with specific options.
 
 @param keyPath The property to observe, relative to the reciever.
 @param options The NSKeyValueObservingOptions to use.
 @param task A block with no return argument and two parameters: the
 reciever and the change dictionary.
 @return Returns a globally unique process identifier for removing
 observation with kkRemoveObserverWithBlockToken:.
 @see kkAddObserverForKeyPath:identifier:options:task:
 */
- (NSString *)kkAddObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSDictionary *change))task;

/**
 Adds a block observer that executes the same block upon
 multiple state changes with specific options.
 
 @param keyPaths An array of properties to observe, relative to the reciever.
 @param options The NSKeyValueObservingOptions to use.
 @param task A block with no return argument and three parameters: the
 reciever, the key path of the value change, and the change dictionary.
 @return A unique identifier for removing
 observation with kkRemoveObserverWithBlockToken:.
 @see kkAddObserverForKeyPath:identifier:options:task:
 */
- (NSString *)kkAddObserverForKeyPaths:(NSArray *)keyPaths options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSString *keyPath, NSDictionary *change))task;

/**
 Adds a block observer that executes the block upon a
 state change.
 
 @param keyPath The property to observe, relative to the reciever.
 @param identifier An identifier for the observation block.
 @param options The NSKeyValueObservingOptions to use.
 @param task A block responding to the reciever and the KVO change.
 observation with kkRemoveObserverWithBlockToken:.
 @see kkAddObserverForKeyPath:task:
 */
- (void)kkAddObserverForKeyPath:(NSString *)keyPath identifier:(NSString *)identifier options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSDictionary *change))task;

/**
 Adds a block observer that executes the same block upon
 multiple state changes.
 
 @param keyPaths An array of properties to observe, relative to the reciever.
 @param identifier An identifier for the observation block.
 @param options The NSKeyValueObservingOptions to use.
 @param task A block responding to the reciever, the key path, and the KVO change.
 observation with kkRemoveObserverWithBlockToken:.
 @see addObserverForKeyPath:task:
 */
- (void)kkAddObserverForKeyPaths:(NSArray *)keyPaths identifier:(NSString *)identifier options:(NSKeyValueObservingOptions)options task:(void (^)(id obj, NSString *keyPath, NSDictionary *change))task;

/**
 Removes a block observer.
 
 @param keyPath The property to stop observing, relative to the reciever.
 @param token The unique key returned by kkAddObserverForKeyPath:task:
 or the identifier given in kkAddObserverForKeyPath:identifier:task:.
 @see kkRemoveObserversWithIdentifier:
 */
- (void)kkRemoveObserverForKeyPath:(NSString *)keyPath identifier:(NSString *)token;

/**
 Removes multiple block observers with a certain identifier.
 
 @param token A unique
 @see kkRemoveObserverForKeyPath:identifier:
 */
- (void)kkRemoveObserversWithIdentifier:(NSString *)token;

/** Remove all registered block observers. */
- (void)kkRemoveAllBlockObservers;


@end

NS_ASSUME_NONNULL_END
