//
//  NCMyResumeInfoViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMyResumeInfoViewController.h"

@interface NCMyResumeInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_photoview;
    UILabel *_nameLabel;
    UILabel *_cardtypeLabel;
    UILabel *_cityLabel;
    
    UILabel *_cardLabel;
    UILabel *_cardValueLabel;
}

@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UITableView *infoTableView;
@end

@implementation NCMyResumeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleBar.hidden = NO;
    [self.titleBar setTitle:@"我的简历"];
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    self.infoTableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.infoTableView];
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleBarHeight, kScreenWidth, kScreenHeight-self.titleBar.height)];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
    }
    return _infoTableView;
    
}

-(UIView *)headView
{
    if (!_headView) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        
        _photoview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 120)];
        _photoview.clipsToBounds = YES;
        _photoview.layer.cornerRadius = _photoview.width/2;
        [_headView addSubview:_photoview];
        
         _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoview.right+4, _photoview.top, 100, 16)];
        [_headView addSubview:_photoview];
        _nameLabel.text = @"张先生";
        
        _cardtypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, _photoview.bottom+2, 100, 16)];
        _cardtypeLabel.text = @"特种作业操作证";
        [_headView addSubview:_photoview];
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cardtypeLabel.right+2, _cardtypeLabel.top, 100, 16)];
        _cityLabel.text = @"北京市";
       [_headView addSubview:_photoview];
        
        _cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, _cardtypeLabel.bottom+2, 100, 16)];
        _cardLabel.text = @"安全证件号:";
        [_headView addSubview:_cardLabel];
        
        _cardValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_cardLabel.right+4, _cardLabel.top, 100, 16)];
        [_headView addSubview:_cardValueLabel];
        _cardValueLabel.text = @"12011200323232";
        
    }
    
    return _headView;
}

#define kCellHeight 70
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 4;
    switch (section) {
        case 0:
            count = 5;
            break;
        case 1:
            count =  4;
            break;
        case 2:
            count = 2;
            break;
        default:
            break;
    }
    
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 18)];
    UILabel *titlelbl = [[UILabel alloc] initWithFrame:headview.bounds];
    switch (section) {
        case 1:
        {
         titlelbl.text = @"从业经历:";
        }
            break;
        case 2:
        {
           titlelbl.text = @"培训经历:";
        }
            break;
        default:
            break;
    }
    return headview;
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
    
    switch (indexPath.section) {
        case 0:
        {
                switch (indexPath.row) {
                 case 0:
                    {
                        cell.textLabel.text =@"最高学历:";
                        cell.detailTextLabel.text =@"大专";
                    }
                        break;
                    case 1:
                    {
                        cell.textLabel.text =@"从业年限:";
                        cell.detailTextLabel.text =@"5年";
                    }
                        break;
                    case 2:
                    {
                        cell.textLabel.text =@"目标职业:";
                        cell.detailTextLabel.text =@"建筑安全员";
                    }
                        break;
                    case 3:
                    {
                        cell.textLabel.text =@"期望薪资:";
                        cell.detailTextLabel.text =@"5000元";
                    }
                        break;
                    case 4:
                    {
                        cell.textLabel.text =@"电话号码:";
                        cell.detailTextLabel.text =@"15912345678";
                    }
                        break;
                    case 5:
                    {
                        cell.textLabel.text =@"邮箱地址:";
                        cell.detailTextLabel.text =@"zhangzhang@126.com";
                    }
                        break;
                }
            
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text =@"2009.10在工程教育实习";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text =@"2009.10在工程教育实习";
                }
                    break;
                case 2:
                {
                    cell.textLabel.text =@"2009.10在工程教育实习";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text =@"2009.10在工程教育实习";
                }
                    break;
                case 4:
                {
                    cell.textLabel.text =@"2009.10在工程教育实习";
                }
                    break;
            }
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text =@"2009.10在工程教育实习";
                    
                    break;
                case 1:
                    cell.textLabel.text =@"2009.10在工程教育实习";
                    
                    break;
            }
            
        }
            break;
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
