//
//  NCPracticeStartViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeStartViewController.h"
#import "NCPracticeQuestionViewController.h"

@interface NCPracticeStartViewController ()

@end

@implementation NCPracticeStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.titleBar.hidden = YES;
    UIButton *startButton =  [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [startButton addTarget:self action:@selector(startButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"开始做题" forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    
}

-(void)startButtonAction
{
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
