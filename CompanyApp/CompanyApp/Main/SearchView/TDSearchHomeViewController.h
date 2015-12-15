//  搜索首页
//  TDSearchHomeViewController.h
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDViewController.h"
#import "TDSearchTypeDropListView.h"
#import "TDSearchBarViewController.h"

@protocol SearchHomeViewControllerDelegate<NSObject>
- (void)didclickKeyword:(NSString *)keyword searchType:(SearchType)searchType;

- (void)resignKeyboard;

- (void)showKeyboard;

//- (void)searchHomeRefreshNetworkDataFailed;
//- (void)searchHomeRefreshDataTaped;
@end

/*!
 @class
 @abstract 搜索热词 + 搜索历史
 */
@interface TDSearchHomeViewController : TDViewController

@property(nonatomic, weak) id <SearchHomeViewControllerDelegate> delegate;

/**
 *  置顶
 */
- (void)setTableViewContentOffSetZero;
@end