//
//  NSString+KKCategory.m
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import "NSString+KKCategory.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIView+KKCategory.h"

static NSString * const SZRegExEmail = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@implementation NSString (KKCategory)

- (CGFloat (^)(CGFloat width, UIFont *font))kkHeight {
    return ^CGFloat(CGFloat width, UIFont *font) {
        UILabel *label = [UILabel new];
        if (font) label.font = font;
        return [label.text boundingRectWithSize:CGSizeMake(width, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.height;
    };
}

- (CGFloat (^)(UIFont *font))kkWidth {
    return ^CGFloat(UIFont *font) {
        UILabel *label = [UILabel new];
        if (font) label.font = font;
        label.text = self;
        [label sizeToFit];
        return label.width;
    };
}


#pragma mark - Pinyin
///=============================================================================
/// @name Pinyin
///=============================================================================

- (NSString*)kkTonePinyin {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return pinyin;
}

- (NSString*)kkPinYin {
    NSMutableString *pinyin = [NSMutableString stringWithString:[self kkTonePinyin]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

- (NSArray *)kkArrayPinyin {
    return [[self kkPinYin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSArray *)kkInitialArrayPinyin {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self kkArrayPinyin]) {
        if ([str length] > 0)
            [array addObject:[str substringToIndex:1]];
    }
    return array;
}

#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

- (BOOL)kkMatchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    if (!regex.kkRegex) return NO;
    return ([regex.kkRegex numberOfMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)] > 0);
}

- (void)kkEnumerateRegexMatches:(NSString *)regex
                        options:(NSRegularExpressionOptions)options
                     usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    if (!regex.kkRegex) return;
    [regex.kkRegex enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)kkStringByReplacingRegex:(NSString *)regex
                               options:(NSRegularExpressionOptions)options
                            withString:(NSString *)replacement {
    if (!regex.kkRegex) return self;
    return [regex.kkRegex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

+ (NSString *)kkStringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)kkStringUniqueString {
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

+ (NSString *)kkTimestamp {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%llu", recordTime];
    return timeString;
}

+ (NSString *)kkStringName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        // TODO: meaning?
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}

- (NSString *)kkStringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)kkStringByWhitespaceAndNewline {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (BOOL)kkIsNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i=0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) return YES;
    }
    return NO;
}

- (BOOL)kkIsPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)kkIsContainChinese {
    NSUInteger length = [self length];
    for (NSUInteger i=0; i<length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) return YES;
    }
    return NO;
}

- (BOOL)kkContainsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSNumber *)kkNumberValue {
    // TODO: Update the implementation
    return @([self integerValue]);
}

- (NSRange)kkRangeOfAll {
    return NSMakeRange(0, self.length);
}

- (BOOL)kkIsEqualToString:(id)aString {
    if ([aString respondsToSelector:@selector(string)]) {
        return [self isEqualToString:[(id)aString string]];
    }
    return [self isEqualToString:aString];
}

- (BOOL)isEmail{
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", SZRegExEmail];
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}

- (id)kkJsonValueDecoded {
    // TODO: implementation should be the Data implementation
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"jsonValueDecoded error:%@", error);
#endif
    }
    return value;
}

- (NSDictionary *)kkDictionaryByUrl {
    // TODO:  http://app.ufenqi.com/app/refresh?amount=1000
    //        ==>  @{@"domain":@"http://app.ufenqi.com/", @"address":@"/app/refresh",
    //               @"params":@{@"amount":@"1000"}};
    return @{};
}

- (NSURL *)kkUrl {
    // TODO:  !$&'()*+,-./:;=?@_~%#[]  is Equal to [NSCharacterSet URLQueryAllowedCharacterSet]
    NSString *urlString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

- (NSString *)kkURLEncode {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@";?/:#& =+$,%<>~%"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:set];
}

- (NSString *)kkMd5 {
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (uint32_t)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for (i=0;i<CC_MD5_DIGEST_LENGTH;i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (NSUInteger)kkLengthWithoutWhitespace {
    return self.kkStringWithoutWhitespace.length;
}

- (NSString*)kkStringWithoutWhitespace {
    NSArray *words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *nospacestring = [words componentsJoinedByString:@""];
    return nospacestring;
}

- (NSRegularExpression *)kkRegex {
    NSError *error = nil;
    NSRegularExpression *regex =  [[NSRegularExpression alloc] initWithPattern:self options:0 error:&error];
    if (error)
        [NSException raise:NSInvalidArgumentException format:@"Invalid regex pattern: %@\nError: %@", self, error];
    return regex;
}

///=============================================================================
/// @name Function
///=============================================================================

- (NSArray *)kkSplit:(id)obj {
    if ([obj isKindOfClass:NSString.class]) {
        return [self componentsSeparatedByString:obj];
    } else if ([obj isKindOfClass:NSCharacterSet.class]) {
        return [self componentsSeparatedByCharactersInSet:obj];
    }
    return @[];
}
- (NSArray *(^)(id obj))split {
    return ^id(id obj) {
        return [self kkSplit:obj];
    };
}

#pragma mark - Emoji
///=============================================================================
/// @name Emoji
///=============================================================================

- (BOOL)kkContainsEmoji {
    return [self kkContainsEmojiForSystemVersion:[UIDevice currentDevice].systemVersion.floatValue];
}

- (NSString *)kkTransEmojiToUnicode {
    // TODO: invalide
    if (!kkCheatCodesToUnicode) [NSString kkInitializeEmojiCheatCodes];
    if ([self rangeOfString:@":"].location != NSNotFound) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [kkCheatCodesToUnicode enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            [newText replaceOccurrencesOfString:key withString:obj options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

- (NSString *)kkTransUnicodeToEmoji {
    // TODO: invalide
    if (!kkUnicodeToCheatCodes) [NSString kkInitializeEmojiCheatCodes];
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [kkUnicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

- (BOOL)kkContainsEmojiForSystemVersion:(float)systemVersion {
    // If detected, it MUST contains emoji; otherwise it MAY not contains emoji.
    static NSMutableCharacterSet *minSet8_3, *minSetOld;
    // If detected, it may contains emoji; otherwise it MUST NOT contains emoji.
    static NSMutableCharacterSet *maxSet;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        minSetOld = [NSMutableCharacterSet new];
        [minSetOld addCharactersInString:@"u2139\u2194\u2195\u2196\u2197\u2198\u2199\u21a9\u21aa\u231a\u231b\u23e9\u23ea\u23eb\u23ec\u23f0\u23f3\u24c2\u25aa\u25ab\u25b6\u25c0\u25fb\u25fc\u25fd\u25fe\u2600\u2601\u260e\u2611\u2614\u2615\u261d\u261d\u263a\u2648\u2649\u264a\u264b\u264c\u264d\u264e\u264f\u2650\u2651\u2652\u2653\u2660\u2663\u2665\u2666\u2668\u267b\u267f\u2693\u26a0\u26a1\u26aa\u26ab\u26bd\u26be\u26c4\u26c5\u26ce\u26d4\u26ea\u26f2\u26f3\u26f5\u26fa\u26fd\u2702\u2705\u2708\u2709\u270a\u270b\u270c\u270c\u270f\u2712\u2714\u2716\u2728\u2733\u2734\u2744\u2747\u274c\u274e\u2753\u2754\u2755\u2757\u2764\u2795\u2796\u2797\u27a1\u27b0\u27bf\u2934\u2935\u2b05\u2b06\u2b07\u2b1b\u2b1c\u2b50\u2b55\u3030\u303d\u3297\u3299\U0001f004\U0001f0cf\U0001f170\U0001f171\U0001f17e\U0001f17f\U0001f18e\U0001f191\U0001f192\U0001f193\U0001f194\U0001f195\U0001f196\U0001f197\U0001f198\U0001f199\U0001f19a\U0001f201\U0001f202\U0001f21a\U0001f22f\U0001f232\U0001f233\U0001f234\U0001f235\U0001f236\U0001f237\U0001f238\U0001f239\U0001f23a\U0001f250\U0001f251\U0001f300\U0001f301\U0001f302\U0001f303\U0001f304\U0001f305\U0001f306\U0001f307\U0001f308\U0001f309\U0001f30a\U0001f30b\U0001f30c\U0001f30d\U0001f30e\U0001f30f\U0001f310\U0001f311\U0001f312\U0001f313\U0001f314\U0001f315\U0001f316\U0001f317\U0001f318\U0001f319\U0001f31a\U0001f31b\U0001f31c\U0001f31d\U0001f31e\U0001f31f\U0001f320\U0001f330\U0001f331\U0001f332\U0001f333\U0001f334\U0001f335\U0001f337\U0001f338\U0001f339\U0001f33a\U0001f33b\U0001f33c\U0001f33d\U0001f33e\U0001f33f\U0001f340\U0001f341\U0001f342\U0001f343\U0001f344\U0001f345\U0001f346\U0001f347\U0001f348\U0001f349\U0001f34a\U0001f34b\U0001f34c\U0001f34d\U0001f34e\U0001f34f\U0001f350\U0001f351\U0001f352\U0001f353\U0001f354\U0001f355\U0001f356\U0001f357\U0001f358\U0001f359\U0001f35a\U0001f35b\U0001f35c\U0001f35d\U0001f35e\U0001f35f\U0001f360\U0001f361\U0001f362\U0001f363\U0001f364\U0001f365\U0001f366\U0001f367\U0001f368\U0001f369\U0001f36a\U0001f36b\U0001f36c\U0001f36d\U0001f36e\U0001f36f\U0001f370\U0001f371\U0001f372\U0001f373\U0001f374\U0001f375\U0001f376\U0001f377\U0001f378\U0001f379\U0001f37a\U0001f37b\U0001f37c\U0001f380\U0001f381\U0001f382\U0001f383\U0001f384\U0001f385\U0001f386\U0001f387\U0001f388\U0001f389\U0001f38a\U0001f38b\U0001f38c\U0001f38d\U0001f38e\U0001f38f\U0001f390\U0001f391\U0001f392\U0001f393\U0001f3a0\U0001f3a1\U0001f3a2\U0001f3a3\U0001f3a4\U0001f3a5\U0001f3a6\U0001f3a7\U0001f3a8\U0001f3a9\U0001f3aa\U0001f3ab\U0001f3ac\U0001f3ad\U0001f3ae\U0001f3af\U0001f3b0\U0001f3b1\U0001f3b2\U0001f3b3\U0001f3b4\U0001f3b5\U0001f3b6\U0001f3b7\U0001f3b8\U0001f3b9\U0001f3ba\U0001f3bb\U0001f3bc\U0001f3bd\U0001f3be\U0001f3bf\U0001f3c0\U0001f3c1\U0001f3c2\U0001f3c3\U0001f3c4\U0001f3c6\U0001f3c7\U0001f3c8\U0001f3c9\U0001f3ca\U0001f3e0\U0001f3e1\U0001f3e2\U0001f3e3\U0001f3e4\U0001f3e5\U0001f3e6\U0001f3e7\U0001f3e8\U0001f3e9\U0001f3ea\U0001f3eb\U0001f3ec\U0001f3ed\U0001f3ee\U0001f3ef\U0001f3f0\U0001f400\U0001f401\U0001f402\U0001f403\U0001f404\U0001f405\U0001f406\U0001f407\U0001f408\U0001f409\U0001f40a\U0001f40b\U0001f40c\U0001f40d\U0001f40e\U0001f40f\U0001f410\U0001f411\U0001f412\U0001f413\U0001f414\U0001f415\U0001f416\U0001f417\U0001f418\U0001f419\U0001f41a\U0001f41b\U0001f41c\U0001f41d\U0001f41e\U0001f41f\U0001f420\U0001f421\U0001f422\U0001f423\U0001f424\U0001f425\U0001f426\U0001f427\U0001f428\U0001f429\U0001f42a\U0001f42b\U0001f42c\U0001f42d\U0001f42e\U0001f42f\U0001f430\U0001f431\U0001f432\U0001f433\U0001f434\U0001f435\U0001f436\U0001f437\U0001f438\U0001f439\U0001f43a\U0001f43b\U0001f43c\U0001f43d\U0001f43e\U0001f440\U0001f442\U0001f443\U0001f444\U0001f445\U0001f446\U0001f447\U0001f448\U0001f449\U0001f44a\U0001f44b\U0001f44c\U0001f44d\U0001f44e\U0001f44f\U0001f450\U0001f451\U0001f452\U0001f453\U0001f454\U0001f455\U0001f456\U0001f457\U0001f458\U0001f459\U0001f45a\U0001f45b\U0001f45c\U0001f45d\U0001f45e\U0001f45f\U0001f460\U0001f461\U0001f462\U0001f463\U0001f464\U0001f465\U0001f466\U0001f467\U0001f468\U0001f469\U0001f46a\U0001f46b\U0001f46c\U0001f46d\U0001f46e\U0001f46f\U0001f470\U0001f471\U0001f472\U0001f473\U0001f474\U0001f475\U0001f476\U0001f477\U0001f478\U0001f479\U0001f47a\U0001f47b\U0001f47c\U0001f47d\U0001f47e\U0001f47f\U0001f480\U0001f481\U0001f482\U0001f483\U0001f484\U0001f485\U0001f486\U0001f487\U0001f488\U0001f489\U0001f48a\U0001f48b\U0001f48c\U0001f48d\U0001f48e\U0001f48f\U0001f490\U0001f491\U0001f492\U0001f493\U0001f494\U0001f495\U0001f496\U0001f497\U0001f498\U0001f499\U0001f49a\U0001f49b\U0001f49c\U0001f49d\U0001f49e\U0001f49f\U0001f4a0\U0001f4a1\U0001f4a2\U0001f4a3\U0001f4a4\U0001f4a5\U0001f4a6\U0001f4a7\U0001f4a8\U0001f4a9\U0001f4aa\U0001f4ab\U0001f4ac\U0001f4ad\U0001f4ae\U0001f4af\U0001f4b0\U0001f4b1\U0001f4b2\U0001f4b3\U0001f4b4\U0001f4b5\U0001f4b6\U0001f4b7\U0001f4b8\U0001f4b9\U0001f4ba\U0001f4bb\U0001f4bc\U0001f4bd\U0001f4be\U0001f4bf\U0001f4c0\U0001f4c1\U0001f4c2\U0001f4c3\U0001f4c4\U0001f4c5\U0001f4c6\U0001f4c7\U0001f4c8\U0001f4c9\U0001f4ca\U0001f4cb\U0001f4cc\U0001f4cd\U0001f4ce\U0001f4cf\U0001f4d0\U0001f4d1\U0001f4d2\U0001f4d3\U0001f4d4\U0001f4d5\U0001f4d6\U0001f4d7\U0001f4d8\U0001f4d9\U0001f4da\U0001f4db\U0001f4dc\U0001f4dd\U0001f4de\U0001f4df\U0001f4e0\U0001f4e1\U0001f4e2\U0001f4e3\U0001f4e4\U0001f4e5\U0001f4e6\U0001f4e7\U0001f4e8\U0001f4e9\U0001f4ea\U0001f4eb\U0001f4ec\U0001f4ed\U0001f4ee\U0001f4ef\U0001f4f0\U0001f4f1\U0001f4f2\U0001f4f3\U0001f4f4\U0001f4f5\U0001f4f6\U0001f4f7\U0001f4f9\U0001f4fa\U0001f4fb\U0001f4fc\U0001f500\U0001f501\U0001f502\U0001f503\U0001f504\U0001f505\U0001f506\U0001f507\U0001f508\U0001f509\U0001f50a\U0001f50b\U0001f50c\U0001f50d\U0001f50e\U0001f50f\U0001f510\U0001f511\U0001f512\U0001f513\U0001f514\U0001f515\U0001f516\U0001f517\U0001f518\U0001f519\U0001f51a\U0001f51b\U0001f51c\U0001f51d\U0001f51e\U0001f51f\U0001f520\U0001f521\U0001f522\U0001f523\U0001f524\U0001f525\U0001f526\U0001f527\U0001f528\U0001f529\U0001f52a\U0001f52b\U0001f52c\U0001f52d\U0001f52e\U0001f52f\U0001f530\U0001f531\U0001f532\U0001f533\U0001f534\U0001f535\U0001f536\U0001f537\U0001f538\U0001f539\U0001f53a\U0001f53b\U0001f53c\U0001f53d\U0001f550\U0001f551\U0001f552\U0001f553\U0001f554\U0001f555\U0001f556\U0001f557\U0001f558\U0001f559\U0001f55a\U0001f55b\U0001f55c\U0001f55d\U0001f55e\U0001f55f\U0001f560\U0001f561\U0001f562\U0001f563\U0001f564\U0001f565\U0001f566\U0001f567\U0001f5fb\U0001f5fc\U0001f5fd\U0001f5fe\U0001f5ff\U0001f600\U0001f601\U0001f602\U0001f603\U0001f604\U0001f605\U0001f606\U0001f607\U0001f608\U0001f609\U0001f60a\U0001f60b\U0001f60c\U0001f60d\U0001f60e\U0001f60f\U0001f610\U0001f611\U0001f612\U0001f613\U0001f614\U0001f615\U0001f616\U0001f617\U0001f618\U0001f619\U0001f61a\U0001f61b\U0001f61c\U0001f61d\U0001f61e\U0001f61f\U0001f620\U0001f621\U0001f622\U0001f623\U0001f624\U0001f625\U0001f626\U0001f627\U0001f628\U0001f629\U0001f62a\U0001f62b\U0001f62c\U0001f62d\U0001f62e\U0001f62f\U0001f630\U0001f631\U0001f632\U0001f633\U0001f634\U0001f635\U0001f636\U0001f637\U0001f638\U0001f639\U0001f63a\U0001f63b\U0001f63c\U0001f63d\U0001f63e\U0001f63f\U0001f640\U0001f645\U0001f646\U0001f647\U0001f648\U0001f649\U0001f64a\U0001f64b\U0001f64c\U0001f64d\U0001f64e\U0001f64f\U0001f680\U0001f681\U0001f682\U0001f683\U0001f684\U0001f685\U0001f686\U0001f687\U0001f688\U0001f689\U0001f68a\U0001f68b\U0001f68c\U0001f68d\U0001f68e\U0001f68f\U0001f690\U0001f691\U0001f692\U0001f693\U0001f694\U0001f695\U0001f696\U0001f697\U0001f698\U0001f699\U0001f69a\U0001f69b\U0001f69c\U0001f69d\U0001f69e\U0001f69f\U0001f6a0\U0001f6a1\U0001f6a2\U0001f6a3\U0001f6a4\U0001f6a5\U0001f6a6\U0001f6a7\U0001f6a8\U0001f6a9\U0001f6aa\U0001f6ab\U0001f6ac\U0001f6ad\U0001f6ae\U0001f6af\U0001f6b0\U0001f6b1\U0001f6b2\U0001f6b3\U0001f6b4\U0001f6b5\U0001f6b6\U0001f6b7\U0001f6b8\U0001f6b9\U0001f6ba\U0001f6bb\U0001f6bc\U0001f6bd\U0001f6be\U0001f6bf\U0001f6c0\U0001f6c1\U0001f6c2\U0001f6c3\U0001f6c4\U0001f6c5"];
        
        maxSet = minSetOld.mutableCopy;
        [maxSet addCharactersInRange:NSMakeRange(0x20e3, 1)]; // Combining Enclosing Keycap (multi-face emoji)
        [maxSet addCharactersInRange:NSMakeRange(0xfe0f, 1)]; // Variation Selector
        [maxSet addCharactersInRange:NSMakeRange(0x1f1e6, 26)]; // Regional Indicator Symbol Letter
        
        minSet8_3 = minSetOld.mutableCopy;
        [minSet8_3 addCharactersInRange:NSMakeRange(0x1f3fb, 5)]; // Color of skin
    });
    
    // 1. Most of string does not contains emoji, so test the maximum range of charset first.
    if ([self rangeOfCharacterFromSet:maxSet].location == NSNotFound) return NO;
    
    // 2. If the emoji can be detected by the minimum charset, return 'YES' directly.
    if ([self rangeOfCharacterFromSet:((systemVersion < 8.3) ? minSetOld : minSet8_3)].location != NSNotFound) return YES;
    
    // 3. The string contains some characters which may compose an emoji, but cannot detected with charset.
    // Use a regular expression to detect the emoji. It's slower than using charset.
    static NSRegularExpression *regexOld, *regex8_3, *regex9_0;
    static dispatch_once_t onceTokenRegex;
    dispatch_once(&onceTokenRegex, ^{
        regexOld = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇨🇳|🇩🇪|🇪🇸|🇫🇷|🇬🇧|🇮🇹|🇯🇵|🇰🇷|🇷🇺|🇺🇸)" options:kNilOptions error:nil];
        regex8_3 = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇦🇺|🇦🇹|🇧🇪|🇧🇷|🇨🇦|🇨🇱|🇨🇳|🇨🇴|🇩🇰|🇫🇮|🇫🇷|🇩🇪|🇭🇰|🇮🇳|🇮🇩|🇮🇪|🇮🇱|🇮🇹|🇯🇵|🇰🇷|🇲🇴|🇲🇾|🇲🇽|🇳🇱|🇳🇿|🇳🇴|🇵🇭|🇵🇱|🇵🇹|🇵🇷|🇷🇺|🇸🇦|🇸🇬|🇿🇦|🇪🇸|🇸🇪|🇨🇭|🇹🇷|🇬🇧|🇺🇸|🇦🇪|🇻🇳)" options:kNilOptions error:nil];
        regex9_0 = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇦🇫|🇦🇽|🇦🇱|🇩🇿|🇦🇸|🇦🇩|🇦🇴|🇦🇮|🇦🇶|🇦🇬|🇦🇷|🇦🇲|🇦🇼|🇦🇺|🇦🇹|🇦🇿|🇧🇸|🇧🇭|🇧🇩|🇧🇧|🇧🇾|🇧🇪|🇧🇿|🇧🇯|🇧🇲|🇧🇹|🇧🇴|🇧🇶|🇧🇦|🇧🇼|🇧🇻|🇧🇷|🇮🇴|🇻🇬|🇧🇳|🇧🇬|🇧🇫|🇧🇮|🇰🇭|🇨🇲|🇨🇦|🇨🇻|🇰🇾|🇨🇫|🇹🇩|🇨🇱|🇨🇳|🇨🇽|🇨🇨|🇨🇴|🇰🇲|🇨🇬|🇨🇩|🇨🇰|🇨🇷|🇨🇮|🇭🇷|🇨🇺|🇨🇼|🇨🇾|🇨🇿|🇩🇰|🇩🇯|🇩🇲|🇩🇴|🇪🇨|🇪🇬|🇸🇻|🇬🇶|🇪🇷|🇪🇪|🇪🇹|🇫🇰|🇫🇴|🇫🇯|🇫🇮|🇫🇷|🇬🇫|🇵🇫|🇹🇫|🇬🇦|🇬🇲|🇬🇪|🇩🇪|🇬🇭|🇬🇮|🇬🇷|🇬🇱|🇬🇩|🇬🇵|🇬🇺|🇬🇹|🇬🇬|🇬🇳|🇬🇼|🇬🇾|🇭🇹|🇭🇲|🇭🇳|🇭🇰|🇭🇺|🇮🇸|🇮🇳|🇮🇩|🇮🇷|🇮🇶|🇮🇪|🇮🇲|🇮🇱|🇮🇹|🇯🇲|🇯🇵|🇯🇪|🇯🇴|🇰🇿|🇰🇪|🇰🇮|🇰🇼|🇰🇬|🇱🇦|🇱🇻|🇱🇧|🇱🇸|🇱🇷|🇱🇾|🇱🇮|🇱🇹|🇱🇺|🇲🇴|🇲🇰|🇲🇬|🇲🇼|🇲🇾|🇲🇻|🇲🇱|🇲🇹|🇲🇭|🇲🇶|🇲🇷|🇲🇺|🇾🇹|🇲🇽|🇫🇲|🇲🇩|🇲🇨|🇲🇳|🇲🇪|🇲🇸|🇲🇦|🇲🇿|🇲🇲|🇳🇦|🇳🇷|🇳🇵|🇳🇱|🇳🇨|🇳🇿|🇳🇮|🇳🇪|🇳🇬|🇳🇺|🇳🇫|🇲🇵|🇰🇵|🇳🇴|🇴🇲|🇵🇰|🇵🇼|🇵🇸|🇵🇦|🇵🇬|🇵🇾|🇵🇪|🇵🇭|🇵🇳|🇵🇱|🇵🇹|🇵🇷|🇶🇦|🇷🇪|🇷🇴|🇷🇺|🇷🇼|🇧🇱|🇸🇭|🇰🇳|🇱🇨|🇲🇫|🇻🇨|🇼🇸|🇸🇲|🇸🇹|🇸🇦|🇸🇳|🇷🇸|🇸🇨|🇸🇱|🇸🇬|🇸🇰|🇸🇮|🇸🇧|🇸🇴|🇿🇦|🇬🇸|🇰🇷|🇸🇸|🇪🇸|🇱🇰|🇸🇩|🇸🇷|🇸🇯|🇸🇿|🇸🇪|🇨🇭|🇸🇾|🇹🇼|🇹🇯|🇹🇿|🇹🇭|🇹🇱|🇹🇬|🇹🇰|🇹🇴|🇹🇹|🇹🇳|🇹🇷|🇹🇲|🇹🇨|🇹🇻|🇺🇬|🇺🇦|🇦🇪|🇬🇧|🇺🇸|🇺🇲|🇻🇮|🇺🇾|🇺🇿|🇻🇺|🇻🇦|🇻🇪|🇻🇳|🇼🇫|🇪🇭|🇾🇪|🇿🇲|🇿🇼)" options:kNilOptions error:nil];
    });
    
    NSRange regexRange = [(systemVersion < 8.3 ? regexOld : systemVersion < 9.0 ? regex8_3 : regex9_0) rangeOfFirstMatchInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    return regexRange.location != NSNotFound;
}

static NSDictionary * kkUnicodeToCheatCodes = nil;
static NSDictionary * kkCheatCodesToUnicode = nil;

+ (void)kkInitializeEmojiCheatCodes {
    NSDictionary *forwardMap = @{
                                 @"😄": @":smile:",
                                 @"😆": @[@":laughing:", @":D"],
                                 @"😊": @":blush:",
                                 @"😃": @[@":smiley:", @":)", @":-)"],
                                 @"☺": @":relaxed:",
                                 @"😏": @":smirk:",
                                 @"😞": @[@":disappointed:", @":("],
                                 @"😍": @":heart_eyes:",
                                 @"😘": @":kissing_heart:",
                                 @"😚": @":kissing_closed_eyes:",
                                 @"😳": @":flushed:",
                                 @"😥": @":relieved:",
                                 @"😌": @":satisfied:",
                                 @"😁": @":grin:",
                                 @"😉": @[@":wink:", @";)", @";-)"],
                                 @"😜": @[@":wink2:", @":P"],
                                 @"😝": @":stuck_out_tongue_closed_eyes:",
                                 @"😀": @":grinning:",
                                 @"😗": @":kissing:",
                                 @"😙": @":kissing_smiling_eyes:",
                                 @"😛": @":stuck_out_tongue:",
                                 @"😴": @":sleeping:",
                                 @"😟": @":worried:",
                                 @"😦": @":frowning:",
                                 @"😧": @":anguished:",
                                 @"😮": @[@":open_mouth:", @":o"],
                                 @"😬": @":grimacing:",
                                 @"😕": @":confused:",
                                 @"😯": @":hushed:",
                                 @"😑": @":expressionless:",
                                 @"😒": @":unamused:",
                                 @"😅": @":sweat_smile:",
                                 @"😓": @":sweat:",
                                 @"😩": @":weary:",
                                 @"😔": @":pensive:",
                                 @"😞": @":dissapointed:",
                                 @"😖": @":confounded:",
                                 @"😨": @":fearful:",
                                 @"😰": @":cold_sweat:",
                                 @"😣": @":persevere:",
                                 @"😢": @":cry:",
                                 @"😭": @":sob:",
                                 @"😂": @":joy:",
                                 @"😲": @":astonished:",
                                 @"😱": @":scream:",
                                 @"😫": @":tired_face:",
                                 @"😠": @":angry:",
                                 @"😡": @":rage:",
                                 @"😤": @":triumph:",
                                 @"😪": @":sleepy:",
                                 @"😋": @":yum:",
                                 @"😷": @":mask:",
                                 @"😎": @":sunglasses:",
                                 @"😵": @":dizzy_face:",
                                 @"👿": @":imp:",
                                 @"😈": @":smiling_imp:",
                                 @"😐": @":neutral_face:",
                                 @"😶": @":no_mouth:",
                                 @"😇": @":innocent:",
                                 @"👽": @":alien:",
                                 @"💛": @":yellow_heart:",
                                 @"💙": @":blue_heart:",
                                 @"💜": @":purple_heart:",
                                 @"❤": @":heart:",
                                 @"💚": @":green_heart:",
                                 @"💔": @":broken_heart:",
                                 @"💓": @":heartbeat:",
                                 @"💗": @":heartpulse:",
                                 @"💕": @":two_hearts:",
                                 @"💞": @":revolving_hearts:",
                                 @"💘": @":cupid:",
                                 @"💖": @":sparkling_heart:",
                                 @"✨": @":sparkles:",
                                 @"⭐️": @":star:",
                                 @"🌟": @":star2:",
                                 @"💫": @":dizzy:",
                                 @"💥": @":boom:",
                                 @"💢": @":anger:",
                                 @"❗": @":exclamation:",
                                 @"❓": @":question:",
                                 @"❕": @":grey_exclamation:",
                                 @"❔": @":grey_question:",
                                 @"💤": @":zzz:",
                                 @"💨": @":dash:",
                                 @"💦": @":sweat_drops:",
                                 @"🎶": @":notes:",
                                 @"🎵": @":musical_note:",
                                 @"🔥": @":fire:",
                                 @"💩": @[@":poop:", @":hankey:", @":shit:"],
                                 @"👍": @[@":+1:", @":thumbsup:"],
                                 @"👎": @[@":-1:", @":thumbsdown:"],
                                 @"👌": @":ok_hand:",
                                 @"👊": @":punch:",
                                 @"✊": @":fist:",
                                 @"✌": @":v:",
                                 @"👋": @":wave:",
                                 @"✋": @":hand:",
                                 @"👐": @":open_hands:",
                                 @"☝": @":point_up:",
                                 @"👇": @":point_down:",
                                 @"👈": @":point_left:",
                                 @"👉": @":point_right:",
                                 @"🙌": @":raised_hands:",
                                 @"🙏": @":pray:",
                                 @"👆": @":point_up_2:",
                                 @"👏": @":clap:",
                                 @"💪": @":muscle:",
                                 @"🚶": @":walking:",
                                 @"🏃": @":runner:",
                                 @"👫": @":couple:",
                                 @"👪": @":family:",
                                 @"👬": @":two_men_holding_hands:",
                                 @"👭": @":two_women_holding_hands:",
                                 @"💃": @":dancer:",
                                 @"👯": @":dancers:",
                                 @"🙆": @":ok_woman:",
                                 @"🙅": @":no_good:",
                                 @"💁": @":information_desk_person:",
                                 @"🙋": @":raised_hand:",
                                 @"👰": @":bride_with_veil:",
                                 @"🙎": @":person_with_pouting_face:",
                                 @"🙍": @":person_frowning:",
                                 @"🙇": @":bow:",
                                 @"💏": @":couplekiss:",
                                 @"💑": @":couple_with_heart:",
                                 @"💆": @":massage:",
                                 @"💇": @":haircut:",
                                 @"💅": @":nail_care:",
                                 @"👦": @":boy:",
                                 @"👧": @":girl:",
                                 @"👩": @":woman:",
                                 @"👨": @":man:",
                                 @"👶": @":baby:",
                                 @"👵": @":older_woman:",
                                 @"👴": @":older_man:",
                                 @"👱": @":person_with_blond_hair:",
                                 @"👲": @":man_with_gua_pi_mao:",
                                 @"👳": @":man_with_turban:",
                                 @"👷": @":construction_worker:",
                                 @"👮": @":cop:",
                                 @"👼": @":angel:",
                                 @"👸": @":princess:",
                                 @"😺": @":smiley_cat:",
                                 @"😸": @":smile_cat:",
                                 @"😻": @":heart_eyes_cat:",
                                 @"😽": @":kissing_cat:",
                                 @"😼": @":smirk_cat:",
                                 @"🙀": @":scream_cat:",
                                 @"😿": @":crying_cat_face:",
                                 @"😹": @":joy_cat:",
                                 @"😾": @":pouting_cat:",
                                 @"👹": @":japanese_ogre:",
                                 @"👺": @":japanese_goblin:",
                                 @"🙈": @":see_no_evil:",
                                 @"🙉": @":hear_no_evil:",
                                 @"🙊": @":speak_no_evil:",
                                 @"💂": @":guardsman:",
                                 @"💀": @":skull:",
                                 @"👣": @":feet:",
                                 @"👄": @":lips:",
                                 @"💋": @":kiss:",
                                 @"💧": @":droplet:",
                                 @"👂": @":ear:",
                                 @"👀": @":eyes:",
                                 @"👃": @":nose:",
                                 @"👅": @":tongue:",
                                 @"💌": @":love_letter:",
                                 @"👤": @":bust_in_silhouette:",
                                 @"👥": @":busts_in_silhouette:",
                                 @"💬": @":speech_balloon:",
                                 @"💭": @":thought_balloon:",
                                 @"☀": @":sunny:",
                                 @"☔": @":umbrella:",
                                 @"☁": @":cloud:",
                                 @"❄": @":snowflake:",
                                 @"⛄": @":snowman:",
                                 @"⚡": @":zap:",
                                 @"🌀": @":cyclone:",
                                 @"🌁": @":foggy:",
                                 @"🌊": @":ocean:",
                                 @"🐱": @":cat:",
                                 @"🐶": @":dog:",
                                 @"🐭": @":mouse:",
                                 @"🐹": @":hamster:",
                                 @"🐰": @":rabbit:",
                                 @"🐺": @":wolf:",
                                 @"🐸": @":frog:",
                                 @"🐯": @":tiger:",
                                 @"🐨": @":koala:",
                                 @"🐻": @":bear:",
                                 @"🐷": @":pig:",
                                 @"🐽": @":pig_nose:",
                                 @"🐮": @":cow:",
                                 @"🐗": @":boar:",
                                 @"🐵": @":monkey_face:",
                                 @"🐒": @":monkey:",
                                 @"🐴": @":horse:",
                                 @"🐎": @":racehorse:",
                                 @"🐫": @":camel:",
                                 @"🐑": @":sheep:",
                                 @"🐘": @":elephant:",
                                 @"🐼": @":panda_face:",
                                 @"🐍": @":snake:",
                                 @"🐦": @":bird:",
                                 @"🐤": @":baby_chick:",
                                 @"🐥": @":hatched_chick:",
                                 @"🐣": @":hatching_chick:",
                                 @"🐔": @":chicken:",
                                 @"🐧": @":penguin:",
                                 @"🐢": @":turtle:",
                                 @"🐛": @":bug:",
                                 @"🐝": @":honeybee:",
                                 @"🐜": @":ant:",
                                 @"🐞": @":beetle:",
                                 @"🐌": @":snail:",
                                 @"🐙": @":octopus:",
                                 @"🐠": @":tropical_fish:",
                                 @"🐟": @":fish:",
                                 @"🐳": @":whale:",
                                 @"🐋": @":whale2:",
                                 @"🐬": @":dolphin:",
                                 @"🐄": @":cow2:",
                                 @"🐏": @":ram:",
                                 @"🐀": @":rat:",
                                 @"🐃": @":water_buffalo:",
                                 @"🐅": @":tiger2:",
                                 @"🐇": @":rabbit2:",
                                 @"🐉": @":dragon:",
                                 @"🐐": @":goat:",
                                 @"🐓": @":rooster:",
                                 @"🐕": @":dog2:",
                                 @"🐖": @":pig2:",
                                 @"🐁": @":mouse2:",
                                 @"🐂": @":ox:",
                                 @"🐲": @":dragon_face:",
                                 @"🐡": @":blowfish:",
                                 @"🐊": @":crocodile:",
                                 @"🐪": @":dromedary_camel:",
                                 @"🐆": @":leopard:",
                                 @"🐈": @":cat2:",
                                 @"🐩": @":poodle:",
                                 @"🐾": @":paw_prints:",
                                 @"💐": @":bouquet:",
                                 @"🌸": @":cherry_blossom:",
                                 @"🌷": @":tulip:",
                                 @"🍀": @":four_leaf_clover:",
                                 @"🌹": @":rose:",
                                 @"🌻": @":sunflower:",
                                 @"🌺": @":hibiscus:",
                                 @"🍁": @":maple_leaf:",
                                 @"🍃": @":leaves:",
                                 @"🍂": @":fallen_leaf:",
                                 @"🌿": @":herb:",
                                 @"🍄": @":mushroom:",
                                 @"🌵": @":cactus:",
                                 @"🌴": @":palm_tree:",
                                 @"🌲": @":evergreen_tree:",
                                 @"🌳": @":deciduous_tree:",
                                 @"🌰": @":chestnut:",
                                 @"🌱": @":seedling:",
                                 @"🌼": @":blossum:",
                                 @"🌾": @":ear_of_rice:",
                                 @"🐚": @":shell:",
                                 @"🌐": @":globe_with_meridians:",
                                 @"🌞": @":sun_with_face:",
                                 @"🌝": @":full_moon_with_face:",
                                 @"🌚": @":new_moon_with_face:",
                                 @"🌑": @":new_moon:",
                                 @"🌒": @":waxing_crescent_moon:",
                                 @"🌓": @":first_quarter_moon:",
                                 @"🌔": @":waxing_gibbous_moon:",
                                 @"🌕": @":full_moon:",
                                 @"🌖": @":waning_gibbous_moon:",
                                 @"🌗": @":last_quarter_moon:",
                                 @"🌘": @":waning_crescent_moon:",
                                 @"🌜": @":last_quarter_moon_with_face:",
                                 @"🌛": @":first_quarter_moon_with_face:",
                                 @"🌙": @":moon:",
                                 @"🌍": @":earth_africa:",
                                 @"🌎": @":earth_americas:",
                                 @"🌏": @":earth_asia:",
                                 @"🌋": @":volcano:",
                                 @"🌌": @":milky_way:",
                                 @"⛅": @":partly_sunny:",
                                 @"🎍": @":bamboo:",
                                 @"💝": @":gift_heart:",
                                 @"🎎": @":dolls:",
                                 @"🎒": @":school_satchel:",
                                 @"🎓": @":mortar_board:",
                                 @"🎏": @":flags:",
                                 @"🎆": @":fireworks:",
                                 @"🎇": @":sparkler:",
                                 @"🎐": @":wind_chime:",
                                 @"🎑": @":rice_scene:",
                                 @"🎃": @":jack_o_lantern:",
                                 @"👻": @":ghost:",
                                 @"🎅": @":santa:",
                                 @"🎱": @":8ball:",
                                 @"⏰": @":alarm_clock:",
                                 @"🍎": @":apple:",
                                 @"🎨": @":art:",
                                 @"🍼": @":baby_bottle:",
                                 @"🎈": @":balloon:",
                                 @"🍌": @":banana:",
                                 @"📊": @":bar_chart:",
                                 @"⚾": @":baseball:",
                                 @"🏀": @":basketball:",
                                 @"🛀": @":bath:",
                                 @"🛁": @":bathtub:",
                                 @"🔋": @":battery:",
                                 @"🍺": @":beer:",
                                 @"🍻": @":beers:",
                                 @"🔔": @":bell:",
                                 @"🍱": @":bento:",
                                 @"🚴": @":bicyclist:",
                                 @"👙": @":bikini:",
                                 @"🎂": @":birthday:",
                                 @"🃏": @":black_joker:",
                                 @"✒": @":black_nib:",
                                 @"📘": @":blue_book:",
                                 @"💣": @":bomb:",
                                 @"🔖": @":bookmark:",
                                 @"📑": @":bookmark_tabs:",
                                 @"📚": @":books:",
                                 @"👢": @":boot:",
                                 @"🎳": @":bowling:",
                                 @"🍞": @":bread:",
                                 @"💼": @":briefcase:",
                                 @"💡": @":bulb:",
                                 @"🍰": @":cake:",
                                 @"📆": @":calendar:",
                                 @"📲": @":calling:",
                                 @"📷": @":camera:",
                                 @"🍬": @":candy:",
                                 @"📇": @":card_index:",
                                 @"💿": @":cd:",
                                 @"📉": @":chart_with_downwards_trend:",
                                 @"📈": @":chart_with_upwards_trend:",
                                 @"🍒": @":cherries:",
                                 @"🍫": @":chocolate_bar:",
                                 @"🎄": @":christmas_tree:",
                                 @"🎬": @":clapper:",
                                 @"📋": @":clipboard:",
                                 @"📕": @":closed_book:",
                                 @"🔐": @":closed_lock_with_key:",
                                 @"🌂": @":closed_umbrella:",
                                 @"♣": @":clubs:",
                                 @"🍸": @":cocktail:",
                                 @"☕": @":coffee:",
                                 @"💻": @":computer:",
                                 @"🎊": @":confetti_ball:",
                                 @"🍪": @":cookie:",
                                 @"🌽": @":corn:",
                                 @"💳": @":credit_card:",
                                 @"👑": @":crown:",
                                 @"🔮": @":crystal_ball:",
                                 @"🍛": @":curry:",
                                 @"🍮": @":custard:",
                                 @"🍡": @":dango:",
                                 @"🎯": @":dart:",
                                 @"📅": @":date:",
                                 @"♦": @":diamonds:",
                                 @"💵": @":dollar:",
                                 @"🚪": @":door:",
                                 @"🍩": @":doughnut:",
                                 @"👗": @":dress:",
                                 @"📀": @":dvd:",
                                 @"📧": @":e-mail:",
                                 @"🍳": @":egg:",
                                 @"🍆": @":eggplant:",
                                 @"🔌": @":electric_plug:",
                                 @"✉": @":email:",
                                 @"💶": @":euro:",
                                 @"👓": @":eyeglasses:",
                                 @"📠": @":fax:",
                                 @"📁": @":file_folder:",
                                 @"🍥": @":fish_cake:",
                                 @"🎣": @":fishing_pole_and_fish:",
                                 @"🔦": @":flashlight:",
                                 @"💾": @":floppy_disk:",
                                 @"🎴": @":flower_playing_cards:",
                                 @"🏈": @":football:",
                                 @"🍴": @":fork_and_knife:",
                                 @"🍤": @":fried_shrimp:",
                                 @"🍟": @":fries:",
                                 @"🎲": @":game_die:",
                                 @"💎": @":gem:",
                                 @"🎁": @":gift:",
                                 @"⛳": @":golf:",
                                 @"🍇": @":grapes:",
                                 @"🍏": @":green_apple:",
                                 @"📗": @":green_book:",
                                 @"🎸": @":guitar:",
                                 @"🔫": @":gun:",
                                 @"🍔": @":hamburger:",
                                 @"🔨": @":hammer:",
                                 @"👜": @":handbag:",
                                 @"🎧": @":headphones:",
                                 @"♥": @":hearts:",
                                 @"🔆": @":high_brightness:",
                                 @"👠": @":high_heel:",
                                 @"🔪": @":hocho:",
                                 @"🍯": @":honey_pot:",
                                 @"🏇": @":horse_racing:",
                                 @"⌛": @":hourglass:",
                                 @"⏳": @":hourglass_flowing_sand:",
                                 @"🍨": @":ice_cream:",
                                 @"🍦": @":icecream:",
                                 @"📥": @":inbox_tray:",
                                 @"📨": @":incoming_envelope:",
                                 @"📱": @":iphone:",
                                 @"🏮": @":izakaya_lantern:",
                                 @"👖": @":jeans:",
                                 @"🔑": @":key:",
                                 @"👘": @":kimono:",
                                 @"📒": @":ledger:",
                                 @"🍋": @":lemon:",
                                 @"💄": @":lipstick:",
                                 @"🔒": @":lock:",
                                 @"🔏": @":lock_with_ink_pen:",
                                 @"🍭": @":lollipop:",
                                 @"➿": @":loop:",
                                 @"📢": @":loudspeaker:",
                                 @"🔅": @":low_brightness:",
                                 @"🔍": @":mag:",
                                 @"🔎": @":mag_right:",
                                 @"🀄": @":mahjong:",
                                 @"📫": @":mailbox:",
                                 @"📪": @":mailbox_closed:",
                                 @"📬": @":mailbox_with_mail:",
                                 @"📭": @":mailbox_with_no_mail:",
                                 @"👞": @":mans_shoe:",
                                 @"🍖": @":meat_on_bone:",
                                 @"📣": @":mega:",
                                 @"🍈": @":melon:",
                                 @"📝": @":memo:",
                                 @"🎤": @":microphone:",
                                 @"🔬": @":microscope:",
                                 @"💽": @":minidisc:",
                                 @"💸": @":money_with_wings:",
                                 @"💰": @":moneybag:",
                                 @"🚵": @":mountain_bicyclist:",
                                 @"🎥": @":movie_camera:",
                                 @"🎹": @":musical_keyboard:",
                                 @"🎼": @":musical_score:",
                                 @"🔇": @":mute:",
                                 @"📛": @":name_badge:",
                                 @"👔": @":necktie:",
                                 @"📰": @":newspaper:",
                                 @"🔕": @":no_bell:",
                                 @"📓": @":notebook:",
                                 @"📔": @":notebook_with_decorative_cover:",
                                 @"🔩": @":nut_and_bolt:",
                                 @"🍢": @":oden:",
                                 @"📂": @":open_file_folder:",
                                 @"📙": @":orange_book:",
                                 @"📤": @":outbox_tray:",
                                 @"📄": @":page_facing_up:",
                                 @"📃": @":page_with_curl:",
                                 @"📟": @":pager:",
                                 @"📎": @":paperclip:",
                                 @"🍑": @":peach:",
                                 @"🍐": @":pear:",
                                 @"✏": @":pencil2:",
                                 @"☎": @":phone:",
                                 @"💊": @":pill:",
                                 @"🍍": @":pineapple:",
                                 @"🍕": @":pizza:",
                                 @"📯": @":postal_horn:",
                                 @"📮": @":postbox:",
                                 @"👝": @":pouch:",
                                 @"🍗": @":poultry_leg:",
                                 @"💷": @":pound:",
                                 @"👛": @":purse:",
                                 @"📌": @":pushpin:",
                                 @"📻": @":radio:",
                                 @"🍜": @":ramen:",
                                 @"🎀": @":ribbon:",
                                 @"🍚": @":rice:",
                                 @"🍙": @":rice_ball:",
                                 @"🍘": @":rice_cracker:",
                                 @"💍": @":ring:",
                                 @"🏉": @":rugby_football:",
                                 @"🎽": @":running_shirt_with_sash:",
                                 @"🍶": @":sake:",
                                 @"👡": @":sandal:",
                                 @"📡": @":satellite:",
                                 @"🎷": @":saxophone:",
                                 @"✂": @":scissors:",
                                 @"📜": @":scroll:",
                                 @"💺": @":seat:",
                                 @"🍧": @":shaved_ice:",
                                 @"👕": @":shirt:",
                                 @"🚿": @":shower:",
                                 @"🎿": @":ski:",
                                 @"🚬": @":smoking:",
                                 @"🏂": @":snowboarder:",
                                 @"⚽": @":soccer:",
                                 @"🔉": @":sound:",
                                 @"👾": @":space_invader:",
                                 @"♠": @":spades:",
                                 @"🍝": @":spaghetti:",
                                 @"🔊": @":speaker:",
                                 @"🍲": @":stew:",
                                 @"📏": @":straight_ruler:",
                                 @"🍓": @":strawberry:",
                                 @"🏄": @":surfer:",
                                 @"🍣": @":sushi:",
                                 @"🍠": @":sweet_potato:",
                                 @"🏊": @":swimmer:",
                                 @"💉": @":syringe:",
                                 @"🎉": @":tada:",
                                 @"🎋": @":tanabata_tree:",
                                 @"🍊": @":tangerine:",
                                 @"🍵": @":tea:",
                                 @"📞": @":telephone_receiver:",
                                 @"🔭": @":telescope:",
                                 @"🎾": @":tennis:",
                                 @"🚽": @":toilet:",
                                 @"🍅": @":tomato:",
                                 @"🎩": @":tophat:",
                                 @"📐": @":triangular_ruler:",
                                 @"🏆": @":trophy:",
                                 @"🍹": @":tropical_drink:",
                                 @"🎺": @":trumpet:",
                                 @"📺": @":tv:",
                                 @"🔓": @":unlock:",
                                 @"📼": @":vhs:",
                                 @"📹": @":video_camera:",
                                 @"🎮": @":video_game:",
                                 @"🎻": @":violin:",
                                 @"⌚": @":watch:",
                                 @"🍉": @":watermelon:",
                                 @"🍷": @":wine_glass:",
                                 @"👚": @":womans_clothes:",
                                 @"👒": @":womans_hat:",
                                 @"🔧": @":wrench:",
                                 @"💴": @":yen:",
                                 @"🚡": @":aerial_tramway:",
                                 @"✈": @":airplane:",
                                 @"🚑": @":ambulance:",
                                 @"⚓": @":anchor:",
                                 @"🚛": @":articulated_lorry:",
                                 @"🏧": @":atm:",
                                 @"🏦": @":bank:",
                                 @"💈": @":barber:",
                                 @"🔰": @":beginner:",
                                 @"🚲": @":bike:",
                                 @"🚙": @":blue_car:",
                                 @"⛵": @":boat:",
                                 @"🌉": @":bridge_at_night:",
                                 @"🚅": @":bullettrain_front:",
                                 @"🚄": @":bullettrain_side:",
                                 @"🚌": @":bus:",
                                 @"🚏": @":busstop:",
                                 @"🚗": @":car:",
                                 @"🎠": @":carousel_horse:",
                                 @"🏁": @":checkered_flag:",
                                 @"⛪": @":church:",
                                 @"🎪": @":circus_tent:",
                                 @"🌇": @":city_sunrise:",
                                 @"🌆": @":city_sunset:",
                                 @"🚧": @":construction:",
                                 @"🏪": @":convenience_store:",
                                 @"🎌": @":crossed_flags:",
                                 @"🏬": @":department_store:",
                                 @"🏰": @":european_castle:",
                                 @"🏤": @":european_post_office:",
                                 @"🏭": @":factory:",
                                 @"🎡": @":ferris_wheel:",
                                 @"🚒": @":fire_engine:",
                                 @"⛲": @":fountain:",
                                 @"⛽": @":fuelpump:",
                                 @"🚁": @":helicopter:",
                                 @"🏥": @":hospital:",
                                 @"🏨": @":hotel:",
                                 @"♨": @":hotsprings:",
                                 @"🏠": @":house:",
                                 @"🏡": @":house_with_garden:",
                                 @"🗾": @":japan:",
                                 @"🏯": @":japanese_castle:",
                                 @"🚈": @":light_rail:",
                                 @"🏩": @":love_hotel:",
                                 @"🚐": @":minibus:",
                                 @"🚝": @":monorail:",
                                 @"🗻": @":mount_fuji:",
                                 @"🚠": @":mountain_cableway:",
                                 @"🚞": @":mountain_railway:",
                                 @"🗿": @":moyai:",
                                 @"🏢": @":office:",
                                 @"🚘": @":oncoming_automobile:",
                                 @"🚍": @":oncoming_bus:",
                                 @"🚔": @":oncoming_police_car:",
                                 @"🚖": @":oncoming_taxi:",
                                 @"🎭": @":performing_arts:",
                                 @"🚓": @":police_car:",
                                 @"🏣": @":post_office:",
                                 @"🚃": @":railway_car:",
                                 @"🌈": @":rainbow:",
                                 @"🚀": @":rocket:",
                                 @"🎢": @":roller_coaster:",
                                 @"🚨": @":rotating_light:",
                                 @"📍": @":round_pushpin:",
                                 @"🚣": @":rowboat:",
                                 @"🏫": @":school:",
                                 @"🚢": @":ship:",
                                 @"🎰": @":slot_machine:",
                                 @"🚤": @":speedboat:",
                                 @"🌠": @":stars:",
                                 @"🌃": @":city-night:",
                                 @"🚉": @":station:",
                                 @"🗽": @":statue_of_liberty:",
                                 @"🚂": @":steam_locomotive:",
                                 @"🌅": @":sunrise:",
                                 @"🌄": @":sunrise_over_mountains:",
                                 @"🚟": @":suspension_railway:",
                                 @"🚕": @":taxi:",
                                 @"⛺": @":tent:",
                                 @"🎫": @":ticket:",
                                 @"🗼": @":tokyo_tower:",
                                 @"🚜": @":tractor:",
                                 @"🚥": @":traffic_light:",
                                 @"🚆": @":train2:",
                                 @"🚊": @":tram:",
                                 @"🚩": @":triangular_flag_on_post:",
                                 @"🚎": @":trolleybus:",
                                 @"🚚": @":truck:",
                                 @"🚦": @":vertical_traffic_light:",
                                 @"⚠": @":warning:",
                                 @"💒": @":wedding:",
                                 @"🇯🇵": @":jp:",
                                 @"🇰🇷": @":kr:",
                                 @"🇨🇳": @":cn:",
                                 @"🇺🇸": @":us:",
                                 @"🇫🇷": @":fr:",
                                 @"🇪🇸": @":es:",
                                 @"🇮🇹": @":it:",
                                 @"🇷🇺": @":ru:",
                                 @"🇬🇧": @":gb:",
                                 @"🇩🇪": @":de:",
                                 @"💯": @":100:",
                                 @"🔢": @":1234:",
                                 @"🅰": @":a:",
                                 @"🆎": @":ab:",
                                 @"🔤": @":abc:",
                                 @"🔡": @":abcd:",
                                 @"🉑": @":accept:",
                                 @"♒": @":aquarius:",
                                 @"♈": @":aries:",
                                 @"◀": @":arrow_backward:",
                                 @"⏬": @":arrow_double_down:",
                                 @"⏫": @":arrow_double_up:",
                                 @"⬇": @":arrow_down:",
                                 @"🔽": @":arrow_down_small:",
                                 @"▶": @":arrow_forward:",
                                 @"⤵": @":arrow_heading_down:",
                                 @"⤴": @":arrow_heading_up:",
                                 @"⬅": @":arrow_left:",
                                 @"↙": @":arrow_lower_left:",
                                 @"↘": @":arrow_lower_right:",
                                 @"➡": @":arrow_right:",
                                 @"↪": @":arrow_right_hook:",
                                 @"⬆": @":arrow_up:",
                                 @"↕": @":arrow_up_down:",
                                 @"🔼": @":arrow_up_small:",
                                 @"↖": @":arrow_upper_left:",
                                 @"↗": @":arrow_upper_right:",
                                 @"🔃": @":arrows_clockwise:",
                                 @"🔄": @":arrows_counterclockwise:",
                                 @"🅱": @":b:",
                                 @"🚼": @":baby_symbol:",
                                 @"🛄": @":baggage_claim:",
                                 @"☑": @":ballot_box_with_check:",
                                 @"‼": @":bangbang:",
                                 @"⚫": @":black_circle:",
                                 @"🔲": @":black_square_button:",
                                 @"♋": @":cancer:",
                                 @"🔠": @":capital_abcd:",
                                 @"♑": @":capricorn:",
                                 @"💹": @":chart:",
                                 @"🚸": @":children_crossing:",
                                 @"🎦": @":cinema:",
                                 @"🆑": @":cl:",
                                 @"🕐": @":clock1:",
                                 @"🕙": @":clock10:",
                                 @"🕥": @":clock1030:",
                                 @"🕚": @":clock11:",
                                 @"🕦": @":clock1130:",
                                 @"🕛": @":clock12:",
                                 @"🕧": @":clock1230:",
                                 @"🕜": @":clock130:",
                                 @"🕑": @":clock2:",
                                 @"🕝": @":clock230:",
                                 @"🕒": @":clock3:",
                                 @"🕞": @":clock330:",
                                 @"🕓": @":clock4:",
                                 @"🕟": @":clock430:",
                                 @"🕔": @":clock5:",
                                 @"🕠": @":clock530:",
                                 @"🕕": @":clock6:",
                                 @"🕡": @":clock630:",
                                 @"🕖": @":clock7:",
                                 @"🕢": @":clock730:",
                                 @"🕗": @":clock8:",
                                 @"🕣": @":clock830:",
                                 @"🕘": @":clock9:",
                                 @"🕤": @":clock930:",
                                 @"㊗": @":congratulations:",
                                 @"🆒": @":cool:",
                                 @"©": @":copyright:",
                                 @"➰": @":curly_loop:",
                                 @"💱": @":currency_exchange:",
                                 @"🛃": @":customs:",
                                 @"💠": @":diamond_shape_with_a_dot_inside:",
                                 @"🚯": @":do_not_litter:",
                                 @"8⃣": @":eight:",
                                 @"✴": @":eight_pointed_black_star:",
                                 @"✳": @":eight_spoked_asterisk:",
                                 @"🔚": @":end:",
                                 @"⏩": @":fast_forward:",
                                 @"5⃣": @":five:",
                                 @"4⃣": @":four:",
                                 @"🆓": @":free:",
                                 @"♊": @":gemini:",
                                 @"#⃣": @":hash:",
                                 @"💟": @":heart_decoration:",
                                 @"✔": @":heavy_check_mark:",
                                 @"➗": @":heavy_division_sign:",
                                 @"💲": @":heavy_dollar_sign:",
                                 @"➖": @":heavy_minus_sign:",
                                 @"✖": @":heavy_multiplication_x:",
                                 @"➕": @":heavy_plus_sign:",
                                 @"🆔": @":id:",
                                 @"🉐": @":ideograph_advantage:",
                                 @"ℹ": @":information_source:",
                                 @"⁉": @":interrobang:",
                                 @"🔟": @":keycap_ten:",
                                 @"🈁": @":koko:",
                                 @"🔵": @":large_blue_circle:",
                                 @"🔷": @":large_blue_diamond:",
                                 @"🔶": @":large_orange_diamond:",
                                 @"🛅": @":left_luggage:",
                                 @"↔": @":left_right_arrow:",
                                 @"↩": @":leftwards_arrow_with_hook:",
                                 @"♌": @":leo:",
                                 @"♎": @":libra:",
                                 @"🔗": @":link:",
                                 @"Ⓜ": @":m:",
                                 @"🚹": @":mens:",
                                 @"🚇": @":metro:",
                                 @"📴": @":mobile_phone_off:",
                                 @"❎": @":negative_squared_cross_mark:",
                                 @"🆕": @":new:",
                                 @"🆖": @":ng:",
                                 @"9⃣": @":nine:",
                                 @"🚳": @":no_bicycles:",
                                 @"⛔": @":no_entry:",
                                 @"🚫": @":no_entry_sign:",
                                 @"📵": @":no_mobile_phones:",
                                 @"🚷": @":no_pedestrians:",
                                 @"🚭": @":no_smoking:",
                                 @"🚱": @":non-potable_water:",
                                 @"⭕": @":o:",
                                 @"🅾": @":o2:",
                                 @"🆗": @":ok:",
                                 @"🔛": @":on:",
                                 @"1⃣": @":one:",
                                 @"⛎": @":ophiuchus:",
                                 @"🅿": @":parking:",
                                 @"〽": @":part_alternation_mark:",
                                 @"🛂": @":passport_control:",
                                 @"♓": @":pisces:",
                                 @"🚰": @":potable_water:",
                                 @"🚮": @":put_litter_in_its_place:",
                                 @"🔘": @":radio_button:",
                                 @"♻": @":recycle:",
                                 @"🔴": @":red_circle:",
                                 @"®": @":registered:",
                                 @"🔁": @":repeat:",
                                 @"🔂": @":repeat_one:",
                                 @"🚻": @":restroom:",
                                 @"⏪": @":rewind:",
                                 @"🈂": @":sa:",
                                 @"♐": @":sagittarius:",
                                 @"♏": @":scorpius:",
                                 @"㊙": @":secret:",
                                 @"7⃣": @":seven:",
                                 @"📶": @":signal_strength:",
                                 @"6⃣": @":six:",
                                 @"🔯": @":six_pointed_star:",
                                 @"🔹": @":small_blue_diamond:",
                                 @"🔸": @":small_orange_diamond:",
                                 @"🔺": @":small_red_triangle:",
                                 @"🔻": @":small_red_triangle_down:",
                                 @"🔜": @":soon:",
                                 @"🆘": @":sos:",
                                 @"🔣": @":symbols:",
                                 @"♉": @":taurus:",
                                 @"3⃣": @":three:",
                                 @"™": @":tm:",
                                 @"🔝": @":top:",
                                 @"🔱": @":trident:",
                                 @"🔀": @":twisted_rightwards_arrows:",
                                 @"2⃣": @":two:",
                                 @"🈹": @":u5272:",
                                 @"🈴": @":u5408:",
                                 @"🈺": @":u55b6:",
                                 @"🈯": @":u6307:",
                                 @"🈷": @":u6708:",
                                 @"🈶": @":u6709:",
                                 @"🈵": @":u6e80:",
                                 @"🈚": @":u7121:",
                                 @"🈸": @":u7533:",
                                 @"🈲": @":u7981:",
                                 @"🈳": @":u7a7a:",
                                 @"🔞": @":underage:",
                                 @"🆙": @":up:",
                                 @"📳": @":vibration_mode:",
                                 @"♍": @":virgo:",
                                 @"🆚": @":vs:",
                                 @"〰": @":wavy_dash:",
                                 @"🚾": @":wc:",
                                 @"♿": @":wheelchair:",
                                 @"✅": @":white_check_mark:",
                                 @"⚪": @":white_circle:",
                                 @"💮": @":white_flower:",
                                 @"🔳": @":white_square_button:",
                                 @"🚺": @":womens:",
                                 @"❌": @":x:",
                                 @"0⃣": @":zero:"
                                 };
    
    NSMutableDictionary *reversedMap = [NSMutableDictionary dictionaryWithCapacity:[forwardMap count]];
    [forwardMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *object in obj) {
                [reversedMap setObject:key forKey:object];
            }
        } else {
            [reversedMap setObject:key forKey:obj];
        }
    }];
    
    @synchronized(self) {
        kkUnicodeToCheatCodes = forwardMap;
        kkCheatCodesToUnicode = [reversedMap copy];
    }
}

#pragma mark - Encryption
///=============================================================================
/// @name Encryption
///=============================================================================

+ (NSString *)kkMd5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/**
 *  正则表达式简单说明
 *  语法：
 .       匹配除换行符以外的任意字符
 \w      匹配字母或数字或下划线或汉字
 \s      匹配任意的空白符
 \d      匹配数字
 \b      匹配单词的开始或结束
 ^       匹配字符串的开始
 $       匹配字符串的结束
 *       重复零次或更多次
 +       重复一次或更多次
 ?       重复零次或一次
 {n}     重复n次
 {n,}     重复n次或更多次
 {n,m}     重复n到m次
 \W      匹配任意不是字母，数字，下划线，汉字的字符
 \S      匹配任意不是空白符的字符
 \D      匹配任意非数字的字符
 \B      匹配不是单词开头或结束的位置
 [^x]     匹配除了x以外的任意字符
 [^aeiou]匹配除了aeiou这几个字母以外的任意字符
 *?      重复任意次，但尽可能少重复
 +?      重复1次或更多次，但尽可能少重复
 ??      重复0次或1次，但尽可能少重复
 {n,m}?     重复n到m次，但尽可能少重复
 {n,}?     重复n次以上，但尽可能少重复
 \a      报警字符(打印它的效果是电脑嘀一声)
 \b      通常是单词分界位置，但如果在字符类里使用代表退格
 \t      制表符，Tab
 \r      回车
 \v      竖向制表符
 \f      换页符
 \n      换行符
 \e      Escape
 \0nn     ASCII代码中八进制代码为nn的字符
 \xnn     ASCII代码中十六进制代码为nn的字符
 \unnnn     Unicode代码中十六进制代码为nnnn的字符
 \cN     ASCII控制字符。比如\cC代表Ctrl+C
 \A      字符串开头(类似^，但不受处理多行选项的影响)
 \Z      字符串结尾或行尾(不受处理多行选项的影响)
 \z      字符串结尾(类似$，但不受处理多行选项的影响)
 \G      当前搜索的开头
 \p{name}     Unicode中命名为name的字符类，例如\p{IsGreek}
 (?>exp)     贪婪子表达式
 (?<x>-<y>exp)     平衡组
 (?im-nsx:exp)     在子表达式exp中改变处理选项
 (?im-nsx)       为表达式后面的部分改变处理选项
 (?(exp)yes|no)     把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no
 (?(exp)yes)     同上，只是使用空表达式作为no
 (?(name)yes|no) 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no
 (?(name)yes)     同上，只是使用空表达式作为no
 
 捕获
 (exp)               匹配exp,并捕获文本到自动命名的组里
 (?<name>exp)        匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
 (?:exp)             匹配exp,不捕获匹配的文本，也不给此分组分配组号
 零宽断言
 (?=exp)             匹配exp前面的位置
 (?<=exp)            匹配exp后面的位置
 (?!exp)             匹配后面跟的不是exp的位置
 (?<!exp)            匹配前面不是exp的位置
 注释
 (?#comment)         这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读
 
 *  表达式：\(?0\d{2}[) -]?\d{8}
 *  这个表达式可以匹配几种格式的电话号码，像(010)88886666，或022-22334455，或02912345678等。
 *  我们对它进行一些分析吧：
 *  首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，
 *  最后是8个数字(\d{8})
 */

- (float)DecimalFloat;
{
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:self];
    return [num floatValue];
}
@end
