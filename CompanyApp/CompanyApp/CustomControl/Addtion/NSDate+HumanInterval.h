//
//  NSDate+HumanInterval.h
//  Buzzalot
//
//  Created by David E. Wheeler on 2/18/10.
//  Copyright 2010-2011 Lunar/Theory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (HumanInterval)
- (NSString *)humanIntervalAgoSinceNow;
- (NSString *)intervalSinceNowDate:(NSString *)theDate;//剩余的时间
@end

@interface NSDate (formatTime)
+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString;
@end