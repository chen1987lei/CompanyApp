//
//  NCMyViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMyViewController.h"
#import "RKCardView.h"

#import "NCMyInfoViewController.h"
#import "NCMyCollecionViewController.h"
#import "NCMyResumeInfoViewController.h"
#import "NCMySettingViewController.h"

#define BUFFERX 20 //distance from side to the card (higher makes thinner card)
#define BUFFERY 40 //distance from top to the card (higher makes shorter card)


@interface NCMyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_cardTable;
}
@end

@implementation NCMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    //    RKCardView* cardView= [[RKCardView alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
//    
//    cardView.coverImageView.image = Image(@"exampleCover");
//    cardView.profileImageView.image = Image(@"exampleProfile");
//    
//    cardView.titleLabel.text = @"Richard Kim";
//    //    [cardView addBlur];
//    //    [cardView addShadow];
//    [self.view addSubview:cardView];
 
    self.title = @"个人中心";
    
    //创建tableView
    [self createTableView];
    
}


- (void)createTableView{
    
    float tbwidth = self.view.width;
    _cardTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, (FSystenVersion >= 7.0)?64.f:44.f, tbwidth, (FSystenVersion >=7.0)?(ISIPHONE5?(568.f - 64.f):(480.f - 64.f)):(ISIPHONE5?(548.f - 44.f):(460.f - 44.f))) style:UITableViewStyleGrouped];
    _cardTable.delegate = self;
    _cardTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _cardTable.dataSource = self;
    [self.view addSubview:_cardTable];
    
    UIView *footview =  [[UIView alloc] initWithFrame:CGRectMake(0, 0,_cardTable.width , 200)];
    
    UIButton *submitbtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 28, self.view.width-12, 34)];
    [submitbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [submitbtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [footview addSubview:submitbtn];
    submitbtn.backgroundColor =[UIColor blueColor];
    [submitbtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    _cardTable.tableFooterView = footview;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


#define offset 15.f
#define textwidth 120.f
#define celltop 10.f

#define txtfieldHeight 20.f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        //        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        static NSString *cellIdentifier = @"cellIdentifier";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, celltop, 70.f, 20.f) withTitle:@"姓名" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
//        _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(label.right+offset, celltop, 250, txtfieldHeight)];
//        _phoneTF.placeholder= @"请输入注册时使用的手机号";
//        [cell addSubview:_phoneTF];
//        _phoneTF.font = [UIFont systemFontOfSize:13];
        
        

        return cell;
    }
    else if (indexPath.row == 1){
        static NSString *cellIdentifier1 = @"cellIdentifier1";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"我的收藏" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
//        _codeTF=[[UITextField alloc]initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
//        _codeTF.placeholder= @"请输入验证码";
//        [cell addSubview:_codeTF];
        
        return cell;
    }else if (indexPath.row == 2){
        static NSString *cellIdentifier2 = @"cellIdentifier2";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"我的积分" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
//        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
//        textField.returnKeyType = UIReturnKeyDone;
//        textField.delegate = self;
//        textField.placeholder = @"请输入密码";
//        textField.keyboardType = UIKeyboardTypeASCIICapable;
//        [cell addSubview:textField];
//        _firstpwd = textField;
//        _firstpwd.font = [UIFont systemFontOfSize:13];

        return cell;
    }
    else if (indexPath.row == 3){
        static NSString *cellIdentifier3 = @"cellIdentifier3";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"我的简历" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
        
//        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(label.right+offset, celltop, textwidth, txtfieldHeight)];
//        textField.returnKeyType = UIReturnKeyDone;
//        textField.delegate = self;
//        textField.placeholder = @"请重复输入密码";
//        textField.keyboardType = UIKeyboardTypeASCIICapable;
//        [cell addSubview:textField];
//        _secondpwd = textField;
//        _secondpwd.font = [UIFont systemFontOfSize:13];

        return cell;
    }
    else if (indexPath.row == 4){
        static NSString *cellIdentifier4 = @"cellIdentifier4";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4];
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(6.f, 10.f, 70.f, 20.f) withTitle:@"设置" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [cell addSubview:label];
    
        return cell;
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 36;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            NCMyInfoViewController *myview = [[NCMyInfoViewController alloc] init];
            [self.navigationController pushViewController:myview animated:YES];
            
        }
            break;
        case 1:
        {
            NCMyCollecionViewController *myview = [[NCMyCollecionViewController alloc] init];
            [self.navigationController pushViewController:myview animated:YES];
        }
            break;
        case 2:
        {
          //我的积分
        }
            break;
        case 3:
        {
            NCMyResumeInfoViewController *myview = [[NCMyResumeInfoViewController alloc] init];
            [self.navigationController pushViewController:myview animated:YES];
        }
            break;
        case 4:
        {
            NCMySettingViewController *myview = [[NCMySettingViewController alloc] init];
            [self.navigationController pushViewController:myview animated:YES];
        }
            break;
        default:
            break;
    }
    
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)logoutAction
{
    NSUserDefaults *defal = [NSUserDefaults standardUserDefaults];
    [defal removeObjectForKey:@"useruid"];
      [defal removeObjectForKey:@"useruuid"];
    [defal synchronize];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        exit(0);
    });
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
