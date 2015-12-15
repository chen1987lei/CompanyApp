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
@interface NCHomeViewController ()<UITableViewDataSource,UITableViewDelegate,TDHomeTitleViewDelegate>
{
    UITableView *_mainTable;
    
    NSMutableArray *_arrHomeTitle;
}

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
    
    _mainTable.frame = CGRectMake(0, _titleView.height, [UIScreen width], self.view.height-_titleView.height);//内存警告时用
    
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
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *firstCellIdentifier = @"firstCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
                
                cell.backgroundColor = [UIColor whiteColor];
                
                
            }
            
            
            
            return cell;
        }
            
            break;
        case 1:
        {
            static NSString *kCellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            
            
            return cell;
        }
            break;
        case 2:
        {
            static NSString *kCellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            
            
            return cell;
        }
            break;
        case 3:
        {
            static NSString *kCellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                
                cell.backgroundColor = [UIColor whiteColor];
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
    if (!tableView.isEditing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
