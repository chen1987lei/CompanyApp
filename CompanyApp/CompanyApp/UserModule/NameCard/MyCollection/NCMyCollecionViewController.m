//
//  NCMyCollecionViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/21.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMyCollecionViewController.h"

@interface NCMyCollecionViewController ()

@end

@implementation NCMyCollecionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.titleBar.hidden = NO;
    
    [self.titleBar setTitle:@"我的收藏"];
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    self.titleBar.delegate = self;
    
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
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
