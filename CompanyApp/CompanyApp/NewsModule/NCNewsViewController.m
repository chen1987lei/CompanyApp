//
//  NCNewsViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/16.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCNewsViewController.h"
#import "HomeView.h"

@interface NCNewsViewController ()
{
    HomeView *mHomeView;
}
@end

@implementation NCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
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


//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
        [self initTopNavBar];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {
    
//    [self setViewFrame];
}

//重载导航条
-(void)initTopNavBar{
    self.title = @"我的新闻客户端";
    self.navigationItem.leftBarButtonItem = Nil;
}


//初始化数据
-(void)initCommonData{
    
}


#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
// 初始View
- (void) initView {
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    //contentView大小设置
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    //contentView大小设置
    
    CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight -44 -20);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    if (mHomeView == nil) {
        mHomeView = [[HomeView alloc] initWithFrame:vContentView.frame];
    }
    [vContentView addSubview:mHomeView];
    
    self.view = vContentView;
    
//    [self setViewFrame];
}


@end
