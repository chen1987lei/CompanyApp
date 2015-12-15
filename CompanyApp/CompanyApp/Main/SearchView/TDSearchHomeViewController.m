//
//  TDSearchHomeViewController.m
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//
#import "TDSearchHomeViewController.h"
#import "SearchHistory.h"

#import "TDLabel.h"
#import "EmptyView.h"

/*
 * 搜索热词
 */
@interface TDSearchHomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger           hotCellHeight;//搜索热词总的高度
    SearchType          searchType;
}
@property (nonatomic, strong) NSDictionary   *dataSource_suggest;
@property (nonatomic, strong) NSMutableArray *cellArray_video;
@property (nonatomic, strong) NSMutableArray *cellArray_channel;
@property (nonatomic, strong) NSMutableArray *cellArray_searchHistory;//存储搜索历史button
@property (nonatomic, strong) NSMutableArray *dataSource_video;//存储网络返回的源,s视频
@property (nonatomic, strong) NSMutableArray *dataSource_channel;//存储网络返回的源,频道

@property (nonatomic, strong) NSMutableArray *dataSource_searchHistory;//存储搜索历史

@property (nonatomic, strong) EmptyView    *emptyView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) BOOL hasRecommendData;
@end

@implementation TDSearchHomeViewController

#define kLeftMargin             10
#define kHotButtonBetweenMargin  7
#define khotWordsCellNumber     6
#define kSearchHistoryNumber    12

#define kHotButtonTag        1000
#define kHotButtonHeight     35
#define KHeaderViewHeight    44
#define kHotButtonWidth      ([UIScreen width] - 2*kLeftMargin - (kButtonCountPerLine-1)*kHotButtonBetweenMargin)/3.0
#define kButtonCountPerLine  3

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchType = SearchType_VIDEO;
        _cellArray_video  = [NSMutableArray array];
        _cellArray_channel  = [@[] mutableCopy];
        _dataSource_video = [@[] mutableCopy];
        _dataSource_channel = [@[] mutableCopy];
        _cellArray_searchHistory = [@[] mutableCopy];
        _dataSource_suggest = @{};
        
        _dataSource_searchHistory = [@[] mutableCopy];
        
        _hasRecommendData = NO;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor TDMainBackgroundColor];
    self.view.frame = CGRectMake(0, TitleBar_Height, self.view.width, self.view.height - TitleBar_Height);
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.emptyView];
    self.emptyView.hidden = YES;
//    [self.view addSubview:self.scrollView];
//    [self addPullRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchTypeChange:)
                                                 name:KSearchTypeChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchHistoryDidChange:)
                                                 name:SearchHistoryDidChangeNotification
                                               object:nil];
    [self getSearchHistory];
    
//    self.historyLayoutView.backgroundColor = [UIColor yellowColor];
//    [self refreshNetworkData];
//    [self addLoading];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.cancelsTouchesInView = NO; 
    [self.view addGestureRecognizer:tap];
    
    if ([self hasHistoryData]) {
        WS(weakself);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself showKeyboard];
        });
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //    self.dataSource_video = nil;
    //    self.dataSource_channel = nil;
    //    self.scrollView = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.width,
                                                                   self.view.height)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollsToTop = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = RGBS(245);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initOtherStyleWithFrame:self.tableView.frame];
        _emptyView.emptyString = @"暂无数据";
    }
    return _emptyView;
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        //new一个scrollview 是为支持下拉刷新
        _scrollView = [[UIScrollView alloc] initWithFrame:_tableView.frame];
        [_scrollView setContentSize:CGSizeMake(_tableView.width, _tableView.height+1)];
    }
    return _scrollView;
}


- (void)addPullRefresh
{
    __weak __typeof(self)weakSelf = self;
//    [self.scrollView addPullToRefreshWithActionHandler:^{
//        [weakSelf performSelector:@selector(delayRefresh) withObject:nil afterDelay:1];
//    }];
}
- (BOOL)hasHistoryData{
    if (_dataSource_searchHistory && _dataSource_searchHistory.count > 0) {
        return YES;
    }
    return NO;
}
#pragma mark - loadData
- (void)delayRefresh{
    [self refreshNetworkData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if ([self hasHistoryData] && _hasRecommendData) {
        if (section==0) {
            headerView = [self getHistoryHeaderView];
        }else if (section==1){
            headerView = [self getRecommendHeaderView];
        }
    }else if ([self hasHistoryData]){
        if (section==0) {
            headerView = [self getHistoryHeaderView];
        }
    }else if (_hasRecommendData){
        if (section==0) {
            headerView = [self getRecommendHeaderView];
        }
    }
    return headerView;
}

- (UIView *)getHistoryHeaderView{
    
    UIView*  headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KHeaderViewHeight)];
    headerView.backgroundColor = RGBS(245.0);
    
    NSString *text = @"历史搜索";
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    
    TDLabel* label = [[TDLabel alloc] initWithFrame:CGRectMake(kLeftMargin,0,60,KHeaderViewHeight-9)];

    label.text = text;
    label.textColor = RGB(255, 102, 0);
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.verticalAlignment = VerticalAlignmentBottom;
    [headerView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(headerView.width - 110, 0, 100, headerView.height);
    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:RGBS(128.0) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor TDOrange] forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [headerView addSubview:button];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = Image(@"ic_search_delete");
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.right.equalTo(button.titleLabel.mas_left).offset(-5);
    }];
    
    return headerView;

}

- (UIView *)getRecommendHeaderView{
    UIView*  headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KHeaderViewHeight)];
    headerView.backgroundColor = RGBS(245.0);
    
    NSString *text = @"大家都在看";
    UIFont *font = [UIFont boldSystemFontOfSize:14.0];
    
    TDLabel* label = [[TDLabel alloc] initWithFrame:CGRectMake(kLeftMargin,0,120,KHeaderViewHeight-9)];
    
    label.text = text;
    label.textColor = RGB(255, 102, 0);
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.verticalAlignment = VerticalAlignmentBottom;
    [headerView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, headerView.height-0.5, headerView.width-20, 0.5)];
    lineView.backgroundColor = RGBS(204);
    [headerView addSubview:lineView];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger index = 0;
    if ([self hasHistoryData]) {
        index ++;
    }
    if (_hasRecommendData) {
        index ++;
    }
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasHistoryData] && _hasRecommendData) {
        if (section==0 || section==1) {
            return 1;
        }
    }else if ([self hasHistoryData]){
        if (section==0) {
            return 1;
        }
    }else if(_hasRecommendData){
        if (section==0) {
            return 1;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return kHotButtonHeight + 5;
    NSInteger section = indexPath.section;
    CGFloat height = 0.0;
   /*
    if ([self hasHistoryData] && _hasRecommendData) {
        if (section==0) {
            height = [TDHotWordLayoutView calHeight:_dataSource_searchHistory maxWidth:self.view.width];
        }else {
            height = self.recommendViewController.tableView.height;
        }
    }else if ([self hasHistoryData]){
        if (section==0) {
            height = [TDHotWordLayoutView calHeight:_dataSource_searchHistory maxWidth:self.view.width];
        }
    }else if(_hasRecommendData){
        if (section==0) {
            height = self.recommendViewController.tableView.height + 60;//设计要求留白60
        }
    }
    */
    
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    if ([self hasHistoryData] && _hasRecommendData) {
        if (section==0) {
            cell = [self getHistoryCell:tableView];
        }else {
            cell = [self getRecommendCell:tableView];
        }
    }else if ([self hasHistoryData]){
        if (section==0) {
            cell = [self getHistoryCell:tableView];
        }
    }else if(_hasRecommendData){
        if (section==0) {
            cell = [self getRecommendCell:tableView];
        }
    }

    return cell;
}

- (UITableViewCell*)getHistoryCell:(UITableView*)tableView{
    static NSString *cellIdentifier = @"historyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor TDMilkWhite];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.exclusiveTouch = YES;
    }
    return cell;
}

- (UITableViewCell*)getRecommendCell:(UITableView*)tableView{
    static NSString *cellIdentifier = @"recommendCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.backgroundColor = RGBS(245);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.exclusiveTouch = YES;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if ([self hasHistoryData] && _hasRecommendData) {
        if (section==0) {
            [self refreshHistoryLayoutView];
        }
    }else if ([self hasHistoryData]){
        if (section==0) {
            [self refreshHistoryLayoutView];
        }
    }
}

- (void)refreshHistoryLayoutView{
    
}

- (void)refreshUI
{
    if (![self hasHistoryData] && !_hasRecommendData) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
    [_tableView reloadData];
}

- (void)refreshNetworkData
{
//    if ([self.delegate respondsToSelector:@selector(    searchHomeRefreshDataTaped)]) {
//        [self.delegate searchHomeRefreshNetworkDataFailed];
//    }

    
}

- (void)searchTypeChange:(NSNotification*)ntf
{
    if ([ntf.object isKindOfClass:[NSNumber class]]) {
        NSNumber* type = ntf.object;
        searchType = [type intValue];
        [self refreshUI];
    }
}

- (void)getSearchHistory
{
    WS(weakself);
    
    [SearchHistory getSearchHistory:^(NSArray *array, BOOL success) {
        if ([array count] > 0) {
//            //注意range不要越界
//            self.dataSource_searchHistory = [NSMutableArray arrayWithArray:([array count] > kSearchHistoryNumber ? [array subarrayWithRange:NSMakeRange(0,kSearchHistoryNumber)] : array)];
            [weakself.dataSource_searchHistory removeAllObjects];
            NSInteger count = ([array count] > kSearchHistoryNumber)?kSearchHistoryNumber:[array count];
            for (int i= 0; i<count ; i++) {
                SearchHistory *history = array[i];
                /*
                HotWordInfo * info = [[HotWordInfo alloc] init];
                info.title = history.title;
                info.imageType = [history.typeSearch intValue];
                [weakself.dataSource_searchHistory addObject:info];
                 */
                
            }
        }
        else
            weakself.dataSource_searchHistory = [NSMutableArray array];
        
//        [weakself.tableView reloadData];
    }];
}
#pragma mark - TDWatchRecommendViewControllerDeleate
- (void)successReuqestData{
    _hasRecommendData = YES;
    [self refreshUI];

}

- (void)failedRequestData{
    if (![self hasHistoryData] && !_hasRecommendData) {
        self.emptyView.hidden = NO;
//fix bug 27019
//        if ([self.firstResponser isFirstResponder]) {
//            [self.firstResponser resignFirstResponder];
//        }
    }else{
        self.emptyView.hidden = YES;
    }
 }

#pragma mark - TDHotWordLayoutViewDelegate


- (void)hotWordsCellDidClick:(UIButton *)cell
{
    NSArray* array = searchType == SearchType_VIDEO ? _dataSource_video:_dataSource_channel;
    [SearchHistory addHistory:[array objectAtIndex:(cell.tag - kHotButtonTag)] type:searchType];
    
    if([self.delegate respondsToSelector:@selector(didclickKeyword:searchType:)])
    {
        [self.delegate didclickKeyword:[array objectAtIndex:(cell.tag - kHotButtonTag)] searchType:searchType];
    }
}

- (void)clearAll
{
    UIAlertView * alert = [UIAlertView alertViewWithTitle:@"确定删除所有记录吗？"
                                                  message:nil
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:[NSArray arrayWithObject:@"确定"]
                                                onDismiss:^(int buttonIndex)
                           {
                               [SearchHistory clearAllRecords];
                               [self getSearchHistory];
                               [self refreshUI];
                           } onCancel:nil];
    [alert show];
}

/**
 *  更新搜索历史界面
 *
 *  @param ntf 消息
 */
- (void)searchHistoryDidChange:(NSNotification*)ntf
{
    [self getSearchHistory];
    [self refreshUI];
}

- (UIControl *)firstResponser
{
    UIControl *firstResponder = [self.view.window performSelector:@selector(firstResponder)];
    return firstResponder;
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.firstResponser isFirstResponder]) {
        [self.firstResponser resignFirstResponder];
    }
}

- (void)setTableViewContentOffSetZero
{
    [_tableView setContentOffset:CGPointZero];
}

- (void)tapped:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(resignKeyboard)]) {
        [_delegate resignKeyboard];
    }
}

- (void)showKeyboard
{
    if (_delegate && [_delegate respondsToSelector:@selector(showKeyboard)]) {
//        [_delegate showKeyboard];
    }
}

@end
