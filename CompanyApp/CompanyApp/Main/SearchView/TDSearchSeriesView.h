//
//  TDSearchSeriesView.h
//  Tudou
//
//  Created by zhangjiwang on 13-12-17.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

/*!
 @class
 @abstract 搜索的选集列表
 */

@protocol TdSearchGridViewDelegate <NSObject>

@optional
- (void)didClickSearchGridView:(id)record;

@end

typedef NS_ENUM(NSInteger, SearchSeriesType) {
    ksearchSeriesList,
    ksearchSeriesCover
};

@interface TDSearchSeriesView : GMGridView

@property (nonatomic,strong) NSMutableArray *searchDataSource;
@property (nonatomic, assign) BOOL is_tudou;
@property (nonatomic, assign) SearchSeriesType seriesType;
@property (nonatomic, weak) id<TdSearchGridViewDelegate> gridViewDelegate;

@end
