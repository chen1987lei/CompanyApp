//
//  TDSearchBarViewController.m
//  Tudou
//
//  Created by weiliangMac on 14-7-17.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDSearchBarViewController.h"
#import "TDSearchVideoResultViewController.h"
#import <objc/runtime.h>
#import "SearchHistory.h"
#import "TDSearchViewController.h"
#import "EmptyView.h"
//#import "TDScanViewController.h"

@interface TDSearchBarViewController()
{
    BOOL    isShowTableView;
}
@property (nonatomic, strong) NSMutableArray        *dataSource;//相关词汇
@property (nonatomic, assign) SearchType             currentSearchType;
@property (nonatomic, strong) EmptyView             *emptyView;
@end

@implementation TDSearchBarViewController
@synthesize table = _table;
@dynamic text;

- (id)initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self)
    {
        _rect = frame;
        _defaultSearchWord = nil;
        self.currentSearchType = SearchType_VIDEO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.frame = _rect;
    self.view.clipsToBounds = YES;
    self.view.autoresizesSubviews = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor TDMainBackgroundColor];
    
    float height = screenSize().height - TitleBar_Height;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, TitleBar_Height, self.view.width,height) style:UITableViewStylePlain];
    _table.hidden = NO;
    _table.dataSource = self;
    _table.delegate = self;
    _table.scrollsToTop = NO;
    _table.backgroundColor = RGBS(253);
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
	_searchBar = [[TDSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TitleBar_Height)];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, _searchBar.height-0.5, _searchBar.width, 0.5);
    line.backgroundColor =RGBS(204);
    [_searchBar addSubview:line];
    
    if (_defaultSearchWord>0 && _defaultSearchWord.length>0) {
        _searchBar.textField.placeholder = _defaultSearchWord;
        _searchBar.textField.enablesReturnKeyAutomatically = NO;
    }else{
        _searchBar.textField.placeholder = @"搜索";
        _searchBar.textField.enablesReturnKeyAutomatically = YES;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)dealloc
{
    _defaultSearchWord = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar.textField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setSearchType:(SearchType)searchType
{
    switch (searchType) {
        case SearchType_VIDEO:
        {
            [_searchBar.searchTypeButton setTitle:@"视频" forState:UIControlStateNormal];
            
            break;
        }
        case SearchType_CHANNEL:
        {
            [_searchBar.searchTypeButton setTitle:@"自频道" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KSearchTypeChangeNotification object:[NSNumber numberWithBool:searchType]];
    self.currentSearchType = searchType;
}

- (void)refreshNetworkData
{
    NSString * str = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!IsStringWithAnyText(str))
    {
        self.dataSource = nil;
        [self refreshUI];
        return;
    }
    
    /*
     think more
     当前一个请求返回数据 在后一个请求之后，界面上刷新的数据 就是前一个请求的。暂时还没想到方法来处理！！！！！
     */
    
    /*
     2014.5.5 添加  如果搜索建议返回为空，则显示搜索历史
     */
    _searchText = _searchBar.text;
 
    
}

- (void)refreshUI
{
    [_table reloadData];
}

- (EmptyView *)emptyView
{
    if (!_emptyView) {
        float height = screenSize().height - TitleBar_Height;
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, TitleBar_Height, self.view.width,height)];
        _emptyView.emptyIcon = Image(@"prompt_logo.png");
        _emptyView.emptyString = LocalizedString(@"您还没有搜索过，赶紧搜搜看吧！");
    }
    return _emptyView;
}

- (void)showTableView
{
    self.view.height = screenSize().height;
}

- (void)hideTableView
{
    self.view.height = TitleBar_Height;
}

- (void)setText:(NSString *)text
{
    _searchBar.text = [text copy];
}

- (NSString *)text
{
    return _searchBar.text;
}
- (void)dismissTable
{
    [self hideTableView];
    isShowTableView = NO;
}

- (void)setTableViewFrame{
    float height = screenSize().height - TitleBar_Height;
    _table.frame = CGRectMake(0, TitleBar_Height, self.view.width,height);
}

#pragma mark UISearchBarDelegate
- (void)searchTypeButtonClick:(TDSearchBar *)searchBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTypeButtonClick:)]) {
        [self.delegate searchTypeButtonClick:self];
    }
}
- (void)searchBarTextDidBeginEditing:(TDSearchBar *)searchBar
{
    isShowTableView = YES;
    [self refreshNetworkData];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSearchBarTextDidBeginEditingNotification object:nil];
   
    
}
- (void)searchBarTextDidEndEditing:(TDSearchBar *)searchBar
{
    [self setTableViewFrame];
}

- (void)searchBarSearchButtonClicked:(TDSearchBar *)searchBar
{
    isShowTableView = NO;
    NSString * string = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(!IsStringWithAnyText(string))
    {
        if (_defaultSearchWord && _defaultSearchWord.length>0) {
            string = [_defaultSearchWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.topSuperView animated:YES];
//            [MBProgressHUD showTextHudAddTo:self.topSuperView title:@"输入内容不能为空" animated:YES afterDelayHide:1];
            [searchBar.textField resignFirstResponder];
            return;
        }
    }
    [SearchHistory addHistory:string type:self.currentSearchType];
    [searchBar.textField resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(searchString: searchType: albumId:)])
    {
        [self.delegate searchString:string searchType:self.currentSearchType albumId:nil];
        
//        [[TDAnalyticsSearch sharedInstance] analyticsSearchClickLogEvent:@"开始搜索点击"
//                                                                    page:@"搜索页一级页面"
//                                                                  extend:@{@"refercode":@"Search|Start"}];

    }
}

- (void)searchBarCancelButtonClicked:(TDSearchBar *) searchBar
{
    [self dismissTable];
    if([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

- (BOOL)searchBar:(TDSearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    NSString * string = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (IsStringWithAnyText(string)) {
        isShowTableView = YES;
        self.dataSource = nil;
        [self refreshNetworkData];
    }
    else {
        self.dataSource = nil;
        [self refreshUI];
        [self dismissSearchTextFeild];
    }
    return YES;
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isShowTableView && _searchBar.textField.text != nil && [_searchBar.textField.text length] > 0) {
        [self showTableView];
    }
    else {
        [self hideTableView];
    }
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    static NSString *clearCellIdentifier = @"clearCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITableViewCell *clearCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:clearCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.indentationLevel = 1;
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.textColor = RGB(112, 112, 112);
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageWithTudouBackgroundImage]];
        cell.backgroundView=backView;
    }
    
    if (!clearCell) {
        clearCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clearCellIdentifier];
        clearCell.indentationLevel = 0;
        clearCell.textLabel.font = [UIFont systemFontOfSize:14.f];
        clearCell.textLabel.textColor = RGB(112, 112, 112);
        
        clearCell.textLabel.backgroundColor = [UIColor clearColor];
        
        clearCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageWithTudouBackgroundImage]];
        clearCell.backgroundView=backView;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource hasIndex:indexPath.row]) {
        cell.indentationWidth = 0;
        NSDictionary * dict = self.dataSource[indexPath.row];
        cell.textLabel.text = dict[@"name"];
        
        UIImage *playImage = nil;
        [cell.contentView removeAllSubviews];
        UIButton *buttonIco = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonIco.frame = CGRectMake(0, (cell.height - 22)/2, 35, 22);
        buttonIco.titleLabel.font = [UIFont systemFontOfSize:10];
        [buttonIco setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
        [buttonIco setBackgroundImage:Image(@"search_recommended_directIco") forState:UIControlStateNormal];
        buttonIco.backgroundColor = [UIColor clearColor];
        buttonIco.userInteractionEnabled = NO;
        [buttonIco setTitle:dict[@"cate"] forState:UIControlStateNormal];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (dict[@"cate"] && [dict[@"cate"] length]) {
            if ([buttonIco isKindOfClass:[UIButton class]]) {
                buttonIco.hidden = NO;
            }
            playImage = Image(@"search_recommended_video_play_icon");
            playBtn.hidden = NO;
        }
        else
        {
            buttonIco.hidden = YES;
            playBtn.hidden = YES;
        }
        [cell.contentView addSubview:buttonIco];

        [playBtn setImage:playImage forState:UIControlStateNormal];
        playBtn.frame = CGRectMake(40, 0, 20, 44);
        playBtn.centerY = cell.height / 2;
        playBtn.userInteractionEnabled = NO;
        playBtn.backgroundColor = [UIColor clearColor];
        
        UIView* playView = [[UIView alloc] initWithFrame:CGRectMake(tableView.width - 60, 0, 60, 44)];
        [playView addSubview:playBtn];
        [playView addSubview:buttonIco];
        cell.accessoryView = playView;
 
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //搜索相关
    NSDictionary * dict = self.dataSource[indexPath.row];
    if([self.delegate respondsToSelector:@selector(searchString:searchType:albumId:)])
    {
      

      //注意命中直达区
        [self.delegate searchString:dict[@"name"]
                         searchType:self.currentSearchType
                            albumId:dict[@"aid"]];
    }
    
    [SearchHistory addHistory:dict[@"name"] type:self.currentSearchType];
    isShowTableView = NO;
    [self.searchBar.textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.3];
    [self hideTableView];
    
}

- (UIControl *)firstResponser
{
    UIControl *firstResponder = [self.view.window performSelector:@selector(firstResponder)];
    return firstResponder;
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.firstResponser isFirstResponder]) {
        [self.firstResponser resignFirstResponder];
    }
}

- (void)dismissSearchTextFeild
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KHideResultsControllerNotif object:nil userInfo:nil];
}


@end
