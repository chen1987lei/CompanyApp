//
//  NSDictionary+Addition.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-21.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "NSDictionary+Addition.h"

@implementation NSDictionary (Addtion)

-(id)objectSafeForKey:(id)aKey
{
    if (self.count > 0 && [[self allKeys] containsObject:aKey]) {
        return [self objectForKey:aKey];
    }
    else {
        return nil;
    }
}

@end
