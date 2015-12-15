//
//  TDSearchSeriesPannel.m
//  Tudou
//
//  Created by zhangjiwang on 13-12-17.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDSearchSeriesPannel.h"
//#import "TDSeriesTitleView.h"
//#import "TDSearchSeriesView.h"
#import "TDSearchTitleView.h"
#import "TDSearchAlbum.h"
#import "TDSearchAlbumVideoCell.h"

#define kSearchTitleViewMarginForLeftRight 0
@interface TDSearchSeriesPannel () <TdSearchTitleDelegate,UIScrollViewDelegate>{
    
//    CALayer *_leftDirectionIcon;
//    CALayer *_rightDirectionIcon;
    
}

@property (nonatomic, strong)TDSearchTitleView *searchTitleView;
@property (nonatomic, strong) UIView *searchTitleViewBorder;    //康力泉：专门给searchTitleView做的背景框（用contentInset操作起来比较麻烦）
//@property (nonatomic, strong)TDSearchSeriesView *seriesView;
@property (nonatomic, strong)UILabel *seriesTitlelabel;
@property (nonatomic,strong)NSMutableArray *totalSearchData;
@property (nonatomic)UIButton *backBtn;
@property (nonatomic) BOOL descendOrder;//正序 or 逆序
@property (nonatomic) int series_page_size;
@property (nonatomic) int totalSize;

- (void)showSeriesType:(NSInteger)type;
@end

@implementation TDSearchSeriesPannel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBS(250);
//        self.layer.borderColor = RGB(223, 223, 223).CGColor;
//        self.layer.borderWidth = 1;
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:Image(@"search_episode_back_icon") forState:UIControlStateNormal];
        [self addSubview:_backBtn];
        
        _seriesTitlelabel = [[UILabel alloc] init];
        _seriesTitlelabel.backgroundColor = [UIColor clearColor];
        _seriesTitlelabel.font = [UIFont systemFontOfSize:16.0f];
        _seriesTitlelabel.textColor = [UIColor blackColor];
        _seriesTitlelabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_seriesTitlelabel];
        
//        _leftDirectionIcon = [CALayer layer];
//        _leftDirectionIcon.backgroundColor = [UIColor whiteColor].CGColor;
//        _leftDirectionIcon.contents = (id)Image(@"search_more_episode_left_icon").CGImage;
//        [self.layer addSublayer:_leftDirectionIcon];
//        _leftDirectionIcon.hidden = YES;
//        
//        _rightDirectionIcon = [CALayer layer];
//        _rightDirectionIcon.backgroundColor = [UIColor whiteColor].CGColor;
//        _rightDirectionIcon.contents = (id)Image(@"search_more_episode_icon").CGImage;
//        [self.layer addSublayer:_rightDirectionIcon];
//        _rightDirectionIcon.hidden = YES;
    }
    return self;
}

- (void)back {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onbackClick:)]) {
        [_delegate onbackClick:self];
    }
}

- (void)showSeriesType:(NSInteger)type {
    
    switch (type) {
        case Direct_DianShiJu:
        case Direct_DongMan:
//            self.seriesView.seriesType = ksearchSeriesCover;
            self.series_page_size = SERIES_PAGE_SIZE_COVER;
            break;
        case Direct_ZongYi:
        case Direct_DianYing:
        case Direct_JiLuPian:
            case Direct_DianYingXiLie:
            case Direct_ZiXun:
//            self.seriesView.seriesType = ksearchSeriesList;
            self.series_page_size = SERIES_PAGE_SIZE_LIST;
        default:
//            self.seriesView.seriesType = ksearchSeriesList;
            self.series_page_size = SERIES_PAGE_SIZE_LIST;
            break;
    }
}
- (void)setSeriesInfo:(TDSearchAlbum *)info {
    
    _totalSearchData = [info.itemsArray mutableCopy];
    _totalSize = info.item_count;
    _descendOrder = info.is_reversed;
    [self showSeriesType:[info.cate_id integerValue]];
//    _seriesView.is_tudou = info.is_tudou;
    [self.searchTitleView createTitleWithNumber:[_totalSearchData count]
                                       PageSize:self.series_page_size
                                           desc:_descendOrder
                                       CurIndex:info.currentSelect
                                      CurOffset:info.currentOffset
                                        Items:_totalSearchData];
    [self handleDreciton:_searchTitleView];
    self.seriesTitlelabel.text = info.title;
}

- (void)refreshData:(NSInteger)page {
    
    @autoreleasepool {
        NSMutableArray *pageDataSource = [self subArrayOfArray:_totalSearchData Index:page];
//        self.seriesView.searchDataSource = [pageDataSource mutableCopy];
//        [self.seriesView reloadData];
    }
}

- (void)layoutSubviews {
    self.backBtn.frame = CGRectMake(4, 0, 35, 32);
    self.seriesTitlelabel.frame = CGRectMake((self.bounds.size.width-240)/2, 6, 250, 20);
    self.searchTitleViewBorder.frame =CGRectMake(5, 31, self.bounds.size.width - 10 , 35);
    [self.searchTitleViewBorder addSubview:self.searchTitleView];
    self.searchTitleView.frame = CGRectMake(kSearchTitleViewMarginForLeftRight, 0, self.searchTitleViewBorder.bounds.size.width - kSearchTitleViewMarginForLeftRight * 2, 35);
    CGSize size = CGSizeMake([UIScreen width],104.0/320.0*[UIScreen width]*3.0/2.0 + 7*2 + 47);
//    self.seriesView.frame = CGRectMake(5, 71, self.bounds.size.width - 10, size.height-71);
//    CGSize leftSize = Image(@"search_more_episode_left_icon").size;
//    CGSize rightSize = Image(@"search_more_episode_icon").size;
//    _leftDirectionIcon.frame = CGRectMake(kSearchMoreEpisodeIconMarginForLeftRight, 33 + (35 - leftSize.height)/2, leftSize.width, leftSize.height);
//    _rightDirectionIcon.frame = CGRectMake(self.width - Image(@"search_more_episode_icon").size.width - kSearchMoreEpisodeIconMarginForLeftRight, 33 + (35 - rightSize.height)/2 , rightSize.width, rightSize.height);
}

#pragma mark -tdSearchTitleClicked
- (void)tdSearchTitleClicked:(NSNumber *)index
                 OffSetIndex:(NSNumber *)offset
              OffsetDistance:(NSNumber *)distance
           shouldModifyIndex:(NSNumber *)should{
    
    if ([should boolValue]) {
        if (_delegate &&[_delegate respondsToSelector:@selector(onSeriesSegmentClick:Offset:)]) {
            [_delegate onSeriesSegmentClick:offset Offset:distance];
        }
    }
    [self refreshData:[index integerValue]];
}

- (NSMutableArray *)subArrayOfArray:(NSMutableArray *)TotalArray Index:(NSInteger)index {
    @autoreleasepool {
        NSMutableArray *arr = [NSMutableArray array];
        int total = (int)[TotalArray count];
        int pages = total / self.series_page_size;
        if (pages * self.series_page_size < total) {
            pages += 1;
        }
        if (_descendOrder) {
            int left = total%self.series_page_size;
            if (left == 0 && total > 0) {
                left = self.series_page_size;
            }
            if (pages-1 == index) {
                for (int i=0; i<left; i++) {
                    if ([TotalArray hasIndex:i]) {
                        [arr addObject:[TotalArray objectAtIndex:i]];
                    }
                }
            } else if (index < pages - 1) {
                for (int i = left + (pages - 1 - (int)index - 1) *self.series_page_size; i < left + (pages - 1 - (int)index) *self.series_page_size; i ++) {
                    if ([TotalArray hasIndex:i]) {
                        [arr addObject:[TotalArray objectAtIndex:i]];
                    }
                }
            }
            
        } else{
            for (int i=(int)index*self.series_page_size; i<(index+1)*self.series_page_size; i++) {
                if ([TotalArray hasIndex:i]) {
                    [arr addObject:[TotalArray objectAtIndex:i]];
                }
            }
            
        }
        return arr;
    }
}

//- (TDSearchSeriesView *)seriesView {
//    if (!_seriesView) {
//        _seriesView = [[TDSearchSeriesView alloc] initWithFrame:CGRectZero];
//        _seriesView.gridViewDelegate = self;
//        [self addSubview:_seriesView];
//    }
//    return _seriesView;
//}

-(TDSearchTitleView*)searchTitleView
{
	if (!_searchTitleView) {
		_searchTitleView = [[TDSearchTitleView alloc] initWithFrame:CGRectZero];
        _searchTitleView.searchDelegate = self;
        _searchTitleView.delegate = self;
        _searchTitleView.scrollsToTop = NO;

	}
	return _searchTitleView;
}

-(UIView *)searchTitleViewBorder
{
    if (!_searchTitleViewBorder) {
        _searchTitleViewBorder = [[UIView alloc] initWithFrame:CGRectZero];
        self.searchTitleViewBorder.layer.borderColor = RGB(217, 217, 217).CGColor;  //边框线
        self.searchTitleViewBorder.layer.borderWidth = .5f;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_searchTitleViewBorder];
    }
    return _searchTitleViewBorder;
}

#pragma mark - TdSearchGridViewDelegate 
- (void)didClickSearchGridView:(id)record {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onSeriesItemClick:)]) {
        [_delegate onSeriesItemClick:record];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[TDSearchTitleView class]]) {
        [self handleDreciton:scrollView];
    }
}

- (void)handleDreciton:(UIScrollView *)scrollView {
    
//    if (scrollView.contentSize.width < scrollView.width) {
//        _leftDirectionIcon.hidden = YES;
//        _rightDirectionIcon.hidden = YES;
//    }else {
//        if (scrollView.contentOffset.x>5) {
//            _leftDirectionIcon.hidden = NO;
//        }
//        else{
//            _leftDirectionIcon.hidden = YES;
//        }
//        if (scrollView.contentOffset.x+scrollView.width  > scrollView.contentSize.width - 10) {
//            _rightDirectionIcon.hidden = YES;
//        }
//        else{
//            _rightDirectionIcon.hidden = NO;
//        }
//        
//    }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetAllowsAntialiasing(context, false);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 42, 6);
    CGContextAddLineToPoint(context, 42, 26);
    CGContextSetRGBStrokeColor(context, 217/255.0, 217/255.0, 217/255.0, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
    
}


@end
