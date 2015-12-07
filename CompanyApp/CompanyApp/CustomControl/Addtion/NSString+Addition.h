//
//  NSString+Addition.h
//  Youku
//
//  Created by Lee Peter on 2/1/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>


BOOL IsStringWithAnyText(id object);

@interface NSString (FormatTime)
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString;//@"yyyy-MM-dd HH:mm:ss"等转化成date
+ (NSString *)stringTimeFormatWithSeconds:(NSInteger)seconds;//将seconds格式化成HH:MM:SS或者MM:SS
+ (NSString *)formatTotalTime:(NSString *)string;//将诸如 时长 51:02这样包含:的时间格式转换成时间
+ (NSString *)noColonstringTimeFormatWithSeconds:(NSInteger)seconds;//将seconds格式转化成HH小时MM分SS秒
@end

@interface NSString (Size)
+ (NSString *)getSpacestringWithSize:(long long)size;
@end

@interface NSString (Addition)
+ (NSString *)hexWithNumber:(long long int)number;
- (BOOL)isNotBlankString;
- (NSString *)md5Digest;
- (NSString *)md5Digest16;
- (NSString *)escape;
- (NSString *)unescape;
- (NSString *)trim;
- (NSInteger )count;
- (NSString *)replaceNewLineWithBlank;
- (NSString *)replaceQuoteWithBlank;
- (NSString *)replaceSingleQuoteWithBlank;
- (NSString *)toQueryString:(NSDictionary *)params;
- (NSString *)longLongSizeToString;
- (BOOL)isVideoID;
- (BOOL)isContainSpace;//是否包含空格
- (BOOL)isNumber;
- (BOOL)isCnAndEn;//中英文字符判断
- (BOOL)isContainsEmoji;//是否包含表情字符
- (NSString *)filterEmoji;//过滤掉表情字符
@end

@interface NSString (RegexExpression)
- (BOOL)isMatchedByRegex:(NSString *)regex;
- (NSString *)stringByMatching:(NSString *)regex;
- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)regex withString:(NSString *)withString;
@end

@interface NSString (AES)
- (NSString *)stringWithAESEncodeAndFillSpaceCount:(NSInteger)count;//这里做了处理 不足32倍数的末尾补空格。但是解码的时候没有做完全还原处理
- (NSString *)stringWithAESDecodeAndFillSpaceCount:(NSInteger)count;//解码返回的是32的倍数 不足的末尾补了空格。

- (NSString *)stringWithAESEncode;//这里做了处理 不足32倍数的末尾补空格。但是解码的时候没有做完全还原处理
- (NSString *)stringWithAESDecode;//解码返回的是32的倍数 不足的末尾补了空格。
/**
 *  视频防盗链加密处理
 *
 *  @param keychain 密钥
 *
 *  @return 加密后的字符
 */
- (NSString *)stringWithAESEncodeByVideo:(NSString *)keychain;
/**
 *  视频防盗链解密处理，针对播放接口加密进行解密
 *
 *  @param keychain 密钥
 *
 *  @return 解密后的字符
 */
- (NSString *)stringWithAESDecodeByVideo:(NSString *)keychain;

- (NSString *)encryptStringWithKey:(NSString *)strKey;
/**
 *  字符转码
 *
 *  @return 返回转码后的字符
 */
-(NSString *)stringEncodeByUTF8;
@end

@interface NSString (URLHandler)
- (NSString *)stringByAppendingParams:(NSDictionary *)dict;
/**
 *  解析url地址的参数
 *
 *  @return 解析后的参数
 */
- (NSDictionary *) transQueryToDictionary;

@end

@interface NSString (FileIO)
//会加一行空白
- (BOOL)writeToEndOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;


@end

@interface NSString (DateFormat)
-(NSDate *)getDateWithFormat:(NSString *)format;
@end

@interface NSString (HexConversion)
/**
 * 十进制转化为二进制
 * 输出 string类型
 */
-(NSString *)decimalTOBinary:(NSString *)decimal;
@end