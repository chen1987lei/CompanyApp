//
//  NSString+Addition.m
//  Youku
//
//  Created by Lee Peter on 2/1/12.
//  Copyright (c) 2012 Youku.com inc. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"
#import "NSData-AES.h"

#define AESKeychain @"094b2a34e812a4282f25c7ca1987789f"

@implementation NSString (FormatTime)
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //ex.  @"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setDateFormat:formatString];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+ (NSString *)stringTimeFormatWithSeconds:(NSInteger)seconds {
    NSString *string = nil;
    
    int hh, mm, ss;
    
    hh = (int)(seconds / 3600);
    mm = seconds % 3600 / 60;
    ss = seconds % 60;
    
    if (hh > 0) {
        string = [NSString stringWithFormat:@"%02d:%02d:%02d", hh, mm, ss];
    } else {
        string = [NSString stringWithFormat:@"%02d:%02d", mm, ss];
    }
    return string;
}

+ (NSString *)noColonstringTimeFormatWithSeconds:(NSInteger)seconds {
    NSString *string = nil;
    
    int hh, mm, ss;
    
    hh = (int)(seconds / 3600);
    mm = seconds % 3600 / 60;
    ss = seconds % 60;
    
    if (hh > 0) {
        string = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", hh, mm, ss];
    } else {
        string = [NSString stringWithFormat:@"%02d分%02d秒", mm, ss];
    }
    return string;
}

+ (NSString *)formatTotalTime:(NSString *)string
{
    NSArray *timeArray = [string componentsSeparatedByString:@":"];
    if (timeArray.count > 1) {
        if (timeArray.count == 2) {
            int mm = [timeArray[0] intValue];
            int ss = [timeArray[1] intValue];
            
            string = [NSString stringWithFormat:@"%d",mm * 60 + ss];
        }
        else if (timeArray.count == 3) {
            int hh = [timeArray[0] intValue];
            int mm = [timeArray[1] intValue];
            int ss = [timeArray[2] intValue];
            
            string = [NSString stringWithFormat:@"%d", hh * 60 * 60 + mm * 60 + ss];
        }
        else {
            string = @"0";
        }
    }
    return string;
    
}
@end

@implementation NSString (Size)


+ (NSString *)getSpacestringWithSize:(long long)size{
    
    if (size) {
        float s = size / (1024.0 * 1024.0);
        if (s > 1024) {
            return [NSString stringWithFormat:@"%.2f G", s / 1024.0];
        }
        else if (s > 0.1){
            return [NSString stringWithFormat:@"%.1f M", s];
        }
        else{
            return [NSString stringWithFormat:@"%.1f M", 0.0];
        }
    }
    return [NSString stringWithFormat:@"%.1f M", 0.0];
}

@end

@implementation NSString(Addition)
+ (NSString *)hexWithNumber:(long long int)number
{
    NSString *hexString;
    NSString *zeroString= @"";
    hexString = [NSString stringWithFormat:@"%qX", [@(number) longLongValue]];
    
    for (int i = 0; i < 8 - hexString.length; i ++) {
        zeroString = [zeroString stringByAppendingString:@"0"];
    }
    
    return [zeroString stringByAppendingString:hexString];
}
- (BOOL)isNotBlankString {
    if (self == nil || self == NULL) {
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}
- (NSString *)md5Digest {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //整型转换
    CC_MD5( cStr, (uint32_t)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5Digest16 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (uint32_t)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7]];    
}

- (NSString*)escape {
	NSString *s = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)self,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8));
	return s; // Due to the 'create rule' we own the above and must autorelease it
}

- (NSString*)unescape
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));

	return result;
}

- (NSString *)toQueryString:(NSDictionary *)params {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:self];
	// Convert the params into a query string
	if (params) {
		for(id key in params) {
			NSString *sKey = [key description];
			NSString *sVal = [[params objectForKey:key] description];
			// Do we need to add ?k=v or &k=v ?
			if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
				[urlWithQuerystring appendFormat:@"?%@=%@", [sKey escape], [sVal escape]];
			} else {
				[urlWithQuerystring appendFormat:@"&%@=%@", [sKey escape], [sVal escape]];
			}
		}
	}
	return urlWithQuerystring;
}

// " this is a test \r\n" => "this is a test"
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//你好 => 2 * 2
//hello => 5
- (NSInteger )count {
    //你好 => 2 * 2
    //hello => 5
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

- (NSString *)replaceNewLineWithBlank {
    return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
}

- (NSString *)replaceQuoteWithBlank {
    return [self stringByReplacingOccurrencesOfString:@"\"" withString:@""];    
}

- (NSString *)replaceSingleQuoteWithBlank {
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@" "];
}
- (NSString *)longLongSizeToString {
    long long size = [self longLongValue];
    float s = size / (1024.0 * 1024.0);
    if (s > 1024) {
        return [NSString stringWithFormat:@"%.2fG", s / 1024.0];
    }else {
        return [NSString stringWithFormat:@"%.1fM", s];
    }
}

//- (BOOL)isVideoID {
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(X|id_)?(\\w+)$" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *match = [regex firstMatchInString:self
//                                                    options:0
//                                                      range:NSMakeRange(0, [self length])];
//    if ([match numberOfRanges] == 3) {
//        NSRange range = [match rangeAtIndex:2];
//        NSData *data = [Base64 decode:[self substringWithRange:range]];
//        NSInteger value = [[[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease] integerValue] >> 2;
//        return value > 0;        
//    }
//    return false;
//}

- (BOOL)isContainSpace{
    NSRange _range = [self rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isNumber {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)isCnAndEn{
    if (!self || self.length==0) {
        return NO;
    }
    BOOL isLegal = NO;
    NSUInteger len = [self length];
    for (int i = 0; i<len; i++) {
        char strChar = [self characterAtIndex:i];
        NSString *strTemp = [self substringWithRange:NSMakeRange(i,1)];
        if (strTemp==nil) {
            isLegal = NO;
            break;
        }
        if((strChar>64)&&(strChar<91)){
            isLegal = YES;
        }else if((strChar>96)&&(strChar<123)){
            isLegal = YES;
        }else if((strChar>47)&&(strChar<58)){
            isLegal = YES;
        }else{
            int a = [self characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
                isLegal = YES;
            }else{
                isLegal = NO;
                break;
            }
        }
    }
    return isLegal;
}

- (BOOL)isContainsEmoji {
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

- (NSString *)filterEmoji{
    
    NSMutableString *resStr = [[NSMutableString alloc] initWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        BOOL isEomji = NO;
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
        if (!isEomji) {
            [resStr appendString:substring];
        }
    }];

    return resStr;
}

@end

@implementation NSString (RegexExpression)
- (BOOL)isMatchedByRegex:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    return !!match;
}

- (NSString *)stringByMatching:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    if ([match numberOfRanges] > 0) {
        NSRange range = [match rangeAtIndex:0];
        if (range.location != NSNotFound) {
            return [self substringWithRange:range];
        }
    }
    return nil;
}

- (NSString *)stringByReplacingOccurrencesOfRegex:(NSString *)pattern withString:(NSString *)withString {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:withString];
}
@end

@implementation NSString (AES)
- (NSString *)stringWithAESEncodeAndFillSpaceCount:(NSInteger)count{
    NSString *str = self; // It does not work with UTF8 like @"こんにちは世界"
	int i = (int)MIN(32, count);
    for (int j = 0; j < i; j++) {
        str = [str stringByAppendingString:@" "];
    }
    return [str stringWithAESEncode];
}
- (NSString *)stringWithAESDecodeAndFillSpaceCount:(NSInteger)count{
    NSString *str = [self stringWithAESDecode]; // It does not work with UTF8 like @"こんにちは世界"
	int i = (int)MIN(32, count);
    str = [str substringToIndex:(32 - i)];
    return str;
}

- (NSString *)stringWithAESEncode
{
    NSString *keychain = AESKeychain;
    
    
	NSString *str = self; // It does not work with UTF8 like @"こんにちは世界"
	
	// 1) Encrypt
	//NSLog(@"encrypting string = %@",str);
	
	NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
	NSData *encryptedData = [data AESEncryptWithPassphrase:keychain];
	
	// 2) Encode Base 64
	// If you need to send over internet, encode NSData -> Base64 encoded string
	[Base64 initialize];
	NSString *b64EncStr = [Base64 encode:encryptedData];
	
	//NSLog(@"Base 64 encoded = %@",b64EncStr);
    return b64EncStr;
}

- (NSString *)stringWithAESDecode
{
    // 3) Decode Base 64
	// Then you can put that back like this
	NSData	*b64DecData = [Base64 decode:self];
	
	
	// 4) Decrypt
	// This should be same before encode -> decode base 64
	//NSData *decryptedData = [encryptedData AESDecryptWithPassphrase:password];
	NSData *decryptedData = [b64DecData AESDecryptWithPassphrase:AESKeychain];
	
	NSString* decryptedStr = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
	
	//NSLog(@"decrypted string = %@",decryptedStr);
    return decryptedStr;
}

- (NSString *)stringWithAESEncodeByVideo:(NSString *)keychain{
    [Base64 initialize];
    NSData *dataKey=[Base64 decode:keychain];
    NSString *strKey=[[NSString alloc]initWithData:dataKey encoding:NSUTF8StringEncoding];
	NSString *str = self;
	NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
    NSData *dataNew=encryptData(data, strKey);
	//NSData *encryptedData = [data AESEncryptWithPassphrase:strKey];
	NSString *b64EncStr = [Base64 encode:dataNew];
    CFStringRef stringref = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)b64EncStr,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    
    NSString *strEncoding = [NSString stringWithFormat:@"%@",stringref];
    CFRelease(stringref);
    return strEncoding;
}

- (NSString *)encryptStringWithKey:(NSString *)strKey{

    NSData *dataval = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataNew= encryptData(dataval, strKey);
    NSString *b64EncStr = [Base64 encode:dataNew];
    CFStringRef stringref = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (CFStringRef)b64EncStr,
                                                                    NULL,
                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                    kCFStringEncodingUTF8);
    
    NSString *strEncoding = [NSString stringWithFormat:@"%@",stringref];
    CFRelease(stringref);
    return strEncoding;
}


NSData *encryptData(NSData *data, NSString *key)
{
    char ckey[kCCKeySizeAES128];
    
    [key getBytes:ckey
        maxLength:kCCKeySizeAES128
       usedLength:nil
         encoding:NSASCIIStringEncoding
          options:0
            range:NSMakeRange(0, key.length)
   remainingRange:nil];
    
    NSUInteger bufferLength = (data.length + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    NSMutableData *odata = [NSMutableData dataWithCapacity:bufferLength];
    
    [odata appendData:data];
    
    for (NSUInteger len = bufferLength - data.length; len > 0; len--) {
        [odata appendBytes:" " length:1];
    }
    
    NSMutableData *mdata = [NSMutableData dataWithCapacity:bufferLength];
    
    [mdata setLength:bufferLength];
    
    void *buffer = mdata.mutableBytes;
    
    CCCryptorStatus status =
    CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionECBMode, ckey, kCCKeySizeAES128, NULL, odata.mutableBytes, odata.length, buffer, bufferLength, NULL);
    
    if (status == kCCSuccess) {
        return mdata;
    }
    
    return nil;
}

- (NSString *)stringWithAESDecodeByVideo:(NSString *)keychain{
    [Base64 initialize];
    NSData *dataKey=[Base64 decode:keychain];
    NSString *strKey=[[NSString alloc]initWithData:dataKey encoding:NSUTF8StringEncoding];
    NSString *tmpstr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSData	*dataOld64 = [Base64 decode:tmpstr];
    NSData *dataNew = [dataOld64 AESDecryptWithPassphrase:strKey];
    NSString *strNew=[[NSString alloc]initWithData:dataNew encoding:NSUTF8StringEncoding];
    return strNew;
}

-(NSString *)stringEncodeByUTF8{
  CFStringRef stringref =  CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)self,
                                                                                NULL,
                                                                                CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                kCFStringEncodingUTF8);
    
    NSString *strEncoding = [NSString stringWithFormat:@"%@",stringref];
    CFRelease(stringref);
    return strEncoding;
}
@end
@implementation NSString (URLHandler)
static NSString * ASIPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~',";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}
- (NSString *)stringByAppendingParams:(NSDictionary *)dict
{
    NSMutableString * mulStr = [NSMutableString stringWithString:self];
    if([self rangeOfString:@"?"].location != NSNotFound)
        [mulStr appendString:@"&"];
    else
        [mulStr appendString:@"?"];
    NSArray * keys = [dict allKeys];
    for(NSString * key in keys)
    {
        NSString * value = [dict valueForKey:key];
        [mulStr appendFormat:@"%@=%@",key, ASIPercentEscapedQueryStringPairMemberFromStringWithEncoding([value description], NSUTF8StringEncoding)];
        int index = (int)[keys indexOfObject:key];
        if(index+1 != keys.count)
        {
            [mulStr appendString:@"&"];
        }
    }
    return [NSString stringWithString:mulStr];
}

- (NSDictionary *) transQueryToDictionary{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSArray * array = [self componentsSeparatedByString:@"?"];
    if ([array count]>=2) {
        NSArray * arrayNew = [array[1] componentsSeparatedByString:@"&"];
        for (NSString * obj in arrayNew)
        {
            NSArray * subArray = [obj componentsSeparatedByString:@"="];
            if ([subArray count]>=2) {
                NSString * key =@"";
                NSString * value =@"";
                for (int i=0; i<[subArray count]; i++) {
                    if (i==0) {
                        key= [subArray objectAtIndex:0];
                    }
                    else{
                        if (i>=2) {
                            value=[value stringByAppendingString:@"="];
                        }
                        value=[value stringByAppendingString:[subArray objectAtIndex:i]];                        
                    }
                }
                [dict setValue:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end

@implementation NSString (FileIO)

- (BOOL)writeToEndOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [self writeToFile:path atomically:YES encoding:enc error:error];
    }
    else
    {
        NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:path];
        [file seekToEndOfFile];
        NSString * blank = @"\r\n";
        [file writeData:[blank dataUsingEncoding:enc]];
        [file writeData:[self dataUsingEncoding:enc]];
    }
    return YES;
}


@end

BOOL IsStringWithAnyText(id object) {
	return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}

@implementation NSString (DateFormat)
-(NSDate *)getDateWithFormat:(NSString *)format{
    NSDateFormatter *date_formater=[[NSDateFormatter alloc] init] ;
    [date_formater setDateFormat:format];
    return [date_formater dateFromString:self];
}

@end

@implementation NSString(HexConversion)

-(NSString *)decimalTOBinary:(NSString *)decimal
{
    if (!decimal || [decimal floatValue] > 65534) {
        return nil;
    }
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    NSString * prepare = @"";
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}


@end

