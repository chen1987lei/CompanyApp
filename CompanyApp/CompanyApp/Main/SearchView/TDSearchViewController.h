//  搜索页面的容器类
//  TDSearchViewController.h
//  Tudou
//
//  Created by zhang jiangshan on 12-12-5.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDViewController.h"
#import "TDSearchTypeDropListView.h"
#import "TDSearchBarViewController.h"
#import "TDSearchHomeViewController.h"
/*!
 @class
 @abstract 搜索页phone版
 */
#define KHideResultsControllerNotif         @"hideResultsControllerNotif"

@interface TDSearchViewController : TDViewController<TDSearchBarViewControllerDelegate,
                                                    SearchHomeViewControllerDelegate,
                                                    TDTDSearchTypeDropListViewDelegate,
                                                    UIGestureRecognizerDelegate>
@property(nonatomic,copy)NSString* defaultSearchWord;//搜索框默认字

@end
