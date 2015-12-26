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

#import "NCPracticeViewController.h"

#import "NCPracticeLibraryController.h"

#import "DropDownListView.h"

#import "NCCorpListViewController.h"

#import "NCTestEnrollViewController.h"
#import "NCTestNoticeViewController.h"


enum TAG_HomeView_SECTION{
    
    TAG_HomeView_SECTION1  = 1,
    TAG_HomeView_SECTION2,
    TAG_HomeView_SECTION3,
    TAG_HomeView_SECTION4
};

@interface NCHomeViewController ()<UITableViewDataSource,UITableViewDelegate,TDHomeTitleViewDelegate,NCHomeSectionViewDelegate,
DropDownChooseDelegate,DropDownChooseDelegate>
{
    UITableView *_mainTable;
    
    NSMutableArray *_arrHomeTitle;
    
    NSArray *_arrSectionData;
    
    NSMutableArray *chooseArray ;
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
    
    
    _mainTable.frame = CGRectMake(0, self.postbannerview.bottom, [UIScreen width], self.view.height-TAB_BAR_HEIGHT - self.postbannerview.bottom);//内存警告时用
    
    [self requestBannerData];
    [self refreshSectionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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



-(void)refreshSectionView
{
    _arrSectionData = [NCInitial sharedInstance].indexData.childSectionData;
    
    [_mainTable reloadData];
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
 
       NCBaseModel *model = [NCInitial sharedInstance].indexSearchData;
        NSMutableArray *muarr = [NSMutableArray new];
        for (NCBaseModel *chmodel in model.childSectionData) {
            [muarr addObject:chmodel.modelName];
            
        } chooseArray = [NSMutableArray arrayWithArray:@[muarr]];
        
//        chooseArray = [NSMutableArray arrayWithArray:@[@[@"资讯",@"资料库"]]];
        
        DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,30, 80, 40) dataSource:self delegate:self];
        dropDownView.mSuperView = self.view;
        [_titleView addSubview:dropDownView];
    }
    return _titleView;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%d ,index:%d",section,index);
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
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
//y2aqbcjf
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
    return kCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_arrSectionData count];
    
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 8)];
    
    return footview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        secview.tag = 111;
        
        [cell.contentView addSubview:secview];
    }
    NCHomeSectionView *secview = [cell.contentView viewWithTag:111];
    secview.rowIndex = indexPath.row;
    secview.firstButton.tag = TAG_HomeView_SECTION1+indexPath.row;
    NCBaseModel *model = [_arrSectionData objectAtIndex:indexPath.row];
    NSArray *child = model.childSectionData;

    [secview.leftImageButton setTitle:model.modelName forState:UIControlStateNormal];

    NCBaseModel *model0 = child[0];
    [secview.firstButton setTitle:model0.modelName forState:UIControlStateNormal];
    NCBaseModel *model1 = child[1];
    [secview.secondButton setTitle:model1.modelName forState:UIControlStateNormal];
    if ([child count] >2) {
        NCBaseModel *model2 = child[2];
        [secview.moreButton setTitle:model2.modelName forState:UIControlStateNormal];
    }
    else
    {
       [secview.moreButton setTitle:@"更多" forState:UIControlStateNormal];
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
    NCBaseModel *model = _arrSectionData[secview.rowIndex];
    NCBaseModel *childmodel= model.childSectionData[0];
    switch (secview.firstButton.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION2:
        {
            NCPracticeViewController *newview = [[NCPracticeViewController alloc] init];
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION3:
        {
            NCTestEnrollViewController *newview = [[NCTestEnrollViewController alloc] init];
            [self.navigationController pushViewController:newview animated:YES];
         
        }
            break;
        case TAG_HomeView_SECTION4:
        {
            NCCorpListViewController *newview = [[NCCorpListViewController alloc] init];
            //            newview.currentModel = childmodel;
            //            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)homeSectionSecondButtonAction:(NCHomeSectionView *)secview
{
    NCBaseModel *model = _arrSectionData[secview.rowIndex];
    NCBaseModel *childmodel= model.childSectionData[1];
    switch (secview.firstButton.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION2:
        {
            NCPracticeLibraryController *newview = [[NCPracticeLibraryController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION3:
        {
            NCTestNoticeViewController *newview = [[NCTestNoticeViewController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        case TAG_HomeView_SECTION4:
        {
            NCCorpListViewController *newview = [[NCCorpListViewController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
            [self.navigationController pushViewController:newview animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)homeSectionMoreButtonAction:(NCHomeSectionView *)secview
{
    NCBaseModel *model = _arrSectionData[secview.rowIndex];
    
    if ([model.childSectionData count]<=2) {
        return;
    }
    NCBaseModel *childmodel= model.childSectionData[2];
    switch (secview.firstButton.tag) {
        case TAG_HomeView_SECTION1:
        {
            NCNewsViewController *newview = [[NCNewsViewController alloc] init];
            newview.currentModel = childmodel;
            newview.childData = model.childSectionData;
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
