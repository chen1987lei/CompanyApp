//
//  NSMutableArray+Addition.m
//  Tudou
//
//  Created by 李 福庆 on 13-4-18.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "NSMutableArray+Addition.h"

@implementation NSMutableArray (Addition)

- (void)shuffle {
    int count = (int)[self count];
    for (int i = 0; i < count; ++i)
    {
        int n = (arc4random() % (count - i)) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx
{
    [self insertObject:object atIndex:idx];
}
- (void)reverseArray
{
    if (self.count == 0) {
        return ;
    }
    
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
		
        i++;
        j--;
    }
}
@end
