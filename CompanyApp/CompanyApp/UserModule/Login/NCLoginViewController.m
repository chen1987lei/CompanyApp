//
//  NCLoginViewController.m
//  CompanyApp
//
//  Created by chenlei on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "NCLoginViewController.h"
#import "TDAutocompleteTextField.h"
#import "TDNoneMenuTextField.h"

#import "RegisterViewController.h"
#import "NCRecoveryPWDViewController.h"

#import "NCUserConfig.h"
#import "NCUserNetManager.h"
#import "Utils.h"

#define kTextFieldHeight 45.0f
#define kBreakLineColor         RGBS(220)

@interface NCLoginViewController ()
{
    UIScrollView *_scrollView;
    TDAutocompleteTextField *tfLoginName;
    TDNoneMenuTextField *tfPassword;
    
    UIView *_actionsview;
    UIButton *_loginBtn;
    UIButton *_findPasswordBtn ;
    UIButton *_phoneBtn;
    
    UIView  *_passwordline;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *contentView;
@end

@implementation NCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    [self.view addSubview:self.scrollView];
    [self addLoginActionsView];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.titleBarHeight+0.5, self.view.width, screenSize().height - self.titleBarHeight-0.5)];
        //_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height + 1);
        _scrollView.backgroundColor = RGBS(245);
        _scrollView.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, _scrollView.width, 0.5)];
        line.backgroundColor = RGBS(220);
        [_scrollView addSubview:line];
        
        
        
        UIImageView *iconview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 161)];
        
        [_scrollView addSubview:iconview];
        
        
        [_scrollView addSubview:self.contentView];
        
    }
       return _scrollView;
}

- (UIImageView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 161, self.view.width, 120)];
        _contentView.userInteractionEnabled = YES;
        

        tfLoginName = [[TDAutocompleteTextField alloc] initWithFrame:CGRectMake(20, 0.5, _contentView.width - 2 * 20, kTextFieldHeight)];
        tfLoginName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tfLoginName.autocorrectionType =UITextAutocorrectionTypeNo;              //不自动做拼写矫正
        tfLoginName.autocapitalizationType = UITextAutocapitalizationTypeNone;  //首字母不自动大写
        tfLoginName.placeholder = @"请输入手机号";

        tfLoginName.keyboardType=UIKeyboardTypeEmailAddress;
        tfLoginName.clearButtonMode = UITextFieldViewModeWhileEditing;
        tfLoginName.returnKeyType = UIReturnKeyDone;
        tfLoginName.delegate = self;
        tfLoginName.font = [UIFont systemFontOfSize:14];
        tfLoginName.textColor = RGBS(61);
        tfLoginName.backgroundColor = [UIColor whiteColor];
        tfLoginName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfLoginName.autoDelegate = self;
        
        //Email白背景
        UIView *emailBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, _contentView.width, kTextFieldHeight)];
        emailBG.backgroundColor  = [UIColor whiteColor];
        
        UIView *midline = [[UIView alloc] initWithFrame:CGRectMake(15, kTextFieldHeight, _contentView.width-30, 0.5)];
        midline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        midline.backgroundColor = kBreakLineColor;
        
        tfPassword = [[TDNoneMenuTextField alloc] initWithFrame:CGRectMake(20, tfLoginName.bottom, _contentView.width - 2 * 20, kTextFieldHeight)];
        tfPassword.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tfPassword.placeholder = LocalizedString(@"请输入密码");
        tfPassword.secureTextEntry = YES;
        tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        tfPassword.returnKeyType = UIReturnKeyDone;
        tfPassword.delegate = self;
        tfPassword.font = [UIFont systemFontOfSize:14];
        tfPassword.textColor = RGB(117, 117, 118);
        tfPassword.backgroundColor = [UIColor whiteColor];
        tfPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        
        //密码白背景
        UIView *passwordBG = [[UIView alloc] initWithFrame:CGRectMake(0, tfLoginName.bottom, _contentView.width, kTextFieldHeight)];
        passwordBG.backgroundColor  = [UIColor whiteColor];
        
        _passwordline = [[UIView alloc] initWithFrame:CGRectMake(0, passwordBG.bottom, _contentView.width, 0.5)];
        _passwordline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _passwordline.backgroundColor = kBreakLineColor;
        

        //        [_contentView addSubview:nickLabel];
        [_contentView addSubview:emailBG];
        [_contentView addSubview:passwordBG];
        
        [_contentView addSubview:tfLoginName];
        [_contentView addSubview:tfPassword];
        
        
        //        [_contentView addSubview:passwordLabel];
        [_contentView addSubview:midline];
        [_contentView addSubview:_passwordline];
        
        
    }
    return _contentView;
}

#define kMarginTopToLoginButton 25.0f
#define kConfirmButtonHeight        40.0f
-(void)addLoginActionsView
{
    _actionsview = [[UIView alloc] initWithFrame:CGRectMake(25, _contentView.bottom + 8, self.contentView.width-50, kConfirmButtonHeight+30)];
    
    float btnwidth = (_actionsview.width - 20)/2;
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneBtn.frame = CGRectMake(0, 5, btnwidth, kConfirmButtonHeight);
    _phoneBtn.backgroundColor = [UIColor whiteColor];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_phoneBtn setTitle:LocalizedString(@"注册") forState:UIControlStateNormal];
    
    [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
    [_phoneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    
    
    _phoneBtn.backgroundColor = RGB(255, 97, 42);
    [_phoneBtn addTarget:self action:@selector(phoneButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(_phoneBtn.right + 10, _phoneBtn.top, _phoneBtn.width, _phoneBtn.height);
    _loginBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _loginBtn.adjustsImageWhenDisabled = NO;
    _loginBtn.adjustsImageWhenHighlighted = NO;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _loginBtn.enabled = NO;
    _loginBtn.backgroundColor = [UIColor blueColor];
    
    [_loginBtn setTitle:LocalizedString(@"登录") forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_loginBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    
    
    
    [_loginBtn addTarget:self action:@selector(LoginButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _loginBtn.layer.cornerRadius = 2;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.backgroundColor = RGB(255, 97, 42);
    _loginBtn.tag = 10001;
    
    
    _findPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _findPasswordBtn.frame = CGRectMake(_loginBtn.right - 70 , _loginBtn.bottom + 10, 70, 25);
    _findPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _findPasswordBtn.contentHorizontalAlignment = NSTextAlignmentLeft;
    _findPasswordBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_findPasswordBtn setTitle:LocalizedString(@"忘记密码?") forState:UIControlStateNormal];
    [_findPasswordBtn setTitleColor:RGB(58, 160, 235) forState:UIControlStateNormal];
    [_findPasswordBtn setTitleColor:RGB(58, 160, 235) forState:UIControlStateHighlighted];
    [_findPasswordBtn addTarget:self action:@selector(findPasswordButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_actionsview addSubview:_phoneBtn];
    [_actionsview addSubview:_loginBtn];
    [_actionsview addSubview:_findPasswordBtn];
    
    [_scrollView addSubview:_actionsview];
    
}

-(void)LoginButtonDidClick
{
    NSString *acount = [tfLoginName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *inputpwd = [tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(acount.length ==0 || inputpwd.length ==0)
    {
        [Utils alertTitle:@"提示" message:@"请输入用户名和密码" delegate:nil cancelBtn:@"好" otherBtnName:nil];
        return;
    }
    WS(weakself)
     [[NCUserNetManager sharedInstance] loginWithAccount:acount andPassword:inputpwd withComplate:^(NSDictionary *result, NSError *error) {

         
         if ([result[@"code"] integerValue] == 200) {
             NCUserConfig *user =  [NCUserConfig sharedInstance];
             user.mobilenumber = acount;
             user.uid = result[@"res"][@"uid"];
             user.uuid = result[@"res"][@"uuid"];
             
        	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:user.uid forKey:@"useruid"];
             [userDefaults setObject:user.uuid forKey:@"useruuid"];
             [userDefaults synchronize];
             
             [weakself doActionWhenLoginIn];
         }
         else
         {
             NSString *msg = result[@"msg"];
             if (msg) {
                 
                 [Utils alertTitle:@"提示" message:msg delegate:nil cancelBtn:@"好" otherBtnName:nil];
             }
             else
             {
                 NSString *resultstr = @"登陆失败";;
                 [Utils alertTitle:@"提示" message:resultstr delegate:nil cancelBtn:@"好" otherBtnName:nil];
             }
         }
     }];
}


-(void)doActionWhenLoginIn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

-(void)findPasswordButtonDidClick
{
    NCRecoveryPWDViewController *fview = [[NCRecoveryPWDViewController alloc] init];
    [self.navigationController pushViewController:fview animated:YES];
}

-(void)phoneButtonDidClick
{
    RegisterViewController *regview = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regview animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self LoginButtonDidClick];
    return YES;
}


-(void)refreshTableViewWithArray:(NSMutableArray *)array
{
    
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
