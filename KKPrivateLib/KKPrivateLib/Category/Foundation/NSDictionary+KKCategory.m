//
//  NSDictionary+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/13.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSDictionary+KKCategory.h"

/// Foundation Class Type
typedef NS_ENUM (NSUInteger, KKEncodingNSType) {
    KKEncodingTypeNSUnknown = 0,
    KKEncodingTypeNSString,
    KKEncodingTypeNSMutableString,
    KKEncodingTypeNSValue,
    KKEncodingTypeNSNumber,
    KKEncodingTypeNSDecimalNumber,
    KKEncodingTypeNSData,
    KKEncodingTypeNSMutableData,
    KKEncodingTypeNSDate,
    KKEncodingTypeNSURL,
    KKEncodingTypeNSArray,
    KKEncodingTypeNSMutableArray,
    KKEncodingTypeNSDictionary,
    KKEncodingTypeNSMutableDictionary,
    KKEncodingTypeNSSet,
    KKEncodingTypeNSMutableSet,
};

//NS_INLINE KKEncodingNSType KKClassGetNSType(Class cls) {
//    if (!cls) return KKEncodingTypeNSUnknown;
//    if ([cls isSubclassOfClass:[NSMutableString class]]) return KKEncodingTypeNSMutableString;
//    if ([cls isSubclassOfClass:[NSString class]]) return KKEncodingTypeNSString;
//    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return KKEncodingTypeNSDecimalNumber;
//    if ([cls isSubclassOfClass:[NSNumber class]]) return KKEncodingTypeNSNumber;
//    if ([cls isSubclassOfClass:[NSValue class]]) return KKEncodingTypeNSValue;
//    if ([cls isSubclassOfClass:[NSMutableData class]]) return KKEncodingTypeNSMutableData;
//    if ([cls isSubclassOfClass:[NSData class]]) return KKEncodingTypeNSData;
//    if ([cls isSubclassOfClass:[NSDate class]]) return KKEncodingTypeNSDate;
//    if ([cls isSubclassOfClass:[NSURL class]]) return KKEncodingTypeNSURL;
//    if ([cls isSubclassOfClass:[NSMutableArray class]]) return KKEncodingTypeNSMutableArray;
//    if ([cls isSubclassOfClass:[NSArray class]]) return KKEncodingTypeNSArray;
//    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return KKEncodingTypeNSMutableDictionary;
//    if ([cls isSubclassOfClass:[NSDictionary class]]) return KKEncodingTypeNSDictionary;
//    if ([cls isSubclassOfClass:[NSMutableSet class]]) return KKEncodingTypeNSMutableSet;
//    if ([cls isSubclassOfClass:[NSSet class]]) return KKEncodingTypeNSSet;
//    return KKEncodingTypeNSUnknown;
//}

/// Parse a number value from 'id'.
NS_INLINE NSNumber *KKNSNumberCreateFromID(__unsafe_unretained id value) {
    static NSCharacterSet *dot;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull};
    });
    
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSNumber *num = dic[value];
        if (num) {
            if (num == (id)kCFNull) return nil;
            return num;
        }
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            double num = atof(cstring);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        } else {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            return @(atoll(cstring));
        }
    }
    return nil;
}

/// Parse string to date.
static NSDate *KKNSDateFromString(__unsafe_unretained NSString *string) {
    typedef NSDate *(^KKNSDateParseBlock)(NSString *string);
#define kParserNum 32
    static KKNSDateParseBlock blocks[kParserNum + 1] = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            /*
             2014-01-20  // Google
             */
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"yyyy-MM-dd";
            blocks[10] = ^(NSString *string) { return [formatter dateFromString:string]; };
        }
        
        {
            /*
             2014-01-20 12:24:48
             2014-01-20T12:24:48   // Google
             */
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            blocks[19] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter1 dateFromString:string];
                } else {
                    time_t t = 0;
                    struct tm tm = {0};
                    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%d %H:%M:%S", &tm);
                    tm.tm_isdst = -1;
                    t = mktime(&tm);
                    if (t >= 0) {
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
                        if (date) return date;
                    }
                    return [formatter2 dateFromString:string];
                }
            };
        }
        
        {
            /*
             2014-01-20T12:24:48Z        // Github, Apple
             2014-01-20T12:24:48+0800    // Facebook
             2014-01-20T12:24:48+12:00   // Google
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            blocks[20] = ^(NSString *string) {
                time_t t = 0;
                struct tm tm = {0};
                strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
                tm.tm_isdst = -1;
                t = mktime(&tm);
                if (t >= 0) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
                    if (date) return date;
                }
                return [formatter dateFromString:string];
            };
            blocks[24] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[25] = ^(NSString *string) { return [formatter dateFromString:string]; };
        }
        
        {
            /*
             Fri Sep 04 00:12:21 +0800 2015 // Weibo, Twitter
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
            blocks[30] = ^(NSString *string) { return [formatter dateFromString:string]; };
        }
    });
    if (!string) return nil;
    if (string.length > kParserNum) return nil;
    KKNSDateParseBlock parser = blocks[string.length];
    if (!parser) return nil;
    return parser(string);
#undef kParserNum
}


#pragma mark - KKStringValue
///=============================================================================
/// @name KKStringValue
///=============================================================================
__attribute__((overloadable)) NSString * KKStringValue(NSString *value) { return value; }
__attribute__((overloadable)) NSString * KKStringValue(NSNumber *value) { return value.stringValue; }
__attribute__((overloadable)) NSString * KKStringValue(NSURL *value) { return value.absoluteString; }
__attribute__((overloadable)) NSString * KKStringValue(NSAttributedString *value) { return value.string; }
__attribute__((overloadable)) NSString * KKStringValue(NSData *value) {
    return [[NSMutableString alloc] initWithData:value encoding:NSUTF8StringEncoding];
}
__attribute__((overloadable)) NSString * KKStringValue(id value) {
    return @"";
}

NS_INLINE id KKTransformValue(__unsafe_unretained id value, KKEncodingNSType type) {
    // TODO: whether the 'Switch' is more better
    switch (type) {
        case KKEncodingTypeNSString:
        case KKEncodingTypeNSMutableString: {
            if ([value isKindOfClass:[NSString class]]) {
                if (type == KKEncodingTypeNSString) {
                    return value;
                } else {
                    if ([value isKindOfClass:[NSMutableString class]]) {
                        return value;
                    } else {
                        return ((NSString *)value).mutableCopy;
                    }
                }
            } else if ([value isKindOfClass:[NSNumber class]]) {
                return type==KKEncodingTypeNSString ?
                ((NSNumber *)value).stringValue :
                ((NSNumber *)value).stringValue.mutableCopy;
            } else if ([value isKindOfClass:[NSData class]]) {
                return [[NSMutableString alloc] initWithData:value encoding:NSUTF8StringEncoding];
            } else if ([value isKindOfClass:[NSURL class]]) {
                return type==KKEncodingTypeNSString ?
                ((NSURL *)value).absoluteString :
                ((NSURL *)value).absoluteString.mutableCopy;
            } else if ([value isKindOfClass:[NSAttributedString class]]) {
                return type==KKEncodingTypeNSString ?
                ((NSAttributedString *)value).string :
                ((NSAttributedString *)value).string.mutableCopy;
            } else {
                return type==KKEncodingTypeNSString ? @"" : @"".mutableCopy;
            }
        } break;
            
        case KKEncodingTypeNSValue:{
            if ([value isKindOfClass:[NSValue class]]) {
                return value;
            } else {
                return nil;
            }
        } break;
        case KKEncodingTypeNSNumber: {
            return KKNSNumberCreateFromID(value);
        } break;
        case KKEncodingTypeNSDecimalNumber: {
            if ([value isKindOfClass:[NSDecimalNumber class]]) {
                return value;
            } else if ([value isKindOfClass:[NSNumber class]]) {
                return [NSDecimalNumber decimalNumberWithDecimal:[((NSNumber *)value) decimalValue]];
            } else if ([value isKindOfClass:[NSString class]]) {
                NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithString:value];
                NSDecimal dec = decNum.decimalValue;
                if (dec._length == 0 && dec._isNegative) return nil;
                return decNum;
            } else {
                return nil;
            }
        } break;
            
        case KKEncodingTypeNSData:
        case KKEncodingTypeNSMutableData: {
            if ([value isKindOfClass:[NSData class]]) {
                if (type == KKEncodingTypeNSData) {
                    return value;
                } else {
                    NSMutableData *data = [value isKindOfClass:[NSMutableData class]] ? value : ((NSData *)value).mutableCopy;
                    return data;
                }
            } else if ([value isKindOfClass:[NSString class]]) {
                NSData *data = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
                return (type == KKEncodingTypeNSMutableData) ? data : ((NSData *)data).mutableCopy;
            } else {
                return nil;
            }
        } break;
            
        case KKEncodingTypeNSDate: {
            if ([value isKindOfClass:[NSDate class]]) {
                return value;
            } else if ([value isKindOfClass:[NSString class]]) {
                return KKNSDateFromString(value);
            } else {
                return nil;
            }
        } break;
            
        case KKEncodingTypeNSURL: {
            if ([value isKindOfClass:[NSURL class]]) {
                return value;
            } else if ([value isKindOfClass:[NSString class]]) {
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSString *str = [value stringByTrimmingCharactersInSet:set];
                if (str.length == 0) {
                    return nil;
                } else {
                    return [[NSURL alloc] initWithString:str];
                }
            } else {
                return nil;
            }
        } break;
            
        case KKEncodingTypeNSArray:
        case KKEncodingTypeNSMutableArray: {
            if ([value isKindOfClass:[NSArray class]]) {
                if (type == KKEncodingTypeNSArray) {
                    return value;
                } else {
                    return [value isKindOfClass:[NSMutableArray class]] ?
                    value : ((NSArray *)value).mutableCopy;
                }
            } else if ([value isKindOfClass:[NSSet class]]) {
                if (type == KKEncodingTypeNSArray) {
                    return ((NSSet *)value).allObjects;
                } else {
                    return [value isKindOfClass:[NSMutableArray class]] ?
                    ((NSSet *)value).allObjects :
                    ((NSSet *)value).allObjects.mutableCopy;
                }
            } else {
                return (type == KKEncodingTypeNSArray) ? @[] : @[].mutableCopy;
            }
        } break;
            
        case KKEncodingTypeNSDictionary:
        case KKEncodingTypeNSMutableDictionary: {
            if ([value isKindOfClass:[NSDictionary class]]) {
                if (type == KKEncodingTypeNSDictionary) {
                    return value;
                } else {
                    return [value isKindOfClass:[NSMutableDictionary class]] ?
                    value : ((NSDictionary *)value).mutableCopy;
                }
            } else {
                return (type==KKEncodingTypeNSDictionary) ? @{} : @{}.mutableCopy;
            }
        } break;
            
        case KKEncodingTypeNSSet:
        case KKEncodingTypeNSMutableSet: {
            NSSet *valueSet = nil;
            if ([value isKindOfClass:[NSArray class]]) valueSet = [NSMutableSet setWithArray:value];
            else if ([value isKindOfClass:[NSSet class]]) valueSet = ((NSSet *)value);
            if (type == KKEncodingTypeNSSet) {
                return valueSet;
            } else {
                return [valueSet isKindOfClass:[NSMutableSet class]] ?
                valueSet : ((NSSet *)valueSet).mutableCopy;
            }
        } break;
            
        default: {
            return nil;
        } break;
    }
}



@implementation NSDictionary (KKCategory)
#pragma mark - Correct Value
///=============================================================================
/// @name Correct Value
///=============================================================================

- (NSString *(^)(NSString *))kkString {
    return ^NSString *(NSString *key) {
        return KKTransformValue(self[key], KKEncodingTypeNSString);
    };
}

- (NSNumber *(^)(NSString *))kkNumber {
    return ^NSNumber *(NSString *key) {
        return KKTransformValue(self[key], KKEncodingTypeNSNumber);
    };
}

- (NSArray *(^)(NSString *))kkArray {
    return ^NSArray *(NSString *key) {
        return KKTransformValue(self[key], KKEncodingTypeNSArray);
    };
}

#pragma mark - <#name#>
///=============================================================================
/// @name <#name#>
///=============================================================================

- (BOOL)kkIncludesKey:(id)aKey {
    return [self objectForKey:aKey] != nil;
}

- (BOOL)kkIncludesValue:(id)aValue {
    return [[self allValues] containsObject:aValue];
}

@end

@implementation NSMutableDictionary (KKCategory)

- (NSMutableDictionary *(^)(NSString *key, NSString *value))kkSetKeyValue {
    return ^NSMutableDictionary *(NSString *key, NSString *value) {
        [self setValue:value forKey:key];
        return self;
    };
}

@end
