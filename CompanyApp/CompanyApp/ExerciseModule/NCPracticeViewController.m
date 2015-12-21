//
//  NCPracticeViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/19.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeViewController.h"
#import "TDHomeModel.h"
#import "NCInitial.h"

#import "NCPracticeManager.h"
#import "NCPracticeStartViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"

@interface NCPracticeViewController ()<TDTitleBarDelegate,UITableViewDataSource,UITableViewDelegate,SKSTableViewDelegate>

@property(nonatomic,strong) NSArray *listdata;
@property(nonatomic,strong) SKSTableView *infoTableView;
@end

@implementation NCPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBar.hidden = NO;
    [self.titleBar setTitle:@"练习"];
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    [self.view addSubview:self.infoTableView];
    
    [self requestCorpListData];
}

-(void)requestCorpListData
{
    NCBaseModel *model = [NCInitial sharedInstance].practiceData;
    
    [self loadTableData:model.childSectionData];
    
}

-(void)loadTableData:(NSArray *)list
{
    self.listdata = list;
    
    [self.infoTableView reloadData];
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [[SKSTableView alloc] initWithFrame:CGRectMake(0, self.titleBar.bottom, kScreenWidth, kScreenHeight-self.titleBar.height)];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.SKSTableViewDelegate = self;
    }
    return _infoTableView;
    
}




#define kCellHeight 100
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
    return  [self.listdata count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
{
    NCBaseModel *childmodel = self.listdata[indexPath.row];
    return   [childmodel.childSectionData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CorpMainCell";

    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NCBaseModel *model = self.listdata[indexPath.row];
    
    cell.textLabel.text = model.modelName;
    
    if ([model.childSectionData count] >0)
        cell.isExpandable = YES;
    else
        cell.isExpandable = NO;
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   
    NCBaseModel *model = self.listdata[indexPath.row];
    
    NSInteger subrow = indexPath.subRow -1;
    NCBaseModel *childmodel = model.childSectionData[subrow];
    cell.textLabel.text = childmodel.modelName;
    //[NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.tag = indexPath.row;
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
    
    SKSTableViewCell *cell = (SKSTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SKSTableViewCell class]] && cell.isExpandable) {
        
    }
    else
    {
        NSInteger cellrow = cell.textLabel.tag;
        NCBaseModel *model = self.listdata[cellrow];
        NSInteger subrow = indexPath.subRow ;
//        NCBaseModel *childmodel = model.childSectionData[subrow];
        
        [NCPracticeManager sharedInstance].testStartId = @"17";// childmodel.modelId;
        NCPracticeStartViewController *view = [[NCPracticeStartViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
