//
//  NCTabBarController.h
//  CompanyApp
//
//  Created by chenlei on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#import "NCTabBar.h"
@interface NCTabBarController : UIViewController<NCTabBarDelegate,UITabBarControllerDelegate, UINavigationControllerDelegate>
{
    NCTabBar * _customTabBar;
    UIView * _mainView;
}
@property (nonatomic, strong) NCTabBar * customTabBar;
@property(nonatomic,copy) NSArray *viewControllers;
@property(nonatomic,readonly) UIViewController *selectedViewController;
@property(nonatomic,assign) NSUInteger selectedIndex;



+ (id)currentTabBarController;

- (void)showTabBarWithAnimation:(BOOL) animated;

- (void)hideTabBarWithAnimation:(BOOL) animated;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

- (void)tabBarSetToIndex:(NSInteger)index;

- (void)refreshUserCenterForeViewApplyRecommendItemView;//当网络连接状态改变时，刷新应用推荐是否显示
@end