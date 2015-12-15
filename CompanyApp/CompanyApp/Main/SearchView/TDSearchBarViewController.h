//  搜索输入框页面控制器
//  TDSearchBarViewController.h
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDSearchBar.h"
#import "TDCustomSeg.h"
#import "TDSearchSegmentView.h"
#import "TDSearchTypeDropListView.h"
#import "TDViewController.h"
/*!
 @class
 @abstract 搜索框除了框，搜索联想词逻辑也在其中
 */
#define KSearchBarTextDidBeginEditingNotification   @"SearchBarTextDidBeginEditingNotification"
#define KSearchBarTextDidEndEditingNotification     @"SearchBarTextDidEndEditingNotification"
#define KSearchBarHiddenMaskViewNotification        @"SearchBarHiddenMaskViewNotification"

#define KSearchTypeChangeNotification               @"SearchTypeChangeNotification"
#define kkeyboardDefaultHeight 216

@protocol TDSearchBarViewControllerDelegate;
@interface TDSearchBarViewController : TDViewController<UITableViewDataSource,UITableViewDelegate,TDSearchBarDelegate>
{
    UITableView * _table;
    CGRect _rect;
    NSString * _searchText;
}
@property (nonatomic,assign   ) id<TDSearchBarViewControllerDelegate> delegate;
@property (nonatomic,readonly ) TDSearchBar                   * searchBar;
@property (nonatomic,readonly ) UITableView                   * table;//默认table是加载该视图上，pad版是单独加在外部
@property (nonatomic,readwrite) NSString                      * text;
@property (nonatomic,copy) NSString                           * defaultSearchWord;
- (id)initWithFrame:(CGRect)frame;

- (void)dismissTable;

/**
 *  设置搜索类型
 *
 *  @param searchType
 */
- (void)setSearchType:(SearchType)searchType;
 
@end



@protocol TDSearchBarViewControllerDelegate<NSObject>
@optional
- (void)comeBackFrom:(TDSearchBarViewController*)sender;
- (void)searchBarCancelButtonClicked:(TDSearchBarViewController *) searchBarVc;
/**
 * 若有albumId，则代表直接命中直达区，点击直接播放
 */
- (void)searchString:(NSString *)keyword
          searchType:(SearchType)searchType
             albumId:(NSString*)albumId;
/**
 *  搜索类型切换
 *
 *  @param sender
 */
- (void)searchTypeButtonClick:(TDSearchBarViewController*)sender;

@end