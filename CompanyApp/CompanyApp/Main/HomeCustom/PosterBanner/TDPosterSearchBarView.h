//
//  TDPosterSearchBarView.h
//  Tudou
//  海报图搜索栏
//  Created by CL7RNEC on 15/4/3.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPOSTER_SEARCH_MARGIN_X 10.0f
#define kPOSTER_SEARCH_HEIGHT 36
#define kPOSTER_SEARCH_WIDTH ([UIScreen width] - kPOSTER_SEARCH_MARGIN_X*2)

@protocol TDPosterSearchBarViewDelegate;

@interface TDPosterSearchBarView : UIView

@property (nonatomic,weak) id<TDPosterSearchBarViewDelegate>delegate;

/**
 *  刷新搜索bar
 *
 *  @param text    文案
 *  @param iconUrl icon
 */
-(void)refreshSearchBarWithText:(NSString *)text withIconUrl:(NSString *)iconUrl;

@end

@protocol TDPosterSearchBarViewDelegate <NSObject>

-(void)searchBarDidClick;

@end
