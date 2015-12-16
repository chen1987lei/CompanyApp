//
//  NewsWebViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/16.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NewsWebViewController.h"

@interface NewsWebViewController ()<UIWebViewDelegate,TDTitleBarDelegate>
{
    UIWebView *_webview;
}
@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleBar.hidden =NO;
    self.titleBar.delegate = self;
    
    [self.titleBar.leftItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    _webview  = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.titleBar.bottom, kScreenWidth,  self.view.frame.size.height - TitleBar_Height)];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    
    [_webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:_newsUrlString]]];
    
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
