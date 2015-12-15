//
//  TDSearchViewController.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-5.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDSearchViewController.h"
#import "TDSearchVideoResultViewController.h"
#import "SearchHistory.h"
#import "TDSearchBarViewController.h"

typedef NS_ENUM(NSInteger, LastSearchResultType) {
    SearchResultTypeNone          = 0,//还没有进入过搜索结果页
    SearchResultTypeVideo         = 1,//搜索了视频
    SearchResultTypePodcaster     = 2,//搜索了频道
};
 
@interface TDSearchViewController ()<TDSearchVideoResultViewControllerDelegate>
@property(nonatomic,strong)TDSearchBarViewController *                         searchBarController;
@property(nonatomic,strong)TDSearchHomeViewController *                        searchHomeViewController;
@property(nonatomic,strong)TDSearchVideoResultViewController *                 searchVideoResultsController;

/**
 *  搜索类型下拉菜单
 */
@property(nonatomic,strong)TDSearchTypeDropListView*                           searchTypeDropBoxView;

@property(nonatomic,assign)LastSearchResultType                                searchResultType;

@end

@implementation TDSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _searchHomeViewController = [[TDSearchHomeViewController alloc] init];
        _searchHomeViewController.delegate = self;
        
        _searchBarController = [[TDSearchBarViewController alloc] initWithFrame:CGRectMake(0, 0,[UIScreen width], TitleBar_Height)];
        _searchBarController.delegate = self;
        
        _searchVideoResultsController = [[TDSearchVideoResultViewController alloc] init];
        _searchVideoResultsController.delegate = self;

    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = NO;
    self.view.backgroundColor = [UIColor TDMainBackgroundColor];
    _searchBarController.defaultSearchWord = _defaultSearchWord;

    [self.view addSubview:_searchBarController.view];
 
    [self.view addSubview:_searchHomeViewController.view];
    [self.view addSubview:_searchVideoResultsController.view];
    
    [self.view sendSubviewToBack:_searchBarController.view];
    [self.view sendSubviewToBack:_searchVideoResultsController.view];
    
    _searchVideoResultsController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
 
    [self creatSearchTypeDropBoxView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SearchBarTextDidBeginEditingNotification:)
                                                 name:KSearchBarTextDidBeginEditingNotification
                                               object:nil];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideResultsController)
                                                 name:KHideResultsControllerNotif object:nil];
    
    [self addSlideBack:self conflictScrollView:nil];
    
    [self showKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBarController.searchBar.textField resignFirstResponder];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_searchTypeDropBoxView removeFromSuperview];
    _defaultSearchWord = nil;
}
/**
 *  隐藏搜索结果页
 */
- (void)hideResultsController
{
    //fix bug 18015
    if (_searchResultType==SearchResultTypePodcaster) {
        [_searchVideoResultsController stopPullRefreshAnimaiton];
    }
    
    [self.view bringSubviewToFront:_searchBarController.view];
    
    [self.view sendSubviewToBack:_searchVideoResultsController.view];
    [_searchBarController dismissTable];
    [_searchHomeViewController setTableViewContentOffSetZero];
    _searchResultType = SearchResultTypeNone;
}

/**
 *  隐藏搜索首页
 */
- (void)hideHomeViewController
{
    [self.view bringSubviewToFront:_searchBarController.view];
    [_searchHomeViewController removeLoading];
    [self.view sendSubviewToBack:_searchHomeViewController.view];
    [_searchBarController dismissTable];
}
- (void)hideKeyWindow
{
    [_searchBarController.searchBar.textField resignFirstResponder];
}

- (void)searchString:(NSString *) keyword searchType:(SearchType)searchType albumId:(NSString *)albumId
{
    if(!IsStringWithAnyText(keyword))
    {
//        [MBProgressHUD showTextHudAddTo:self.topSuperView title:@"输入内容不能为空" animated:YES afterDelayHide:1];
        return;
    }
    if (albumId && [albumId length]) {
        //直接命中直达区，播放
        [_searchBarController dismissTable];
        [self.view bringSubviewToFront:_searchHomeViewController.view];
     
        
        return;
    }
    [_searchBarController setSearchType:searchType];
    if (searchType == SearchType_CHANNEL) {
       
        
        _searchResultType = SearchResultTypeVideo;
    }
    else if (searchType == SearchType_VIDEO)
    {
        [self.view bringSubviewToFront:_searchVideoResultsController.view];
        [self.view bringSubviewToFront:_searchBarController.view];
    
        [_searchVideoResultsController searchString:keyword];
        _searchBarController.text = keyword;
        
        [_searchVideoResultsController setTableViewScrollToTop:YES];
        
        _searchResultType = SearchResultTypePodcaster;
    }
 
    [self hideHomeViewController];
    [self hideKeyWindow];
}

- (void)searchBarCancelButtonClicked:(TDSearchBarViewController *) searchBarVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark SearchKeywordsControllerDelegate
- (void)didclickKeyword:(NSString *)keyword searchType:(SearchType)searchType
{
  
    
    [_searchTypeDropBoxView setSelectSearchTypeDropButton:searchType];
    [self searchString:keyword searchType:searchType albumId:nil];
    [_searchBarController.searchBar setSearchTypeButtonFrame:searchType == SearchType_CHANNEL ? YES : NO];
}
- (void)resignKeyboard
{
    [_searchBarController.searchBar.textField resignFirstResponder];
}

- (void)showKeyboard
{
    //首次进来,激活输入框
    if (![_searchBarController.searchBar.textField isFirstResponder]) {
        WS(weakself);
        [weakself.searchBarController.searchBar.textField becomeFirstResponder];
    }
}
//- (void)searchHomeRefreshDataTaped{
//    if (_searchBarController.searchBar.textField && ![_searchBarController.searchBar.textField isFirstResponder]) {
//        [_searchBarController.searchBar.textField becomeFirstResponder];
//    }
//}
//
//- (void)searchHomeRefreshNetworkDataFailed{
//    [self hideKeyWindow];
//}

-(void)SearchBarTextDidBeginEditingNotification:(NSNotification *)notification
{
    [self.view bringSubviewToFront:_searchBarController.view];
    _searchResultType = SearchResultTypeNone;
}

/**
 *  创建搜索类型下拉菜单
 */
- (void)creatSearchTypeDropBoxView
{
    _searchTypeDropBoxView = [[TDSearchTypeDropListView alloc] initWithFrame:CGRectMake(0, sSTATUS_BAR_MARGIN_TOP, self.view.width, self.view.height)];
    _searchTypeDropBoxView.delegateType = self;
    _searchTypeDropBoxView.userInteractionEnabled = YES;
    _searchTypeDropBoxView.hidden = YES;
}

- (void)tapGestureRecognizerEvent
{
    [self setSearchTypeDropBoxViewHidden];
}
- (void)searchTypeDropBoxButtonClick:(SearchType)searchType
{
    if (_searchResultType != SearchResultTypeNone) {
        [SearchHistory addHistory:_searchBarController.searchBar.text type:searchType];
        [self searchString:_searchBarController.searchBar.text searchType:searchType albumId:nil];
    }
 
    switch (searchType) {
        case SearchType_VIDEO:
        {
            [_searchBarController setSearchType:SearchType_VIDEO];
            [_searchBarController.searchBar setSearchTypeButtonFrame:NO];
            break;
        }
        case SearchType_CHANNEL:
        {
            [_searchBarController setSearchType:SearchType_CHANNEL];
            [_searchBarController.searchBar setSearchTypeButtonFrame:YES];
            break;
        }
        default:
            break;
    }
    [self setSearchTypeDropBoxViewHidden];

}

#pragma mark TDSearchBarControllerDelegate
- (void)searchTypeButtonClick:(TDSearchBarViewController*)sender
{
    if (_searchTypeDropBoxView) {
        Boolean ishidden = _searchTypeDropBoxView.hidden;
        switch (ishidden) {
            case YES:
            {
                [self setSearchTypeDropBoxViewShow];
                [_searchBarController.searchBar setSearchTypeIco:YES];
                break;
            }
            case NO:
            {
                [self setSearchTypeDropBoxViewHidden];
                [_searchBarController.searchBar setSearchTypeIco:NO];
                break;
            }
            default:
                break;
        }
    }
}

- (void)setSearchTypeDropBoxViewHidden{
    _searchTypeDropBoxView.hidden = YES;
    [_searchTypeDropBoxView removeFromSuperview];
    [_searchBarController.searchBar setSearchTypeIco:NO];
}
- (void)setSearchTypeDropBoxViewShow{
    if (_searchTypeDropBoxView) {
        if ([_searchBarController.searchBar.textField isFirstResponder]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                [[[self findKeyboard] superview].window addSubview:_searchTypeDropBoxView];
            }else{
//                [TDAPP.window addSubview:_searchTypeDropBoxView];
            }
        }
        else
        {
//            [TDAPP.window addSubview:_searchTypeDropBoxView];
        }
        _searchTypeDropBoxView.hidden = NO;
    }
 
}
//参考 http://www.myexception.cn/operating-system/1405409.html
//找出键盘所在的view
- (UIView *)findKeyboard
{
    [UITextInputMode activeInputModes];
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}
//判断这个view 是不是键盘view
- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

/**
 *  隐藏搜索类型下拉菜单
 *  注：当触摸到view（手势）的时候就隐藏，键盘隐藏的触发事件为 滑动（uiscrollview）
 *  @param ntf
 */
- (void)hideSearchTypeDropBoxView:(NSNotification*)ntf
{
    if (_searchTypeDropBoxView.hidden == NO) {
        [self setSearchTypeDropBoxViewHidden];
    }
}

#pragma mark TDSearchVideoResultViewControllerDelegate

- (void)userClickCorrectPopView:(NSString*)correctStr
{
    if (_searchBarController && correctStr && correctStr.length != 0) {
        _searchBarController.searchBar.textField.text = correctStr;
    }
}

@end
