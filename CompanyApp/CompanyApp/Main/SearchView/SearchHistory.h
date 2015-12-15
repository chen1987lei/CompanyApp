//
//  SearchHistory.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-6.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SearchHistoryDidChangeNotification;

/*!
 @class
 @abstract 基于coredata的搜索播放记录的简单封装 modal类
*/
@interface SearchHistory : NSObject

@property (nonatomic, copy) NSString * title;
/**
 * 是频道还是普通搜索 普通搜索 0 频道 1
 */
@property (nonatomic, copy) NSNumber* typeSearch;

+ (void)getSearchHistory:(void (^)(NSArray *array, BOOL success))success;

+ (NSArray *)getRecords;

+ (void)addHistory:(NSString *)text type:(NSInteger)typeSearch;

+ (void)deleteRecord:(SearchHistory *)object;


+ (void)clearAllRecords;
@end
