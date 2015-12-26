//
//  NCTabBarController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCTabBarController.h"
#import "UIView+Addition.h"

#import "NCHomeViewController.h"
#import "NCPersonLibraryViewController.h"
#import "NCMessageViewController.h"
#import "NCMyViewController.h"

@interface NCTabBarController ()
{
    NSInteger _cacheIndex;
}
@end


@implementation NCTabBarController

@dynamic selectedViewController;

static NCTabBarController * _currentTabarController;
+ (id)currentTabBarController
{
    return _currentTabarController;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    UIViewController * viewController = [_viewControllers objectAtIndex:selectedIndex];
    if([viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController * navigation = (UINavigationController *)viewController;
        [navigation popToRootViewControllerAnimated:YES];
    }
    if(_selectedIndex == selectedIndex)
        return;
    else{
        
        //        [self youkuAnalyticsAction:_selectedIndex nextIndex:selectedIndex];
        
        UIViewController *oldVC = _viewControllers[_selectedIndex];
        
        UIViewController *newVC = _viewControllers[selectedIndex];
        
        [self cycleFromViewController:oldVC toViewController:newVC selectIndex:selectedIndex];
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initall];
        _selectedIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    if(_currentTabarController == self)
        _currentTabarController = nil;
}

- (void)initall{
    
    _currentTabarController = self;
    
    NCHomeViewController * home= [[NCHomeViewController alloc] init];
    
    NCPersonLibraryViewController *subscribe = [[NCPersonLibraryViewController alloc] init];
    
    NCMessageViewController *find = [[NCMessageViewController alloc] init];
    
    NCMyViewController * userCenter = [[NCMyViewController alloc] init];
    
    NSArray * array;
    array = [NSArray arrayWithObjects:home,subscribe,find,userCenter,nil];
    
    self.viewControllers = array;
    
}

- (void)loadView
{
    [super loadView];
    self.view.top = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor TDMainBackgroundColor];
    
    //内存警告用
    if (!_viewControllers) {
        [self initall];
    }
    
    //必须先加一个childController，才能使用cycleFromViewController:toViewController:
    [self displayContentController:[_viewControllers objectAtIndex:_selectedIndex]];
    
    
    if (!_customTabBar) {
        _customTabBar = [[NCTabBar alloc] initWithFrame:CGRectMake(0, self.view.height - TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _customTabBar.delegate = self;
        
        [self tabBarSetToIndex:_selectedIndex];
        
//        BOOL hasClickFind = [[NSUserDefaults standardUserDefaults] boolForKey:@"HasClickFind"];
//        [_customTabBar setShowMark:!hasClickFind atIndex:kDicoveryIndex];
    }
    
    _customTabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8)
    {
        [_customTabBar setBlurTintColor:RGBA(255, 255, 255, 0.8)];
    }else{
        _customTabBar.backgroundColor = RGBA(255, 255, 255, 0.8);
    }
    if(!_customTabBar.superview){
        [self.view addSubview:_customTabBar];
    }
    
    [self addTestButton];
}

- (void)viewDidUnload
{
    _cacheIndex = 0;
    _mainView = nil;
    _customTabBar = nil;
    _viewControllers = nil;
    _currentTabarController = nil;
}

- (void)displayContentController:(UIViewController*)content;
{
    if (!content.parentViewController) {
        [self addChildViewController:content];
    }
    
    if (!content.view.superview) {
        
        content.view.frame = CGRectMake(0, 0, [UIScreen width], [UIScreen height]);
        
        [self.view addSubview:content.view];
    }
    
    [content didMoveToParentViewController:self];
}

- (void)cycleFromViewController:(UIViewController*)oldC toViewController:(UIViewController*)newC selectIndex:(NSInteger)selectIndex
{
    [oldC willMoveToParentViewController:nil];
    
    if (!newC.parentViewController) {
        [self addChildViewController:newC];
    }
    
    newC.view.frame = CGRectMake(0, 0, [UIScreen width], [UIScreen height]);
    
    WS(weakself);
    [self transitionFromViewController:oldC toViewController:newC
                              duration:0 options:0
                            animations:^{
                                [weakself.view bringSubviewToFront:weakself.customTabBar];
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                _selectedIndex = selectIndex;
                                [newC didMoveToParentViewController:weakself];
                            }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    
    if(!animated)
        self.selectedIndex = selectedIndex;
    else
    {
        self.selectedIndex = selectedIndex;
    }
}

- (void)tabBarSetToIndex:(NSInteger)index
{
    [self.customTabBar setSelectIndex:index];
}

#pragma mark NCTabBarDelegate
-(void)didSelectIndex:(NSInteger)index
{
    
    if (0 <= index && index < [self.viewControllers count]) {
        [self setSelectedIndex:index animated:YES];
    }
}

- (void)showTabBarWithAnimation:(BOOL)animated
{
    _mainView.height = self.view.height - TAB_BAR_HEIGHT;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _customTabBar.top = self.view.height - TAB_BAR_HEIGHT;
        }];
    }
    else{
        _customTabBar.top = self.view.height - TAB_BAR_HEIGHT;
    }
}

- (void)hideTabBarWithAnimation:(BOOL)animated
{
    _mainView.height = self.view.height;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _customTabBar.top = self.view.height + 20;
        }];
    }
    else{
        _customTabBar.top = self.view.height + 20;
    }
}

- (void)refreshUserCenterForeViewApplyRecommendItemView{
    
}


- (void)addTestButton{
   
}

@end

