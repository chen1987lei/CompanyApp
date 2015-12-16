//
//  TDPosterBannerView.m
//  Tudou
//
//  Created by CL7RNEC on 15/4/2.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDPosterBannerView.h"
#import "TDHomePosterBannerModel.h"
#import "TDPosterSearchBarView.h"
#import "TDScrollTouchView.h"
#import "TDPageControl.h"

#define kPAGE_MAX_COUNT 10      //最多10页
#define kPRELOAD_PAGE_COUNT	3   //一次性加载3个
#define kAUTO_SCROLL_TIME 1     //轮询1秒执行一次

@interface TDPosterView : UIImageView

@property(nonatomic, strong)TDHomePosterBannerModel *banner;
@property (nonatomic,strong) UIImageView *imgBottom;
@property (nonatomic,strong) UILabel *bottomTitleLab;
@property (nonatomic,strong) UILabel *bottomSubTitleLab;

@end

@implementation TDPosterView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        WS(weakSelf)
        //腰封
        _imgBottom=[[UIImageView alloc] init];
        [self addSubview:_imgBottom];
        [_imgBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.height.equalTo(@(162));
            make.bottom.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
        }];
        _imgBottom.image=Image(@"yaofeng_toutu");
        _imgBottom.backgroundColor=[UIColor clearColor];
        _imgBottom.hidden=YES;
        //腰封副标题
        _bottomSubTitleLab=[[UILabel alloc] init];
        [self addSubview:_bottomSubTitleLab];
        [_bottomSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.left.equalTo(@10);
            make.bottom.equalTo(weakSelf).offset(-10);
        }];
        _bottomSubTitleLab.backgroundColor=[UIColor clearColor];
        _bottomSubTitleLab.textColor=RGBS(204);
        _bottomSubTitleLab.textAlignment=NSTextAlignmentLeft;
        _bottomSubTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?14:12];
        _bottomSubTitleLab.hidden=YES;
        //腰封标题
        _bottomTitleLab=[[UILabel alloc] init];
        [self addSubview:_bottomTitleLab];
        [_bottomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf);
            make.left.equalTo(weakSelf.bottomSubTitleLab);
            make.baseline.equalTo(weakSelf.bottomSubTitleLab.mas_top).offset(-8);
        }];
        _bottomTitleLab.backgroundColor=[UIColor clearColor];
        _bottomTitleLab.textColor=RGBS(255);
        _bottomTitleLab.textAlignment=NSTextAlignmentLeft;
        _bottomTitleLab.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?17:15];
        _bottomTitleLab.hidden=YES;
    }
    return self;
}

-(void)setBanner:(TDHomePosterBannerModel *)banner
{
    if (self.height < 110.0*[UIScreen width]/320.0) {
        [self td_setImageWithURL:[NSURL URLWithString:banner.imageUrl] placeholderImage:Image(@"discovery_default-_map")];
    } else {
        [self td_setImageWithURL:[NSURL URLWithString:banner.imageUrl] placeholderImage:Image(@"shouyebanner")];
        if ([banner.title isNotBlankString]) {
            _bottomTitleLab.text=banner.title;
            _bottomSubTitleLab.text=banner.subTitle;
            _bottomTitleLab.hidden=NO;
            _bottomSubTitleLab.hidden=NO;
            _imgBottom.hidden=NO;
        }
    }
}

@end

@interface TDPosterBannerView()<UIScrollViewDelegate,TDPosterSearchBarViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TDPageControl *pageCon;
@property (nonatomic,strong) TDPosterSearchBarView *searchBar;
@property (nonatomic,strong) NSArray *bannerData;               //海报数据
@property (nonatomic,strong) NSMutableArray *curImages;         //当前滚动的三张图片
@property (nonatomic,strong) NSTimer *timer;                    //定时器
@property (nonatomic,assign) NSInteger timerCount;              //计数
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic,assign) NSInteger curPageIndex;            //当前图片索引
@property (nonatomic,assign) PosterPageType pageType;           //小圆点位置
@property CGRect scrollFrame;                                   //原始尺寸

@end

@implementation TDPosterBannerView
#pragma mark - life cycle
-(id)initWithFrame:(CGRect)frame
      withPageType:(PosterPageType)pageType{
    
    if (self=[super initWithFrame:frame]) {
        _pageType=pageType;
        _isSearchBarHidden=YES;
        _curImages=[[NSMutableArray alloc] init];
        _curPageIndex=0;
        _timerCount = 0;
        _scrollFrame=frame;
        [self createScrollView];
            if (_pageType!=posterPageNone) {
                [self createPageView];
            }
            [self createGesture];
            [self createTimer];
    }
    return self;
}

-(void)createScrollView{
    if (!_scrollView) {
        _scrollView=[[TDScrollTouchView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        _scrollView.scrollsToTop = NO;
        NSInteger count = [_bannerData count]==1?1:kPRELOAD_PAGE_COUNT;
        _scrollView.contentSize=CGSizeMake(_scrollView.width * count, _scrollView.height);
        [self addSubview:_scrollView];
    }
}

-(void)createPageView{
    if (!_pageCon) {
        _pageCon=[[TDPageControl alloc] init];
        _pageCon.currentPage=0;
        [self addSubview:_pageCon];
    }
}
/**
 *  计算page的frame
 *
 *  @return frame
 */
-(CGRect)caculatePageViewFrame{
    CGRect rect;
    NSInteger count=[_bannerData count]>kPAGE_MAX_COUNT?kPAGE_MAX_COUNT:[_bannerData count];
    float width=count*10;
    float x=0.0;
    switch (_pageType) {
        case posterPageMiddle:
            x=([UIScreen width]-width)/2;
            break;
        case posterPageRight:
            x=[UIScreen width]-width-12;
            break;
        case posterPageLeft:
            x=10;
            break;
        default:
            break;
    }
    
    rect=CGRectMake(x, self.height-16, width, 5);
    return rect;
}

-(NSInteger)caculatePageCount{
    if ([_bannerData count]==1) {
        return 0;
    }
    else{
        return [_bannerData count]>kPAGE_MAX_COUNT?kPAGE_MAX_COUNT:[_bannerData count];
    }
}

-(void)createGesture{
    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleLongPress:)];
    //长按1秒后触发事件
    _longPressGR.minimumPressDuration = 1;
    [_scrollView addGestureRecognizer:_longPressGR];
}

-(void)createTimer{
    if (_timer) {
        _timerCount = 0;
        [_timer invalidate];
    }
    _timer = [NSTimer timerWithTimeInterval:kAUTO_SCROLL_TIME target:self selector:@selector(heartStep) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self startTimer];
}

-(void)dealloc{
    [_scrollView removeGestureRecognizer:_longPressGR];
    _scrollView=nil;
    _longPressGR=nil;
    [_timer invalidate];
    _pageCon=nil;
    _timer=nil;
    _bannerData=nil;
    _curImages=nil;
    _searchBar=nil;
}
#pragma mark - set
-(void)setIsSearchBarHidden:(BOOL)isSearchBarHidden{
    _isSearchBarHidden=isSearchBarHidden;
    if (!_isSearchBarHidden) {
        //显示搜索bar
        if (!_searchBar) {
            _searchBar=[[TDPosterSearchBarView alloc] initWithFrame:CGRectMake(kPOSTER_SEARCH_MARGIN_X, self.bottom-kPOSTER_SEARCH_HEIGHT-15, kPOSTER_SEARCH_WIDTH, kPOSTER_SEARCH_HEIGHT)];
            _searchBar.delegate=self;
            [self addSubview:_searchBar];
        }
        _searchBar.hidden=NO;
    }
}
#pragma mark - action
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self pauseTimer];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        _timerCount=0;
        [self startTimer];
    }
}
#pragma mark - heart
-(void)startTimer
{
    [_timer setFireDate:[NSDate date]];
}

-(void)pauseTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)startTimerAfterWhile
{
    WS(weakself);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself startTimer];
    });
}

-(void)pauseTimerAfterWhile
{
    WS(weakself);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself pauseTimer];
    });
}

-(void)heartStep
{
    if (_curImages.count < 2){
        return;
    }
    _timerCount++;
    if (_timerCount == 6)
    {
        _timerCount = 0;
        [_scrollView setContentOffset:CGPointMake(_scrollFrame.size.width*2 , 0)animated:YES];
    } 
}
-(void)refreshPosterBanner:(NSArray *)bannerData bannerHeight:(CGFloat)height{
    self.height = height;
    [self refreshPosterBanner:bannerData];
}

#pragma mark - refresh
-(void)refreshPosterBanner:(NSArray *)bannerData{
    if (!bannerData||[bannerData count]==0) {
        return;
    }
    
    _bannerData=bannerData;
    _curPageIndex = 0;
    if (_timer) {
        [_timer invalidate];
        [self createTimer];
    }
    [self resetCurImages];
    [self refreshScrollView];
    if (_pageType!=posterPageNone) {
        [self refreshPageView];
    }
    [_searchBar refreshSearchBarWithText:_searchBartext withIconUrl:_searchBariconUrl];
}

-(void)refreshPageView{
    _pageCon.frame=[self caculatePageViewFrame];
    _pageCon.numberOfPages=[self caculatePageCount];
    if (_pageCon.numberOfPages!=0) {
        [_pageCon setCurrentPage:_curPageIndex];
    }
}

- (void)reSetFrame:(CGRect)rect{
    self.frame = rect;
    _scrollFrame = rect;
    _scrollView.frame = _scrollFrame;
}

- (void)resetCurImages{
    [_curImages removeAllObjects];
    [_scrollView removeAllSubviews];
    int size = _bannerData.count == 1 ? 1 : kPRELOAD_PAGE_COUNT;
    for (int i=0; i<size; i++) {
        TDPosterView *imageV = [[TDPosterView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_curImages addObject:imageV];
    }
}
- (void) refreshScrollView{
    NSArray *subViews = [_scrollView subviews];
    [self refreshCurrentImages];
    for (int i = 0 ; i < [_curImages count];  i++)
    {
        TDPosterView *imageV=_curImages[i];
        imageV.frame=CGRectOffset(CGRectMake(0, 0, self.width, self.height), _scrollFrame.size.width*i, 0);
        int pos;
        pos = (_curImages.count > 1) ? _scrollFrame.size.width : 0;
        [_scrollView setContentOffset:CGPointMake(pos, 0)];
        if (![subViews containsObject:imageV]) {
            //如果不存在则需要添加
            [_scrollView addSubview:imageV];
        }
    }
    //在水平方向滚动
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width * [_curImages count], _scrollView.frame.size.height);
}

- (void)refreshCurrentImages{
    int pre = [self validPageValue:self.curPageIndex - 1];    
    int last = [self validPageValue:self.curPageIndex + 1];
    TDPosterView *imageV;
    TDHomePosterBannerModel *banner;
    if (_bannerData.count >= 2) {
        imageV = [_curImages objectAtIndex:1]; //当前显示的View
        banner = [_bannerData objectAtIndex:self.curPageIndex];    //显示第一个banner
        imageV.banner = banner;
        imageV = [_curImages objectAtIndex:0];       //前一个显示的View
        banner = [_bannerData objectAtIndex:pre];    //前一个banner
        imageV.banner = banner;
        imageV = [_curImages objectAtIndex:2]; //当前显示的View
        banner = [_bannerData objectAtIndex:last];    //显示第一个banner
        imageV.banner = banner;
    }
    else if (_bannerData.count == 1) {
        imageV = [_curImages objectAtIndex:0]; //当前显示的View
        banner = [_bannerData objectAtIndex:0];    //显示第一个banner
        imageV.banner = banner;
    }
}

- (int)validPageValue:(NSInteger)value
{
    if(value == -1)
    {
        value = [_bannerData count]-1;    //value＝1为第一张，value=0为前面一张
    }
    if (value == [_bannerData count])
    {
        value = 0;
    }
    return (int)value;
}
#pragma mark - touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //海报图点击
    if (_delegate&&[_delegate respondsToSelector:@selector(posterBannerDidClickWithIndex:)]) {
        [_delegate posterBannerDidClickWithIndex:self.curPageIndex];
    }
}
#pragma mark - TDPosterSearchBarViewDelegate
-(void)searchBarDidClick{
    if (_delegate&&[_delegate respondsToSelector:@selector(searchBarDidClick:)]) {
        [_delegate searchBarDidClick:_searchBartext];
    }
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollImagesView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
    int buttonNumber = (_scrollView.contentOffset.x + self.frame.size.width /2 ) / self.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(buttonNumber * self.frame.size.width, 0)];
    [self scrollImagesView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
}

-(void)scrollImagesView:(UIScrollView *)scrollView
{
    _timerCount=0;
    int x=scrollView.contentOffset.x;
    if(x>=2*_scrollFrame.size.width) //往下翻一张
    {
        self.curPageIndex = [self validPageValue:self.curPageIndex+1];
        [self refreshScrollView];
    }
    if(x<=0)
    {
        self.curPageIndex = [self validPageValue:self.curPageIndex-1];
        [self refreshScrollView];
    }
    if (_pageType!=posterPageNone) {
        [_pageCon setCurrentPage:_curPageIndex];
    }
}

@end
