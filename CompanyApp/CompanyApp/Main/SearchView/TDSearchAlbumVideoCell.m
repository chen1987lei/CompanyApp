//
//  TDSearchAlbumVideoCell.m
//  Tudou
//
//  Created by weiliang on 13-12-9.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDSearchAlbumVideoCell.h"
#import "TDMultiplyLable.h"
#import "TDSearchSeriesPannel.h"
#import "TDBorderView.h"
#import "TDLabel.h"

#define kHorizontalMargin 0
#define kVerticalMargin_top 0
#define kVerticalMargin_bottom 7.5

#define kBackgroundHorizontalMargin 6
#define kBackgroundVerticalMargin 10

#define kTitleLeftMargin 10
#define kTitleTopMargin 10
#define kTitleLableHeight 35
#define kDescLabelHeight 15
#define kStripe_topLabelHeight 20
#define kdescLabelScoreWidth 50
#define kAlbumVideoCoverWidth 104.0/320.0*[UIScreen width]
#define kAlbumVideoCoverHeight kAlbumVideoCoverWidth*3.0/2.0
#define kAlbumVideoCoverSize  CGSizeMake(kAlbumVideoCoverWidth,kAlbumVideoCoverHeight)

#define kViewSize CGSizeMake([UIScreen width],kAlbumVideoCoverHeight + kTitleTopMargin*2 + kView1Height + 10)

#define kSiteIDTitleDefaultSize CGSizeMake(40,20)

#define KCornerImageWidth 37

@interface KSearchButton : UIButton{
    
    CALayer *leftLine;
    
    CALayer *rightLine;
    
    CALayer *topLine;
    
    CALayer *bottomLine;
    
    BOOL isInitial;

}
@end

@implementation KSearchButton

- (id)init{
    self = [super init];
    if (self) {
//        self.layer.shouldRasterize = YES;
        isInitial = NO;
    }
    return self;
}

//画0.5线在5、6、plus上会出各种问题，暂由layer代替
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!isInitial) {
        leftLine = [[CALayer alloc] init];
        
        rightLine = [[CALayer alloc] init];
        
        topLine = [[CALayer alloc] init];
        
        bottomLine = [[CALayer alloc] init];
        
        leftLine.frame = CGRectMake(0, 0, 0.5, self.height);
        rightLine.frame = CGRectMake(self.width, 0, 0.5, self.height);
        topLine.frame = CGRectMake(0, 0, self.width , 0.5);
        bottomLine.frame = CGRectMake(0, self.height, self.width, 0.5);
        
        leftLine.backgroundColor =
        rightLine.backgroundColor =
        topLine.backgroundColor =
        bottomLine.backgroundColor =
        RGBA(180, 180, 180, 0.3).CGColor;
        
        [self.layer addSublayer:leftLine];
        [self.layer addSublayer:rightLine];
        [self.layer addSublayer:topLine];
        [self.layer addSublayer:bottomLine];
        
        isInitial = YES;
    }

}

//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(context);
//    
//    CGContextSetRGBStrokeColor(context, 180/255.0, 180/255.0, 180/255.0, 1);
//    
//    CGContextSetLineWidth(context, 0.5);
//    
////    CGContextMoveToPoint(context, self.width, 0);
////    CGContextAddLineToPoint(context, self.width, self.height);
////    CGContextAddLineToPoint(context, 0, self.height);
////    if (self.tag == 0) {
////        CGContextMoveToPoint(context, 0, 0);
////        CGContextAddLineToPoint(context, 0, self.height);
////    }
////    if (self.tag <= 4 || self.tag == Button_More ) {
////        CGContextMoveToPoint(context, 0, 0);
////        CGContextAddLineToPoint(context, self.width, 0);
////    }
//    
//    CGContextSetShouldAntialias(context, YES);
//
//    CGContextMoveToPoint(context, 0, 0);
//
//    CGContextAddLineToPoint(context, (int)self.width, 0);
//    
//    CGContextAddLineToPoint(context, (int)self.width, self.height);
//    
//    CGContextAddLineToPoint(context, 0, self.height);
//    
////    CGContextAddLineToPoint(context, 0.5, 0.5);
//
////    CGContextMoveToPoint(context, 0, 0);
////    CGContextAddLineToPoint(context, self.width, 0);
//
//    if (self.tag == 0) {
//        CGContextMoveToPoint(context, 0, 0);
//        CGContextAddLineToPoint(context, 0, self.height);
//    }
//    
//    CGContextStrokePath(context);
//    
//}

@end


@interface TDSearchAlbumVideoCell() <TdSearchPannelDelegate>
{
    UIActivityIndicatorView* _indicator;
}
@property (nonatomic, strong)   UIImageView     * bgImageView;//海报
@property (nonatomic, strong)   UIImageView     * cornerImageView;//海报右上角 会员角标

@property (nonatomic, strong)   UIView      * BGView;
@property (nonatomic, strong)   TDLabel     * titleLabel;
@property (nonatomic, strong)   UILabel     * descLabel1;
@property (nonatomic, strong)   UILabel     * descLabel2;
@property (nonatomic, strong)   UILabel     * descLabel3;
@property (nonatomic, strong)   TDMultiplyLable     * descLabelVV;
@property (nonatomic, strong)   UILabel     * descLabel4;
@property (nonatomic, strong)   TDLabel     * descLabelScore;//评分_整数部分
@property (nonatomic, strong)   TDLabel     * descLabelScore_fdecimal;//小数
@property (nonatomic, strong)   TDLabel     * descLabelScore_fen;//分
@property (nonatomic, strong)   UIImageView     * stripe_topLabelBackground;//封面图片上的文字背景
@property (nonatomic, strong)   UILabel     * stripe_topLabel;//封面图片上的文字描述

@property (nonatomic, strong)   UIImageView     * siteImageIco;
@property (nonatomic, strong)   UILabel         * siteNameLabel;

@property (nonatomic, strong)   UIButton     * playButton;

@property (nonatomic, strong)   UIView      * view1;//剧集，点击播放，综艺等得按钮view

@property (nonatomic, strong)   UIView      * view2;//剧集等展开后的view
@property(nonatomic,assign)     CGSize kAlbumButtonSize;

@property (nonatomic, strong)   TDSearchSeriesPannel *seriesView;//剧集view

@property (nonatomic, assign)   CateId   DirectType;
@property (nonatomic, strong)   NSArray*   site_ID_Array;
@end

@implementation TDSearchAlbumVideoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if (is_iphone4() || is_iphone5()) {
            _kAlbumButtonSize = CGSizeMake(61.5f,43);
        }else if (is_iphone6() || is_iphone6Plus() || is_iphone6S() || is_iphone6SPlus()){
            _kAlbumButtonSize = CGSizeMake(ceil(([UIScreen width] - 2.0*kBackgroundHorizontalMargin)/5.0),43.5f);
        }else {
            _kAlbumButtonSize = CGSizeMake(ceil(([UIScreen width] - 2.0*kBackgroundHorizontalMargin)/5.0),43.5f);
        }
        [self initCellView];
        [self creatView2];
        self.clipsToBounds = YES;
    }
    return self;
}

+ (float)height
{
    return kViewSize.height + kVerticalMargin_bottom;
    //kAlbumVideoCoverSize.height + kBackgroundVerticalMargin*2 + kView1Height + kVerticalMargin_bottom;
}

- (CGRect)subScribeButtonRect
{
    if (_subscribeButton) {
        return _subscribeButton.frame;
    }
    return CGRectZero;
}

//初始化 cell视图
-(void)initCellView{
    _BGView = [[UIView alloc] init];
    _BGView.frame = CGRectMake(kHorizontalMargin, kVerticalMargin_top, kViewSize.width, kViewSize.height);
    _BGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_BGView];
    
    //节目Cover图片
    UIImage * image = [UIImage imageWithTudouVeritcal];
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    _bgImageView = [[UIImageView alloc] initWithImage:image];
    _bgImageView.frame = CGRectMake(kBackgroundHorizontalMargin, kBackgroundVerticalMargin, kAlbumVideoCoverSize.width, kAlbumVideoCoverSize.height);
    [_BGView addSubview:_bgImageView];
    
    //节目名称
    _titleLabel = [[TDLabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = RGB(41,44,51);
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.verticalAlignment = VerticalAlignmentTop;
    _titleLabel.numberOfLines = 2;
    _titleLabel.frame = CGRectMake(_bgImageView.right + kTitleLeftMargin, 14, [UIScreen width]/2-30, kTitleLableHeight + 5);
    [_BGView addSubview:_titleLabel];
 
    //评分
    _descLabelScore = [[TDLabel alloc] init];
    _descLabelScore.textColor = RGB(255,117,0);
    _descLabelScore.backgroundColor = [UIColor clearColor];
    _descLabelScore.verticalAlignment = VerticalAlignmentTop;
    _descLabelScore.font = [UIFont systemFontOfSize:19];
    _descLabelScore.frame = CGRectMake(_BGView.width - kdescLabelScoreWidth-6, _titleLabel.top-2, kdescLabelScoreWidth, kTitleLableHeight);
    [_BGView addSubview:_descLabelScore];
    
    _descLabelScore_fdecimal = [[TDLabel alloc] init];
    _descLabelScore_fdecimal.textColor = RGB(255,117,0);
    _descLabelScore_fdecimal.verticalAlignment = VerticalAlignmentTop;
    _descLabelScore_fdecimal.backgroundColor = [UIColor clearColor];
    _descLabelScore_fdecimal.font = [UIFont boldSystemFontOfSize:12];
    _descLabelScore_fdecimal.frame = CGRectMake(_descLabelScore.right, _descLabelScore.top + 4, 20, 15);
    [_BGView addSubview:_descLabelScore_fdecimal];
    
    _descLabelScore_fen = [[TDLabel alloc] init];
    _descLabelScore_fen.textColor = RGB(255,117,0);
    _descLabelScore_fen.backgroundColor = [UIColor clearColor];
    _descLabelScore_fen.verticalAlignment = VerticalAlignmentTop;
    _descLabelScore_fen.font = [UIFont systemFontOfSize:12];
    _descLabelScore_fen.frame = CGRectMake(_BGView.width - kdescLabelScoreWidth, _descLabelScore.top + 4, kdescLabelScoreWidth, 15);
    [_BGView addSubview:_descLabelScore_fen];
    //一
    _descLabel1 = [[UILabel alloc] init];
    _descLabel1.backgroundColor = [UIColor clearColor];
    _descLabel1.textAlignment = NSTextAlignmentLeft;
    _descLabel1.textColor = RGB(121, 121, 121);
    _descLabel1.font = [UIFont systemFontOfSize:12];
    _descLabel1.frame = CGRectMake(_titleLabel.left, 54.0, _BGView.width - kAlbumVideoCoverSize.width - kTitleLeftMargin - kBackgroundHorizontalMargin * 2, kDescLabelHeight);
    [_BGView addSubview:_descLabel1];
    //二
    _descLabel2 = [[UILabel alloc] init];
    _descLabel2.backgroundColor = [UIColor clearColor];
    _descLabel2.textAlignment = NSTextAlignmentLeft;
    _descLabel2.textColor = RGB(121, 121, 121);
    _descLabel2.font = [UIFont systemFontOfSize:12];
    _descLabel2.frame = CGRectMake(self.descLabel1.origin.x, _descLabel1.bottom, _BGView.width - kAlbumVideoCoverSize.width - kTitleLeftMargin - kBackgroundHorizontalMargin * 2, kDescLabelHeight);
    [_BGView addSubview:_descLabel2];
    
    //三
    _descLabel3 = [[UILabel alloc] init];
    _descLabel3.backgroundColor = [UIColor clearColor];
    _descLabel3.textAlignment = NSTextAlignmentLeft;
    _descLabel3.textColor = RGB(121, 121, 121);
    _descLabel3.font = [UIFont systemFontOfSize:12];
    _descLabel3.frame = CGRectMake(self.descLabel1.origin.x, _descLabel2.bottom, _BGView.width - kAlbumVideoCoverSize.width - kTitleLeftMargin - kBackgroundHorizontalMargin * 2, kDescLabelHeight);
    [_BGView addSubview:_descLabel3];
 
    //四  （播放次数）要用到TDMultiplyLable
    _descLabelVV = [[TDMultiplyLable alloc] init];
    _descLabelVV.backgroundColor = [UIColor clearColor];
    _descLabelVV.frame = CGRectMake(self.descLabel1.origin.x, _descLabel3.bottom, _BGView.width - kAlbumVideoCoverSize.width - kTitleLeftMargin - kBackgroundHorizontalMargin * 2, kDescLabelHeight);
    [_BGView addSubview:_descLabelVV];
 
    //五
    _descLabel4 = [[UILabel alloc] init];
    _descLabel4.backgroundColor = [UIColor clearColor];
    _descLabel4.textAlignment = NSTextAlignmentLeft;
    _descLabel4.textColor = RGB(121, 121, 121);
    _descLabel4.font = [UIFont systemFontOfSize:12];
    _descLabel4.frame = CGRectMake(self.descLabel1.origin.x, _descLabelVV.bottom + 5, 40, kDescLabelHeight + 5);
    [_BGView addSubview:_descLabel4];
    
    //来源
    _siteImageIco = [[UIImageView alloc] initWithFrame:CGRectMake(self.descLabel4.right - 3, self.descLabel4.top, 20, kSiteIDTitleDefaultSize.height)];
    _siteImageIco.backgroundColor = [UIColor TDMainBackgroundColor];
    
    _siteNameLabel = [[UILabel alloc] init];
    _siteNameLabel.frame = CGRectMake(_siteImageIco.right, self.descLabel4.top, kSiteIDTitleDefaultSize.width, kSiteIDTitleDefaultSize.height);
    _siteNameLabel.font = [UIFont systemFontOfSize:12];
    [_siteNameLabel.layer setCornerRadius:0];
    _siteNameLabel.backgroundColor = [UIColor TDMainBackgroundColor];
    _siteNameLabel.textAlignment = NSTextAlignmentCenter;
    [_BGView addSubview:_siteNameLabel];
    [_BGView addSubview:_siteImageIco];
 
    //封面图片上的文字背景
    _stripe_topLabelBackground = [[UIImageView alloc] init];
    _stripe_topLabelBackground.image = [UIImage imageWithTudouYaoFeng];
//    _stripe_topLabelBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _stripe_topLabelBackground.frame =  CGRectMake(kBackgroundHorizontalMargin, self.bgImageView.origin.y + self.bgImageView.height - 50, kAlbumVideoCoverSize.width, 50);
    [_BGView addSubview:_stripe_topLabelBackground];
    //封面图片上的文字描述
    _stripe_topLabel = [[UILabel alloc] init];
    _stripe_topLabel.backgroundColor = [UIColor clearColor];
    _stripe_topLabel.font = [UIFont systemFontOfSize:10];
    _stripe_topLabel.textColor = [UIColor TDMilkWhite];
    _stripe_topLabel.textAlignment = NSTextAlignmentLeft;
    _stripe_topLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _stripe_topLabel.frame = CGRectMake(kBackgroundHorizontalMargin + 3, self.bgImageView.origin.y + self.bgImageView.height - kStripe_topLabelHeight, kAlbumVideoCoverSize.width - 3, kStripe_topLabelHeight);
    [_BGView addSubview:_stripe_topLabel];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(self.descLabel1.origin.x, _bgImageView.bottom - 29, 61, 29);
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:Image(@"search_play_btn") forState:UIControlStateNormal];
    _playButton.backgroundColor = [UIColor clearColor];
    [_BGView addSubview:_playButton];
 
    _subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subscribeButton.frame = CGRectMake(_playButton.right + 10, _bgImageView.bottom - 29, 61, 29);
    [_subscribeButton addTarget:self action:@selector(subscribeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_subscribeButton setBackgroundImage:Image(@"search_channel_subscribe_noPlay_small") forState:UIControlStateNormal];
    [_subscribeButton setBackgroundImage:Image(@"search_channel_subscribed_small") forState:UIControlStateSelected];

    _subscribeButton.backgroundColor = [UIColor clearColor];
    [_BGView addSubview:_subscribeButton];
 
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(-1, _bgImageView.bottom + 10 -ceil((kView1Height - _kAlbumButtonSize.height)/2) , kViewSize.width + 2, kView1Height)];
    _view1.backgroundColor = [UIColor clearColor];
    [_BGView addSubview:_view1];
    
//    TDBaseView_TwoLine *gapview = [[TDBaseView_TwoLine alloc] initWithFrame:CGRectMake(0, [TDSearchAlbumVideoCell height] - 8, [UIScreen width], 8)];
//    gapview.lineColor = RGB(220, 220, 220);
//    gapview.backgroundColor = [UIColor TDMainBackgroundColor];
//    [self addSubview:gapview];
}

-(void) creatView2
{
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalMargin, kVerticalMargin_top, kViewSize.width, kViewSize.height)];
    _view2.backgroundColor = [UIColor TDMilkWhite];
    [self addSubview:_view2];
    _seriesView = [[TDSearchSeriesPannel alloc] initWithFrame:CGRectMake(0, 0, _view2.width, _view2.height)];
    _seriesView.delegate = self;
    [_view2 addSubview:_seriesView];
    
    self.view2.hidden = YES;
}

-(void)refreshData:(id)object
{
    [self setBackgroundColor:[UIColor clearColor]];
//    self.object = object;
    [self setValueData];
    [self resetLabsTop];
}

-(void)setValueData
{
//    TDSearchAlbum* album = self.object;
//    if (album.isShowMore) {
//        [_seriesView setSeriesInfo:album];
//    }
//    else
//    {
//        [self creatFirstView];
//    }
//    [self setSubscribeButtonStatus:self.isSubscribed];
//    
//    [self setPayType:album.payType];
}

- (void)setPayType:(int)type
{
    if (type == 1) {
        if (!self.cornerImageView.superview) {
            [_bgImageView addSubview:_cornerImageView];
        }
        [_cornerImageView setImage:Image(@"pay_jiaobiao")];

    }else if(type == 10 || type == 100){
        if (!self.cornerImageView.superview) {
            [_bgImageView addSubview:_cornerImageView];
        }
        [_cornerImageView setImage:Image(@"vip_jiaobiao")];
    }else{
        if (self.cornerImageView.superview) {
            [_cornerImageView removeFromSuperview];
        }
    }
    
    [_playButton setBackgroundImage:Image(@"search_play_btn") forState:UIControlStateNormal];
}

- (UIImageView*)cornerImageView
{
    if (!_cornerImageView) {
        _cornerImageView = [[UIImageView alloc] init];
    }
    _cornerImageView.frame = CGRectMake(_bgImageView.width-KCornerImageWidth, 0, KCornerImageWidth, KCornerImageWidth);
    return _cornerImageView;
}

-(void)creatFirstView
{
    TDSearchAlbum* album = nil;// self.object;
    int width = 0;
 
    if (self.descLabelVV) {
        
        width += [[NSString stringWithFormat:@"播放："] sizeWithFont:[UIFont systemFontOfSize:12]].width;
        width += [[NSString stringWithFormat:@"%@",album.vv] sizeWithFont:[UIFont systemFontOfSize:12]].width;
        
        LableTextAndColor* lableLeft = [[LableTextAndColor alloc] init];
        lableLeft.lableFont = [UIFont systemFontOfSize:12];
        lableLeft.lableColor = RGBS(121);
        lableLeft.lableText = [NSString stringWithFormat:@"播放："];
        
        LableTextAndColor* lableRight = [[LableTextAndColor alloc] init];
        lableRight.lableFont = [UIFont systemFontOfSize:12];
        lableRight.lableColor = [UIColor TDOrange];
        lableRight.lableText = album.vv;
        //重新设置宽度
        self.descLabelVV.frame = CGRectMake(self.descLabel1.origin.x, _descLabel3.origin.y + kDescLabelHeight, _BGView.width - kAlbumVideoCoverSize.width - kTitleLeftMargin - kBackgroundHorizontalMargin * 2, kDescLabelHeight);
        NSArray* array = [NSArray arrayWithObjects:lableLeft,lableRight, nil];
        [self.descLabelVV setMultiplyTexts:array];
        [self resetLabsTop];
    }
    if (album.score != nil && [album.score length]) {
        NSArray* scoreArray = [album.score componentsSeparatedByString:@"."];
        
        NSInteger widthScore = [[NSString stringWithFormat:@"%@.",scoreArray[0]] sizeWithFont:[UIFont systemFontOfSize:19]].width;
        self.descLabelScore.text = [NSString stringWithFormat:@"%@.",scoreArray[0]];
        NSInteger fdecimalWidth = 0;
        if ([scoreArray count] > 1) {
            _descLabelScore_fdecimal.text = scoreArray[1];
            fdecimalWidth += [[NSString stringWithFormat:@"%@",scoreArray[1]] sizeWithFont:[UIFont boldSystemFontOfSize:12]].width;
        }
        else
        {
            _descLabelScore_fdecimal.text = @"0";
            fdecimalWidth += [@"0" sizeWithFont:[UIFont boldSystemFontOfSize:12]].width;
        }
        _descLabelScore_fdecimal.frame = CGRectMake(_descLabelScore.origin.x + widthScore, _descLabelScore.top + 4, 30, 15);
        self.descLabelScore_fen.text = [NSString stringWithFormat:@"分"];
        self.descLabelScore_fen.frame = CGRectMake(_descLabelScore.origin.x + widthScore + fdecimalWidth, _descLabelScore.top + 5, 30, 15);
    }
    else
    {
        self.descLabelScore.text = @"";
        self.descLabelScore_fen.text = @"";
        _descLabelScore_fdecimal.text = @"";
    }
    _descLabel4.frame = CGRectMake(self.descLabel1.origin.x, _descLabelVV.origin.y + kDescLabelHeight, 40, kDescLabelHeight + 5);
    //根据 type来判断 显示什么样式
    _DirectType = [album.cate_id integerValue];
    /**一般直达区
     * cateId=1,cateId=2,cateId=3,cateId=5,cateId=8,cateId=9,cateId=17
     *
     */
    
   // [self.bgImageView td_setImageWithURL:[NSURL URLWithString:album.vimg] placeholderImage:[UIImage imageWithTudouVeritcal]];
    
    self.titleLabel.text = album.title;
    
    self.descLabel1.text = album.notice;
    self.descLabel2.text = [NSString stringWithFormat:@"类型：%@",album.genre];
    self.descLabel3.text = [NSString stringWithFormat:@"地区：%@",album.area];
    if (album.is_tudou) {
        self.descLabel4.hidden = YES;
        self.siteNameLabel.hidden = YES;
        self.siteImageIco.hidden = YES;
        _subscribeButton.hidden = NO;
    }
    else
    {
        _subscribeButton.hidden = YES;
        self.descLabel4.hidden = NO;
        self.siteNameLabel.hidden = NO;
        self.siteImageIco.hidden = NO;
        self.descLabel4.text = @"来源：";
        [self creatComeFromCateName:album];
    }
 
    _stripe_topLabel.text = album.stripe_top;
    [self.view1 removeAllSubviews];
    switch (_DirectType) {
        case Direct_DianShiJu:
        case Direct_DongMan:
//        case Direct_ZiXun:
        {
            [self creatView1Button_DianShiJu:album];
            break;
        }
        case Direct_DianYing:
        case Direct_DianYingXiLie:
        {
            break;
        }
        case Direct_ZongYi:
        case Direct_JiaoYu:
        case Direct_JiLuPian:
        case Direct_ZiXun:
        {
            //V4 将资讯归入综艺
            [self creatView1Button_ZongYi:album];
            break;
        }
        default:
            break;
    }
}

#pragma mark 剧集播放按钮
/**创建 剧集播放按钮
 */
-(void)creatView1Button_DianShiJu:(TDSearchAlbum *)album
{
    for (int i = 0; i < (album.itemsArray.count > 4 ? 4 : album.itemsArray.count); i++) {
        //需要自定义 button
        SeriesItem* item = [album.itemsArray objectAtIndex:i];
        KSearchButton * button = [KSearchButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kBackgroundHorizontalMargin + (_kAlbumButtonSize.width) * i, (kView1Height - _kAlbumButtonSize.height)/2, _kAlbumButtonSize.width, _kAlbumButtonSize.height);
        [button setTitle:item.show_stage forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        UIView *grayline = [[UIView alloc] init];
        grayline.frame = CGRectMake((button.width-15)/2.0,button.height/2.0 , 15, 1);
        grayline.backgroundColor = [UIColor lightGrayColor];
        grayline.tag = 10001;
        [button addSubview:grayline];
        grayline.hidden = YES;
        button.tag = i;
        [button setNeedsDisplay];
//        if ([item.item_id integerValue] == 0 && album.is_tudou) {
//            [button setTitleColor:RGBS(193) forState:UIControlStateNormal];
//        } else {
            [button setTitleColor:RGBS(71) forState:UIControlStateNormal];
//        }
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button addTarget:self action:@selector(albumSeriesButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view1 addSubview:button];

        if (![item.item_id isNotBlankString] && ![item.url isNotBlankString]) {
            [button setEnabled:NO];
            grayline.hidden = NO;
        }else {
            [button setEnabled:YES];
            grayline.hidden = YES;
        }
        
        UIImageView *trailerView = (UIImageView*)[button viewWithTag:10002];
        if (!trailerView) {
            trailerView = [[UIImageView alloc] initWithFrame:CGRectMake(button.width - 15, 0, 15, 15)];
            trailerView.image = Image(@"media_ic_detail_trailer");
            trailerView.backgroundColor = [UIColor clearColor];
            trailerView.tag = 10002;
            [button addSubview:trailerView];
        }
        trailerView.hidden = !item.isTrailer;
    }
    if (album.itemsArray.count > 5) {
        KSearchButton* buttonMore = [KSearchButton buttonWithType:UIButtonTypeCustom];
        buttonMore.frame = CGRectMake(kBackgroundHorizontalMargin + (_kAlbumButtonSize.width) * 4, (kView1Height - _kAlbumButtonSize.height)/2, _kAlbumButtonSize.width, _kAlbumButtonSize.height);
        buttonMore.tag = Button_More;
        [buttonMore setNeedsDisplay];
        [buttonMore addTarget:self action:@selector(albumSeriesButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
        [buttonMore setBackgroundColor:[UIColor whiteColor]];
        [buttonMore setTitleColor:RGBS(71) forState:UIControlStateNormal];
        [self.view1 addSubview:buttonMore];
    }
    else if (album.itemsArray.count == 5) {
        //需要自定义 button
        SeriesItem* item = [album.itemsArray objectAtIndex:4];
        KSearchButton* button = [KSearchButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kBackgroundHorizontalMargin + (_kAlbumButtonSize.width) * 4, (kView1Height - _kAlbumButtonSize.height)/2, _kAlbumButtonSize.width, _kAlbumButtonSize.height);
        [button setTitle:item.show_stage forState:UIControlStateNormal];
        button.tag = 4;
        [button setNeedsDisplay];
//        if ([item.item_id integerValue] == 0 && album.is_tudou) {
//            [button setTitleColor:RGBS(193) forState:UIControlStateNormal];
//        } else {
            [button setTitleColor:RGBS(71) forState:UIControlStateNormal];
//        }
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button addTarget:self action:@selector(albumSeriesButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view1 addSubview:button];
    }
}

-(void)creatView1Button_ZongYi:(TDSearchAlbum*)album
{
    NSString* titleQishu = @"";
    NSString* titleTitle = @"";
    SeriesItem* item;
    if ([album.itemsArray count]) {
        item = album.itemsArray[0];
        titleQishu = item.show_seq;
        titleTitle = item.title;
    }
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ceil(kBackgroundHorizontalMargin), ceil((kView1Height - _kAlbumButtonSize.height)/2), _kAlbumButtonSize.width*4-kBackgroundHorizontalMargin, _kAlbumButtonSize.height);
    int scale = [[UIScreen mainScreen] scale];
    if (is_iphone6Plus()) {//6plus分辨率问题，1/3 除不尽导致
        button.layer.borderWidth = SINGLE_LINE_WIDTH;
        button.layer.borderColor = RGBA(180.0, 180.0, 180.0,0.6).CGColor;
        
    }else{
        button.layer.borderWidth = SINGLE_LINE_WIDTH;
        button.layer.borderColor = RGBA(180.0, 180.0, 180.0,0.6).CGColor;
    }
    button.tag = Button_ZongYi;
    [button setNeedsDisplay];
    [button addTarget:self action:@selector(albumSeriesButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor whiteColor]];
    [self.view1 addSubview:button];
    
    TDMultiplyLable* lable = [[TDMultiplyLable alloc] init];
    int width = 0;
    width += [titleQishu sizeWithFont:[UIFont systemFontOfSize:14]].width;
    width += [titleTitle sizeWithFont:[UIFont systemFontOfSize:14]].width;
    lable.userInteractionEnabled = NO;
    LableTextAndColor* lableLeft = [[LableTextAndColor alloc] init];
    lableLeft.lableFont = [UIFont systemFontOfSize:14];
    lableLeft.lableColor = RGBS(148);
    lableLeft.lableText = [NSString stringWithFormat:@"   %@   ",titleQishu];
    
    LableTextAndColor* lableRight = [[LableTextAndColor alloc] init];
    lableRight.lableFont = [UIFont systemFontOfSize:14];
    lableRight.lableColor = RGBS(71);
    lableRight.lableText = titleTitle;
    
    if (album.is_tudou) {
//        if ([item.item_id integerValue] == 0) {
//            lableLeft.lableColor = RGBS(170);
//            lableRight.lableColor = RGBS(170);
//        }
//        else
//        {
            lableLeft.lableColor = RGBS(148);
            lableRight.lableColor = RGBS(102);
//        }
        
    } else {
//        if (!album.url) {
//            lableLeft.lableColor = RGBS(193);
//            lableRight.lableColor = RGBS(170);
//        }
//        else
//        {
            lableLeft.lableColor = RGBS(148);
            lableRight.lableColor = RGBS(102);
//        }
    }
    
    //重新设置宽度
    lable.frame = button.frame;
    NSArray* array = [NSArray arrayWithObjects:lableLeft,lableRight, nil];
    [lable setMultiplyTexts:array];
 
    [self.view1 addSubview:lable];
    if ([album.itemsArray count]) {
        UIButton* buttonMore = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMore.frame = CGRectMake(ceil(kBackgroundHorizontalMargin + _kAlbumButtonSize.width * 4), ceil((kView1Height - _kAlbumButtonSize.height)/2), _kAlbumButtonSize.width, _kAlbumButtonSize.height);
        buttonMore.tag = Button_More;
        int scale = [[UIScreen mainScreen] scale];
        if (is_iphone6Plus()) {//6plus分辨率问题，0.5/3 除不尽导致
            buttonMore.layer.borderWidth = SINGLE_LINE_WIDTH;
            buttonMore.layer.borderColor = RGBA(180.0, 180.0, 180.0,0.6).CGColor;
        }else{
            buttonMore.layer.borderWidth = SINGLE_LINE_WIDTH;
            buttonMore.layer.borderColor = RGBA(180.0, 180.0, 180.0,0.6).CGColor;
        }

        [buttonMore addTarget:self action:@selector(albumSeriesButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttonMore setTitle:[NSString stringWithFormat:@"更多"] forState:UIControlStateNormal];
        button.titleLabel.backgroundColor = [UIColor clearColor];
        [buttonMore setBackgroundColor:[UIColor whiteColor]];
        [buttonMore setTitleColor:RGBS(102) forState:UIControlStateNormal];
        [self.view1 addSubview:buttonMore];
    }
}

- (UIView*)getBorderView:(CGSize)size
{
    TDBorderView *v = [[TDBorderView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    v.tag = 998;
    v.userInteractionEnabled = NO;
    v.borderWidth = 0.5;
    v.borderColor = RGBA(180.0, 180.0, 180.0,0.6);
    return v;
}

- (BOOL)isAllowClickButton
{
    //下拉刷新时不允许点击
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getTableViewState)] &&
//        [self.delegate getTableViewState] == UZYSGIFPullToRefreshStateLoading) {
//        return NO;
//    }
    return YES;
}

-(void) albumSeriesButton:(UIButton*)button
{
    if (![self isAllowClickButton]) {
        return;
    }
    
    if (button.tag == Button_More) {
        self.isShowMore = YES;
        [self showMoreView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onMoreShowClick_view1:)]) {
            [self.delegate onMoreShowClick_view1:self];
        }
        
//        TDSearchAlbum* album = self.object;
//        [_seriesView setSeriesInfo:album];
    }
    else
    {
        float index = 0;
        if (button.tag == Button_DianYing) {
            index = 0;
        }
        else if(button.tag == Button_ZongYi)
        {
            index = 0;
        }
        else
        {
            //电视剧
            index = button.tag;
        }
   
    }
}

-(void)showMoreView
{
    WS(weakself);
    self.view2.hidden = YES;
    [UIView transitionWithView:self.view2
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        weakself.view2.hidden = NO;
                    } completion:^(BOOL finished) {
                        
                    }];
    
    
    self.BGView.hidden = NO;
    [UIView transitionWithView:self.BGView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        weakself.BGView.hidden = YES;
                    } completion:^(BOOL finished) {
                    }];
}

- (void)animationsDidStop:(CAAnimation *)anim
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadTableView:)]) {
        [self.delegate reloadTableView:self];
    }
}

-(void)dismissMoreView
{
    WS(weakself);
    self.view2.hidden = NO;
    [UIView transitionWithView:self.view2
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        weakself.view2.hidden = YES;
                    } completion:nil];
    
    self.BGView.hidden = YES;
    [UIView transitionWithView:self.BGView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        weakself.BGView.hidden = NO;
                    } completion:nil];
}

-(void) setMoreShow:(BOOL)isShow
{
    if (isShow) {
        self.isShowMore = YES;
        if (_view2) {
            _view2.hidden = NO;
        }
        self.BGView.hidden = YES;
    }
    else
    {
        self.isShowMore = NO;
        if (_view2) {
            _view2.hidden = YES;
        }
        self.BGView.hidden = NO;
    }
}
-(NSArray*)site_ID_Array
{
    if (_site_ID_Array == nil) {
        _site_ID_Array = [NSArray arrayWithObjects:@"1",@"2",@"3",@"6",@"8",@"9",@"10",@"14",@"15",@"16",@"17",@"19",@"27",@"28",@"31",@"83",@"130",@"131",@"132",@"24"/*,@"1001",@"1002"*/, nil];
        /*
         注：V3.7版本后台做了限制，搜不到 暴风影音的来源，3.7以后正常显示
         */
    }
    return _site_ID_Array;
    //百度影音 及 快播 现在暂时不加
}
-(void)creatComeFromCateName:(TDSearchAlbum*)album
{
    if (album.is_tudou) {
        _siteNameLabel.text = @"";
        _siteImageIco.image = /*Image(@"search_logo_tudou.png")*/nil;
        
    }
    else
    {
        NSString* site_id_temp = [NSString stringWithFormat:@"%d",[album.site_id intValue]];
        if (album.site_id && [self.site_ID_Array containsObject:site_id_temp]) {
            _siteImageIco.hidden = NO;
            _siteNameLabel.text = album.site_name;
            _siteImageIco.image = Image([NSString stringWithFormat:@"search_logo_%d.png",[album.site_id intValue]]);
            _siteNameLabel.frame = CGRectMake(_siteImageIco.right, self.descLabel4.top, [album.site_name sizeWithFont:[UIFont systemFontOfSize:12]].width + 7, kSiteIDTitleDefaultSize.height);
        }
        else
        {
            _siteNameLabel.text = @"其他";
            _siteImageIco.image = nil;
            _siteImageIco.hidden = YES;
            _siteNameLabel.frame = CGRectMake(self.descLabel4.right - 3, self.descLabel4.top, kSiteIDTitleDefaultSize.width, kSiteIDTitleDefaultSize.height);
        }
    }
}

- (void)layoutSubviews
{
    if (_DirectType == Direct_DianYing || _DirectType == Direct_DianYingXiLie) {
        _BGView.frame = CGRectMake(kHorizontalMargin, kVerticalMargin_top, kViewSize.width, kViewSize.height -kView1Height);
    }
    else
    {
        _BGView.frame = CGRectMake(kHorizontalMargin, kVerticalMargin_top, kViewSize.width, kViewSize.height);
    }
}

- (void)resetLabsTop
{
    
}

#pragma mark - TdSearchPannelDelegate
- (void)onbackClick:(TDSearchSeriesPannel *)pannel {
    
    self.isShowMore = NO;
    [self dismissMoreView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMoreShowClick_view1:)]) {
        [self.delegate onMoreShowClick_view1:self];
    }
    
    [self creatFirstView];
}

- (void)onSeriesItemClick:(id)item {
    
    if (![self isAllowClickButton]) {
        return;
    }
    
   
    
}

- (void)onSeriesSegmentClick:(NSNumber *)index Offset:(NSNumber *)offset{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeriesSegmentClick_view1: currentSelect: currentOffset:)]) {
        [self.delegate onSeriesSegmentClick_view1:self currentSelect:index currentOffset:offset];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    UITouch *touch = [touches anyObject];
 
    CGPoint point = [touch  locationInView:_BGView];
    /*
     单击 播放的区域：剧集栏以上
     */
    SEL _selector;
    if([self.delegate respondsToSelector:_selector] && !self.isShowMore && point.y < 147)
    {
        
    }
} 



- (void)subscribeButtonClick:(UIButton*)sender{
    if (self.isSubscribing) {
        return;
    }
    
    if (![self isAllowClickButton]) {
        return;
    }

    if (![[sender subviews] containsObject:self.indicator]) {
        [sender addSubview:self.indicator];
    }
    self.indicator.frame = CGRectMake((_subscribeButton.width-20)/2.0, (_subscribeButton.height-20)/2.0, 20, 20);
    [self.indicator startAnimating];
   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(subscribeButtonClickDelegate: orderType:)]) {
        self.isSubscribing = YES;
        [self.delegate subscribeButtonClickDelegate:self orderType:self.isSubscribed ? 0 : 1];
    }
}

- (void)stopLoading
{
    self.isSubscribing = NO;
    [self.indicator stopAnimating];
}

-(void)startLoading
{
    if (_subscribeButton) {
        if (![[_subscribeButton subviews] containsObject:self.indicator]) {
            [_subscribeButton addSubview:self.indicator];
        }
        self.indicator.frame = CGRectMake((_subscribeButton.width-20)/2.0, (_subscribeButton.height-20)/2.0, 20, 20);
        [self.indicator startAnimating];
    }
}

- (void)setSubscribeButtonStatus:(BOOL)subscribed
{
    self.isSubscribed = subscribed;
    _subscribeButton.selected = _isSubscribed;
}

- (void)playButtonClick{
    
    
}

- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake(0, 0, 20, 20);
    }
    return _indicator;
}

- (void)postAnalyticsClick:(NSString*)vid cid:(NSString*)cid weburl:(NSString*)weburl
{
    //统计sdk
    
    
}

@end
