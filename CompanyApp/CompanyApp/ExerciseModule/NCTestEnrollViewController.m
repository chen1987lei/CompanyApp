//
//  NCTestEnrollViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCTestEnrollViewController.h"

@interface NCTestEnrollViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_currentChoicelist;
}

@property(nonatomic,strong) UITableView *infoTableView;
@end

@implementation NCTestEnrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.titleBar setTitle:@"考试报名"];
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleBar.height, kScreenWidth, kScreenHeight-self.titleBar.height- 50)];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
    }
    return _infoTableView;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    NSInteger count = [_currentChoicelist count];
    
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
        
        UIButton *choicebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 30, 30)];
        choicebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        choicebtn.backgroundColor =[UIColor whiteColor];
        choicebtn.clipsToBounds = YES;
        choicebtn.layer.cornerRadius = choicebtn.width/2;
        [choicebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choicebtn.tag = 123;
        [cell.contentView addSubview:choicebtn];
        
        UILabel *choiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(choicebtn.right+4, choicebtn.top, 200, 30)];
        choiceLabel.numberOfLines = 0;
        choiceLabel.tag = 124;
        [cell.contentView addSubview:choiceLabel];
    }
    
    UIButton *choicebtn = [cell.contentView viewWithTag:123];
    UILabel *choiceLabel = [cell.contentView viewWithTag:124];
    
  
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end
