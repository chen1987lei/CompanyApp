//
//  TDViewController.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-16.
//  Copyright (c) 2012年 Youku.com inc.All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TDTitleBar.h"
#import "NCTabBar.h"
#import "MBProgressHUD.h"
#import "TDFailedView.h"
#import "TDHud.h"

//各个页面的枚举，有需要自己可以加
typedef NS_ENUM(NSInteger, TDPageVC) {
    TDPageIntroductVC,
    TDPageSeriesVC,
    TDPageDownLoadVC,
    TDPageCommnetVC,
    TDpageRelateVC
};

typedef NS_ENUM(NSInteger, TDTabBarType) {
    TDTabBarTypeDefault,
    TDTabBarTypeHide,
    TDTabBarTypeShow
};


@interface TDViewController : UIViewController<UIGestureRecognizerDelegate>
{
    TDTitleBar * _titleBar;
    id _record;
    TDFailedView * _failedView;
    
    TDHud * _hud;
    UIViewController * _focusViewController;
    UIViewAnimationOptions _focusAnimationStyle;
}
@property(nonatomic,assign) TDTabBarType tabBarType; //默认是TDTabBarTypeDefault
@property(nonatomic,assign) TDPageVC pageVC;//默认无意义，做标记用
@property (nonatomic, assign) BOOL leftItemHidden;
@property (nonatomic, strong) UIView *topSuperView;//最顶层的窗口。区域为全屏幕。加TDdropdownView的时候调用方便self.topSuperView
@property(nonatomic,readonly) TDFailedView * failedView;
@property(nonatomic,assign) BOOL autoAddLoading; //默认为NO
@property(nonatomic,assign) BOOL canLayoutFullscreen;
@property(nonatomic,assign) BOOL isTopVC;
@property (nonatomic, strong) UIButton *failedBtn;
@property (nonatomic, assign) BOOL isViewAppear;

//lazy load
- (TDTitleBar *)titleBar; //复写该方法来定制titleBar，默认是TDTitleBar
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation; //重写该方法来支持旋转

//便捷方法
- (float)titleBarHeight;//继承时可用
- (float)tabBarHeight; //继承时可用

//复写来实现机制 没有内容，须自己调用
- (void)refreshUI; 
- (void)refreshNetworkData;


//复写实现自定义failedView
//- (TDFailedView *)failedView;
//- (TDFailedView *)createFailedViewWithImage:(UIImage *)img text:(NSString *)text;
//- (TDFailedView *)createFailedViewWithImage:(UIImage *)img text:(NSString *)text size:(CGSize)size;

//加载loading方法
- (void)addLoading;
- (void)removeLoading;
- (BOOL)isLoading;
- (void)bringloadingFront;
//显示登录框
- (void)showLogin;
- (void)showLogin:(void (^)(void))completion;
- (void)showLandscapeLogin;

/**
 *  侧滑返回的方法
 *
 *  因ios7支持侧滑返回，所以直接使用的是interactivePopGestureRecognizer属性
 *
 *  ios7以下的系统，手动添加 手势及 返回动画
 *  @param viewControllerDelegate  *  侧滑返回的方法
 *  @param conflictScrollView     ios7上与边界手势冲突的uiscrollView （用来解决 ios7上，滑动返回与ScrollView共存）
 */
- (void)addSlideBack:(id)viewControllerDelegate conflictScrollView:(UIScrollView*)conflictScrollView;

//ios7下viewwillpeare问题
- (BOOL)isNeedPerformViewWillApeare;

-(void)showFailedHUD;
- (BOOL)isNetWorkAvailable;

@end
