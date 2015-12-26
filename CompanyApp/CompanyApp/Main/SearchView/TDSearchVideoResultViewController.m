 //
//  TDSearchVideoResultViewController.m
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDSearchVideoResultViewController.h"

/*
#import "TDFilterBar.h"
#import "PRPToggleButton.h"
#import "TDFilterPullView.h"

#import "TDSearchDirectAllDataSource.h"
#import "TDSearchUGCDataSource.h"
#import "TDSearchAlbum.h"
#import "TDSearchAlbumPerson.h"
#import "TDSearchUGCVideo.h"
#import "TDSearchAlbumPersonCell.h"
#import "TDOutsideVideoController.h"

#import "TDSearchAlbumVideoCell.h"
#import "TDPodcastChannelPersonCell.h"
#import "TDPodcastChannelPerson.h"
#import "TDPersonalChannelViewController.h"
#import "TDUserChannelInfo.h"

#import "TDTipPopView.h"

#import "TDSubscribeDataSource.h"
#import "TDSubscribeModel.h"

#import "TDSearchPopMessageView.h"

#import "SearchHistory.h"
*/

#define kHeaderViewHeight (37 + 6)

#define kHeaderView_CountLableHeight 0

#define kFilterBarTagOffset 1000
#define kFilterViewTag 111
#define kFilterButtonTag 222
#define kFilterPullViewHeight (116 + 25 - 2)
#define kHeaderViewHeight_NoUGC 50

#define kUGCVideosCount_Row 2

#define kAlbumClassifyButtonTag 2000
#define kAlbumClassifyViewHeight 40
#define kAlbumClassifyMargin     8
@interface TDSearchVideoResultViewController ()

//<TDBaseDataSourceDelegate, TDFilterBarDelegate, TDFilterPullViewDelegate,TDBaseCellDelegate,TDBaseCellDelegate>
{
    NSString            * _keyword;
    
    int           sortBarIndex;
    NSString            *sortValue;//用来进行item的筛选过滤未筛选默认为nil
    
    NSDictionary*       selectFilterValue;
    
    BOOL                isAnimate;
    BOOL                hasOriginItemData;//判断第一次请求是不是有itemsource
    
    /*
     加载更多
     */
    BOOL                expandMore;//是否展开了更多，此变量只有在 needLoadMore == yes (directAllDataSource)的情况下 才有可能为yes
    /*
     * 首次订阅提示
     */
    BOOL                isShowTipPopView;
    /**
     *  直达区分类筛选
     */
    UIImageView*        albumClassifyRightDirectionIcon;
    NSInteger           albumClassifySelectIndex;
    UIView*             albumClassifyView;
    UIScrollView*       albumClassifyScrollView;
    
    BOOL                isHasClassify;//是否有直达区分类tab
    
    BOOL                isSendCorrectReq;//发请求时是否纠偏
    
}
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) UIView *loadMoreView;
/**-------------------------------ALBUM----------------------------------
 */


@end

@implementation TDSearchVideoResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sortBarIndex = -1;
        selectFilterValue = nil;
        
//        _albumDataSource = [NSMutableArray arrayWithCapacity:1];
//        _itemDataSource = [NSMutableArray arrayWithCapacity:1];
//        _subscribeDataSource=[[TDSubscribeDataSource alloc] init];
        //注册订阅通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSub:) name:kUserSubscribeNotification object:nil];
        //注册搜索统计点击日志通知
 
        
        
        isSendCorrectReq = YES;
         
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.view.autoresizesSubviews = YES;
    hasOriginItemData = NO;//首次进来不显示 failedView 
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    self.tableView = nil;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
    
    
}

- (void)clearFilter{
    
    
    sortValue = nil;
}
- (void)resetData{
    
    
    
}
- (void)resetView{
    /*
     恢复初始状态
     放在返回数据后处理（finishOfDataSource）
     _ihead = nil;
     */
    
    sortBarIndex = 0;
}
- (void)refreshNetworkData//只用一次 比如刚进入的时候和下拉重新刷新
{
    //清空页面数据
    [self resetData];
    [self resetView];
    sortValue = nil;
    sortBarIndex = -1;
    selectFilterValue = nil;

    
    NSString * realString = [_keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!IsStringWithAnyText(realString))
        return;
   
   
    
 
    [self reloadNetWorkData:NO];
    return;
}

- (void)refreshNetworkDataWithoutRestUGCdata
{
    //清空页面部分数据
    
    hasOriginItemData = NO;
    
    [self resetView];
    sortValue = nil;
    sortBarIndex = -1;
    selectFilterValue = nil;
    
    NSString * realString = [_keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!IsStringWithAnyText(realString))
        return;
    
    
    
    [self reloadNetWorkData:NO];
    return;
}

- (void)reloadNetWorkData:(BOOL)isOnlyFilter
{
   
    
}

#pragma mark - checkSubscribe

#pragma mark - SearchWordCorrect

/*
- (void)handleSearchWordCorrect:(CorrectionData*)data
{
    if (data) {
        [self.popMessageView.datasource removeAllObjects];
        [self.popMessageView.datasource addObject:data];
        [self.popMessageView refreshUI];
        [self.view addSubview:self.popMessageView];
        [self.popMessageView showList];

    }else{
        [self.popMessageView hiddenList];
    }
}

-(TDSearchPopMessageView *) popMessageView
{
    if (!_popMessageView) {
        _popMessageView = [[TDSearchPopMessageView alloc] initWithFrame:CGRectMake(0, TitleBar_Height+50, self.view.width, 37.5) withDelegate:self];
    }
    return _popMessageView;
}

#pragma mark -  TDSearchPopMessageViewDelegate
- (void)searchPopViewDidSelectMessage:(CorrectionData *)data
{
    if (data.corr_type == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(userClickCorrectPopView:)]) {
            [_delegate userClickCorrectPopView:data.corrWord];
        }
        [SearchHistory addHistory:data.corrWord type:SearchType_VIDEO];
        [self searchString:data.corrWord];
    }else if (data.corr_type==1){
        isSendCorrectReq = NO;
        [self searchString:data.keyWord];
        isSendCorrectReq = YES;
    }
    

}

#pragma mark - TDBaseDataSourceDelegate
- (void)finishOfDataSource:(TDBaseDataSource *)dataSource
{
    if ([dataSource isKindOfClass:[TDSearchDirectAllDataSource class]]) {
        _directAllDataSource.isFinishRequest = YES;
        isHasClassify = _directAllDataSource.isHasClassify;
        if (_directAllDataSource.error)
        {
            DLog(@"failed!_directAllDataSource");
            _directAllDataSource.isHasClassify = NO;
            _directAllDataSource.isNeedCorrect = NO;
            _albumDataSource  = [NSMutableArray arrayWithCapacity:2];
            
        }
        else
        {
            if (_directAllDataSource.isHasClassify) {
                albumClassifySelectIndex = 0;
                [self refreshAlbumClassifyTable:albumClassifySelectIndex];
                [self creatAlbumClassifyTabs:[self getAlbumClassifyTitles]];
                //显示类别栏
                albumClassifyView.hidden = NO;
            }
            else
            {
                if ([_directAllDataSource.albumDataSource_part count])
                {
                    expandMore = NO;
                    _albumDataSource  = [_directAllDataSource.albumDataSource_part mutableCopy];
                }
                else
                {
                    _directAllDataSource.isHasClassify = NO;
                    _albumDataSource  = [NSMutableArray arrayWithCapacity:2];
                }
            }
            [self refreshUIWithoutFailedView];
            [self channelCheckSubscribe:_directAllDataSource.albumDataSource_all];
        }
        
        if (_directAllDataSource.isNeedCorrect == YES) {
            [self handleSearchWordCorrect:_directAllDataSource.corr_data];
        }else{
            [self.popMessageView hiddenList];
        }
        //需要重设 aaid
        [[TDAnalyticsSDKSearch sharedInstance] resetAnalyticsSearchAaid];
    }
    else if ([dataSource isKindOfClass:[TDSearchUGCDataSource class]])
    {
        _UGCDataSource.isFinishRequest = YES;
        if (_UGCDataSource.error)
        {
            _UGCDataSource.hasMore = YES;
            if (!_itemDataSource || _itemDataSource.count==0) {
                _UGCDataSource.hasMore = NO;
            }
            DLog(@"failed!_UGCDataSource");
            /**
             *  不对原来数据做清除
             */
            //            _itemDataSource = nil;
            //            _itemDataSource  = [NSMutableArray arrayWithCapacity:2];
/*
        }
        else
        {
            if (_UGCDataSource.list) {
                _itemDataSource = [_UGCDataSource.list mutableCopy];
            }
            if (_UGCDataSource.sortArray) {
                _itemSortArray = [_UGCDataSource.sortArray mutableCopy];
            }
            if (_UGCDataSource.filterArray) {
                _itemFilterDict = nil;//刷新一下
            }
        }
    }
    if (_directAllDataSource.isFinishRequest && _UGCDataSource.isFinishRequest) {
        
  
         V3.8 注：
         数据处理方式：当有任何一个请求返回失败的时候，提示加载失败
         V4.0
         数据处理方式：当两个请求返回都失败的时候，提示加载失败
         V4.5 
         数据处理方式：当ugc请求返回失败的时候，提示加载失败
         */
        /*
        if (_UGCDataSource.error) {
            NetworkStatus netStatus = [TDAPP currentReachabilityStatus];
            if ( netStatus == NotReachable ) {
                [self addFailedView];
            }else {
                [MBProgressHUD showTextHudAddTo:self.view title:@"加载失败，请稍后重试" animated:YES afterDelayHide:1];
            }
        }else{
            _ihead = nil;
            if (self.ihead) {
                //refreshUI 之前重新创建一下head
            }
        }
        

        if (_directAllDataSource.error && _UGCDataSource.error) {
            self.failedView.type = [TDAPP currentReachabilityStatus] == NotReachable ? TDFailedView_NOWifi : TDFailedView_NetWorkError;
        }
        else {
            [[TDAnalyticsSDKSearch sharedInstance] analyticsSearchVisitLog:[[TDAnalyticsSDKSearch sharedInstance] getAnalyticsSearchAaid]
                                                                 pageIndex:_UGCDataSource.page
                                                                  pageSize:[_itemDataSource count]
                                                                   keyWord:_keyword
                                                                directSize:[_albumDataSource count]
                                                                   ugcSize:_UGCDataSource.totalSize
                                                                       seq:(sortBarIndex > 0 ? [NSString stringWithFormat:@"%i",sortBarIndex] : nil)
                                                                    filter:[self getFilterDataToanalytics]
                                                                        sh:0
                                                                   logType:@"11"
                                                                      name:@"搜索结果页加载"
                                                                      page:@"搜索-视频搜索结果页"
                                                                    target:@"target_搜索结果页加载"];
        }
        
        if (self.albumDataSource.count == 0 && self.itemDataSource.count == 0 && !_directAllDataSource.error && !_UGCDataSource.error)
        {
            self.failedView.noDataDes = @"抱歉,未找到相关视频";
            self.failedView.type = TDFailedView_NoData;
        }
        [self refreshUI];
        //fix bug19785
        [self removeLoading];
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        self.tableView.infiniteScrollingView.enabled = [_UGCDataSource hasMore];
        self.tableView.showsInfiniteScrolling = [_UGCDataSource hasMore];
    }
}

*/

-(void)addFailedView
{
  
    
}


@end