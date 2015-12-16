//
//  TDBannerCollectionView.m
//  Tudou
//
//  Created by chenlei on 15/7/15.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDBannerCollectionView.h"

#import "TDBannerCollectionViewCell.h"
#import "TDHomePosterBannerModel.h"

//#import "UIView+SDExtension.h"
//#import "TAPageControl.h"

NSString * const ID = @"cycleCell";

@interface TDBannerCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
//@property (nonatomic, weak) TAPageControl *pageControl;

@property (nonatomic, strong) NSArray *bannerData;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGR;

@end

#define kAUTO_SCROLL_TIME 1     //轮询1秒执行一次
@implementation TDBannerCollectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pageControlAliment = TDCycleScrollViewPageContolAlimentCenter;
        _autoScrollTimeInterval = kAUTO_SCROLL_TIME;
        [self setupMainView];
        
        [self createGesture];
    }
    return self;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup
{
    TDBannerCollectionView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imagesGroup = imagesGroup;
    return cycleScrollView;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _flowLayout.itemSize = self.frame.size;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor lightGrayColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[TDBannerCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setImagesGroup:(NSArray *)imagesGroup
{
    _imagesGroup = imagesGroup;
    _totalItemsCount = imagesGroup.count +1;//* 100;
    
    [self setupTimer];
    [self setupPageControl];
}

- (void)setupPageControl
{
//    TAPageControl *pageControl = [[TAPageControl alloc] init];
//    pageControl.numberOfPages = self.imagesGroup.count;
//    [self addSubview:pageControl];
//    _pageControl = pageControl;
}


-(void)reloadBannerImagesData:(NSArray *)images andTitles:(NSArray *)titles andBottomtitles:(NSArray *)bottomTitles
{
    self.imagesGroup = images;
    self.titlesGroup = titles;
    self.bottomTitlesGroup = bottomTitles;
    [_mainView reloadData];
}

-(void)refreshPosterBanner:(NSArray *)bannerData
{
    self.bannerData = bannerData;
    self.imagesGroup = bannerData;
    
    _totalItemsCount = self.bannerData.count +1;//* 100;
    [_mainView reloadData];
}

- (void)automaticScroll
{
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    //    if (targetIndex == _totalItemsCount) {
    //        targetIndex =  _totalItemsCount * 0.5;
    //        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //    }
    
    if (targetIndex == _totalItemsCount) { //当前是末位补加的
        targetIndex = 1;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


-(void)createGesture{
    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(handleLongPress:)];
    //长按1秒后触发事件
    _longPressGR.minimumPressDuration = 1;
    [self addGestureRecognizer:_longPressGR];
}

#pragma mark - action
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self pauseTimer];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        //_timerCount=0;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;
    //    if (_mainView.contentOffset.x == 0) {
    //        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //    }

    
    
//    CGSize size = [_pageControl sizeForNumberOfPages:self.imagesGroup.count];
//    CGFloat x = (self.width - size.width) * 0.5;
//    if (self.pageControlAliment == TDCycleScrollViewPageContolAlimentRight) {
//        x = self.mainView.width - size.width - 10;
//    }
//    CGFloat y = self.mainView.height - size.height - 10;
//    _pageControl.frame = CGRectMake(x, y, size.width, size.height);
//    [_pageControl sizeToFit];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    long itemIndex = indexPath.item % self.imagesGroup.count;
    
    TDHomePosterBannerModel *banner =[self.bannerData objectAtIndex:itemIndex];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:banner.imageUrl] placeholderImage:Image(@"shouyebanner")];
   
    if ([banner.title isNotBlankString]) {
         cell.titleLabel.text = banner.title;
//         cell.bottomTitleLabel.text =  banner.subTitle;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
//        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagesGroup.count];
//    }
    
    
    if (_delegate&&[_delegate respondsToSelector:@selector(posterBannerDidClickWithIndex:)]) {
        [_delegate posterBannerDidClickWithIndex:indexPath.item % self.imagesGroup.count];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int itemIndex = (scrollView.contentOffset.x + self.mainView.sd_width * 0.5) / self.mainView.sd_width;
//    int indexOnPageControl = itemIndex % self.imagesGroup.count;
//    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [_timer invalidate];
//    _timer = nil;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    //    if (targetIndex == _totalItemsCount) {
    //        targetIndex =  _totalItemsCount * 0.5;
    //        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    //    }
    
    if (targetIndex == _totalItemsCount) { //当前是末位补加的
        targetIndex = 1;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    
    [self startTimer];
}


@end
