//
//  HomeView.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
#import "ScrollPageView.h"

@class TDHomeModel;

@protocol HomeViewDelegate <NSObject>

-(void)homeViewDidClickNews:(TDHomeModel *)model;
-(void)homeViewDidChangeChannel:(NSInteger)chIndex;
@end
@interface HomeView : UIView<MenuHrizontalDelegate,ScrollPageViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    ScrollPageView *mScrollPageView;
}
@property(nonatomic,assign) NSInteger baseChIndex;
@property(nonatomic,strong) NSArray *menuItemArray;
@property(nonatomic,assign) id<HomeViewDelegate> actiondelegate;
-(void)commInit;
-(void)loadData:(NSArray *)newslist;
@end
