//
//  NSArray+Addition.h
//  YKiPad
//
//  Created by flexih on 1/9/12.
//  Copyright (c) 2012 优酷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Addition)

- (id)firstObject;
- (id)randomObject;
- (NSArray *)reverse;
- (BOOL)hasIndex:(NSInteger)index;
- (id)objectAtSafeIndex:(NSUInteger)index;

@end

