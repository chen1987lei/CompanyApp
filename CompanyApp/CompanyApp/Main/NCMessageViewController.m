//
//  NCMessageViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMessageViewController.h"

@interface NCMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
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
}
-(void)addTableView
{
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height - TAB_BAR_HEIGHT)];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    [self.view addSubview:_mainTable];
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
 
            static NSString *firstCellIdentifier = @"firstCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.backgroundColor = [UIColor whiteColor];
            }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text =@"2015年北京市第十期安全员考试名单";
            break;
        }
        case 1:
        {
            cell.textLabel.text =@"安全员考试报名方法"; break;
        }
        case 2:
        {
            cell.textLabel.text =@"劳动职业技能鉴定教材"; break;
        }
        case 3:
        {
            cell.textLabel.text =@"版本更新至2.0，增加新的功能"; break;
        }
            default:
            break;
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
