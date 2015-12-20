//
//  NCMessageViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMessageViewController.h"
#import "TDHomeModel.h"
#import "NCMessageCntentController.h"

@interface NCMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_msgdata;
    UITableView *_mainTable;
}
@end

@implementation NCMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBar.hidden = NO;
    [self.titleBar setTitle:@"我的消息"];
    
    [self addTableView];
    
    [self requestMessageData];
}
-(void)addTableView
{
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height - TAB_BAR_HEIGHT)];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    [self.view addSubview:_mainTable];
}

-(void)requestMessageData
{
    [[NCInitial sharedInstance] requestServerMessageData:1 withPageNumber:10 WithComplate:^(NSDictionary *result, NSError *error) {
       
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *res = result[@"res"];
            
            NSMutableArray *mularr =  [NSMutableArray array];
            for (NSDictionary *dict in res) {
                
                TDHomeModel *model  = [[TDHomeModel alloc] init];
                 model.modelId = dict[@"id"];
                model.title = dict[@"title"];
                model.subTitle = dict[@"summary"];
                model.imageUrl = dict[@"img"];
                model.coverImageUrl = dict[@"url"];
                model.publicdate = dict[@"time"];
                [mularr addObject:model];
            }
            _msgdata = mularr;
            [_mainTable reloadData];
        }
        else
        {
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"刷新失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }

    }];
}


#define kCellHeight 50
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
    return [_msgdata count];
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
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    TDHomeModel *model = _msgdata[indexPath.row];
    NSString *title = model.title;
    cell.textLabel.text = title;
    NSString *image = model.imageUrl;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    
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
    
    TDHomeModel *model = _msgdata[indexPath.row];
    NCMessageCntentController *contentview= [[NCMessageCntentController alloc] init];
    contentview.msgID = model.modelId;
    [self.navigationController pushViewController:contentview animated:YES];
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
