//
//  NCLibraryHomeView.h
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
#import "NCLibraryScrollView.h"

@class TDHomeModel;

@protocol HomeViewDelegate <NSObject>

-(void)homeViewDidClickNews:(TDHomeModel *)model;
-(void)homeViewDidChangeChannel:(NSInteger)chIndex;
@end
@interface NCLibraryHomeView : UIView<MenuHrizontalDelegate,LibraryScrollPageViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    NCLibraryScrollView *mScrollPageView;
}
@property(nonatomic,assign) NSInteger baseChIndex;
@property(nonatomic,strong) NSArray *menuItemArray;
@property(nonatomic,assign) id<HomeViewDelegate> actiondelegate;
-(void)commInit;
-(void)loadData:(NSArray *)newslist;
@end
