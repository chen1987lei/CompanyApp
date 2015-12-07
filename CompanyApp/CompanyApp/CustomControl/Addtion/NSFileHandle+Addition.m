//
//  NSFileHandle+Addition.m
//  iphone
//
//  Created by liguang on 8/1/11.
//  Copyright 2011 优酷. All rights reserved.
//

#import "NSFileHandle+Addition.h"
#import <commoncrypto/CommonDigest.h>


@implementation NSFileHandle(Addition)
+ (NSString *)md5:(NSString *)path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(!handle) {
        return @"";        
    }
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    NSData* filedata;
    NSInteger length;
    do {
        @autoreleasepool {
            filedata = [handle readDataOfLength:1024];
            length = [filedata length];
            //整型转换
            CC_MD5_Update(&md5_ctx, [filedata bytes], (uint32_t)[filedata length]);
            
        }
        
    }
    while(length);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];   
    return [[NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}
@end
