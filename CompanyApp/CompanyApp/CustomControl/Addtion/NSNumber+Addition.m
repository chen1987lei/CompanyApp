//
//  NSNumber+Addition.m
//  YKiPad
//
//  Created by 李 光 on 11-11-29.
//  Copyright (c) 2011年 优酷. All rights reserved.
//

#import "NSNumber+Addition.h"

@implementation NSNumber (Addition)
- (NSString *)covertToTime {
    int ticks = [self intValue];
    int hours = ticks / 3600;
    int mins = ticks / 60 % 60;
    int seconds = ticks % 60;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
    }
}

/*	
 1. 以万为区分， 当小于1万时，显示到个位数，如：1987
 2. 当大于1万，小于1亿时，显示到万，并保留1位小数，并带单位万，如：1978.2万
 3. 当大于1亿时，显示小数点后一位，并带单位亿如：1.9亿 
 */
- (NSString *)beautyTotalVV {
    double w = 10000, y = 100000000;
    long long count = [self longLongValue];
    if (count < w) {
        return [self stringValue];
    }else if(count >= w && count < y ){
        return [NSString stringWithFormat:@"%.1f万", count / w];
    }else {
        return [NSString stringWithFormat:@"%.1f亿", count / y];  
    }
}
@end
