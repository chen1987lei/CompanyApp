//
//  TDPosterBannerView.h
//  Tudou
//  海报轮播图：首页、分类精选页
//  Created by CL7RNEC on 15/4/2.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPOSTER_BANNER_WIDTH [UIScreen width]
#define kPOSTER_BANNER_HEIGHT (kPOSTER_BANNER_WIDTH*81/160)

typedef NS_ENUM(NSInteger, PosterPageType) {
    posterPageMiddle,   //小圆点居中，默认
    posterPageRight,    //居右
    posterPageLeft,      //居左
    posterPageNone
};

@protocol TDPosterBannerViewDelegate;

@interface TDPosterBannerView : UIView

@property (nonatomic,weak) id<TDPosterBannerViewDelegate> delegate;
@property (nonatomic,assign) BOOL isSearchBarHidden;    //1隐藏搜索bar
@property (nonatomic,copy) NSString *searchBartext;
@property (nonatomic,copy) NSString *searchBariconUrl;
/**
 *  初始化
 *
 *  @param frame      尺寸
 *  @param bannerData 海报数据
 *  @param pageType   page类型
 *
 *  @return self
 */
-(id)initWithFrame:(CGRect)frame
      withPageType:(PosterPageType)pageType;
/**
 *  刷新
 *
 *  @param bannerData 海报数据
 */
//wangpengfei
-(void)refreshPosterBanner:(NSArray *)bannerData bannerHeight:(CGFloat)height;

-(void)refreshPosterBanner:(NSArray *)bannerData;
/**
 *  开始计时
 */
-(void)startTimer;
/**
 *  暂停计时
 */
-(void)pauseTimer;
/**
 *  延后开始计时
 */
-(void)startTimerAfterWhile;
/**
 *  延后后暂停计时
 */
-(void)pauseTimerAfterWhile;

@end

@protocol TDPosterBannerViewDelegate <NSObject>

@optional
/**
 *  海报点击
 *
 *  @param index 第几个
 */
-(void)posterBannerDidClickWithIndex:(NSInteger)index;
/**
 *  点击搜索bar
 *
 *  @param searchKey 搜索关键字
 */
-(void)searchBarDidClick:(NSString *)searchKey;

@end