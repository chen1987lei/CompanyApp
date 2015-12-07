//
//  NSData+Addition.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "NSData+Addition.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSData (Hash)

- (NSString*)md5Hash {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    //整型转换
    //将原有的 CC_MD5([self bytes], [self length], result);
	CC_MD5([self bytes], (uint32_t)[self length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

@end
