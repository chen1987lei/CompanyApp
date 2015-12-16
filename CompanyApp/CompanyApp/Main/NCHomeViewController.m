//
//  NCHomeViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCHomeViewController.h"
#import "TDHomeTitleView.h"
#import "TDHomeTitleModel.h"

#import "NCInitial.h"

#import "NCNewsViewController.h"

#import "TDBannerCollectionView.h"

#import "NCHomeSectionView.h"
#import "TDHomePosterBannerModel.h"

#import "NCNewsViewController.h"

enum TAG_HomeView_SECTION{
    
    TAG_HomeView_SECTION1  = 1,
    TAG_HomeView_SECTION2,
    TAG_HomeView_SECTION3,
    TAG_HomeView_SECTION4
};

@interface NCHomeViewController ()<UITableViewDataSource,UITableViewDelegate,TDHomeTitleViewDelegate,NCHomeSectionViewDelegate>
{
    UITableView *_mainTable;
    
    NSMutableArray *_arrHomeTitle;
}
@property(nonatomic,strong) TDBannerCollectionView *postbannerview;
@property (nonatomic,strong) TDHomeTitleView *titleView;
@end

@implementation NCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.opaque=YES;
    self.view.backgroundColor=RGBS(255);
    self.view.frame = CGRectMake(0, 0, [UIScreen width], [UIScreen height]);//不能删，parentViewController相关
    
    [self addTableView];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.postbannerview];
    
    
    _mainTable.frame = CGRectMake(0, self.postbannerview.bottom, [UIScreen width], self.view.height-_titleView.height);//内存警告时用
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestBannerData];
}

-(void)requestBannerData
{
    WS(weakself)
    [[NCInitial sharedInstance] requestHomeBannerWithComplate:^(NSDictionary *result, NSError *error) {
        
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *res = result[@"res"];
            [weakself refreshHomeBannerViewData:res];
        }
        else
        {
            NSString *msg = result[@"msg"];
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
        
    }];
}

-(void)refreshHomeBannerViewData:(NSArray *)bannerData
{
    NSMutableArray *headTemp = [NSMutableArray array];
    for (NSDictionary *dic in bannerData) {
        TDHomePosterBannerModel *home=[[TDHomePosterBannerModel alloc] init];
        
//        img = "http://anquan.weilomo.com/Uploads/2015/1210/thumb/710x200/566976a6dad62.jpg";
//        title = "d\U7b2c\U4e09\U4e2a";
//        url = "http://www.baidu,com";
        
        home.imageUrl=dic[@"img"];
        home.title= dic[@"title"];
        //        home.skipInfo= dic[@"url"];
        [headTemp addObject:home];
    }
    
    [self.postbannerview refreshPosterBanner:headTemp];
}

#define leftoff 8
-(TDBannerCollectionView *)postbannerview
{
    if (!_postbannerview) {
        _postbannerview=[[TDBannerCollectionView alloc] initWithFrame:CGRectMake(leftoff, self.titleView.bottom, kScreenWidth-2*leftoff, 100)];
    }
    return _postbannerview;
}

-(TDHomeTitleView *)titleView{
    if (!_titleView) {
        _titleView=[[TDHomeTitleView alloc] init];
        _titleView.delegate= self;
        _titleView.titleDelegate=self;
        [_titleView setTitleBarTudouColor];
        [_titleView setBottomLineViewHidden:YES];//5.4 设计要求去掉
        
        NSDictionary *homeTitleDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeTitleInfo"];
        _arrHomeTitle = [NSMutableArray array];
        
        if (homeTitleDic) {
            for (NSDictionary *dic in homeTitleDic) {
                TDHomeTitleModel *model = [[TDHomeTitleModel alloc] initWithDictionary:dic];
                
                if (model.isValid) { //只显示可以的
                    [_arrHomeTitle addObject:model];
                }
            }
            
            if (_arrHomeTitle && [_arrHomeTitle count] > 0) {   //cms配置的 icon 没问题的才显示
                [_titleView setTitleItemsWithCMS:_arrHomeTitle];
            }
        }
        
        if (!_titleView.isCMSTitle) {
            [_titleView setDefaultTitleItems];
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMarketingIcon) name:kTDTitleBarShowMarketControlNotification object:nil];
    }
    return _titleView;
}

-(void)addTableView
{
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    [self.view addSubview:_mainTable];
}



-(void)searchBarDidClick:(NSString *)searchKey{
//    TDSearchViewController *search=[[TDSearchViewController alloc] init];
//    [search setDefaultSearchWord:_homeDataSource.searchKey];
//    [self.navigationController pushViewController:search animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define kCellHeight 120
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight+20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 4;
    
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 8)];
    
    return footview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            static NSString *firstCellIdentifier = @"firstCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.backgroundColor = [UIColor whiteColor];
                
                
                NCHomeSectionView *secview = [[NCHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kCellHeight)];
                secview.actiondelegate = self;
//                secview.backgroundColor = [UIColor ];
                secview.tag = TAG_HomeView_SECTION1;
                [secview.leftImageButton setTitle:@"资讯" forState:UIControlStateNormal];
                [secview.firstButton setTitle:@"安全新闻" forState:UIControlStateNormal];
                [secview.secondButton setTitle:@"安全政策" forState:UIControlStateNormal];
                [secview.moreButton setTitle:@"安全动态" forState:UIControlStateNormal];
                
                [cell.contentView addSubview:secview];
            }
            
            return cell;
        }
            
            break;
        case 1:
        {
            static NSString *kCellIdentifier2 = @"Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier2];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier2];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                NCHomeSectionView *secview = [[NCHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 66)];
                secview.actiondelegate = self;
                secview.tag = TAG_HomeView_SECTION2;
                [secview.leftImageButton setTitle:@"培训学习" forState:UIControlStateNormal];
                [secview.firstButton setTitle:@"练习" forState:UIControlStateNormal];
                [secview.secondButton setTitle:@"资料库" forState:UIControlStateNormal];
                [secview.moreButton setTitle:@"安全动态" forState:UIControlStateNormal];
                
                [cell.contentView addSubview:secview];
            }
            
            
            return cell;
        }
            break;
        case 2:
        {
            static NSString *kCellIdentifier3 = @"Cell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier3];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier3];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                NCHomeSectionView *secview = [[NCHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 66)];
                
                secview.actiondelegate = self;
                secview.tag = TAG_HomeView_SECTION3;
                [secview.leftImageButton setTitle:@"考试报名" forState:UIControlStateNormal];
                [secview.firstButton setTitle:@"报名" forState:UIControlStateNormal];
                [secview.secondButton setTitle:@"考试公告" forState:UIControlStateNormal];
                [secview.moreButton setTitle:@"更多" forState:UIControlStateNormal];
                
                [cell.contentView addSubview:secview];
            }
            
            return cell;
        }
            break;
        case 3:
        {
            static NSString *kCellIdentifier4 = @"Cell4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier4];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier4];
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                NCHomeSectionView *secview = [[NCHomeSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 66)];
                secview.actiondelegate = self;
                secview.tag = TAG_HomeView_SECTION4;
                [secview.leftImageButton setTitle:@"认证查询" forState:UIControlStateNormal];
                [secview.firstButton setTitle:@"个人证书查询" forState:UIControlStateNormal];
                [secview.secondButton setTitle:@"认证机构查询" forState:UIControlStateNormal];
                [secview.moreButton setTitle:@"更多" forState:UIControlStateNormal];
                
                [cell.contentView addSubview:secview];
            }
            
            return cell;
        }
            break;
        default:
            break;
    }
    
    static NSString *kCellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(void)searchBarDidClick
{
    //进搜索
    
}

-(void)homeSectionLeftButtonAction:(NCHomeSectionView *)secview
{

}

-(void)homeSectionFisrtButtonAction:(NCHomeSectionView *)secview
{
    switch (secview.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.newsID = @"2";
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION2:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.newsID = @"3";
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION3:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.newsID = @"4";
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION4:
            
            break;
        default:
            break;
    }
}
-(void)homeSectionSecondButtonAction:(NCHomeSectionView *)secview
{
    switch (secview.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.newsID = @"3";
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION2:
            
            break;
        case TAG_HomeView_SECTION3:
            
            break;
        case TAG_HomeView_SECTION4:
            
            break;
        default:
            break;
    }
}

-(void)homeSectionMoreButtonAction:(NCHomeSectionView *)secview
{
    switch (secview.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.newsID = @"4";
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION2:
            
            break;
        case TAG_HomeView_SECTION3:
            
            break;
        case TAG_HomeView_SECTION4:
            
            break;
        default:
            break;
    }
}


@end
