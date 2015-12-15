//
//  TDBaseObject.h
//  Tudou
//
//  Created by Li Chao on 13-3-8.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDBaseObject : NSObject
@property (nonatomic, strong) id attributes;//子类里面实现
- (id)initWithDictionary:(NSDictionary *)dict;
-(void)parseWithDictionary:(NSDictionary *)dict;//rewrite in subclass
/**
 *  数字类型转换成字符类型，主要用于防止接口传递类型不匹配导致的crush
 *
 *  @param num 数字类型
 *
 *  @return 字符类型
 */
-(NSString *)numberToString:(id)num;
@end
