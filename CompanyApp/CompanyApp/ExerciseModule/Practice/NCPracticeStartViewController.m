//
//  NCPracticeStartViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeStartViewController.h"
#import "NCPracticeQuestionViewController.h"

#import "NCPracticeManager.h"

@interface NCPracticeStartViewController ()

@end

@implementation NCPracticeStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.titleBar.hidden = YES;
    
    self.view.backgroundColor =[UIColor blueColor];
    UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusBar_Height, 60, 30)];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    UIButton *startButton =  [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"开始做题" forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    
}


-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startButtonAction
{
    [NCPracticeManager sharedInstance].startDate = [NSDate date];
    NCPracticeQuestionViewController *view = [[NCPracticeQuestionViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
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
