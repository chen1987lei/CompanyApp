//
//  NCPracticeResultViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCPracticeResultViewController.h"

#import "NCPracticeQuestionViewController.h"
#import "NCPracticeManager.h"
@interface NCPracticeResultViewController ()<TDTitleBarDelegate>

//@property
@end

@implementation NCPracticeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self.titleBar setTitle:@"习题报告"];
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    [self showResultView];
    
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showResultView
{
    NSArray *questionlist = [NCPracticeManager sharedInstance].questionList;
    NSInteger score = 0;
    for (NSPracticeQuestion *quest in questionlist) {
        if ([quest.answer isEqualToString:quest.useranswer]) {
            score ++;
        }
    }
    
    
    NSTimeInterval userdtime =  [NCPracticeManager sharedInstance].usedtime;

    
    UIView *contentview =  [[UIView alloc] initWithFrame:CGRectMake(100, self.titleBarHeight+50, kScreenWidth-200, 200)];
    
    
    UILabel *fenshuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 25)];
 
    fenshuLabel.text = @"分数";
    [contentview addSubview:fenshuLabel];
    
    UILabel *fenshuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(fenshuLabel.right +20, fenshuLabel.top, 200, 25)];
    fenshuValueLabel.text = [NSString stringWithFormat:@"%ld",(long)score];
    [contentview addSubview:fenshuValueLabel];
    
    
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(fenshuLabel.left, fenshuLabel.bottom+10, fenshuLabel.width, fenshuLabel.height)];
    timeLable.text = @"用时";
    [contentview addSubview:timeLable];
    
    
    UILabel *timeValueLable = [[UILabel alloc] initWithFrame:CGRectMake(fenshuValueLabel.left, fenshuValueLabel.bottom+10, fenshuValueLabel.width, fenshuValueLabel.height)];
    timeValueLable.text =[NSString stringWithFormat:@"%f",userdtime];
    [contentview addSubview:timeValueLable];
    
    
    UIButton *errButton = [[UIButton alloc] initWithFrame:CGRectMake(fenshuLabel.left, timeLable.bottom+20, fenshuLabel.width,40)];
    [errButton addTarget:self action:@selector(errButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [errButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [errButton setTitle:@"错题解析" forState:UIControlStateNormal];
    [contentview addSubview:errButton];
   
    
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake(errButton.right +20, errButton.top, errButton.width, errButton.height)];
    [retryButton addTarget:self action:@selector(retryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [retryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [retryButton setTitle:@"重新做题" forState:UIControlStateNormal];
    [contentview addSubview:retryButton];
    
    [self.view addSubview:contentview];
    
}

-(void)errButtonAction
{
    //应该找到上个
   NCPracticeQuestionViewController *view = nil;
    for(UIViewController *controll in self.navigationController.viewControllers)
    {
        if ([controll isKindOfClass:[NCPracticeQuestionViewController class]]) {
            view = (NCPracticeQuestionViewController *)controll;
            break;
        }
    }
    
    view.shouldShowErrInfo = YES;
    [self.navigationController popToViewController:view animated:YES];

}

-(void)retryButtonAction
{
    NCPracticeQuestionViewController *view = nil;
    for(UIViewController *controll in self.navigationController.viewControllers)
    {
        if ([controll isKindOfClass:[NCPracticeQuestionViewController class]]) {
            view = (NCPracticeQuestionViewController *)controll;
            break;
        }
    }
    [self.navigationController popToViewController:view animated:YES];
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
