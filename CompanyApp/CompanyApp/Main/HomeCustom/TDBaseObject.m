 //
//  TDBaseObject.m
//  Tudou
//
//  Created by Li Chao on 13-3-8.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDBaseObject.h"

@implementation TDBaseObject
- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _attributes = [dict copy];
        [self parseWithDictionary:dict];
    }
    return self;
}

-(void)parseWithDictionary:(NSDictionary *)dict{
    //subclass
}
-(NSString *)numberToString:(id)num{
    if ([num isKindOfClass:[NSNumber class]]) {
        return [num stringValue];
    }
    else if ([num isKindOfClass:[NSString class]]) {
        return num;
    }
    else{
        return @"";
    }
}
@end
