//
//  TDSearchAlbumVideoCell.h
//  Tudou
//
//  Created by weiliang on 13-12-9.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDSearchAlbum.h"
#import "TDBaseCell.h"

typedef NS_ENUM(NSInteger, Button_tag) {
    Button_DianShiJu = 65532,
    
    Button_DianYing = 65533,
    Button_ZongYi = 65534,

    Button_More = 65537,
    
};

#define kSearchAlbumCellSize CGSizeMake([UIScreen width],222)
#define kView1Height 43.5
#define kLoadShowMoreHeight 43
@class TDSearchAlbumVideoCell;
@protocol TDSearchAlbumVideoCellDelegate <NSObject>
@optional

- (void)onMoreShowClick_view1:(TDSearchAlbumVideoCell *)cell;
- (void)onSeriesSegmentClick_view1:(TDSearchAlbumVideoCell *)cell
                     currentSelect:(NSNumber *)currentSelect
                     currentOffset:(NSNumber *)currentOffset;
//订阅
- (void)subscribeButtonClickDelegate:(TDSearchAlbumVideoCell *)cell orderType:(NSInteger)orderType;

- (void)reloadTableView:(TDSearchAlbumVideoCell*)cell;

//- (UZYSPullToRefreshState)getTableViewState;

@end

@interface TDSearchAlbumVideoCell : TDBaseCell

@property (nonatomic, assign)   BOOL  isShowMore;//展开更多
@property (nonatomic,assign)   float  currentSelect;
@property (nonatomic,weak) id <TDSearchAlbumVideoCellDelegate> delegate;

//订阅按钮
@property (nonatomic, strong)   UIButton     * subscribeButton;

//是否订阅
@property (nonatomic, assign) BOOL      isSubscribed;
//防止 重复点击
@property (nonatomic, assign) BOOL      isSubscribing;

- (void)stopLoading;

-(void)startLoading;

-(void) setMoreShow:(BOOL)isShow;

-(void)refreshData:(id)object;

- (void)setSubscribeButtonStatus:(BOOL)subscribed;

- (CGRect)subScribeButtonRect;

@end
