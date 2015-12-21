//
//  NCTestNoticeViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCTestNoticeViewController.h"
#import "MainCell.h"

#import "NCInitial.h"
#import "TDHomeModel.h"

#import "NCTestNoticeContentController.h"
#import "NewsWebViewController.h"
@interface NCTestNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTable;
    NSMutableArray *_noticelist;
}
@end

@implementation NCTestNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleBar.hidden = NO;
    [self.titleBar setTitle:@"考试公告"];
    
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    [self addTableView];
    
    
    _noticelist = [NSMutableArray new];
    
    [[NCInitial sharedInstance] requestNewsListData:_currentModel.modelId withPageFrom:1 withOnePageCount:10 WithComplate:^(NSDictionary *result, NSError *error) {
        
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *res = result[@"res"];
            for (NSDictionary *dict in res) {
                TDHomeModel *model = [[TDHomeModel alloc] init];
                [_noticelist addObject:model];
                model.modelId = dict[@"id"];
                model.title = dict[@"title"];
                             model.subTitle = dict[@"summary"];
                             model.publicdate = dict[@"time"];
                             model.url = dict[@"url"];
                            model.imageUrl = dict[@"img"];
                
                [_noticelist addObject:model];
//                "id":"9","title":"工程师考试要求","summary":" 工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程师考试要求工程","time":"2015-12-14","img":"http://anquan.weilomo.com/Uploads/2015/1214/thumb/154x154/566e9e902e2d3.jpg","url":"http://anquan.weilomo.com/H5/Index/newscontent/id/9
                
            }
            
            [_mainTable reloadData];
        }
    }];
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addTableView
{
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height - TAB_BAR_HEIGHT)];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    [self.view addSubview:_mainTable];
}


#define kCellHeight 70
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
    NSInteger count = [_noticelist count];
    
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 8)];
    
    return footview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"MainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
   TDHomeModel *model =  _noticelist[indexPath.row];
    cell.textLabel.text = model.title;
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
    
    TDHomeModel *model =  _noticelist[indexPath.row];
    NSString *newUrlstr = model.url;
    NewsWebViewController *webcontroller = [[NewsWebViewController alloc] init];
    webcontroller.newsUrlString = newUrlstr;
    
    [webcontroller.titleBar setTitle: model.title];
    
    [self.navigationController pushViewController:webcontroller animated:YES];
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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


@end

