//
//  NCMessageCntentController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/20.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCMessageCntentController.h"
#import "Utils.h"

@interface NCMessageCntentController ()<TDTitleBarDelegate>
{
    UILabel *titleLabel;
    
    UILabel *subtitleLabel ;
    UITextView *contentView;
}
@end

@implementation NCMessageCntentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.titleBar setTitle:@"消息详情"];
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;

    [self.titleBar.leftItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    titleLabel = [Utils labelWithFrame:CGRectMake(0, self.titleBar.bottom+ 20, kScreenWidth, 30) withTitle:@"" titleFontSize:[UIFont boldSystemFontOfSize:18] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    
    [self.view addSubview:titleLabel];
    
    subtitleLabel = [Utils labelWithFrame:CGRectMake(0, titleLabel.bottom+ 5, kScreenWidth, 20) withTitle:@"" titleFontSize:[UIFont boldSystemFontOfSize:18] textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [self.view addSubview:subtitleLabel];
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, subtitleLabel.bottom, kScreenWidth, 300)];
    contentView.editable = NO;
    [self.view addSubview:contentView];
    
    [self requestMessageData];
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestMessageData
{
    WS(weakself)
    [[NCInitial sharedInstance] requestMessageContentData:_msgID WithComplate:^(NSDictionary *result, NSError *error) {
       
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSDictionary *dict = result[@"res"];
            
            TDHomeModel *model  = [[TDHomeModel alloc] init];
            model.title = dict[@"title"];
            model.modelId = dict[@"id"];
            model.content = dict[@"content"];
            model.publicdate = dict[@"time"];
            
            [weakself showMessage:model];
        }
        else
        {
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"刷新失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }

        
    }];
}

-(void)showMessage:(TDHomeModel *)msgmodel
{
    titleLabel.text = msgmodel.title;
    
    subtitleLabel.text = msgmodel.publicdate;
    
    contentView.text = msgmodel.content;
    
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
