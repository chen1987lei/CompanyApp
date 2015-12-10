//
//  RegisterViewController.m
//  Login_Register
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 NanJingXianLang. All rights reserved.
//

#import "RegisterViewController.h"
#import "TopNavBar.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,TopNavBarDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BOOL          isRead;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    
    
    [_registerTableView release];
    [_topNavBar release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
}

/**
 *	@brief	键盘出现
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil] ;

}

/**
 *	@brief	键盘消失
 *
 *	@param 	aNotification 	参数
 */
- (void)keyboardWillHide:(NSNotification *)aNotification

{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建导航条
    [self createCustomNavBar];
    
    //创建tableView
    [self createTableView];
}

/**
 *	@brief	创建TableView
 */
- (void)createTableView{

    _registerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, (FSystenVersion >= 7.0)?64.f:44.f, 320.f, (FSystenVersion >=7.0)?(ISIPHONE5?(568.f - 64.f):(480.f - 64.f)):(ISIPHONE5?(548.f - 44.f):(460.f - 44.f))) style:UITableViewStyleGrouped];
    _registerTableView.allowsSelection = NO;
    _registerTableView.delegate = self;
    _registerTableView.dataSource = self;
    [self.view addSubview:_registerTableView];
    
}

/**
 *	@brief	创建自定义导航条
 */
- (void)createCustomNavBar
{
    _topNavBar = [[TopNavBar alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, (FSystenVersion >= 7.0)?64.f:44.f)
                                      bgImageName:(FSystenVersion >= 7.0)?@"backgroundNavbar_ios7@2x":@"backgroundNavbar_ios6@2x"
                                       labelTitle:@"注册"
                                         labFrame:CGRectMake(90.f,(FSystenVersion >= 7.0)?27.f:7.f , 140.f, 30.f)
                                         leftBool:YES
                                     leftBtnFrame:CGRectMake(12.f, (FSystenVersion >= 7.0)?27.f:7.f, 30.f, 30.f)
                                 leftBtnImageName:@"button_back_bg@2x.png"
                                        rightBool:NO
                                    rightBtnFrame:CGRectZero
                                rightBtnImageName:nil];
    _topNavBar.delegate = self;
    [self.view addSubview:_topNavBar];
    
}

#pragma mark - TopNavBarDelegate Method
/**
 *	@brief	TopNavBarDelegate Method
 *
 *	@param 	index 	barItemButton 的索引值
 */
- (void)itemButtonClicked:(int)index
{
    switch (index) {
        case 0:
        {
            [Utils alertTitle:@"提示" message:@"您点击了返回按钮" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];

    if (indexPath.section == 0){
        cell.imageView.image = PNGIMAGE(@"register_email@2x");
        UITextField *textField= [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
        textField.tag = Tag_EmailTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"邮箱,必填";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        [cell addSubview:textField];
        [textField release];
        
    }else if (indexPath.section == 1){
        
        cell.imageView.image = PNGIMAGE(@"register_user@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
        textField.tag = Tag_AccountTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"用户名,必填";
        [cell addSubview:textField];
        [textField release];
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
            textField.tag = Tag_TempPasswordTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"密码,必填";
            [cell addSubview:textField];
            [textField release];
            
        }else if (indexPath.row == 1){
            
            cell.imageView.image = PNGIMAGE(@"register_password@2x");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
            textField.tag = Tag_ConfirmPasswordTextField;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.delegate = self;
            textField.placeholder = @"确认密码,必填";
            [cell addSubview:textField];
            [textField release];
        }
        
    }else if (indexPath.section ==3){
        
        cell.imageView.image = PNGIMAGE(@"register_recommand_people@2x");
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50.f, 12.f, 220.f, 21.f)];
        textField.tag = Tag_RecommadTextField;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = @"推荐人,(可选填)";
        [cell addSubview:textField];
        [textField release];
    }else if (indexPath.section == 4){
        
        cell.imageView.image = PNGIMAGE(@"register_lbs@2x");
        
        UILabel *label = [Utils labelWithFrame:CGRectMake(50.f, 14.f, 200.f, 21.f) withTitle:@"来源" titleFontSize:[UIFont systemFontOfSize:14.f] textColor:[UIColor lightGrayColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        label.tag = Tag_SourceLabel;
        [cell addSubview:label];
        
        UIButton *sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sourceBtn.frame = CGRectMake(260.f, 0.f, 50.f, 44.f);
        [sourceBtn addTarget:self action:@selector(sourceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sourceBtn setImage:[UIImage imageNamed:@"mypoisition@2x"] forState:UIControlStateNormal];
        [cell addSubview:sourceBtn];
        
    }else if (indexPath.section == 5){
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake((FSystenVersion >= 7.0)?0.f:10.f, 0.f, (FSystenVersion>=7.0)?320.f:300.f, 44.f);
        [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"register_btn@2x"] forState:UIControlStateNormal];
        [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        [cell addSubview:registerBtn];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        
        return nil;
    }else if (section == 1){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"注册后不可更改，3~20位字符，可包含英文、数字和“_”" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        
        return [footerView autorelease];
    }else if (section == 2){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"6位字符以上，可包含数字、字母（区分大小写）" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        return [footerView autorelease];
    }else if (section == 3){
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *label = [Utils labelWithFrame:CGRectMake(10.f, 0.f, 300.f, 21.f) withTitle:@"请填写推荐您的好友的用户名" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label];
        return [footerView autorelease];
    }else if (section == 4){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 21.f)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *isReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isReadBtn.frame = CGRectMake(10.f, 0.f, 21.f, 21.f);
        [isReadBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
        [isReadBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        isReadBtn.tag = Tag_isReadButton;
        [footerView addSubview:isReadBtn];
        
        UILabel *label1 = [Utils labelWithFrame:CGRectMake(35.f, 0.f, 70.f, 21.f) withTitle:@"我已阅读并同意" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label1];
        
        UIButton *servicesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        servicesBtn.frame = CGRectMake(110.f, 0.f, 40.f, 21.f);
        [servicesBtn setTitle:@"服务协议" forState:UIControlStateNormal];
        [servicesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        servicesBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [servicesBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [servicesBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        servicesBtn.tag = Tag_servicesButton;
        [footerView addSubview:servicesBtn];
        
        UILabel *label2 = [Utils labelWithFrame:CGRectMake(155.f, 0.f, 10.f, 21.f) withTitle:@"和" titleFontSize:[UIFont systemFontOfSize:10.f] textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentLeft];
        [footerView addSubview:label2];
        
        UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        privacyBtn.frame = CGRectMake(170.f, 0.f, 40.f, 21.f);
        [privacyBtn setTitle:@"隐私协议" forState:UIControlStateNormal];
        [privacyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        privacyBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [privacyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [privacyBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        privacyBtn.tag = Tag_privacyButton;
        [footerView addSubview:privacyBtn];
        
        return [footerView autorelease];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 5.f;
    }else if(section == 4){
        
        return 30.f;
        
    }else{
        return 21.f;
    }
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}


#pragma mark - UIButtonClicked Method
- (void)buttonClicked:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Tag_isReadButton:
        {
            //是否阅读协议
            if (_isRead) {
                
                [btn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
                _isRead = NO;
            }else{
                
                [btn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
                
                _isRead = YES;
            }
        }
            break;
        case Tag_servicesButton:
        {
            //服务协议
            [Utils alertTitle:@"提示" message:@"您点击了服务协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
        case Tag_privacyButton:
        {
            //隐私协议
            [Utils alertTitle:@"提示" message:@"您点击了隐私协议" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - sourceBtnClicked Method
- (void)sourceBtnClicked:(id)sender{
    
    [Utils alertTitle:@"提示" message:@"来源接口方法入口" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
}

#pragma mark - RegisterBtnClicked Method
- (void)registerBtnClicked:(id)sender{
    
    
    if (!_isRead) {
        [Utils alertTitle:@"提示" message:@"请勾选阅读协议选项框" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
    }else{
        
        if ([self checkValidityTextField]) {
            
            [Utils alertTitle:@"提示" message:@"资料填写完整可以进行注册请求" delegate:nil cancelBtn:@"确定" otherBtnName:nil];
        }
    }
}

/**
 *	@brief	验证文本框是否为空
 */
#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    
    if ([(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_EmailTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"邮箱不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_AccountTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户名不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:@"提示" message:@"用户确认密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark - UITextFieldDelegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == Tag_RecommadTextField) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.view.frame = CGRectMake(0.f, -35.f, self.view.frame.size.width, self.view.frame.size.height);
            
        }completion:nil] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
            
        case Tag_EmailTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if (![Utils isValidateEmail:textField.text]) {
                    
                    [Utils alertTitle:@"提示" message:@"邮箱格式不正确" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_TempPasswordTextField:
        {
            if ([textField text] != nil && [[textField text] length]!= 0) {
                
                if ([[textField text] length] < 6) {
                    
                    [Utils alertTitle:@"提示" message:@"用户密码小于6位！" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_ConfirmPasswordTextField:
        {
            if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] !=0 && ([textField text]!= nil && [[textField text] length]!= 0)) {
                
                if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[textField text]]) {
                    [Utils alertTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelBtn:@"取消" otherBtnName:nil];
                }
            }
        }
            break;
        case Tag_RecommadTextField:
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.view.frame = CGRectMake(0.f, (FSystenVersion >= 7.0)?0.f:20.f, self.view.frame.size.width, self.view.frame.size.height);
                
            }completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //邮箱
    [[self.view viewWithTag:Tag_EmailTextField] resignFirstResponder];
    //用户名
    [[self.view viewWithTag:Tag_AccountTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];
    //确认密码
    [[self.view viewWithTag:Tag_ConfirmPasswordTextField] resignFirstResponder];
    //推荐人
    [[self.view viewWithTag:Tag_RecommadTextField] resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
