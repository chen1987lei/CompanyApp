//
//  NCNewsViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/16.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCNewsViewController.h"
#import "HomeView.h"
#import "TDHomeModel.h"
#import "NewsWebViewController.h"

@interface NCNewsViewController ()<HomeViewDelegate,TDTitleBarDelegate>
{
    HomeView *mHomeView;
    BOOL _needrefresh;
}
@end

@implementation NCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleBar setTitle:@"咨讯"];
    self.titleBar.hidden = NO;
    self.titleBar.delegate = self;
    
    [self.titleBar.leftItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleBar setLeftTitle:@"返回" withSelector:@selector(goback)];
    
    
    [self initView];
    // Do any additional setup after loading the view.
    
//    [self initCommonData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_needrefresh) {
        
        [self initCommonData];
    }
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


//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
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
    self.title = @"咨讯";
}


//初始化数据
-(void)initCommonData{
  
    NSInteger modelindex  = [_childData indexOfObject:_currentModel];
    [[NCInitial sharedInstance] requestNewsListData:_currentModel.modelId withPageFrom:1 withOnePageCount:10 WithComplate:^(NSDictionary *result, NSError *error) {
        
        NSInteger code = [result[@"code"] integerValue];
        if (code == 200) {
            NSArray *res = result[@"res"];
            
            NSMutableArray *mularr =  [NSMutableArray array];
            for (NSDictionary *dict in res) {
                
                TDHomeModel *model  = [[TDHomeModel alloc] init];
                model.title = dict[@"title"];
                model.subTitle = dict[@"summary"];
                model.imageUrl = dict[@"img"];
                model.coverImageUrl = dict[@"url"];
                model.publicdate = dict[@"time"];
                [mularr addObject:model];
            }
            
            NSLog(@"---modelindex %d--",modelindex);
            if (modelindex == mHomeView.baseChIndex) {
                
                [mHomeView loadData:mularr];
            }
        }
        else
        {
            [mHomeView loadData:nil];
            NSString *msg = result[@"msg"];
            if(msg == nil) msg = @"刷新失败";
            [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
        }
        
    }];
}


#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
// 初始View
- (void) initView {
    
    //contentView大小设置
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = self.view.frame.size.height - TitleBar_Height;
    
    //contentView大小设置
    
    CGRect vViewRect = CGRectMake(0, self.titleBar.bottom, vWidth, vHeight );
    
    if (mHomeView == nil) {
        mHomeView = [[HomeView alloc] initWithFrame:vViewRect];
        mHomeView.actiondelegate = self;
    }
    
    NSInteger currentIndex = [_childData indexOfObject:_currentModel];
    NSMutableArray *mularr = [NSMutableArray new];
    for (NCBaseModel *child in  _childData) {
        [mularr addObject:child.modelName];
    }
    mHomeView.menuItemArray = mularr;
    mHomeView.baseChIndex = currentIndex;
    
    [self.view addSubview:mHomeView];
    [mHomeView  commInit];
}

-(void)homeViewDidClickNews:(TDHomeModel *)model
{
    
    NSString *newUrlstr = model.coverImageUrl;
    NewsWebViewController *webcontroller = [[NewsWebViewController alloc] init];
    webcontroller.newsUrlString = newUrlstr;
    
    [webcontroller.titleBar setTitle: model.title];
    
    [self.navigationController pushViewController:webcontroller animated:YES];
    
}

-(void)homeViewDidChangeChannel:(NSInteger)chIndex
{
     NCBaseModel *model = (NCBaseModel *)_childData[chIndex];
    _currentModel = model;
    [self initCommonData];
}

@end
