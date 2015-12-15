//
//  TDSearchTitleView.m
//  Tudou
//
//  Created by zhangjiwang on 13-12-20.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#define kleftMargin 10
#define KSearchTitleGap 10

#import "TDSearchTitleView.h"
#import "TDSearchAlbum.h"

@protocol SearchTitleIndex <NSObject>

- (void)searchTitleIndexClick:(NSNumber *)index Offset:(NSNumber *)offset shoudModifyModel:(NSNumber *)should;

@end
@interface TitleView : UIView

@property (nonatomic,weak) id <SearchTitleIndex> titleIndex;
@property (nonatomic) NSInteger totalSize;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger descendOrder;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger curIndex;
@property (nonatomic) float textWidth;
@property (nonatomic,strong)NSArray *mItems;
-(void)createTitleWithNumber:(NSInteger)count
                    PageSize:(NSInteger)pagesize
                        desc:(BOOL)descendOrder
                   TotalPage:(NSInteger)totalPage
                    CurIndex:(NSInteger)curIndex
                    titleWidth:(float)width
                       Items:(NSArray*)items;

@end

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _textWidth = 0;
    }
    return self;
}



-(void)createTitleWithNumber:(NSInteger)count
                    PageSize:(NSInteger)pagesize
                        desc:(BOOL)descendOrder
                   TotalPage:(NSInteger)totalPage
                    CurIndex:(NSInteger)curIndex
                   titleWidth:(float)width
                       Items:(NSArray*)items;
{
    
    _totalSize = count;
    _pageSize = pagesize;
    _descendOrder = descendOrder;
    _totalPage = totalPage;
    _textWidth = width;
    self.curIndex = _descendOrder ? _totalPage - curIndex - 1 : curIndex;
    if (_titleIndex && [_titleIndex respondsToSelector:@selector(searchTitleIndexClick:Offset:shoudModifyModel:)]) {
        [_titleIndex searchTitleIndexClick:[NSNumber numberWithInteger:self.curIndex]
                                    Offset:[NSNumber numberWithInteger:curIndex]
                          shoudModifyModel:[NSNumber numberWithBool:NO]];
    }
    //数组倒序时，调回正序
    _mItems = (descendOrder==YES)?[[items reverseObjectEnumerator] allObjects]:[NSArray arrayWithArray:items];
    
    [self setNeedsDisplay];
}

-(NSString *)configAndCalWidthatIndex:(NSInteger)index {
    if (index<0) {
        index=0;
    }
    NSInteger startIndex = index * _pageSize;
    NSInteger endIndex = (index + 1) * _pageSize-1;
    if (endIndex >= _totalSize) {
        endIndex = _totalSize-1;
    }
    NSString *startStr = [NSString stringWithFormat:@"%@",((SeriesItem*)[_mItems objectAtIndex:startIndex]).show_stage];
    NSString *endStr = [NSString stringWithFormat:@"%@",((SeriesItem*)[_mItems objectAtIndex:endIndex]).show_stage];
    NSString *title = nil;
    title  = [NSString stringWithFormat:@"%@-%@",startStr,endStr];
    return title;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Drawing code
    if (_totalSize > 0) {
        UIFont *font = [UIFont systemFontOfSize:14];
        if (_descendOrder) {
            for (int i = 0; i<_totalPage; i++) {
                NSString *text = [self configAndCalWidthatIndex:i];
//                _textWidth = [text sizeWithFont:font].width + KSearchTitleGap;
                if (i == self.curIndex) {
                    [[UIColor TDOrange] set];
                    [self drawLineWithPosition:CGPointMake((_totalPage-i-1)*_textWidth + kleftMargin, 28)
                                         Lengh:[text sizeWithFont:font].width
                                       Context:context];
                } else {
                    [RGB(102, 102, 102) set];
                }
                [text drawInRect:CGRectInset(CGRectMake((_totalPage-i-1)*_textWidth + kleftMargin, 4, _textWidth, 20), 0, 6)
                        withFont:font
                   lineBreakMode:UILineBreakModeMiddleTruncation
                       alignment:NSTextAlignmentLeft];
            }
        }else{
            for (NSInteger i = 0; i < _totalPage; ++i) {
                NSString *text = [self configAndCalWidthatIndex:i];
//                _textWidth = [text sizeWithFont:font].width + KSearchTitleGap;
                if (i == self.curIndex) {
                    [[UIColor TDOrange] set];
                    [self drawLineWithPosition:CGPointMake(i*_textWidth + kleftMargin, 28)
                                         Lengh:[text sizeWithFont:font].width
                                       Context:context];
                } else {
                    [RGB(102, 102, 102) set];
                }
                [text drawInRect:CGRectInset(CGRectMake(i*_textWidth + kleftMargin, 4, _textWidth, 20), 0, 6)
                        withFont:font
                   lineBreakMode:UILineBreakModeMiddleTruncation
                       alignment:NSTextAlignmentLeft];
            }
        }
        
        
    }
}

- (void)drawLineWithPosition:(CGPoint)position
                       Lengh:(float)lengh
                     Context:(CGContextRef)context {
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, position.x, position.y);
    CGContextAddLineToPoint(context, position.x + lengh, position.y);
    CGContextSetRGBStrokeColor(context,255/255.0, 102/255.0, 0/255.0, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    NSInteger offset = point.x / _textWidth;
    self.curIndex = _descendOrder ? _totalPage - offset - 1 : offset;
    if (offset >= _totalPage) {
        return;
    }
    if (_titleIndex && [_titleIndex respondsToSelector:@selector(searchTitleIndexClick:Offset:shoudModifyModel:)]) {
        [_titleIndex searchTitleIndexClick:[NSNumber numberWithInteger:self.curIndex]
                                    Offset:[NSNumber numberWithInteger:offset]
                          shoudModifyModel:[NSNumber numberWithBool:YES]];
    }
    [self setNeedsDisplay];
}

- (void)calculateAndClick {
    
    
}

@end

@interface TDSearchTitleView () <SearchTitleIndex>

@property (nonatomic,strong)TitleView *titleView;

@end

@implementation TDSearchTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentSize = CGSizeMake(800, 33);
        [self setBackgroundColor:[UIColor whiteColor]];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        CGRect frame = self.bounds;
        _titleView = [[TitleView alloc] initWithFrame:frame];
        _titleView.titleIndex = self;
        [self addSubview:_titleView];
    }
    return self;
}



-(void)createTitleWithNumber:(NSInteger)count
                    PageSize:(NSInteger)pagesize
                        desc:(BOOL)descendOrder
                    CurIndex:(NSInteger)curIndex
                   CurOffset:(CGFloat)curOffset
                       Items:(NSArray*)items
{
    
    NSInteger pages = count / pagesize;
    if (pages * pagesize < count) {
        pages += 1;
    }
    
    float searchTitleWidth = [self calMaxOptionViewWidth:(descendOrder==NO)?[items lastObject]:[items firstObject]];
    
    self.contentSize = CGSizeMake(searchTitleWidth*pages, 33);
    self.contentOffset = CGPointMake(curOffset, 0);
    _titleView.frame = CGRectMake(0, 0, searchTitleWidth*pages + 10,self.superview.height);
    [_titleView createTitleWithNumber:count
                             PageSize:pagesize
                                 desc:descendOrder
                            TotalPage:pages
                             CurIndex:curIndex
                                titleWidth:searchTitleWidth
                                Items:items];
}

- (float)calMaxOptionViewWidth:(SeriesItem*)lastItem
{
    NSString *text = [NSString stringWithFormat:@"%@-%@",lastItem.show_stage,lastItem.show_stage];
    return [text sizeWithFont:[UIFont systemFontOfSize:14]].width + KSearchTitleGap;
}

#pragma -mark searchTitleIndex
- (void)searchTitleIndexClick:(NSNumber *)index Offset:(NSNumber *)offset shoudModifyModel:(NSNumber *)should {
    
    if (_searchDelegate && [_searchDelegate respondsToSelector:@selector(tdSearchTitleClicked:OffSetIndex:OffsetDistance:shouldModifyIndex:)]) {
        CGFloat f = self.contentOffset.x;
        [_searchDelegate tdSearchTitleClicked:index
                                  OffSetIndex:offset
                               OffsetDistance:[NSNumber numberWithFloat:f]
                            shouldModifyIndex:should];
    }
}


- (void)layoutSubviews {
    
    CGRect f = self.bounds;
    f.origin.x = 5;
    f.origin.y = 2;
    f.size.width -= 10;
    f.size.height -= 4;
    if (self.titleView.width == 0) {
        self.titleView.frame = f;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextBeginPath(context);
    //
    //    CGContextMoveToPoint(context, 0, 0);
    //    CGContextAddLineToPoint(context, self.width, 0);
    //    CGContextAddLineToPoint(context, self.width, self.height);
    //    CGContextAddLineToPoint(context, 0, self.height);
    //    CGContextAddLineToPoint(context, 0, 0);
    //    CGContextSetStrokeColorWithColor(context, RGB(180, 180, 180).CGColor);
    //    CGContextSetLineWidth(context, 0.5);
    //    CGContextStrokePath(context);
    
}
@end
