//
//  TDHomeTitleView.h
//  Tudou
//
//  Created by CL7RNEC on 15/5/8.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDTitleBar.h"

typedef enum
{
    TDHomeTitleFirstType,
    TDHomeTitleSecondType,
}TDHomeTitleType;

@protocol TDHomeTitleViewDelegate;

@interface TDHomeTitleView : TDTitleBar

@property (nonatomic,weak) id<TDHomeTitleViewDelegate> titleDelegate;
@property (nonatomic,assign) BOOL isAppMarket;  //是否显示应用推荐
@property (nonatomic,assign) BOOL isCMSTitle;
@property (nonatomic,assign) TDHomeTitleType titleType;

-(void)refreshHomeTitleWithImgIcon:(NSString *)imgIcon withText:(NSString *)text;

- (void)setTitleItemsWithCMS:(NSArray *)titleModelArray;
- (void)setDefaultTitleItems;

/**
 *  转换成第一种形态
 */
-(void)transformTitleFirstType;
/**
 *  转换成第二种形态
 */
-(void)transformTitleSectondType;

@end

@protocol TDHomeTitleViewDelegate <NSObject>

-(void)searchBarDidClick;

@end