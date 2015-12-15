//
//  TDSearchSeriesPannel.h
//  Tudou
//
//  Created by zhangjiwang on 13-12-17.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class TDSearchAlbum;
@class TDSearchSeriesPannel;

@protocol TdSearchPannelDelegate <NSObject>

@optional

- (void)onbackClick:(TDSearchSeriesPannel *)pannel;
- (void)onSeriesSegmentClick:(NSNumber *)index Offset:(NSNumber *)offset;
- (void)onSeriesItemClick:(id)item;

@end
/*!
 @class
 @abstract 搜索的剧集控件，包括剧集列表和选集title
 */
@interface TDSearchSeriesPannel : UIView

@property (nonatomic,weak) id <TdSearchPannelDelegate> delegate;

- (void)setSeriesInfo:(TDSearchAlbum *)info;

- (void)refreshData:(NSInteger)page;

@end
