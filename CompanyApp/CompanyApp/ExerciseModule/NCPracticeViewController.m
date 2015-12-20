//
//  NCPracticeViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/19.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeViewController.h"
#import "TDHomeModel.h"

#import "NCPracticeStartViewController.h"

@interface NCPracticeViewController ()<TDTitleBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSArray *listdata;
@property(nonatomic,strong) UITableView *infoTableView;
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
    WS(weakself)
    [[NCInitial sharedInstance] requestCorpListData:nil page:1 withPageNumber:10 WithComplate:^(NSDictionary *result, NSError *error) {
        
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *res = result[@"res"];
            
            NSMutableArray *mularr =  [NSMutableArray array];
            for (NSDictionary *dict in res) {
                
                TDHomeModel *model  = [[TDHomeModel alloc] init];
                model.name = dict[@"name"];
                model.book = dict[@"book"];
                model.address = dict[@"address"];
                model.imageUrl = dict[@"img"];
                model.phone = dict[@"phone"];
                model.addv = dict[@"addv"];
                [mularr addObject:model];
            }
            [weakself loadTableData:mularr];
            
        }
        else
        {
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"刷新失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
    }];
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
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleBar.bottom, kScreenWidth, kScreenHeight-self.titleBar.height)];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
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
    NSInteger count = [self.listdata count];
    
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CorpMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    cell.textLabel.text = @"考试题1";

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
    
    NCPracticeStartViewController *view = [[NCPracticeStartViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    
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
