//  搜索视频结果页
//  TDSearchVideoResultViewController.h
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDViewController.h"
#import "TDSearchBarViewController.h"
#import "TDSearchViewController.h"

#import "TDSearchAlbumVideoCell.h"

//#import "TDSearchAlbumPersonCell.h"
#define filterScrollViewHeight 46.0

typedef NS_ENUM(NSInteger, DriectType) {
    Driect_None,                //非直达区
    Driect_Album,               //一般直达区
    Driect_AlbumPerson,         //人物直达区
    Driect_Channel,             //自频道直达区
    
};
@protocol TDSearchVideoResultViewControllerDelegate<NSObject>

- (void)userClickCorrectPopView:(NSString*)correctStr;

@end

/*!
 @class
 @abstract 搜索结果页phone
 */
@interface TDSearchVideoResultViewController : TDViewController<TDSearchBarViewControllerDelegate,
                                                                UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UIGestureRecognizerDelegate,
                                                                TDSearchAlbumVideoCellDelegate>
/**
 *  搜索结果页的 关键字 开放出来
 */
@property(nonatomic,copy) NSString * keyword;

/**
 *  触发搜索
 *
 *  @param string
 */
- (void)searchString:(NSString *)string;
 
/**
 *  更改tableView.scrollToTop属性
 *
 *  @param isToTop
 */
- (void)setTableViewScrollToTop:(BOOL)isToTop;

//fix bug 18015
- (void)stopPullRefreshAnimaiton;

@property (nonatomic,weak) id<TDSearchVideoResultViewControllerDelegate> delegate;

@end


