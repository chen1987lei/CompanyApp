//
//  NCMyNewNameViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMyNewNameViewController.h"

@interface NCMyNewNameViewController ()
{
    UILabel *_nameTipLabel;
    UITextField *_myTextField;
}
@end

@implementation NCMyNewNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;
    [self.titleBar setRightTitle:@"保存"];
    
    _nameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 , 100, 16)];
    _nameTipLabel.text = @"名称";
    [self.view addSubview:_nameTipLabel];
    
    _myTextField = [[UITextField alloc] initWithFrame:CGRectMake(_nameTipLabel.right+5, _nameTipLabel.top, 100, 16)];
    _myTextField.placeholder = @"请输入名字";
    [self.view addSubview:_myTextField];
    
}

-(void)titleBardidClickRightTitle{

    [self doneEditName:nil];
}


-(void)doneEditName:(id)sender
{
    NSString *trimedString = [_myTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimedString.length >0)
    {
        
    }
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
