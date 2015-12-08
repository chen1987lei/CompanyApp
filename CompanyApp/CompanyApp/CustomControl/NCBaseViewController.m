
//
//  NCBaseViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCBaseViewController.h"

#define TitleBar_Height (MY_IOS_VERSION_7?(44+20):44)

@interface NCBaseViewController ()
{
    UIView *_titleBar;
}
@end

@implementation NCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showTitleBar
{
    [self.view addSubview:self.titleBar];
}

- (UIView *) titleBar
{
    if(!_titleBar)
    {
        _titleBar = [[UIView alloc] init];
        if([self isViewLoaded])
            [self.view addSubview:_titleBar];
    }
    return _titleBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)titleBarHeight
{
    if(_titleBar)
        return TitleBar_Height;
    else
        return 0;
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
