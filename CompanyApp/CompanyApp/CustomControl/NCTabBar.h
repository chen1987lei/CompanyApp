//
//  NCTabBar.h
//  CompanyApp
//
//  Created by chenlei on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define TAB_BAR_HEIGHT 49
#define MARGIN 0//第一个item的左边距
#define IMAGE_TITLE_MARGIN 2
#define TITLE_HEIGHT 10

#define kSubcribeIndex 1
#define kDicoveryIndex 2
#define kMyIndex 3

@interface NCTabBarItem : NSObject
@end

@protocol NCTabBarDelegate<NSObject>
-(void)didSelectIndex:(NSInteger)index;
@optional
-(BOOL)willSelectIndex:(NSInteger)index;
@end

@interface NCTabBar : UIView

@property (nonatomic, weak) id<NCTabBarDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger lastSelected;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIColor *blurTintColor;

/**
 *  设置每个item显示还是隐藏红点标记
 *
 *  @param show  是否显示 yes or no
 *  @param index 第几个tab从0开始是第一个
 */
- (void)setShowMark:(BOOL)show atIndex:(NSInteger)index;

- (void)setShowMark:(BOOL)show atIndex:(NSInteger)index forKey:(NSString *)key;


- (void)userSelectIndex:(NSInteger)index;

@end