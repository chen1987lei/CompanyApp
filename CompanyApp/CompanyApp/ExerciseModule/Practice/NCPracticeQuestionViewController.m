//
//  NCPracticeQuestionViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeQuestionViewController.h"

@interface NCPracticeQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_choiceImageview;
    UILabel *_qtitleView;
}
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UITableView *infoTableView;
@property(nonatomic,strong) UIView *footView;
@end

@implementation NCPracticeQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    self.infoTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.infoTableView];
    
    
    [self.view addSubview:self.footView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(UIView *)headView
{
    if (!_headView) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
 
        _choiceImageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
        _choiceImageview.clipsToBounds = YES;
        _choiceImageview.layer.cornerRadius = _choiceImageview.width/2;
        [_headView addSubview:_choiceImageview];
        
        _qtitleView = [[UILabel alloc] initWithFrame:CGRectMake(_choiceImageview.right+4, _choiceImageview.top,_headView.width-_choiceImageview.right, 30)];
        _qtitleView.numberOfLines = 0;
        [_headView addSubview:_qtitleView];
        _qtitleView.text = @"编织施工组织设计方案时，必须制定针对性的（）";
    }
    
    return _headView;
}

-(void)nextButtonAction
{
    
}

-(void)processButtonAction
{
    
}

-(void)collectButtonAction
{
    
}

-(void)subButtonAction
{
    
}
-(UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.infoTableView.bottom, kScreenWidth, 50)];
        _footView.backgroundColor =[UIColor brownColor];
        
        float btnwidth = kScreenWidth/4;
        UIButton *nextbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, btnwidth, 30)];
            nextbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [nextbtn setTitle:@" 下一题 " forState:UIControlStateNormal];
//            [deletebtn setImage:[UIImage imageNamed:@"icon-rubbish.png"] forState:UIControlStateNormal];
            [nextbtn addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
     
        [_footView addSubview:nextbtn];
        
            
        UIButton *processbtn = [[UIButton alloc] initWithFrame:CGRectMake(nextbtn.right, 7, btnwidth, 30)];
            processbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [processbtn setTitle:@" 1/100 " forState:UIControlStateNormal];
            [processbtn addTarget:self action:@selector(processButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
             [_footView addSubview:processbtn];
        
        UIButton *collectbtn = [[UIButton alloc] initWithFrame:CGRectMake(processbtn.right, 7, btnwidth, 30)];
        collectbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [collectbtn setTitle:@"收藏 " forState:UIControlStateNormal];
        //            [deletebtn setImage:[UIImage imageNamed:@"icon-rubbish.png"] forState:UIControlStateNormal];
        [collectbtn addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_footView addSubview:collectbtn];
        
        
        UIButton *subbtn = [[UIButton alloc] initWithFrame:CGRectMake(collectbtn.right, 7, btnwidth, 30)];
        subbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [subbtn setTitle:@" 交卷 " forState:UIControlStateNormal];
        //            [deletebtn setImage:[UIImage imageNamed:@"icon-rubbish.png"] forState:UIControlStateNormal];
        [subbtn addTarget:self action:@selector(subButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_footView addSubview:subbtn];
        
    }
    
    return _footView;
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
        [choicebtn addTarget:self action:@selector(choiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        choicebtn.tag = 123;
        [cell.contentView addSubview:choicebtn];
        
        UILabel *choiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(choicebtn.right+4, choicebtn.top, 200, 30)];
        choiceLabel.numberOfLines = 0;
        choiceLabel.tag = 124;
        [cell.contentView addSubview:choiceLabel];
    }
    
    UIButton *choicebtn = [cell.contentView viewWithTag:123];
    UILabel *choiceLabel = [cell.contentView viewWithTag:124];
    
    choiceLabel.text = @"安全技术措施和方案";
    choicebtn.titleLabel.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            [choicebtn setTitle:@"A" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
             [choicebtn setTitle:@"B" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
             [choicebtn setTitle:@"C" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [choicebtn setTitle:@"D" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}

-(void)choiceButtonAction:(UIButton *)sender
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
