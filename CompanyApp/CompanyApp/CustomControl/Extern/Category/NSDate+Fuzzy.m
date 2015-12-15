//
//  TimeGap.m
//  ExampleTest
//
//  Created by Tudou-Wangjun on 7/9/14.
//  Copyright (c) 2014 Tudou-Wangjun. All rights reserved.
//

#import "NSDate+Fuzzy.h"

#define ExceptionOutput @""

NSTimeInterval const kOneMinute = (60.0f);
NSTimeInterval const kFiveMinutes = (5.0f*60.0f);
NSTimeInterval const kFifteenMinutes = (15.0f*60.0f) ;
NSTimeInterval const kHalfAnHour = (30.0f*60.0f) ;
NSTimeInterval const kOneHour = 3600.0f;
NSTimeInterval const kHalfADay = (3600.0f * 12.0f);
NSTimeInterval const kOneDay = (3600.0f * 24.0f);
NSTimeInterval const kOneWeek = (3600.0f * 24.0f * 7.0f);

@implementation NSDate (Fuzzy)

- (NSString *)fuzzyStringRelativeToNow {
    NSString *fuzzyString = nil;
    
    //取得正常值必然为负数，最新内容应该是以前发生的，为了计算方便，这里转换取正数
    NSTimeInterval timeFromNow = -[self timeIntervalSinceNow];
    
    BOOL error = NO;
    //如果当前时间比较,如果时间比当前时间还要晚，作为错误现象处理
    if (timeFromNow<0.f) {
        error = YES;
    }
    
    if (error) {
        return ExceptionOutput;
    }
    
    if (timeFromNow < kOneMinute) {
        return @"刚刚";
    }

    if (timeFromNow < kOneHour)
    {
        int count = timeFromNow / kOneMinute;
        fuzzyString = [NSString stringWithFormat:@"%d分钟前", count];
        return fuzzyString;
    }

    //高级判断
    //是否是今天的数据
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* todayComponents = [gregorian components:unitFlags fromDate:today];
    todayComponents.hour = 0;
    NSDate* beginningOfToday = [gregorian dateFromComponents:todayComponents];
    
    NSTimeInterval timeSinceBeginningToday = [self timeIntervalSinceDate:beginningOfToday];
    
    //是不是今天
    if (timeSinceBeginningToday > 0) {
        int count = timeFromNow / kOneHour;
        fuzzyString = [NSString stringWithFormat:@"%d小时前", count];
        return fuzzyString;
    }
    
    //不是今天,则判断是不是昨天
    NSTimeInterval timeSinceYestedayBeginning = timeSinceBeginningToday + kOneDay;
    //是不是昨天
    if (timeSinceYestedayBeginning > 0) {
        return @"昨天";
    }
    
    //不是昨天，继续判断
    NSDateComponents* myComponents = [gregorian components:unitFlags fromDate:self];
    int monthsAgo = (int)(todayComponents.month - myComponents.month);
    int yearsAgo = (int)(todayComponents.year - myComponents.year);
    
    if (yearsAgo == 0)
    {
        if (monthsAgo == 0)
        {
            int dayAgo = (int)(todayComponents.day - myComponents.day);
            fuzzyString = [NSString stringWithFormat:@"%d天前", dayAgo, nil];
            return fuzzyString;
        }
        
        int count = monthsAgo;
        
        return [NSString stringWithFormat:@"%d个月前", count, nil];
    }

    
    if (yearsAgo == 1) {
        return @"去年";
    }
    
    if (yearsAgo > 0) {
       return [NSString stringWithFormat:@"%d年前", yearsAgo, nil];
    }
    
    return ExceptionOutput;
}

@end
