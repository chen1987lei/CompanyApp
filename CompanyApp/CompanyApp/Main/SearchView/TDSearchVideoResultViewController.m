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

//- (void)refreshUI
//{
//    [self removeLoading];
//    [self.tableView reloadData];
//    
//    [self addFailedView];
//    self.tableView.infiniteScrollingView.enabled = NO;
//    self.tableView.showsInfiniteScrolling = NO;
//    [self.tableView.pullToRefreshView stopAnimating];
//    [self.tableView.infiniteScrollingView stopAnimating];
//    
//    self.tableView.infiniteScrollingView.enabled = [_UGCDataSource hasMore];
//    self.tableView.showsInfiniteScrolling = [_UGCDataSource hasMore];
//}
//
//- (void)refreshUIWithoutFailedView
//{
//    [self.tableView reloadData];
//    
//    self.tableView.infiniteScrollingView.enabled = NO;
//    self.tableView.showsInfiniteScrolling = NO;
//    [self.tableView.pullToRefreshView stopAnimating];
//    [self.tableView.infiniteScrollingView stopAnimating];
//    
//    self.tableView.infiniteScrollingView.enabled = [_UGCDataSource hasMore];
//    self.tableView.showsInfiniteScrolling = [_UGCDataSource hasMore];
//}
//
//- (void)refreshUIWithoutReloadTableData
//{
//    self.tableView.infiniteScrollingView.enabled = NO;
//    self.tableView.showsInfiniteScrolling = NO;
//    [self.tableView.pullToRefreshView stopAnimating];
//    [self.tableView.infiniteScrollingView stopAnimating];
//    
//    self.tableView.infiniteScrollingView.enabled = [_UGCDataSource hasMore];
//    self.tableView.showsInfiniteScrolling = [_UGCDataSource hasMore];
//}
//
//- (void)delayRefresh{
//    NetworkStatus status = [TDAPP currentReachabilityStatus];
//    if (status == NotReachable) {
//        [MBProgressHUD showTextHudAddTo:self.view title:LocalizedString(@"当前无网络连接，请检查您的网络") animated:YES afterDelayHide:1];
//        [self refreshUI];
//    }else{
//        [self refreshNetworkDataWithoutRestUGCdata];
//        
//    }
//}
//- (void)delayLoadMore{
//    if ([_UGCDataSource hasMore]) {
//        [_UGCDataSource loadMore];
//    } else {
//        self.tableView.showsInfiniteScrolling = NO;
//        self.tableView.infiniteScrollingView.enabled = NO;
//    }
//}
//- (void)addRefreshViewInTableView
//{
//    __weak TDSearchVideoResultViewController *weakSelf = self;
//    [weakSelf.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf performSelector:@selector(delayRefresh) withObject:nil afterDelay:0.3];
//        //点击POP按钮的时候取消所有的performSelector
//    }];
//}
//
//- (void)addLoadMoreViewInTableView
//{
//    __weak TDSearchVideoResultViewController *weakSelf = self;
//    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
//         [weakSelf delayLoadMore];
//    }];
//}
//
//- (void)loadMore
//{
//    [_UGCDataSource loadMore];
//    _UGCDataSource.isFinishRequest = NO;
//}
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
//                                                                   TitleBar_Height,
//                                                                   self.view.width,
//                                                                   screenSize().height - TitleBar_Height)
//                                                  style:UITableViewStylePlain];
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _tableView.backgroundColor = [UIColor TDMainBackgroundColor];
//        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.scrollsToTop = YES;
//        [self addRefreshViewInTableView];
//        [self addLoadMoreViewInTableView];
//    }
//    return _tableView;
//}
//
//-(TDFailedView *)failedView
//{
//    if (!_failedView) {
//        _failedView = [[TDFailedView alloc] initWithFrame:CGRectMake(0,
//                                                                 0,
//                                                                 self.tableView.width,
//                                                                 self.tableView.height - TitleBar_Height)];
//        _failedView.delegate = self;
//    }
//    return _failedView;
//}
//
//- (void)layout{
//    _filterPullView.top = kHeaderViewHeight;
//}
//
//- (NSString *)keyword{
//    return [_keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//}
//
////更改tableView.scrollToTop属性
//- (void)setTableViewScrollToTop:(BOOL)isToTop
//{
//    if (_tableView!=nil) {
//        _tableView.scrollsToTop = isToTop;
//    }
//}
//
//#pragma mark UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat pullHeight = 0.0f;
//    //加这句话的目的是为了防止我没有点击筛选 但是数据已经获取出来的这种情况造成filterPullView被调用的情况
//    if (self.isAdvanceFilterViewShowing) {
//        pullHeight = self.filterPullView.height;
//    }
//    
//    if (section == 0) {
//        if (isHasClassify) {
//            return kAlbumClassifyViewHeight;
//        }
//        return 0.1;
//    }
//    _noUGCTipLabel.hidden = YES;
//    /**
//     * 如果ugc接口挂掉 隐藏筛选栏
//     */
//    if (section == 1 && _UGCDataSource.error && (!_itemDataSource || [_itemDataSource count]==0)) {
//        return 0.1;
//    }
//    if (section == 1 && [self.itemDataSource count] != 0) {
//        return kHeaderViewHeight + pullHeight;
//    }
//    if (section == 1 && self.isAdvanceFilterViewShowing) {
//        if ([self.itemDataSource count] == 0 && _UGCDataSource.isFinishRequest) {
//            _noUGCTipLabel.hidden = NO;
//            _noUGCTipLabel.frame = CGRectMake(0,
//                                              kHeaderViewHeight + kFilterPullViewHeight,
//                                              _ihead.width,
//                                              kHeaderViewHeight_NoUGC);
//            return kHeaderViewHeight + pullHeight + kHeaderViewHeight_NoUGC;
//        }
//        return kHeaderViewHeight + pullHeight;
//    }
//    if (section == 1 && !self.isAdvanceFilterViewShowing) {
//        if ([self.itemDataSource count] == 0 && _UGCDataSource.isFinishRequest) {
//            _noUGCTipLabel.hidden = NO;
//            _noUGCTipLabel.frame = CGRectMake(0,
//                                              kHeaderViewHeight,
//                                              _ihead.width,
//                                              kHeaderViewHeight_NoUGC);
//            return kHeaderViewHeight + kHeaderViewHeight_NoUGC;
//        }
//        return kHeaderViewHeight;
//    }
//    return 0.1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = nil;
//    if (section == 0) {
//        if (isHasClassify) {
//            return albumClassifyView;
//        }
//        else
//        {
//            headView = [[UIView alloc] init];
//            headView.backgroundColor = [UIColor clearColor];
//            return headView;
//        }
//    }
//    if (section == 1) {
//        if (self.albumDataSource.count == 0 &&
//            self.itemDataSource.count == 0 &&
//            !self.isAdvanceFilterViewShowing && !hasOriginItemData) {
//            headView = [[UIView alloc] init];
//            headView.backgroundColor = [UIColor clearColor];
//            return headView;
//        }
//        if (self.isAdvanceFilterViewShowing) {
//            [self layout];
//        }
//        headView = self.ihead;
//        if ( !_UGCDataSource.isFinishRequest && _itemDataSource.count == 0) {
//            self.ihead.hidden = YES;
//        }else{
//            self.ihead.hidden = NO;
//        }
//    }
//    return headView;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSInteger count = 0;
//    if (section == 0) {
//        if ([self showExpandMoreButton]) {
//            count = ceil([self.albumDataSource count] + 1);
//        }
//        else
//            count = ceil([self.albumDataSource count]);
//    }
//    else if (section == 1) {
//        NSInteger more =  ([self.itemDataSource count] % kUGCVideosCount_Row) ? 1 : 0;
//        count = ceil([self.itemDataSource count]/kUGCVideosCount_Row + more);
//    }
//    return count;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        //更多
//        if ([self showExpandMoreButton] &&
//            indexPath.row == [_albumDataSource count]) {
//            return 47;
//        }
//        //人物直达区
//        if ([_albumDataSource hasIndex:indexPath.row] &&
//            [self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson){
//            return [self calculateAlbumCellHeight:_albumDataSource[indexPath.row]];
//        }
//        if ([_albumDataSource hasIndex:indexPath.row] &&
//            [self isSearchAlbumPerson:indexPath.row] == Driect_Channel) {
//            return [TDPodcastChannelPersonCell height];
//        }
//        //一般直达区
//        if ([_albumDataSource hasIndex:indexPath.row] &&
//            !([self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson)) {
//            TDSearchAlbum* album = [_albumDataSource objectAtIndex:indexPath.row];
//            if ([album.cate_id intValue] == Direct_DianYing || [album.cate_id intValue] == Direct_DianYingXiLie) {
//                //电影 cell 去掉view1
//               // return kSearchAlbumCellSize.height - kView1Height;
//                return [TDSearchAlbumVideoCell height] - kView1Height;
//            }
//        }
//        return [TDSearchAlbumVideoCell height];
//    }
//    else {
//        return 0;//[TDSearchUGCVideoCell cellHeight:cellTypeHorizontalTwo];
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        static NSString *cellIdentifier_person = @"CellIdentifier_person";
//        static NSString *cellIdentifier_video = @"CellIdentifier_video";
//        static NSString *cellIdentifier_channel = @"CellIdentifier_channel";
//        if ([self showExpandMoreButton] && indexPath.row == [_albumDataSource count]) {
//            static NSString *cellCheckMoreIdentifier = @"CellIdentifier_more";
//            //加载更多cell
//            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellCheckMoreIdentifier];
//            if (!cell)
//            {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellCheckMoreIdentifier];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                UIButton* buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
//                buttonMore.frame = CGRectMake(-2, 2, self.view.width + 4, 43);
//                [buttonMore addTarget:self action:@selector(loadMoreAlbum) forControlEvents:UIControlEventTouchUpInside];
//                [buttonMore setTitle:[NSString stringWithFormat:@"查看更多"] forState:UIControlStateNormal];
//                [buttonMore setBackgroundColor:[UIColor TDWhiteColor253]];
//                [buttonMore setTitleColor:RGBS(121) forState:UIControlStateNormal];
//
//                [buttonMore.layer setBorderWidth:0.5];
//                [buttonMore.layer setCornerRadius:0];
//                [buttonMore.layer setBorderColor:RGBS(217).CGColor];
//                [cell.contentView addSubview:buttonMore];
//            }
//            cell.tag = [_albumDataSource count];
//            return cell;
//        }
//        //一般直达区 跟 人物直达区
//        if ([self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson) {
//            TDSearchAlbumPersonCell *cell = (TDSearchAlbumPersonCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_person];
//            if (!cell)
//            {
//                cell = [[TDSearchAlbumPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_person];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.delegate = self;
//                [cell setDidTapMethod:@selector(didTapRecord:)];
//            }
//            if ([_albumDataSource count] > indexPath.row) {
//                cell.currentSelect = ((TDSearchAlbumPerson*)_albumDataSource[indexPath.row]).currentSelect;
//            }
//            cell.tag = indexPath.row;
//            return cell;
//        } else if ([self isSearchAlbumPerson:indexPath.row] == Driect_Channel) {
//            TDPodcastChannelPersonCell *cell = (TDPodcastChannelPersonCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_channel];
//            if (!cell)
//            {
//                cell = [[TDPodcastChannelPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_channel];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.delegate = self;
//            }
//            cell.tag = indexPath.row;
//            if (_isCheckingSubState) {
//                [cell startLoading];
//            }else{
//                [cell stopLoading];
//            }
//            return cell;
//            
//        } else
//        {
//            TDSearchAlbumVideoCell *cell = (TDSearchAlbumVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier_video];
//            if (!cell)
//            {
//                cell = [[TDSearchAlbumVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_video];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.delegate = self;
//                [cell setDidTapMethod:@selector(didTapRecord:)];
//            }
//            if ([_albumDataSource count] > indexPath.row) {
//                [cell setMoreShow:((TDSearchAlbum*)_albumDataSource[indexPath.row]).isShowMore];
//                cell.currentSelect = ((TDSearchAlbum*)_albumDataSource[indexPath.row]).currentSelect;
//                cell.isSubscribed = ((TDSearchAlbum*)_albumDataSource[indexPath.row]).isSubscribed;
//            }
//            cell.tag = indexPath.row;
//            if (_isCheckingSubState) {
//                [cell startLoading];
//            }else{
//                [cell stopLoading];
//            }
//            return cell;
//        }
//        return nil;
//    }
//    else if (indexPath.section == 1) {
//        static NSString *cellIdentifier = @"CellIdentifier_d";
//
//        
//    }
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(TDCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        if (indexPath.row < [_albumDataSource count]) {
//            if ([self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson) {
//                [(TDSearchAlbumPersonCell*)cell refreshData:self.albumDataSource[indexPath.row]];
//            } else if ([self isSearchAlbumPerson:indexPath.row] == Driect_Channel){
//                TDPodcastChannelPerson *podcastChannelPerson = self.albumDataSource[indexPath.row];
//                [(TDPodcastChannelPersonCell*)cell refreshData:podcastChannelPerson];
//            }
//            else
//            {
//                [(TDSearchAlbumVideoCell*)cell refreshData:self.albumDataSource[indexPath.row]];
//                TDSearchAlbum* album = self.albumDataSource[indexPath.row];
//                //显示订阅提示语
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                if (album.is_tudou && ![userDefaults objectForKey:kSEARCHALBUMTIPHIDEN]/* && [APP_VERSION isEqualToString:@"4.0"]*/){
//                    if (![self.view.subviews isKindOfClass:[TDTipPopView class]]) {
//                        [self.view addSubview:tipPopView];
//                    }
//                    CGFloat cellHeight = [TDSearchAlbumVideoCell height];
//                    //人物直达区
//                    if ([_albumDataSource hasIndex:indexPath.row] &&
//                        [self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson){
//                        cellHeight = [self calculateAlbumCellHeight:_albumDataSource[indexPath.row]];
//                    }
//                    if ([_albumDataSource hasIndex:indexPath.row] &&
//                        [self isSearchAlbumPerson:indexPath.row] == Driect_Channel) {
//                        cellHeight = [TDPodcastChannelPersonCell height];
//                    }
//                    //一般直达区
//                    if ([_albumDataSource hasIndex:indexPath.row] &&
//                        !([self isSearchAlbumPerson:indexPath.row] == Driect_AlbumPerson)) {
//                        TDSearchAlbum* album = [_albumDataSource objectAtIndex:indexPath.row];
//                        if ([album.cate_id intValue] == Direct_DianYing || [album.cate_id intValue] == Direct_DianYingXiLie) {
//                            //电影 cell 去掉view1
//                            // return kSearchAlbumCellSize.height - kView1Height;
//                            cellHeight = [TDSearchAlbumVideoCell height] - kView1Height;
//                        }
//                    }
//
//                    CGRect subBtnR = [(TDSearchAlbumVideoCell*)cell subScribeButtonRect];
//                    tipPopView.frame = CGRectMake(7 + 104.0/320.0*[UIScreen width] + 61 + 10 + 30.5 - 200 ,
//                                                  TitleBar_Height + CGRectGetMaxY(subBtnR) + cell.origin.y ,
//                                                  320 - 40,
//                                                  40);
//                    //+ ((_directAllDataSource.isHasClassify==YES)?kAlbumClassifyViewHeight:0)
//                    [tipPopView setArrorPoint:/*cell.origin*/ CGPointMake(200, 0)];
//                    [tipPopView showAnimite];
//                    [userDefaults setObject:@"1" forKey:kSEARCHALBUMTIPHIDEN];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
//            }
//        }
//    }
//    else {
//        int loc = (int)indexPath.row*kUGCVideosCount_Row;
//        NSMutableArray * tempArray = [[NSMutableArray alloc] init];
//        for(int i=loc;i<loc+kUGCVideosCount_Row;++i )
//        {
//            if([self.itemDataSource hasIndex:i])
//            {
//                [tempArray addObject:self.itemDataSource[i]];
//            }
//            else
//                break;
//        }
//        
////        [(TDSearchUGCVideoCell*)cell setArrList:tempArray];
//    }
//    return;
//}
//
//-(BOOL)showExpandMoreButton
//{
//    if (_directAllDataSource.hasLoadMore && !expandMore) {
//        return YES;
//    }
//    return NO;
//}
//-(void)loadMoreAlbum
//{
//    expandMore = !expandMore;
//    if (expandMore) {
//        if (_directAllDataSource.albumDataSource_all) {
//            _albumDataSource = nil;
//            _albumDataSource = [_directAllDataSource.albumDataSource_all mutableCopy];
//        }
//    }
//    else
//    {
//        if (_directAllDataSource.albumDataSource_part) {
//            _albumDataSource = nil;
//            _albumDataSource = [_directAllDataSource.albumDataSource_part mutableCopy];
//        }
//    }
//    [self.tableView reloadData];
//}
//
//-(void)viewTouchWithIndex:(NSInteger)index Video:(TDBaseVideo *)video{
//    TDAppDelegate *delegate = (TDAppDelegate *)[UIApplication sharedApplication].delegate;
//    if (TDAPP.detailController) {
//        [TDAPP.tdNav removeProController:TDAPP.detailController];
//    }
//    TDDetailViewController * controller = [[TDDetailViewController alloc]
//                                           initWithItemCode:video.vid
//                                           albumid:video.albumid
//                                           playListCode:video.playlist_code
//                                           extendInfo:nil];
//    [delegate.tdNav pushViewController:controller animated:YES];
//}
//
////订阅频道
//-(void)subTapedWithCellTag:(NSInteger)tag{
//    
//    if (![self isAllowClickButton]) {
//        return;
//    }
//    TDPodcastChannelPersonCell *tapedCell = (TDPodcastChannelPersonCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
//    [self subscriptionButtonTaped:tapedCell.subButton
//                         WithInfo:[self setUserChannelInfoWithVideoData:self.albumDataSource[tag]]
//                      WithCellTag:tag];
//}
//
//-(void)showProgressHubWithNoBlock:(NSString*)title{
//    [MBProgressHUD showTextHudAddTo:self.view title:title animated:YES afterDelayHide:1.5 isBlock:NO];
//}
//
//-(void)subFailedWith:(SubscribeFailed)error andIsSubed:(BOOL)hasSub{
//    switch (error) {
//        case subscribeFailedNoLogIn:{
//            [self showLogin];
//        }
//            break;
//        case subscribeFailedOther:{
//            if (hasSub) {
//                [self showProgressHubWithNoBlock:@"取消订阅失败，请稍后重试"];
//            } else {
//                [self showProgressHubWithNoBlock:@"订阅失败，请稍后重试"];
//            }
//        }
//            break;
//        case subscribeFailedSubSelf:{
//            [self showProgressHubWithNoBlock:@"不可以订阅自己，订阅点其他频道吧"];
//        }
//            break;
//        case subscribeFailedCompilerRejectSub:{
//            [self showProgressHubWithNoBlock:@"该自频道暂不支持订阅"];
//        }
//            break;
//        case subscribeFailedLogOutOfDate:{
//            [self subscibeTapedWithLogOutOfDate];
//        }
//            break;
//        case subscribeFailedMaxCount:{
//            [MBProgressHUD showTextHudAddTo:self.view title:@"您已达到本地订阅最大数量，登录后可提供无限量的订阅服务" animated:YES afterDelayHide:1];
//            
//        }
//            break;
//        case subscribeFailedBadNet:{
//            [MBProgressHUD showTextHudAddTo:self.view title:@"当前无网络连接，请检查您的网络" animated:YES afterDelayHide:1];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)subscibeTapedWithLogOutOfDate{
//    [TDAPP removeUserDataBase];//需要在退出之前删除.切记.这样可以删除上传的视频
//    [[TDUser sharedInstance] loginOut];
//    [self showLogin:^{
//        [MBProgressHUD showTextHudAddTo:self.topSuperView title:@"账号信息失效，请重新登录" animated:YES afterDelayHide:2];
//    }];
//}
//
//- (TDUserChannelInfo *)setUserChannelInfoWithVideoData:(id)videoData{
//    TDPodcastChannelPerson *podcastChannelPerson = (TDPodcastChannelPerson *)videoData;
//    TDUserChannelInfo *info = [[TDUserChannelInfo alloc] init];
//    info.type = [NSNumber numberWithInteger:2];//2表示频道
//    info.channelId = podcastChannelPerson.podcastId;
//    info.nick = podcastChannelPerson.name;
//    info.isSub = podcastChannelPerson.isSubed;//1表示订阅
//    info.pic = podcastChannelPerson.smallImageUrl;
//    return info;
//}
//
////进入频道详情页
//-(void)detailTapedWithID:(NSString *)podcastChannelID{
//    TDPersonalChannelViewController *personalChannelViewController = [[TDPersonalChannelViewController alloc] init];
//    personalChannelViewController.channelID = podcastChannelID;
//    [TDAPP.tdNav pushViewController:personalChannelViewController animated:YES];
//    
//}
//
//- (BOOL)isAllowClickButton
//{
//    //下拉刷新时不允许点击
//    if (self.tableView.pullToRefreshView.state == UZYSGIFPullToRefreshStateLoading) {
//        return NO;
//    }
//    return YES;
//}
//
//- (void)didTapRecord:(id)record
//{
//    
//    if (![self isAllowClickButton]) {
//        return;
//    }
//    
//    if (record != nil) {
//        TDBaseVideo* video = record;
//        TDAppDelegate *delegate = (TDAppDelegate *)[UIApplication sharedApplication].delegate;
//        if(TDAPP.detailController){
//            [TDAPP.tdNav removeProController:TDAPP.detailController];
//        }
//        TDDetailViewController * controller = [[TDDetailViewController alloc] initWithItemCode:video.vid
//                                                                                       albumid:video.albumid
//                                                                                  playListCode:video.playlist_code
//                                                                                    extendInfo:nil];
//        [delegate.tdNav pushViewController:controller animated:YES];
//        
//        //离开页面再回来订阅提示条不显示
//        if (tipPopView) {
//            [tipPopView disappearAnimite];
//        }
//    }
//}
//
//#pragma mark TDBaseCellDelegate
//-(void)viewTouchWithIndexPath:(NSIndexPath *)index Video:(id)video
//{
//    [self didTapRecord:video];
//}
//
//#pragma mark TDSearchAlbumVideoCellDelegate
//- (void)onMoreShowClick_view1:(TDSearchAlbumVideoCell *)cell
//{
//    NSIndexPath* PATH = [self.tableView indexPathForCell:cell];
//    if ([self.albumDataSource count]) {
//        TDSearchAlbum* model = [_albumDataSource objectAtIndex:PATH.row];
//        model.isShowMore = cell.isShowMore;
//    }
//    if (tipPopView) {
//        [tipPopView disappearAnimite];
//    }
//}
//
//- (void)reloadTableView:(TDSearchAlbumVideoCell*)cell
//{
//    NSIndexPath* PATH = [self.tableView indexPathForCell:cell];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:PATH, nil] withRowAnimation:UITableViewRowAnimationNone];
//}
//
//- (void)onSeriesSegmentClick_view1:(TDSearchAlbumVideoCell *)cell
//                     currentSelect:(NSNumber *)currentSelect
//                     currentOffset:(NSNumber *)currentOffset
//{
//    NSIndexPath* PATH = [self.tableView indexPathForCell:cell];
//    DLog(@"onSeriesSegmentClick_view1  row: %d   currentSelect:%d",(int)PATH.row,[currentSelect intValue]);
//    if ([self.albumDataSource count]) {
//        TDSearchAlbum* model = [_albumDataSource objectAtIndex:PATH.row];
//        model.currentSelect = [currentSelect integerValue];
//        model.currentOffset = [currentOffset floatValue];
//    }
//}
//
//- (UZYSPullToRefreshState)getTableViewState
//{
//    return self.tableView.pullToRefreshView.state;
//}
//
//#pragma mark 订阅
////剧集直达区订阅
//- (void)subscribeButtonClickDelegate:(TDSearchAlbumVideoCell *)cell orderType:(NSInteger)orderType
//{
//    NSIndexPath* path = [_tableView indexPathForCell:cell];
//    //判空、判越界 bug 16551
//    if (!path || path.row>=_albumDataSource.count) {
//        return;
//    }
//    //    操作类型 1(订阅)，2(取消订阅),默认：1
//    //    type订阅类型，1(剧集),2(频道),默认：2
//    TDSearchAlbum* album = [_albumDataSource objectAtIndex:path.row];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:1];
//    //定义扩展参数
//    dic[@"title"]=album.title?album.title:@"";
//    dic[@"image"]=album.vimg?album.vimg:@"";
//    [_subscribeDataSource subscribeOperation:[NSNumber numberWithInt:[album.albumid intValue]]
//                           withOperationType:!album.isSubscribed?operationSubscribe:operationCancel
//                           withSubscribeType:subscribeAlbum
//                              withExtendInfo:dic
//                                     success:^(BOOL isOk) {
//                                         [cell stopLoading];
//                                         if (!album.isSubscribed) {
//                                             [MBProgressHUD showTextHudAddTo:self.view title:@"订阅成功" animated:YES afterDelayHide:0.5];
//                                             
//                                             cell.subscribeButton.selected = YES;
//                                         }
//                                         else
//                                         {
//                                             [MBProgressHUD showTextHudAddTo:self.view title:@"取消订阅成功" animated:YES afterDelayHide:0.5];
//                                             
//                                             cell.subscribeButton.selected = NO;
//                                             
//                                         }
//                                         album.isSubscribed = !album.isSubscribed;
//
//                                     }
//                                     failure:^(SubscribeFailed failed) {
//                                         [cell stopLoading];
//                                         [self subFailedWith:failed andIsSubed:album.isSubscribed];
//                                     }];
//}
////自频道直达区
///*
//- (void)subscriptionButtonTaped:(UIButton *)sender WithInfo:(TDUserChannelInfo *)info WithCellTag:(NSInteger)cellTag{
//    TDPodcastChannelPersonCell *tapedCell = (TDPodcastChannelPersonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellTag inSection:0]];
//    TDPodcastChannelPerson *poder = self.albumDataSource[cellTag];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithCapacity:1];
//    //定义扩展参数
//    dic[@"title"]=info.nick?info.nick:@"";
//    dic[@"image"]=info.pic?info.pic:@"";
//    dic[@"isVuser"]=@(info.isVuser);
//    [tapedCell startLoadingOnButton:sender];
//    [_subscribeDataSource subscribeOperation:[NSNumber numberWithInt:[info.channelId intValue]]
//                           withOperationType:!poder.isSubed?operationSubscribe:operationCancel
//                           withSubscribeType:[info.type integerValue]
//                              withExtendInfo:dic
//                                     success:^(BOOL isOk) {
//                                         [tapedCell stopLoading];
//                                         if (!poder.isSubed) {
//                                             [self showProgressHubWithNoBlock:@"订阅成功"];
//                                             tapedCell.subButton.selected = YES;
//                                         }else{
//                                             [self showProgressHubWithNoBlock:@"取消订阅成功"];
//                                             tapedCell.subButton.selected = NO;
//                                         }
//                                         poder.isSubed = !poder.isSubed;
//                                     }
//                                     failure:^(SubscribeFailed failed) {
//                                         [tapedCell stopLoading];
//                                         [self subFailedWith:failed andIsSubed:YES];
//                                     }];
//}
//
//- (void)tabButtonClick:(TDSearchAlbumPersonCell *)cell currentSelect:(NSNumber *)currentSelect currentOffset:(NSNumber *)currentOffset
//{
//    NSIndexPath* PATH = [self.tableView indexPathForCell:cell];
//    if ([self.albumDataSource count]) {
//        TDSearchAlbumPerson* model = [_albumDataSource objectAtIndex:PATH.row];
//        model.currentSelect = [currentSelect integerValue];
//        model.currentOffset = [currentOffset floatValue];
//    }
//    [self.tableView reloadData];
//    
//}
//#pragma -------------------------------UGC------------------------------------
//
//-(void) creatFliterView
//{
//    UIImageView *filter = [[UIImageView alloc] initWithFrame:CGRectMake(0,kHeaderView_CountLableHeight, _ihead.width,kHeaderViewHeight)];
//    filter.backgroundColor = [UIColor whiteColor];
//    filter.userInteractionEnabled = YES;
//    filter.tag = kFilterViewTag;
//    NSMutableArray *itemarray = [NSMutableArray array];
//    NSMutableArray *array = self.itemSortArray;
//    
//    for (NSDictionary *dict in array) {
//        NSString *title = dict[@"title"];
//        [itemarray addObject:title];
//    }
//    
//    TDFilterBar *filterBar = [[TDFilterBar alloc] initWithFrame:CGRectMake(6,
//                                                                           0,
//                                                                           filter.width - 6,
//                                                                           kHeaderViewHeight - 0.5)
//                                                      itemArray:itemarray];
//    filterBar.hightLightColor = [UIColor TDOrange];
//    [filterBar setSelectedIndex:sortBarIndex];
//    filterBar.tag = kFilterBarTagOffset + 2;
//    filterBar.delegate = self;
//    //筛选
//    CGSize iamgeSize = Image(@"search_screen_icon").size;
//    UIImageView* filterIco = [[UIImageView alloc] initWithFrame:CGRectMake(filter.width - 43-iamgeSize.width,
//                                                                           (filterBar.height - iamgeSize.height)/2,
//                                                                           iamgeSize.width,
//                                                                           iamgeSize.height)];
//    filterIco.image = Image(@"search_screen_icon");
//    [filter addSubview:filterIco];
//    
//    UIButton* filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    filterButton.frame = CGRectMake(filter.width-75, 0, 65, filterBar.height);
//    filterButton.backgroundColor = [UIColor clearColor];
//    [filterButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
//    [filterButton setTag:kFilterButtonTag];
//    [filterButton setTitle:@"筛选" forState:UIControlStateNormal];
//    [filterButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [filterButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [filterButton addTarget:self action:@selector(filterButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
//    filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    if ([itemarray count]) {
//        filterButton.hidden = NO;
//        filterIco.hidden = NO;
//    }
//    else
//    {
//        filterIco.hidden = YES;
//        filterButton.hidden = YES;
//    }
//    [filter addSubview:filterBar];
//    [filter addSubview:filterButton];
//    
//    
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, filterBar.bottom, filter.width, 0.5)];
//    bottomLine.backgroundColor = RGB(220, 220, 220);
//    [filter addSubview:bottomLine];
//    
//    [_ihead addSubview:filter];
//}
//
//#pragma mark - fIlterPull
//- (TDFilterPullView *)filterPullView{
//    if (!_filterPullView) {
//        _filterPullView = [[TDFilterPullView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, self.view.bounds.size.width, 0)];
//        [_filterPullView setScrollHight:filterScrollViewHeight];
//        _filterPullView.delegate = self;
//        _filterPullView.hidden = YES;
//        _filterPullView.hidden = self.isAdvanceFilterViewShowing;
//        _filterPullView.clipsToBounds = YES;
//        [_filterPullView setFilterDic:self.itemFilterDict];
//    }
//    return _filterPullView;
//}
//
//- (NSDictionary *)itemFilterDict{
//    if (!_itemFilterDict) {
//        _itemFilterDict = [NSDictionary dictionaryWithObject:_UGCDataSource.filterArray forKey:@"filter"];
//    }
//    return _itemFilterDict;
//}
//
//- (void)filterButtonDidClick{
//    if (isAnimate  || [_UGCDataSource.filterArray count] == 0) {
//        return;
//    }
//    
//    if (![[self.ihead subviews] containsObject:self.filterPullView]) {
//        [self.ihead addSubview:self.filterPullView];
//        UIImageView *filterImageView = (UIImageView *)[self.ihead viewWithTag:kFilterViewTag];
//        if (filterImageView!=nil) {
//            [self.ihead bringSubviewToFront:filterImageView];
//        }
//    }
//    [self toggleFilterView:CGRectMake(0, kHeaderViewHeight, self.tableView.width, kFilterPullViewHeight)];
//}
//
//- (void) toggleFilterView:(CGRect)rect {
//    
//    if (self.isAdvanceFilterViewShowing == YES) {
//        
//        [self pullupFilterView];
//    }
//    else {
//        
//        [self pullDownFilterView:rect];
//    }
//}
//
//- (void) pullupFilterView {
//    
//    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
//        self.filterPullView.height = 0;
//        isAnimate = YES;
//    } completion:^(BOOL finished){
//        isAnimate = NO;
//        
//        self.filterPullView.hidden = YES;
//        [self.tableView reloadData];
//    }];
//    self.isAdvanceFilterViewShowing = NO;
//}
//
//- (void) pullDownFilterView:(CGRect)rect {
//    
//    self.filterPullView.top = kHeaderViewHeight;
//    self.filterPullView.height = 0;
//    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
//        self.filterPullView.height = rect.size.height;
//        self.filterPullView.hidden = NO;
//        isAnimate = YES;
//        
//    } completion:^(BOOL finished){
//        isAnimate = NO;
//        [self.tableView reloadData];
//        
//    }];
//    self.isAdvanceFilterViewShowing = YES;
//}
//
//- (UIView *)ihead{
//    if (!_ihead) {
//        _ihead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, kHeaderViewHeight)];
//        _ihead.backgroundColor = [UIColor TDMainBackgroundColor];
//        _ihead.clipsToBounds = YES;
//        
//        [self creatFliterView];
//        
//        _noUGCTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 93, _ihead.width, kHeaderViewHeight_NoUGC)];
//        _noUGCTipLabel.textColor = RGB(130, 130, 130);
//        _noUGCTipLabel.font = [UIFont systemFontOfSize:18.f];
//        _noUGCTipLabel.backgroundColor = [UIColor clearColor];
//        _noUGCTipLabel.textAlignment = NSTextAlignmentCenter;
//        _noUGCTipLabel.text = LocalizedString(@"抱歉，未找到筛选结果");
//        [_ihead addSubview:_noUGCTipLabel];
//        _noUGCTipLabel.hidden = YES;
//        /*
//         解决当filterPullView展开的时候此问题
//         ihead在联网成功后有 置nil，因此 需要重新添加filterPullView
//         */
///*
//        if (self.isAdvanceFilterViewShowing && (![[self.ihead subviews] containsObject:self.filterPullView])) {
//            [self.ihead addSubview:self.filterPullView];
//        }
//    }
//    return _ihead;
//}
//*/
//
//- (void)refreshNetworkDataWithKeyString:(NSString *)realString Filter:(NSDictionary *)filter ob:(NSString *)ob pg:(NSString *)pg
//{
//    [_UGCDataSource setKeyString:realString Filter:filter Ob:ob Pg:pg];
//    [_UGCDataSource.list removeAllObjects];
//    [_UGCDataSource.sortArray removeAllObjects];
//    [self addLoading];//加上
//    [_UGCDataSource load];
//}
//
//#pragma mark - TDFilterPullViewDelegate
//- (void)filterPullViewDidTapWithInfo:(NSDictionary *)info{
//
//    if (![self isAllowClickButton]) {
//        return;
//    }
//
//    /*
//     筛选按钮获取数据，控制页面不弹出 “暂无数据”框
//     */
//    hasOriginItemData = YES;
//    selectFilterValue = [NSDictionary dictionaryWithDictionary:info];
//    if ([TDAPP currentReachabilityStatus] != NotReachable) {
//        [self refreshNetworkDataWithKeyString:self.keyword Filter:info ob:sortValue pg:nil];
//    }
//    else
//    {
//        [MBProgressHUD showTextHudAddTo:self.view title:@"当前无网络连接，请检查您的网络" animated:YES afterDelayHide:0.5];
//        
//    }
//    NSMutableDictionary* analyticsParms = [@{ } mutableCopy];
//    analyticsParms[@"weburl"] = @"app";
//    analyticsParms[@"name"] = @"结果筛选";
//    analyticsParms[@"target"] = @"target_结果筛选";
//    analyticsParms[@"type"] = @"1";
//    [[NSNotificationCenter defaultCenter] postNotificationName:kAnalyticsSearchVideoResultClickLogNotif object:analyticsParms];
//}
//#pragma mark TDFilterBarDelegate
//- (void)filterBar:(TDFilterBar *)filterbar didSelectIndex:(int)index{
//
//    if (![self isAllowClickButton]) {
//        return;
//    }
//    
//    if ([TDAPP currentReachabilityStatus]==NotReachable || !_itemSortArray || _itemSortArray.count == 0) {
//        return;
//    }
//    if (filterbar.tag == kFilterBarTagOffset + 2){
//        sortValue = (self.itemSortArray[index])[@"value"];//相关性默认就是全部
//        /*
//         筛选按钮获取数据，控制页面不弹出 “暂无数据”框
//         */
//        hasOriginItemData = YES;
//        sortBarIndex = index;
//        
//        if ( [TDAPP currentReachabilityStatus] != NotReachable ) {
//            [self reloadNetWorkData:YES];
//            [self addLoading];//加上
//        }
//        else {
//            [MBProgressHUD showTextHudAddTo:self.view title:@"当前无网络连接，请检查您的网络" animated:YES afterDelayHide:0.5];
//        }
//        NSString* name = @"搜索页综合排序按钮";
//        switch (sortBarIndex) {
//            case 0:
//            {
//                name = @"搜索页综合按钮";
//                break;
//            }
//            case 1:
//            {
//                name = @"搜索页最新发布按钮";
//                break;
//            }
//            case 2:
//            {
//                name = @"搜索页最多播放按钮";
//                break;
//            }
//            default:
//                break;
//        }
//        NSMutableDictionary* analyticsParms = [@{ } mutableCopy];
//        analyticsParms[@"weburl"] = @"app";
//        analyticsParms[@"target"] = [NSString stringWithFormat:@"target_%@",name];
//        analyticsParms[@"name"] = [NSString stringWithFormat:@"%@点击",name];
//        analyticsParms[@"type"] = @"1";
//        [[NSNotificationCenter defaultCenter] postNotificationName:kAnalyticsSearchVideoResultClickLogNotif object:analyticsParms];
//    }
//}
//
//
//- (UIControl *)firstResponser
//{
//    UIControl *firstResponder = [self.view.window performSelector:@selector(firstResponder)];
//    return firstResponder;
//}
//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    //检测到 keywinDow  并隐藏
//    if ([self.firstResponser isFirstResponder]) {
//        [self.firstResponser resignFirstResponder];
//    }
//    isShowTipPopView = NO;
//    [tipPopView disappearAnimite];
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    if ([scrollView isEqual:albumClassifyScrollView]) {
//        [self handleDreciton:scrollView];
//    }
//}
//
//- (void)handleDreciton:(UIScrollView *)scrollView {
//    
//    if (scrollView.contentSize.width < scrollView.width) {
//        albumClassifyRightDirectionIcon.hidden = YES;
//    }else {
//        if (scrollView.contentOffset.x+scrollView.width  > scrollView.contentSize.width - 10) {
//            albumClassifyRightDirectionIcon.hidden = YES;
//        }
//        else{
//            albumClassifyRightDirectionIcon.hidden = NO;
//        }
//    }
//}
//- (DriectType)isSearchAlbumPerson:(NSInteger)index
//{
//    if (_albumDataSource && ![_albumDataSource hasIndex:index]) {
//        return Driect_None;
//    }
//    if ([[_albumDataSource objectAtIndex:index] isKindOfClass:[TDSearchAlbum class]]) {
//        return Driect_Album;
//    }
//    else if ([[_albumDataSource objectAtIndex:index] isKindOfClass:[TDSearchAlbumPerson class]])
//    {
//        return Driect_AlbumPerson;
//    }
//    else if ([[_albumDataSource objectAtIndex:index] isKindOfClass:[TDPodcastChannelPerson class]])
//    {
//        return Driect_Channel;
//    }
//    else{
//        return Driect_None;
//    }
//}
//
////订阅通知
//- (void)handleSub:(NSNotification*)noti
//{
//    TDSubscribeModel *subModel=(TDSubscribeModel *)noti.object;
//
//    BOOL isSub = subModel.subscribeOperation == operationCancel ? NO : YES;
//
//    //遍历全部的一般直达区
//    NSInteger i = 0;
//    for (; i < [_albumDataSource count]; i++) {
//        id searchItem = [_albumDataSource objectAtIndex:i];
//        if ([searchItem isKindOfClass:[TDSearchAlbum class]]) {
//            if (((TDSearchAlbum*)searchItem).album_id == nil) {
//                continue;
//            }
//            if ([subModel.subscribeId floatValue] == [((TDSearchAlbum*)searchItem).album_id floatValue]) {
//                ((TDSearchAlbum*)searchItem).isSubscribed = isSub;
//                break;
//            }
//        }
//        if ([searchItem isKindOfClass:[TDPodcastChannelPerson class]]) {
//            if (((TDPodcastChannelPerson*)searchItem).podcastId == nil) {
//                continue;
//            }
//            if ([subModel.subscribeId floatValue] == [((TDPodcastChannelPerson*)searchItem).podcastId floatValue]) {
//                ((TDPodcastChannelPerson*)searchItem).isSubed = isSub;
//                break;
//            }
//        }
//    }
//    [_tableView reloadData];
//}
//
//#pragma mark 直达区分类筛选
//- (void)initAlbumClassifyView
//{
//    albumClassifySelectIndex = 0;
//    albumClassifyView = [[UIView alloc] initWithFrame:CGRectMake(0,
//                                                                 TitleBar_Height,
//                                                                 self.view.height,
//                                                                 kAlbumClassifyViewHeight)];
//    albumClassifyView.backgroundColor = [UIColor whiteColor];
//    
//    TDBaseView_TwoLine *headerView = [[TDBaseView_TwoLine alloc] initWithFrame:CGRectMake(0,
//                                                                                          0,
//                                                                                          self.view.width,
//                                                                                          kAlbumClassifyViewHeight)];
//    headerView.backgroundColor = [UIColor clearColor];
//    [albumClassifyView addSubview:headerView];
//    
//    albumClassifyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kAlbumClassifyMargin,
//                                                                             0,
//                                                                             self.view.width- kAlbumClassifyMargin* 2,
//                                                                             kAlbumClassifyViewHeight)];
//    albumClassifyScrollView.delegate = self;
//    albumClassifyScrollView.scrollsToTop = NO;
//    albumClassifyScrollView.showsHorizontalScrollIndicator = NO;
//    albumClassifyScrollView.showsVerticalScrollIndicator = NO;
//    albumClassifyScrollView.backgroundColor = [UIColor clearColor];
//    [albumClassifyView addSubview:albumClassifyScrollView];
//    
//    
//    albumClassifyRightDirectionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 25,
//                                                                                    1,
//                                                                                    25,
//                                                                                    kAlbumClassifyViewHeight - 2)];
//    [albumClassifyRightDirectionIcon setHidden:YES];
//    albumClassifyRightDirectionIcon.image = Image(@"youcezhezhao.png");
//    albumClassifyRightDirectionIcon.backgroundColor = [UIColor clearColor];
//    [albumClassifyView addSubview:albumClassifyRightDirectionIcon];
//}
//- (void)creatAlbumClassifyTabs:(NSArray*)classifyArray
//{
//    __block NSInteger widthIndex = 0;
//    for (UIButton* button in [albumClassifyScrollView subviews]) {
//        [button removeFromSuperview];
//    }
//    [classifyArray enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop){
//        
//        NSInteger nameWidth = [title sizeWithFont:[UIFont systemFontOfSize:13]].width;
//        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(widthIndex, 0, nameWidth + kAlbumClassifyMargin * 4, kAlbumClassifyViewHeight);
//        [button setBackgroundColor:[UIColor clearColor]];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        button.tag = kAlbumClassifyButtonTag + idx;
//        [button setTitle:title forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,4, 0, 0)];
//        if (idx == albumClassifySelectIndex) {
//            [button setTitleColor:RGB(255, 102, 0) forState:UIControlStateNormal];
//        }
//        else
//            [button setTitleColor:RGB(121,121,121) forState:UIControlStateNormal];
//        
//        [button addTarget:self action:@selector(albumClassifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [albumClassifyScrollView addSubview:button];
//        widthIndex += nameWidth + kAlbumClassifyMargin * 4;
//    }];
//    albumClassifyScrollView.contentSize = CGSizeMake(widthIndex, kAlbumClassifyViewHeight-8);
//    if (widthIndex > self.view.width) {
//        albumClassifyRightDirectionIcon.hidden = NO;
//    }
//    else
//        albumClassifyRightDirectionIcon.hidden = YES;
//}
//
//- (NSArray*)getAlbumClassifyTitles
//{
//    NSMutableArray* titlesArray = [NSMutableArray array];
//    NSArray* albumSortTitles = [_directAllDataSource getAlbumSortTitles];
//    for (NSString* key in albumSortTitles) {
//        NSArray* itemArray = [_directAllDataSource.albumDataSource_classify objectForKey:key];
//        [titlesArray addObject:[NSString stringWithFormat:@"%@(%d)",key,(int)[itemArray count]]];
//    }
//    return titlesArray;
//}
//
//- (void)albumClassifyButtonClick:(UIButton*)button
//{
//    if (![self isAllowClickButton]) {
//        return;
//    }
//
//    NSInteger idnex = button.tag - kAlbumClassifyButtonTag;
//    
//    [(UIButton*)[albumClassifyScrollView viewWithTag:(kAlbumClassifyButtonTag + albumClassifySelectIndex)] setTitleColor:RGBS(112) forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
//    [self refreshAlbumClassifyTable:idnex];
//    [_tableView setContentOffset:CGPointZero];
//    [_tableView reloadData];
//    albumClassifySelectIndex = idnex;
//}
//
//- (void)refreshAlbumClassifyTable:(NSInteger)idnex{
//    
//    NSArray* albumSortTitles = [_directAllDataSource getAlbumSortTitles];
//    if ([albumSortTitles hasIndex:idnex]) {
//        NSString* key = albumSortTitles[idnex];
//        NSArray* itemArray = [_directAllDataSource.albumDataSource_classify objectForKey:key];
//        _albumDataSource = [NSMutableArray arrayWithArray:[itemArray mutableCopy]];
//    }
//}
//
//#pragma mark 搜索统计
//- (NSDictionary*)getFilterDataToanalytics
//{
//    NSMutableDictionary* dict = [@{} mutableCopy];
//    if (!selectFilterValue) {
//        return nil;
//    }
//    else
//    {
//        if (selectFilterValue[@"cateids"]) {
//            dict[@"S"] = selectFilterValue[@"cateids"];
//        }
//        if (selectFilterValue[@"timescope"]) {
//            dict[@"T"] = selectFilterValue[@"timescope"];
//        }
//        if (selectFilterValue[@"vtype"]) {
//            dict[@"D"] = selectFilterValue[@"vtype"];
//        }
//    }
//    return dict;
//}
//
//- (NSInteger)calculateAlbumCellHeight:(id)video{
//    if ([video isKindOfClass:[TDSearchAlbumPerson class]]) {
//        TDSearchAlbumPerson* person = (TDSearchAlbumPerson*)video;
//        if (/*[person.tabsArray count] == 1 &&*/ [person.tabsArray hasIndex:person.currentSelect - kTabsButtonTag]) {
//            TabsItem* item = person.tabsArray[person.currentSelect - kTabsButtonTag];
//            NSInteger personHeaderHeight = kHeaderViewSize.height + kTabViewSize.height ;
//            if ([item.show_type intValue]) {
//                //音乐
//                if ([item.videos count] >= 14) {
//                    return personHeaderHeight + kMusicItemViewSize.height * 7 + kLoadShowMoreHeight - 5 + 8;
//                }
//                else
//                {
//                    return personHeaderHeight + ([item.videos count] /2 + [item.videos count] %2) * kMusicItemViewSize.height + 8;
//                }
//            }
//            else{
//                //非音乐
//                if ([item.videos count] >= 4) {
//                    return personHeaderHeight + [TDSearchAlbumPersonCell oneLineHeightWithNoneMusic] * 2 + kVerticalMargin_top * 3 + kLoadShowMoreHeight + 8;
//                }
//                else
//                {
//                    return personHeaderHeight + ([item.videos count]/2 + [item.videos count]%2) * [TDSearchAlbumPersonCell oneLineHeightWithNoneMusic] + kVerticalMargin_top * 3 + 8;
//                }
//            }
//        }
//        return kSearchAlbumPersonCellSize.height + 8;
//    }
//    else
//    {
//        return kSearchAlbumPersonCellSize.height + 8;
//    }
//}

/**
 *  所有的搜索统计视频结果页 点击日志的发送处理
 *
 *  @param notif 视频点击，notif.object 是video，否则 为nil
 */

@end