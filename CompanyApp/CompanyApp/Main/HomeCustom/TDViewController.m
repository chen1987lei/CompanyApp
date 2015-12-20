
//  TDViewController.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-16.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDViewController.h"

#define kDownloadMemoryWaringMaxCount 2

@interface TDViewController ()<UIGestureRecognizerDelegate>
{
    UIImageView * _failedImageView;
    UILabel * _failedLabel;
    NSUInteger warningCount;
}
@property (nonatomic,weak) UIScrollView *currentScrollView;
@end

@implementation TDViewController
@synthesize tabBarType = _tabBarType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.wantsFullScreenLayout = YES;
        _autoAddLoading = NO;
        _tabBarType = 0;
        _focusAnimationStyle = UIViewAnimationOptionTransitionCrossDissolve;
        _isTopVC = YES;
        warningCount = 0;
        _isViewAppear = NO;
    }
    return self;
}


- (void)setTabBarType:(TDTabBarType)tabBarType
{
    if(_tabBarType == tabBarType)
        return;
    _tabBarType = tabBarType;
    if([self isViewLoaded])
    {
        if(_tabBarType == TDTabBarTypeHide)
        {
            self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height);
        }
        else if(_tabBarType == TDTabBarTypeShow)
        {
            self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height-self.tabBarHeight);
        }
    }

}


- (float)titleBarHeight
{
    if(_titleBar)
        return TitleBar_Height;
    else
        return 0;
}

- (float)tabBarHeight
{
    return TAB_BAR_HEIGHT;
}



- (TDFailedView *)createFailedViewWithImage:(UIImage *)img text:(NSString *)text
{
    return _failedView;
}

- (TDTitleBar *) titleBar
{
    if(!_titleBar)
    {
        _titleBar = [[TDTitleBar alloc] init];
        if([self isViewLoaded])
            [self.view addSubview:_titleBar];
    }
    return _titleBar;
}

- (TDFailedView *)failedView
{
    if(!_failedView)
    {
        _failedView = [[TDFailedView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-TitleBar_Height)];
        _failedView.delegate = self;
    }
    return _failedView;
}

- (void)addLoading
{
    if(_hud.superview)
        return;
    if(!_hud)
    {
        _hud = [[TDHud alloc] initWithFrame:self.view.bounds];
        _hud.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if(_titleBar)
        {
            _hud.frame = CGRectMake(0, TitleBar_Height, _hud.width, _hud.height - TitleBar_Height);
        }
        //_hud.dimBackground = YES;//土豆这个版本变暗背景
    }
    if(_titleBar)
        [self.view insertSubview:_hud belowSubview:self.titleBar];
    else
        [self.view addSubview:_hud];
	[_hud startAnimating];
}

- (void)removeLoading
{
    if(_hud.superview!=nil)
    {
        [_hud stopAnimating];
        [_hud removeFromSuperview];
        //_activity.removeFromSuperViewOnHide = YES;
    }
}

- (BOOL)isLoading {
    
    return _hud.superview != nil;
}

- (void)bringloadingFront {
    
    [self.view bringSubviewToFront:_hud];
}

- (UIView *)topSuperView
{
//    if (!_topSuperView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if(!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
//        _topSuperView = [UIApplication sharedApplication].keyWindow;
        if([NCAPP window] == window) {
            if ([[window rootViewController] presentedViewController]) {
                _topSuperView = [[window subviews] objectAtIndex:0];
            } else {
                _topSuperView = [[window rootViewController] view];
            }
        } else {
            _topSuperView = [[window subviews] objectAtIndex:0];
        }
//    }
        return _topSuperView;
}

-(void)failedViewClicked
{
//    NetworkStatus status = [NCAPP currentReachabilityStatus];
//    if (status == NotReachable) {
//        [MBProgressHUD showTextHudAddTo:self.view title:@"当前无网络连接，请检查您的网络" animated:YES afterDelayHide:1];
//        return;
//    }
    
    [self refreshNetworkData];
}
- (void)refreshUI
{
   
}

- (void)refreshNetworkData
{
    
}

- (void)dealloc
{
}

- (void)loadView
{
    [super loadView];
    if(self.tabBarType == TDTabBarTypeShow)
        self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height - self.tabBarHeight);
    else if(self.tabBarType == TDTabBarTypeHide)
        self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height);
    else
        self.view.frame = CGRectMake(0, 0, screenSize().width, screenSize().height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_titleBar)
        [self.view addSubview:_titleBar];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _hud = nil;
    _failedView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_titleBar)
        [self.view bringSubviewToFront:_titleBar];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        self.isViewAppear = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)isNeedPerformViewWillApeare{
    if (self.isViewAppear && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return NO;
    }
    return YES;
}

- (void)showMemoryWarningLocalNotification{
    UILocalNotification* locNot = [[UILocalNotification alloc] init];
    locNot.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    locNot.alertBody = @"你设备运行内存过低，已经为您暂停所有正在缓存的视频";
    locNot.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:locNot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldHandleDownloadMemoryWarning{

    return NO;
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0)
    {
        [self presentViewController:modalViewController animated:animated completion:nil];
    }
    else
    {
        UIWindow * window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        if(window.rootViewController  == self)
        {
//            [[TDTabBarController currentTabBarController] hideTabBarWithAnimation:YES];
            [super presentModalViewController:modalViewController animated:animated];
        }
        else
        {
            [window.rootViewController presentModalViewController:modalViewController animated:animated];
        }
    }
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 5.0)
    {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else
    {
        [super dismissModalViewControllerAnimated:animated];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion{
    UIWindow * window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if(window.rootViewController  == self)
    {
//        [[TDTabBarController currentTabBarController] hideTabBarWithAnimation:YES];
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    else
    {
        [window.rootViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - Rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}

- (void)addSlideBack:(id)viewControllerDelegate conflictScrollView:(UIScrollView*)conflictScrollView
{
   // if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //ios7上 右滑返回的实现在 TDNavigationController中
        //此处解决了 iOS7下滑动返回与ScrollView共存
        if (conflictScrollView) {
            UIPanGestureRecognizer *moveAnimation = [[UIPanGestureRecognizer alloc]init];
            moveAnimation.delegate = self;
            [conflictScrollView addGestureRecognizer:moveAnimation];
           
//            TDNavigationController *tdnav = (TDNavigationController *)self.navigationController;
//            [moveAnimation addTarget:tdnav.navT action:@selector(handleControllerPop:)];

        }
//    }
//    else{
//        //ios6上 添加滑动手势 及 pop动画返回
//        //!! ios6上会跟 播放器上的手势冲突
//        UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController)];
//        [self.view addGestureRecognizer:swipeGesture];
//    }
}
//wangpengfei 搞滑动冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch locationInView:self.view].x>60){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  侧滑返回的方法：（只在 侧滑的时候才会用）
 *  注：这个方法是用来解决 ios7上，滑动返回与ScrollView共存
 *
 *  @return 手势
 */
- (UIPanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    //if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        UIPanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
        if (self.navigationController.view.gestureRecognizers.count > 0)
        {
            for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
            {
                NSLog(@"recongnizer is class is %@",[self.navigationController class]);
                if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
                {
                    screenEdgePanGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
                    break;
                }
            }
        }
        return screenEdgePanGestureRecognizer;
  //  }
//    else
//    {
//        UIGestureRecognizer *screenSwipeGestureRecognizer = nil;
//        return screenSwipeGestureRecognizer;
//    }
}

/**
 *  多手势操作
 *
 *  @param gestureRecognizer
 *  @param otherGestureRecognizer
 *
 *  @return 是否允许 多个手势   默认NO
// */
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
////    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
////        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
////    {
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
//    {
//        //允许同时识别两个手势
//        return YES;
//    }
//    else
//    {
//        return  NO;
//    }
//}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
//网络请求相关
-(void)showFailedHUD{
    if (![self isNetWorkAvailable]) {
//        [MBProgressHUD showTextHudAddTo:self.view title:LocalizedString(@"当前无网络连接，请检查您的网络") animated:YES afterDelayHide:1];
    }else{
//        [MBProgressHUD showTextHudAddTo:self.view title:LocalizedString(@"获取数据失败") animated:YES afterDelayHide:1];
    }
}
- (BOOL)isNetWorkAvailable{
//    NetworkStatus netStatus = [NCAPP currentReachabilityStatus];
//    if (netStatus == NotReachable) {
//        return NO;
//    } else {
//        return YES;
//    }
    return YES;
}
@end
