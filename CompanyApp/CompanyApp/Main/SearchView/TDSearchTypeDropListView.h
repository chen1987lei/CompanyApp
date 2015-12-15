//
//  TDSearchTypeDropListView.h
//  Tudou
//
//  Created by weiliangMac on 14-7-7.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SearchType)
{
    SearchType_VIDEO = 0,
    SearchType_CHANNEL = 1,
};
@class TDSearchTypeDropListView;
@protocol TDTDSearchTypeDropListViewDelegate<NSObject>

/**
 *  搜索筛选button切换
 *
 *  @param searchType
 */
- (void)searchTypeDropBoxButtonClick:(SearchType)searchType;

- (void)tapGestureRecognizerEvent;
@end
 
@interface TDSearchTypeDropListView : UIView<UIGestureRecognizerDelegate>
@property(nonatomic, weak) id<TDTDSearchTypeDropListViewDelegate> delegateType;
- (void)setSelectSearchTypeDropButton:(SearchType)type;
@end