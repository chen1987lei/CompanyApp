//
//  NSDate+HumanInterval.m
//  Buzzalot
//
//  Created by David E. Wheeler on 2/18/10.
//  Copyright 2010-2011 Lunar/Theory. All rights reserved.
//

#import "NSDate+HumanInterval.h"

#define SECOND     1
#define MINUTE (  60 * SECOND )
#define HOUR   (  60 * MINUTE )
#define DAY    (  24 * HOUR   )
#define WEEK   (   7 * DAY    )
#define MONTH  (  30 * DAY    )
#define YEAR   ( 365 * DAY    )

@implementation NSDate (HumanInterval)

- (NSString *)humanIntervalAgoSinceNow {
    int delta = [self timeIntervalSinceNow];
    delta *= -1;
    if (delta < -1 * MINUTE) {
        return [self description];
    } else if (delta < 0){
        return NSLocalizedString(@"刚刚", nil);
    } else if (delta < 1 * MINUTE) {
        return NSLocalizedString(@"刚刚", nil);
    } else if (delta < 2 * MINUTE) {
        return NSLocalizedString(@"1分钟前", nil);
    } else if (delta < 1 * HOUR) {
        return [NSString stringWithFormat:NSLocalizedString(@"%u分钟前", nil), delta / MINUTE];
    } else if (delta < 2 * HOUR) {
        return NSLocalizedString(@"1小时前", nil);
    } else if (delta < 3 * HOUR) {
        return NSLocalizedString(@"2小时前", nil);
    } else if (delta < 1 * DAY) {
        return [NSString stringWithFormat:NSLocalizedString(@"%u小时前", nil), delta / HOUR];
    } else if (delta < 2 * DAY) {
        return NSLocalizedString(@"1天前", nil);
    } else if (delta < 3 * DAY) {
        return NSLocalizedString(@"2天前", nil);
    } else if (delta < 1 * WEEK) {
        return [NSString stringWithFormat:NSLocalizedString(@"%u天前", nil), delta / DAY];
    } else if (delta < 2 * WEEK) {
        return NSLocalizedString(@"1周前", nil);
    } else if (delta < 3 * WEEK) {
        return NSLocalizedString(@"2周前", nil);
    } else if (delta < 1 * MONTH) {
        return [NSString stringWithFormat:NSLocalizedString(@"%u周前", nil), delta / WEEK];
    } else if (delta < 1 * YEAR) {
        return [NSString stringWithFormat:NSLocalizedString(@"%u个月前", nil), delta / MONTH];
    } else if (delta < 2 * YEAR) {
        return NSLocalizedString(@"1年前", nil);
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%u年前", nil), delta / YEAR];
    }
}

//剩余的时间
- (NSString *)intervalSinceNowDate:(NSString *)theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha = late-now;
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    return timeString;
}


@end


@implementation NSDate (formatTime)


+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //ex.  @"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setDateFormat:formatString];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

@end