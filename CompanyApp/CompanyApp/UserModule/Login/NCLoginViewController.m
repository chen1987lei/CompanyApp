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

#define kTextFieldHeight 45.0f
#define kBreakLineColor         RGBS(220)

@interface NCLoginViewController ()
{
    UIScrollView *_scrollView;
    TDAutocompleteTextField *tfLoginName;
    TDNoneMenuTextField *tfPassword;
    
    UIView  *_passwordline;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *contentView;
@end

@implementation NCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.view addSubview:self.scrollView];
    
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
        
        
        UIImageView *iconview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 161)];
        
        [_scrollView addSubview:iconview];
        
        
        [_scrollView addSubview:self.contentView];
    }
       return _scrollView;
}

- (UIImageView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 161, self.view.width, self.scrollView.height)];
        _contentView.userInteractionEnabled = YES;
        

        tfLoginName = [[TDAutocompleteTextField alloc] initWithFrame:CGRectMake(20, 0.5, _contentView.width - 2 * 20, kTextFieldHeight)];
        tfLoginName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tfLoginName.autocorrectionType =UITextAutocorrectionTypeNo;              //不自动做拼写矫正
        tfLoginName.autocapitalizationType = UITextAutocapitalizationTypeNone;  //首字母不自动大写
        tfLoginName.placeholder = @"";

        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
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
