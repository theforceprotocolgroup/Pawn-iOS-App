//
//  NSString+KKCategory.h
//  KKPrivateLib
//
//  Created by 张可 on 2018/12/12.
//  Copyright © 2018年 keke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Format(A, ...) [NSString stringWithFormat:A, __VA_ARGS__]

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KKCategory)

#pragma mark - The specified format String to Attribute String
///=============================================================================
/// @name The specified format String to Attribute String
///=============================================================================

- (CGFloat (^)(CGFloat width, UIFont *font))kkHeight;

- (CGFloat (^)(UIFont *font))kkWidth;

#pragma mark - Pinyin
///=============================================================================
/// @name Pinyin
///=============================================================================

/**
 Return spelling string of chinese characters
 e.g. 字符串 ==> zi fu chuan ;   888 ==> 888;   89汉字 ==> 89han zi
 */
- (NSString *)kkPinYin;

/**
 Return spelling string with phoneticSymbol of chinese characters.
 e.g. 字符串 ==> zì fú chuàn
 */
- (NSString *)kkTonePinyin;

/**
 Return spelling string with phoneticSymbol of chinese characters.
 e.g. 字符串 ==> @[@"zi", @"fu", @"chuan"];
 */
- (NSArray *)kkArrayPinyin;

/**
 Return spelling string with phoneticSymbol of chinese characters.
 e.g. 字符串 ==> @[@"z", @"f", @"c"]
 */
- (NSArray *)kkInitialArrayPinyin;

#pragma mark - Regular Expression
///=============================================================================
/// @name Regular Expression
///=============================================================================

/**
 Whether it can match the regular expression
 
 @param regex  The regular expression
 @param options     The matching options to report.
 @return YES if can match the regex; otherwise, NO.
 */
- (BOOL)kkMatchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

/**
 Match the regular expression, and executes a given block using each object in the matches.
 
 @param regex    The regular expression
 @param options  The matching options to report.
 @param block    The block to apply to elements in the array of matches.
 The block takes four arguments:
 match: The match substring.
 matchRange: The matching options.
 stop: A reference to a Boolean value. The block can set the value
 to YES to stop further processing of the array. The stop
 argument is an out-only argument. You should only ever set
 this Boolean to YES within the Block.
 */
- (void)kkEnumerateRegexMatches:(NSString *)regex
                        options:(NSRegularExpressionOptions)options
                     usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;

/**
 Returns a new string containing matching regular expressions replaced with the template string.
 
 @param regex       The regular expression
 @param options     The matching options to report.
 @param replacement The substitution template used when replacing matching instances.
 
 @return A string with matching regular expressions replaced by the template string.
 */
- (NSString *)kkStringByReplacingRegex:(NSString *)regex
                               options:(NSRegularExpressionOptions)options
                            withString:(NSString *)replacement;


// TODO: Validation Common String with regex, e.g. email、IDCard

/**
 Validate URL regex: @"(http[s]{0,1}|ftp)://.*?/"
 */


#pragma mark - Utilities
///=============================================================================
/// @name Utilities - Unique String
///=============================================================================

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)kkStringWithUUID;

/**
 Returns a new ProgressInfo globallyUniqueString
 e.g. ""
 */
+ (NSString *)kkStringUniqueString;

/*! 时间戳
 */
+ (NSString *)kkTimestamp;

/**
 Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 
 @param name The file name (in main bundle).
 @return A new string create from the file in UTF-8 character encoding.
 */
+ (NSString *)kkStringName:(NSString *)name;

///=============================================================================
/// @name Utilities - Modification
///=============================================================================

/**
 Trim blank characters (space) in line.
 @return the trimmed string.
 */
- (NSString *)kkStringByTrim;

/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)kkStringByWhitespaceAndNewline;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)kkRangeOfAll;


///=============================================================================
/// @name Utilities - Attribute
///=============================================================================

/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 */
- (BOOL)kkIsNotBlank;

/**
 All characters are number will Returns Yes; otherwise Returns NO.
 */
- (BOOL)kkIsPureInt;

/**
 String contain chinese character will Returns NO; otherwise Returns YES.
 */
- (BOOL)kkIsContainChinese;

/**
 Returns YES if the target string is contained within the receiver.
 @param string A string to test the the receiver.
 
 @discussion Apple has implemented this method in iOS8  containsString:.
 */
- (BOOL)kkContainsString:(NSString *)string;


/**
 This compares the raw backing string against a vanilla NSString, ignoring any attributes.
 @param aString   A string or attributeString or  who respondsToSelector @selector(string)
 */
- (BOOL)kkIsEqualToString:(id)aString;

/** Returns `YES` if a string is a valid email address, otherwise `NO`.
 @return True if the string is formatted properly as an email address.
 */
@property (nonatomic, getter=isEmail, readonly) BOOL kkEmail;


///=============================================================================
/// @name Utilities - Transform
///=============================================================================

/**
 Try to parse this string and returns an `NSNumber`.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (NSNumber *)kkNumberValue;

/**
 Returns an NSDictionary/NSArray which is decoded from receiver.
 Returns nil if an error occurs.
 
 e.g. NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count":@2]
 */
- (id)kkJsonValueDecoded;


/**
 @brief  url query to NSDictionary
 @return NSDictionary
 */
- (NSDictionary *)kkDictionaryByUrl;

/**
 Returns an NSURL from receiver.
 Returns nil if an error occurs.
 */
- (NSURL *)kkUrl;

/** Returns a `NSString` that is URL friendly.
 @return A URL encoded string.
 */
@property (nonatomic, readonly, copy) NSString *kkURLEncode;

/** Returns an MD5 string of from the given `NSString`.
 @return A MD5 string.
 */
@property (nonatomic, readonly, copy) NSString *kkMd5;

/** Returns the length of the string minus the whitespace characters.
 @return Returns the length of the string minus the whitespace characters.
 */
@property (nonatomic, readonly) NSUInteger kkLengthWithoutWhitespace;


/**
 Returns an NSRegularExpression from receiver.
 Returns nil if an error occurs.
 */
- (NSRegularExpression *)kkRegex;


#pragma mark - Function

///=============================================================================
/// @name Function
///=============================================================================

- (NSArray *)kkSplit:(id)obj;
- (NSArray *(^)(id obj))split;

#pragma mark - Emoji
///=============================================================================
/// @name Emoji
///=============================================================================

/**
 Whether the receiver contains Apple Emoji (displayed in current version of iOS).
 */
- (BOOL)kkContainsEmoji;

/** @see containsEmoji */
- (BOOL)kkContainsEmojiForSystemVersion:(float)systemVersion;

/**
 Returns a NSString in which any occurrences that match the cheat codes
 from Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com> are replaced by the
 corresponding unicode characters.
 
 e.g.  "smiley face :smiley:" ==> "smiley face \U0001F604"
 */
- (NSString *)kkTransEmojiToUnicode;

/**
 Returns a NSString in which any occurrences that match the unicode characters
 of the emoji emoticons are replaced by the corresponding cheat codes from
 Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com>.
 
 e.g.  "smiley face \U0001F604" ==> "smiley face :smiley:"
 */
- (NSString *)kkTransUnicodeToEmoji;

// TODO: remove Emoji


#pragma mark - Encryption
///=============================================================================
/// @name Encryption
///=============================================================================

+ (NSString *)kkMd5:(NSString *)string;

- (float)DecimalFloat;
@end

NS_ASSUME_NONNULL_END
