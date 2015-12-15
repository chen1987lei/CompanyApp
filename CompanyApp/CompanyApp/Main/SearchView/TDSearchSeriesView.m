//
//  TDSearchSeriesView.m
//  Tudou
//
//  Created by zhangjiwang on 13-12-17.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDSearchSeriesView.h"
#import "TDSearchAlbum.h"
#define kitemListMargin 16
#define kitemHeight (is_iphone4()||is_iphone5())?46:ceil((CGSizeMake([UIScreen width],104.0/320.0*[UIScreen width]*3.0/2.0 + 7*2 + 47).height-76.0)/3.0)
#define ktextLeftalaign 10
#define ktextheight 16

@interface SearchCellItem : UIView
{
    BOOL enabled;
    BOOL isSelected;
}

@property (nonatomic, strong) SeriesItem *item;
@property (nonatomic) BOOL is_tudou;
@property (nonatomic) NSInteger index;
@property (nonatomic) SearchSeriesType type;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *grayLine;
@property (nonatomic, strong) UIImageView *trailerView;
@end

@implementation SearchCellItem
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
		[self setBackgroundColor:[UIColor whiteColor]];
//        [self.layer setBorderWidth:1];
//        [self.layer setCornerRadius:3];
//        [self.layer setBorderColor:RGBS(234).CGColor];
        
    }
    return self;
}

- (UILabel*)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = RGBS(102);
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)trailerView{
    if (!_trailerView) {
        _trailerView = [[UIImageView alloc] init];
        _trailerView.image = Image(@"media_ic_detail_trailer");
        _trailerView.frame = CGRectMake(self.width-15, 0, 15, 15);
        _trailerView.hidden = YES;
        [self addSubview:_trailerView];
    }
    return _trailerView;
}

- (UIView*)grayLine{
    if (!_grayLine) {
        _grayLine = [[UIView alloc] init];
        _grayLine.backgroundColor = [UIColor lightGrayColor];
        _grayLine.frame = CGRectMake((self.width-15)/2.0, self.height/2.0, 15, 1);
        _grayLine.hidden = YES;
        [self addSubview:_grayLine];
    }
    return _grayLine;
}
- (void)drawRect:(CGRect)rect {

    if (_textLabel) {
        _textLabel.text = nil;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.width, 0);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextAddLineToPoint(context, 0, self.height);
    if (_type == ksearchSeriesCover) {
        if (_index % 5 == 0) {
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, self.height);
        }
        if (_index <= 4) {
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, self.width, 0);
        }
    } else {
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, self.height);
        if (_index == 0) {
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, self.width, 0);
        }
    }
    CGContextSetRGBStrokeColor(context, 217/255.0, 217/255.0, 217/255.0, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *color;
    if (_type == ksearchSeriesList) {
        if (_is_tudou) {
//            if ([_item.item_id integerValue] == 0) {
//                color = RGBS(170);
//            }
//            else
                color = RGBS(148);
            
        } else {
//            if (!_item.url) {
//                color = RGBS(193);
//            }
//            else
                color = RGBS(148);
        }
        if (![_item.item_id isNotBlankString] && ![_item.url isNotBlankString]) {
            color = [UIColor lightGrayColor];
            self.grayLine.hidden = NO;
        }else {
            self.grayLine.hidden = YES;
        }
        [color set];
        NSString *seq = _item.show_seq;
        CGSize size = [seq sizeWithFont:font constrainedToSize:CGSizeMake(200, ktextheight) lineBreakMode:NSLineBreakByWordWrapping];
        [seq drawInRect:CGRectMake(ktextLeftalaign, (self.height-size.height)/2.0, size.width, size.height)
               withFont:font
          lineBreakMode:NSLineBreakByTruncatingTail
              alignment:NSTextAlignmentLeft];
//        self.grayLine.top =
        if (_is_tudou) {
//            if ([_item.item_id integerValue] == 0) {
//                color = RGBS(170);
//            }
//            else
                color = RGBS(102);
            
        } else {
//            if (!_item.url) {
//                color = RGBS(170);
//            }
//            else
                color =RGBS(102);
        }
        [color set];
        NSString *text = _item.title;
        
        //fix bug 19921 奇怪的问题 暂时这样处理
        CGSize textSize = TD_TEXTSIZE(text, font);
        CGRect constRect = CGRectMake(size.width + 10 + ktextLeftalaign, (self.height-ktextheight)/2.0, rect.size.width - size.width - 20,ktextheight);
        if (textSize.width > constRect.size.width) {
            self.textLabel.frame = constRect;
            self.textLabel.text = text;
        }else{
            [text drawInRect:constRect
                    withFont:font
               lineBreakMode:NSLineBreakByTruncatingTail
                   alignment:NSTextAlignmentLeft];
        }
        
        
    } else {
        if (_is_tudou) {
//            if ([_item.item_id integerValue] == 0) {
//                color = RGBS(193);
//            }
//            else
                color =RGB(102, 102, 102);
            
        } else {
//            if (_item.url) {
//                color = RGBS(193);
//            }
//            else
                color =RGB(102, 102, 102);
        }
        if (![_item.item_id isNotBlankString] && ![_item.url isNotBlankString]) {
            color = [UIColor lightGrayColor];
            self.grayLine.hidden = NO;
        }else {
            self.grayLine.hidden = YES;
        }
        [color set];
        NSString *text = _item.show_stage;
        CGRect adjustRect = CGRectZero;
        if (is_iphone5()||is_iphone4()) {
            adjustRect = CGRectInset(rect, 0, 15);
        }else {
            if (is_iphone6() && is_iphone_scale_mode()) {
                adjustRect = CGRectInset(rect, 0, 15);
            }else if (is_iphone6Plus() && !is_iphone_scale_mode()){
                adjustRect = CGRectInset(rect, 0, 24);
            }else{
                adjustRect = CGRectInset(rect, 0, 20);
            }
        }
        [text drawInRect:adjustRect
                withFont:font
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentCenter];
    }
    
    self.trailerView.hidden = !_item.isTrailer;
}

@end

@interface TDSearchSeriesView () <GMGridViewDataSource, GMGridViewActionDelegate> {
    
    double _columWidth;
}

@end

@implementation TDSearchSeriesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _columWidth = 50;
        self.actionDelegate = self;
        self.dataSource = self;
        self.centerGrid = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.directionalLockEnabled = YES;
        self.exclusiveTouch = YES;
        self.multipleTouchEnabled = YES;
        self.scrollEnabled = NO;
        self.itemSpacing = 0;
		self.showsHorizontalScrollIndicator = NO;
        self.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)reloadData
{
	[super reloadData];
}


#pragma mark Protocol GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_searchDataSource count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(_columWidth, kitemHeight);
}
- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{

    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    TDGridViewCell *cell = (TDGridViewCell *)[gridView dequeueReusableCell];
    if (!cell)
    {
        cell = [[TDGridViewCell alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.layer.masksToBounds = NO;
        cell.contentView = view;
        
        SearchCellItem *itemView = [[SearchCellItem alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
         itemView.tag = 1000;
        [cell.contentView addSubview:itemView];
    }
    SearchCellItem *cellView = (id)[cell.contentView viewWithTag:1000];
    cellView.width = size.width;
    if ([_searchDataSource hasIndex:index]) {
        cellView.item = self.searchDataSource[index];
        cellView.is_tudou = _is_tudou;
        cellView.index = index;
        cellView.type = _seriesType;
        [cellView setNeedsDisplay];
    }
    return cell;
}


#pragma mark Protocol GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    SearchCellItem *itemBtn = nil;
    UIView *contentView = [gridView cellForItemAtIndex:position].contentView;
    
    for (UIView *view in [contentView subviews]) {
        if ([view isKindOfClass:[SearchCellItem class]]) {
            itemBtn = (SearchCellItem *)view;
        }
    }
    if ((!itemBtn.item.item_id || itemBtn.item.item_id.length==0)  && (!itemBtn.item.url || itemBtn.item.url.length==0)) {
        return;
    }
    if (_gridViewDelegate && [_gridViewDelegate respondsToSelector:@selector(didClickSearchGridView:)]) {
        if ([_searchDataSource hasIndex:position]) {
            [_gridViewDelegate didClickSearchGridView:[_searchDataSource objectAtIndex:position]];
        }
    }
}

- (void)setSeriesType:(SearchSeriesType)seriesType {
    _seriesType = seriesType;
    if (ksearchSeriesCover == seriesType) {
        _columWidth = self.width/5.0;
    } else if (ksearchSeriesList == seriesType) {
        _columWidth = self.width;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
