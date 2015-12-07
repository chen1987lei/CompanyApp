//
//  NSNumber+Addition.h
//  YKiPad
//
//  Created by 李 光 on 11-11-29.
//  Copyright (c) 2011年 优酷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Addition)
- (NSString *)covertToTime;

/*	
 对播放量进行格式化
 1. 以万为区分， 当小于1万时，显示到个位数，如：1987
 2. 当大于1万，小于1亿时，显示到万，并保留1位小数，并带单位万，如：1978.2万
 3. 当大于1亿时，显示小数点后一位，并带单位亿如：1.9亿 
 */
- (NSString *)beautyTotalVV;
@end
