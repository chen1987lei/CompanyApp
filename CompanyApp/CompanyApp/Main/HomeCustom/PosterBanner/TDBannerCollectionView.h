//
//  TDBannerCollectionView.h
//  Tudou
//
//  Created by chenlei on 15/7/15.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    TDCycleScrollViewPageContolAlimentRight,
    TDCycleScrollViewPageContolAlimentCenter
} TDCycleScrollViewPageContolAliment;

@class TDBannerCollectionView;

@protocol TDBannerCollectionViewDelegate <NSObject>

- (void)cycleScrollView:(TDBannerCollectionView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

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


@interface TDBannerCollectionView : UIView
@property (nonatomic, strong) NSArray *imagesGroup;
@property (nonatomic, strong) NSArray *titlesGroup;
@property (nonatomic, strong) NSArray *bottomTitlesGroup;
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, assign) TDCycleScrollViewPageContolAliment pageControlAliment;
@property (nonatomic, weak) id<TDBannerCollectionViewDelegate> delegate;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame;

-(void)reloadBannerImagesData:(NSArray *)images andTitles:(NSArray *)titles andBottomtitles:(NSArray *)bottomTitles;

-(void)refreshPosterBanner:(NSArray *)bannerData;

-(void)startTimer;
-(void)pauseTimer;

@end
