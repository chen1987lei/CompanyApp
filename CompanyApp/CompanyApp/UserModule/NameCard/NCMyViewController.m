//
//  NCMyViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMyViewController.h"
#import "RKCardView.h"

#define BUFFERX 20 //distance from side to the card (higher makes thinner card)
#define BUFFERY 40 //distance from top to the card (higher makes shorter card)


@interface NCMyViewController ()

@end

@implementation NCMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    RKCardView* cardView= [[RKCardView alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
    
    cardView.coverImageView.image = Image(@"exampleCover");
    cardView.profileImageView.image = Image(@"exampleProfile");
    
    cardView.titleLabel.text = @"Richard Kim";
    //    [cardView addBlur];
    //    [cardView addShadow];
    [self.view addSubview:cardView];

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, kScreenWidth- 100*2, 40)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)logoutAction
{
    NSUserDefaults *defal = [NSUserDefaults standardUserDefaults];
    [defal removeObjectForKey:@"useruid"];
      [defal removeObjectForKey:@"useruuid"];
    [defal synchronize];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
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
