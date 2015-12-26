//
//  NCPersonLibraryViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPersonLibraryViewController.h"
#import "MainCell.h"

@interface NCPersonLibraryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTable;
}
@end

@implementation NCPersonLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleBar.hidden = NO;
    [self.titleBar setTitle:@"人才库"];
    
    [self addTableView];
    
    [[NCInitial sharedInstance] requestResumeListData:nil witheTime:nil andBookType:1 page:1 withPageNumber:10 WithComplate:^(NSDictionary *result, NSError *error) {
       
        
        
    }];
}
-(void)addTableView
{
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.height - TAB_BAR_HEIGHT)];
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
        
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.Headerphoto.clipsToBounds = YES;
            cell.Headerphoto.layer.cornerRadius = cell.Headerphoto.frame.size.width/2;
        }
        
        cell.Headerphoto.image =Image(@"exampleProfile");
// [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",arc4random()%11]];
            cell.nameLabel.text = @"名字";
            cell.IntroductionLabel.text = @"工作三年";
            cell.networkLabel.text = @"建筑安全员";
        
//        if (indexPath.row == dataArray.count-1) {
//            cell.imageLine.image = nil;
//        }
//        else
//            cell.imageLine.image = [UIImage imageNamed:@"line.png"];

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
