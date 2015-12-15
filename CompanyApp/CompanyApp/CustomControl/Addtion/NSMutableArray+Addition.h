//
//  NSMutableArray+Addition.h
//  Tudou
//
//  Created by 李 福庆 on 13-4-18.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Addition)
- (void)shuffle;
- (void)reverseArray;
#pragma mark - 实现下标修改
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx;
@end
